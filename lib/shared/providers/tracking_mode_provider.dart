import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/gps_optimizer.dart';
import '../../core/services/performance_config.dart';
import '../../core/services/thermal_monitor.dart';

// ---------------------------------------------------------------------------
// Tracking mode
// ---------------------------------------------------------------------------

/// The currently selected tracking mode. Defaults to [PerformanceConfig.balanced].
///
/// Change this before or during a ride to adjust GPS accuracy, battery usage,
/// and UI update frequency:
/// ```dart
/// ref.read(trackingModeProvider.notifier).state = PerformanceConfig.powerSaver;
/// ```
final trackingModeProvider = StateProvider<TrackingModeConfig>((ref) {
  return PerformanceConfig.balanced;
});

// ---------------------------------------------------------------------------
// Thermal monitor instance
// ---------------------------------------------------------------------------

/// Singleton [ThermalMonitor] shared across providers. Start/stop monitoring
/// from your ride tracking service; providers read status from here.
final thermalMonitorProvider = Provider<ThermalMonitor>((ref) {
  return ThermalMonitor();
});

// ---------------------------------------------------------------------------
// Thermal status stream
// ---------------------------------------------------------------------------

/// Emits the current [ThermalStatus] every 30 seconds while monitoring is
/// active. Yields [ThermalStatus.normal] when the monitor is idle.
///
/// The stream automatically uses the current [trackingModeProvider] config,
/// so switching modes mid-ride adjusts the thermal thresholds immediately.
final thermalStatusProvider = StreamProvider<ThermalStatus>((ref) {
  final monitor = ref.watch(thermalMonitorProvider);
  final config = ref.watch(trackingModeProvider);

  final controller = StreamController<ThermalStatus>();

  // Emit an initial value immediately.
  controller.add(monitor.checkThermalStatus(config));

  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    if (!controller.isClosed) {
      controller.add(monitor.checkThermalStatus(config));
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

// ---------------------------------------------------------------------------
// Battery impact
// ---------------------------------------------------------------------------

/// Derives a [BatteryImpactEstimate] from the currently selected tracking mode.
/// Re-computes automatically when [trackingModeProvider] changes.
final batteryImpactProvider = Provider<BatteryImpactEstimate>((ref) {
  final config = ref.watch(trackingModeProvider);
  return GpsOptimizer.estimateBatteryImpact(config);
});

// ---------------------------------------------------------------------------
// Thermal suggestion (convenience)
// ---------------------------------------------------------------------------

/// Derives a [ThermalSuggestion] from the latest thermal status. Useful for
/// one-shot reads in UI widgets that want to show a banner or dialog.
final thermalSuggestionProvider = Provider<ThermalSuggestion>((ref) {
  final monitor = ref.watch(thermalMonitorProvider);
  final config = ref.watch(trackingModeProvider);
  return monitor.getSuggestion(config);
});
