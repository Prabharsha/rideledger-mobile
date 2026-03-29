import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/performance_config.dart';
import '../../../shared/providers/tracking_mode_provider.dart';

/// Settings screen for choosing the GPS tracking mode and thermal protection
class TrackingModeSettingsScreen extends ConsumerWidget {
  const TrackingModeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(trackingModeProvider);
    final batteryImpact = ref.watch(batteryImpactProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.trackingMode),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current mode indicator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _getModeIcon(currentMode.name),
                    size: 40,
                    color: _getModeColor(currentMode.name),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active: ${currentMode.name}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${AppStrings.batteryImpact}: ${batteryImpact.level}  (~${batteryImpact.estimatedHoursOnFullCharge.toStringAsFixed(1)}h)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getBatteryColor(batteryImpact.level),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Mode selection cards
          Text(
            'Select Tracking Mode',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),

          _TrackingModeCard(
            config: PerformanceConfig.powerSaver,
            isSelected: currentMode.name == PerformanceConfig.powerSaver.name,
            title: AppStrings.trackingModePowerSaver,
            description: AppStrings.trackingModePowerSaverDesc,
            icon: Icons.battery_saver,
            color: AppColors.success,
            specs: [
              'GPS every 10s',
              'Low accuracy',
              'No live map',
              'Minimal battery use',
            ],
            onTap: () {
              ref.read(trackingModeProvider.notifier).state =
                  PerformanceConfig.powerSaver;
            },
          ),
          const SizedBox(height: 8),

          _TrackingModeCard(
            config: PerformanceConfig.balanced,
            isSelected: currentMode.name == PerformanceConfig.balanced.name,
            title: AppStrings.trackingModeBalanced,
            description: AppStrings.trackingModeBalancedDesc,
            icon: Icons.balance,
            color: AppColors.primary,
            specs: [
              'GPS every 3s',
              'Medium accuracy',
              'Speed updates on',
              'Moderate battery use',
            ],
            onTap: () {
              ref.read(trackingModeProvider.notifier).state =
                  PerformanceConfig.balanced;
            },
          ),
          const SizedBox(height: 8),

          _TrackingModeCard(
            config: PerformanceConfig.highAccuracy,
            isSelected:
                currentMode.name == PerformanceConfig.highAccuracy.name,
            title: AppStrings.trackingModeHighAccuracy,
            description: AppStrings.trackingModeHighAccuracyDesc,
            icon: Icons.gps_fixed,
            color: AppColors.accent,
            specs: [
              'GPS every 1s',
              'High accuracy',
              'Live map on',
              'Higher battery use',
            ],
            onTap: () {
              ref.read(trackingModeProvider.notifier).state =
                  PerformanceConfig.highAccuracy;
            },
          ),

          const SizedBox(height: 24),

          // Thermal protection section
          Text(
            AppStrings.thermalProtection,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.thermalProtectionDesc,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Max continuous tracking',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${currentMode.maxContinuousTrackingDuration.inMinutes} min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thermal throttling',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        currentMode.enableThermalThrottling
                            ? 'Enabled'
                            : 'Disabled',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: currentMode.enableThermalThrottling
                              ? AppColors.success
                              : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Technical details
          Text(
            'Technical Details',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'GPS interval',
                    value:
                        '${currentMode.gpsInterval.inMilliseconds}ms',
                  ),
                  _DetailRow(
                    label: 'Distance filter',
                    value:
                        '${currentMode.distanceFilterMeters.toStringAsFixed(0)}m',
                  ),
                  _DetailRow(
                    label: 'Route sample rate',
                    value:
                        '${currentMode.routeSampleInterval.inSeconds}s',
                  ),
                  _DetailRow(
                    label: 'Batch write size',
                    value: '${currentMode.batchWriteSize} points',
                  ),
                  _DetailRow(
                    label: 'UI refresh rate',
                    value:
                        '${currentMode.uiRefreshInterval.inMilliseconds}ms',
                  ),
                  _DetailRow(
                    label: 'Live map rendering',
                    value:
                        currentMode.enableLiveMapRendering ? 'On' : 'Off',
                  ),
                  _DetailRow(
                    label: 'Continuous speed',
                    value: currentMode.enableContinuousSpeedUpdates
                        ? 'On'
                        : 'Off',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getModeIcon(String modeName) {
    switch (modeName) {
      case 'Power Saver':
        return Icons.battery_saver;
      case 'High Accuracy':
        return Icons.gps_fixed;
      default:
        return Icons.balance;
    }
  }

  Color _getModeColor(String modeName) {
    switch (modeName) {
      case 'Power Saver':
        return AppColors.success;
      case 'High Accuracy':
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }

  Color _getBatteryColor(String level) {
    switch (level) {
      case 'Low':
        return AppColors.success;
      case 'High':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }
}

/// Card widget for each tracking mode option
class _TrackingModeCard extends StatelessWidget {
  final TrackingModeConfig config;
  final bool isSelected;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> specs;
  final VoidCallback onTap;

  const _TrackingModeCard({
    required this.config,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.specs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : null,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: color, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: specs
                    .map(
                      (spec) => Chip(
                        label: Text(
                          spec,
                          style: theme.textTheme.labelSmall,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row showing a technical detail label-value pair
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
