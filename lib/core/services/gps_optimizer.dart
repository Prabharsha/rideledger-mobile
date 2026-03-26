import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import 'performance_config.dart';

/// Rough battery-impact estimate for a given tracking configuration.
class BatteryImpactEstimate {
  /// Qualitative level: "low", "medium", or "high".
  final String level;

  /// Rough estimate of how many hours GPS tracking can run on a full charge.
  /// Based on typical mid-range Android phones (~4000 mAh). Actual results
  /// vary widely by device, screen state, and cellular signal.
  final double estimatedHoursOnFullCharge;

  const BatteryImpactEstimate({
    required this.level,
    required this.estimatedHoursOnFullCharge,
  });

  @override
  String toString() =>
      'BatteryImpactEstimate($level, ~${estimatedHoursOnFullCharge.toStringAsFixed(1)}h)';
}

/// Wraps the geolocator package with performance-aware helpers.
///
/// All methods are pure functions or lightweight calculations — no GPS
/// subscriptions are owned here. The caller (ride tracking service) manages
/// the actual position stream and uses these helpers to decide what to do
/// with each position event.
class GpsOptimizer {
  const GpsOptimizer();

  // ---------------------------------------------------------------------------
  // Location settings
  // ---------------------------------------------------------------------------

  /// Builds platform [LocationSettings] from a [TrackingModeConfig].
  LocationSettings getLocationSettings(TrackingModeConfig config) {
    return LocationSettings(
      accuracy: _mapAccuracy(config.accuracy),
      distanceFilter: config.distanceFilterMeters.round(),
      timeLimit: _timeLimitForConfig(config),
    );
  }

  /// Maps the app's [GpsAccuracyLevel] enum to geolocator's
  /// [LocationAccuracy].
  static LocationAccuracy _mapAccuracy(GpsAccuracyLevel level) {
    switch (level) {
      case GpsAccuracyLevel.low:
        return LocationAccuracy.low;
      case GpsAccuracyLevel.medium:
        return LocationAccuracy.medium;
      case GpsAccuracyLevel.high:
        return LocationAccuracy.best;
    }
  }

  /// Returns a generous time limit for the geolocator stream so it doesn't
  /// silently close. The limit is 3x the GPS interval to tolerate temporary
  /// signal loss without killing the stream.
  static Duration _timeLimitForConfig(TrackingModeConfig config) {
    final baseSeconds = config.gpsInterval.inSeconds;
    // Minimum 30 s, otherwise 3x the interval.
    return Duration(seconds: math.max(30, baseSeconds * 3));
  }

  // ---------------------------------------------------------------------------
  // Intelligent point sampling
  // ---------------------------------------------------------------------------

  /// Determines whether the current GPS position should be persisted as a
  /// route point.
  ///
  /// The decision considers elapsed time, distance moved, current speed, and
  /// the active tracking configuration. This avoids recording noise while
  /// stationary and ensures adequate detail at higher speeds.
  ///
  /// Parameters:
  /// - [currentPosition]: latest GPS fix.
  /// - [lastRecordedPosition]: the most recently *persisted* route point
  ///   (null on first point — always record).
  /// - [timeSinceLastRecord]: wall-clock time since the last persisted point.
  /// - [currentSpeedKmh]: current speed in km/h (from GPS or computed).
  /// - [config]: active tracking mode.
  bool shouldRecordPoint({
    required Position currentPosition,
    required Position? lastRecordedPosition,
    required Duration timeSinceLastRecord,
    required double currentSpeedKmh,
    required TrackingModeConfig config,
  }) {
    // Always record the very first point.
    if (lastRecordedPosition == null) return true;

    final distanceMeters = Geolocator.distanceBetween(
      lastRecordedPosition.latitude,
      lastRecordedPosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    // --- Speed-adaptive interval ---
    final effectiveInterval = _effectiveSampleInterval(
      currentSpeedKmh,
      config,
    );

    final timeElapsed = timeSinceLastRecord >= effectiveInterval;
    final distanceElapsed = distanceMeters >= config.distanceFilterMeters;

    // Record if *either* threshold is met — time guarantees at least periodic
    // points on straight roads; distance catches sharp turns quickly.
    return timeElapsed || distanceElapsed;
  }

  /// Returns the effective sample interval adjusted for speed.
  ///
  /// - Very low speed (<3 km/h, likely stationary/walking): 3x the base
  ///   interval to suppress GPS jitter.
  /// - Low speed (3–10 km/h, parking lot / heavy traffic): 1.5x base.
  /// - Normal / high speed: base interval unchanged.
  Duration _effectiveSampleInterval(
    double speedKmh,
    TrackingModeConfig config,
  ) {
    final baseMs = config.routeSampleInterval.inMilliseconds;

    if (speedKmh < 3.0) {
      // Nearly stationary — aggressively reduce sampling.
      return Duration(milliseconds: (baseMs * 3).round());
    } else if (speedKmh < 10.0) {
      return Duration(milliseconds: (baseMs * 1.5).round());
    }
    return config.routeSampleInterval;
  }

  // ---------------------------------------------------------------------------
  // Adaptive distance filter
  // ---------------------------------------------------------------------------

  /// Returns an adjusted distance filter (meters) based on current speed.
  ///
  /// The base filter from [config] is scaled so that:
  /// - Stationary / very slow (< 3 km/h): 2x base → suppress noise.
  /// - Urban traffic (10–30 km/h): 0.75x base → reasonable detail.
  /// - Highway (> 50 km/h): 0.4x base (min 3 m) → tight filter for curves.
  /// - Intermediate speeds are linearly interpolated.
  double adaptiveDistanceFilter(
    double currentSpeedKmh,
    TrackingModeConfig config,
  ) {
    final base = config.distanceFilterMeters;

    if (currentSpeedKmh < 3.0) {
      return base * 2.0;
    } else if (currentSpeedKmh < 10.0) {
      // Lerp from 2.0x at 3 km/h down to 1.0x at 10 km/h.
      final t = (currentSpeedKmh - 3.0) / 7.0;
      return base * _lerp(2.0, 1.0, t);
    } else if (currentSpeedKmh < 30.0) {
      // Lerp from 1.0x at 10 km/h down to 0.75x at 30 km/h.
      final t = (currentSpeedKmh - 10.0) / 20.0;
      return base * _lerp(1.0, 0.75, t);
    } else if (currentSpeedKmh < 50.0) {
      // Lerp from 0.75x at 30 km/h down to 0.4x at 50 km/h.
      final t = (currentSpeedKmh - 30.0) / 20.0;
      return base * _lerp(0.75, 0.4, t);
    } else {
      // Highway / open road — tightest filter.
      return math.max(3.0, base * 0.4);
    }
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  // ---------------------------------------------------------------------------
  // Battery impact estimation
  // ---------------------------------------------------------------------------

  /// Provides a rough battery-impact estimate for the given config.
  ///
  /// The numbers are heuristic and based on typical mid-range Android phones
  /// (~4000 mAh) with the screen off and GPS as the primary consumer. Real
  /// drain depends heavily on chip, signal quality, and screen state.
  static BatteryImpactEstimate estimateBatteryImpact(
    TrackingModeConfig config,
  ) {
    // Base hours (screen off, GPS only) by accuracy level.
    double baseHours;
    switch (config.accuracy) {
      case GpsAccuracyLevel.low:
        baseHours = 12.0;
        break;
      case GpsAccuracyLevel.medium:
        baseHours = 7.0;
        break;
      case GpsAccuracyLevel.high:
        baseHours = 4.0;
        break;
    }

    // Faster polling drains more.
    final intervalPenalty = 1.0 / math.max(1, config.gpsInterval.inSeconds);
    // Normalize: 1 s interval = 1.0 penalty, 10 s = 0.1.
    baseHours *= math.max(0.4, 1.0 - (intervalPenalty * 0.5));

    // Live map rendering adds ~20% drain.
    if (config.enableLiveMapRendering) {
      baseHours *= 0.8;
    }

    // Continuous speed updates add ~5% drain.
    if (config.enableContinuousSpeedUpdates) {
      baseHours *= 0.95;
    }

    // Classify.
    final String level;
    if (baseHours >= 8.0) {
      level = 'low';
    } else if (baseHours >= 4.5) {
      level = 'medium';
    } else {
      level = 'high';
    }

    return BatteryImpactEstimate(
      level: level,
      estimatedHoursOnFullCharge: double.parse(baseHours.toStringAsFixed(1)),
    );
  }
}
