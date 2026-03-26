/// Performance configuration for ride tracking optimization.
///
/// Provides three tracking mode presets (power saver, balanced, high accuracy)
/// that control GPS sampling, batch writes, UI refresh rates, and thermal
/// protection thresholds.

/// GPS accuracy level used to map to platform-specific location settings.
enum GpsAccuracyLevel {
  low,
  medium,
  high,
}

/// Configuration for a single tracking mode, controlling all performance-
/// sensitive parameters during an active ride.
class TrackingModeConfig {
  /// Human-readable name for display in settings UI.
  final String name;

  /// Minimum interval between GPS position requests.
  final Duration gpsInterval;

  /// Minimum distance change (meters) before the platform reports a new
  /// position. Larger values reduce battery drain.
  final double distanceFilterMeters;

  /// Minimum interval between route point samples persisted to the route.
  /// Independent of [gpsInterval] — the GPS may fire more frequently for
  /// speed display, but route storage uses this cadence.
  final Duration routeSampleInterval;

  /// Number of route points accumulated in memory before flushing to Isar.
  final int batchWriteSize;

  /// Minimum interval between UI state refreshes (map, speed, stats).
  final Duration uiRefreshInterval;

  /// Whether the live map layer should continuously re-render the polyline.
  /// Disabling saves significant GPU/CPU on lower-end devices.
  final bool enableLiveMapRendering;

  /// Whether speed should be continuously updated from the GPS stream.
  /// When false, the UI shows the last-known speed and only refreshes at
  /// [uiRefreshInterval].
  final bool enableContinuousSpeedUpdates;

  /// Desired GPS accuracy level.
  final GpsAccuracyLevel accuracy;

  /// Maximum continuous tracking duration before the thermal monitor
  /// suggests a break. Does not force-stop recording.
  final Duration maxContinuousTrackingDuration;

  /// Whether to enable thermal throttling logic that can automatically
  /// downgrade accuracy when the device is running hot.
  final bool enableThermalThrottling;

  const TrackingModeConfig({
    required this.name,
    required this.gpsInterval,
    required this.distanceFilterMeters,
    required this.routeSampleInterval,
    required this.batchWriteSize,
    required this.uiRefreshInterval,
    required this.enableLiveMapRendering,
    required this.enableContinuousSpeedUpdates,
    required this.accuracy,
    required this.maxContinuousTrackingDuration,
    required this.enableThermalThrottling,
  });

  /// Creates a copy with selected fields overridden.
  TrackingModeConfig copyWith({
    String? name,
    Duration? gpsInterval,
    double? distanceFilterMeters,
    Duration? routeSampleInterval,
    int? batchWriteSize,
    Duration? uiRefreshInterval,
    bool? enableLiveMapRendering,
    bool? enableContinuousSpeedUpdates,
    GpsAccuracyLevel? accuracy,
    Duration? maxContinuousTrackingDuration,
    bool? enableThermalThrottling,
  }) {
    return TrackingModeConfig(
      name: name ?? this.name,
      gpsInterval: gpsInterval ?? this.gpsInterval,
      distanceFilterMeters: distanceFilterMeters ?? this.distanceFilterMeters,
      routeSampleInterval: routeSampleInterval ?? this.routeSampleInterval,
      batchWriteSize: batchWriteSize ?? this.batchWriteSize,
      uiRefreshInterval: uiRefreshInterval ?? this.uiRefreshInterval,
      enableLiveMapRendering:
          enableLiveMapRendering ?? this.enableLiveMapRendering,
      enableContinuousSpeedUpdates:
          enableContinuousSpeedUpdates ?? this.enableContinuousSpeedUpdates,
      accuracy: accuracy ?? this.accuracy,
      maxContinuousTrackingDuration:
          maxContinuousTrackingDuration ?? this.maxContinuousTrackingDuration,
      enableThermalThrottling:
          enableThermalThrottling ?? this.enableThermalThrottling,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingModeConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          gpsInterval == other.gpsInterval &&
          distanceFilterMeters == other.distanceFilterMeters &&
          routeSampleInterval == other.routeSampleInterval &&
          batchWriteSize == other.batchWriteSize &&
          uiRefreshInterval == other.uiRefreshInterval &&
          enableLiveMapRendering == other.enableLiveMapRendering &&
          enableContinuousSpeedUpdates == other.enableContinuousSpeedUpdates &&
          accuracy == other.accuracy &&
          maxContinuousTrackingDuration == other.maxContinuousTrackingDuration &&
          enableThermalThrottling == other.enableThermalThrottling;

  @override
  int get hashCode => Object.hash(
        name,
        gpsInterval,
        distanceFilterMeters,
        routeSampleInterval,
        batchWriteSize,
        uiRefreshInterval,
        enableLiveMapRendering,
        enableContinuousSpeedUpdates,
        accuracy,
        maxContinuousTrackingDuration,
        enableThermalThrottling,
      );

  @override
  String toString() => 'TrackingModeConfig($name)';
}

/// Central registry of performance presets.
class PerformanceConfig {
  PerformanceConfig._();

  /// Minimizes battery and CPU usage. Ideal for long highway rides where
  /// precise route shape is less important than total distance.
  static const TrackingModeConfig powerSaver = TrackingModeConfig(
    name: 'Power Saver',
    gpsInterval: Duration(seconds: 10),
    distanceFilterMeters: 100.0,
    routeSampleInterval: Duration(seconds: 15),
    batchWriteSize: 20,
    uiRefreshInterval: Duration(seconds: 3),
    enableLiveMapRendering: false,
    enableContinuousSpeedUpdates: false,
    accuracy: GpsAccuracyLevel.low,
    maxContinuousTrackingDuration: Duration(hours: 4),
    enableThermalThrottling: true,
  );

  /// Default mode. Good balance of route accuracy and battery life for
  /// typical city/suburban riding.
  static const TrackingModeConfig balanced = TrackingModeConfig(
    name: 'Balanced',
    gpsInterval: Duration(seconds: 3),
    distanceFilterMeters: 25.0,
    routeSampleInterval: Duration(seconds: 5),
    batchWriteSize: 10,
    uiRefreshInterval: Duration(seconds: 1),
    enableLiveMapRendering: false,
    enableContinuousSpeedUpdates: true,
    accuracy: GpsAccuracyLevel.medium,
    maxContinuousTrackingDuration: Duration(hours: 3),
    enableThermalThrottling: true,
  );

  /// Maximum GPS precision. Useful for break-in period tracking where every
  /// speed change matters, or for detailed route recording.
  static const TrackingModeConfig highAccuracy = TrackingModeConfig(
    name: 'High Accuracy',
    gpsInterval: Duration(seconds: 1),
    distanceFilterMeters: 5.0,
    routeSampleInterval: Duration(seconds: 2),
    batchWriteSize: 5,
    uiRefreshInterval: Duration(milliseconds: 500),
    enableLiveMapRendering: true,
    enableContinuousSpeedUpdates: true,
    accuracy: GpsAccuracyLevel.high,
    maxContinuousTrackingDuration: Duration(hours: 2),
    enableThermalThrottling: true,
  );

  /// All available presets, ordered from least to most resource-intensive.
  static const List<TrackingModeConfig> allPresets = [
    powerSaver,
    balanced,
    highAccuracy,
  ];
}
