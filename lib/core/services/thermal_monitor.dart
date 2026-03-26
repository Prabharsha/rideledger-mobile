import 'performance_config.dart';

/// Thermal status levels, ordered by severity.
enum ThermalStatus {
  /// Everything is fine — no action needed.
  normal,

  /// Approaching the configured max continuous tracking duration.
  /// Consider suggesting a lower-accuracy mode.
  warm,

  /// Exceeded max duration. Suggest the rider take a break or switch to
  /// power-saver mode to let the device cool down.
  hot,
}

/// Recommended action based on the current thermal status.
enum ThermalSuggestion {
  /// No action needed.
  none,

  /// Downgrade to power-saver tracking mode to reduce CPU/GPS load.
  reduceToPowerSaver,

  /// Recommend the rider take a short break (stop tracking temporarily).
  suggestBreak,
}

/// Monitors continuous ride/GPS duration and produces thermal status
/// assessments based on the active [TrackingModeConfig].
///
/// This is a *software-based* heuristic monitor. It does not read actual
/// hardware thermal sensors (which require platform channels). Instead it
/// uses tracking duration as a proxy: prolonged high-accuracy GPS usage
/// generates heat on most phones, especially when mounted in direct sunlight.
///
/// Usage:
/// ```dart
/// final monitor = ThermalMonitor();
/// monitor.startMonitoring();
/// // ... periodically:
/// final status = monitor.checkThermalStatus(config);
/// final suggestion = monitor.getSuggestion(config);
/// // ... when ride ends:
/// monitor.stopMonitoring();
/// ```
class ThermalMonitor {
  DateTime? _trackingStartTime;
  DateTime? _gpsStartTime;
  bool _isMonitoring = false;

  /// Whether the monitor is currently active.
  bool get isMonitoring => _isMonitoring;

  /// How long the current continuous tracking session has been running.
  /// Returns [Duration.zero] if not monitoring.
  Duration get continuousTrackingDuration {
    if (_trackingStartTime == null || !_isMonitoring) return Duration.zero;
    return DateTime.now().difference(_trackingStartTime!);
  }

  /// How long GPS has been continuously active in the current session.
  /// Returns [Duration.zero] if not monitoring.
  Duration get gpsUsageDuration {
    if (_gpsStartTime == null || !_isMonitoring) return Duration.zero;
    return DateTime.now().difference(_gpsStartTime!);
  }

  /// Starts monitoring. Resets timers if already monitoring.
  void startMonitoring() {
    final now = DateTime.now();
    _trackingStartTime = now;
    _gpsStartTime = now;
    _isMonitoring = true;
  }

  /// Stops monitoring and clears timers.
  void stopMonitoring() {
    _trackingStartTime = null;
    _gpsStartTime = null;
    _isMonitoring = false;
  }

  /// Evaluates the current thermal status against the provided config's
  /// [maxContinuousTrackingDuration].
  ///
  /// Thresholds:
  /// - **normal**: tracking duration < 80% of max.
  /// - **warm**: tracking duration >= 80% and < 100% of max.
  /// - **hot**: tracking duration >= 100% of max.
  ///
  /// Returns [ThermalStatus.normal] if monitoring is inactive or thermal
  /// throttling is disabled in [config].
  ThermalStatus checkThermalStatus(TrackingModeConfig config) {
    if (!_isMonitoring || !config.enableThermalThrottling) {
      return ThermalStatus.normal;
    }

    final elapsed = continuousTrackingDuration;
    final maxDuration = config.maxContinuousTrackingDuration;

    final ratio = elapsed.inMilliseconds / maxDuration.inMilliseconds;

    if (ratio >= 1.0) {
      return ThermalStatus.hot;
    } else if (ratio >= 0.8) {
      return ThermalStatus.warm;
    }
    return ThermalStatus.normal;
  }

  /// Returns an actionable suggestion based on the current thermal status.
  ///
  /// - [ThermalStatus.normal] → [ThermalSuggestion.none]
  /// - [ThermalStatus.warm] → [ThermalSuggestion.reduceToPowerSaver]
  /// - [ThermalStatus.hot] → [ThermalSuggestion.suggestBreak]
  ThermalSuggestion getSuggestion(TrackingModeConfig config) {
    final status = checkThermalStatus(config);

    switch (status) {
      case ThermalStatus.normal:
        return ThermalSuggestion.none;
      case ThermalStatus.warm:
        return ThermalSuggestion.reduceToPowerSaver;
      case ThermalStatus.hot:
        return ThermalSuggestion.suggestBreak;
    }
  }

  /// Resets only the tracking timer without stopping monitoring entirely.
  /// Useful when the user acknowledges a thermal warning and wants to
  /// continue — the timer restarts from zero.
  void resetTrackingTimer() {
    if (_isMonitoring) {
      _trackingStartTime = DateTime.now();
    }
  }

  /// Resets only the GPS timer. Useful if GPS is temporarily paused
  /// (e.g., during a fuel stop) and then resumed.
  void resetGpsTimer() {
    if (_isMonitoring) {
      _gpsStartTime = DateTime.now();
    }
  }
}
