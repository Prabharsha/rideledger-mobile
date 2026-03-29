import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../core/services/storage_manager.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/retention_policy_model.dart';
import '../../../data/models/ride_session_model.dart';
import '../../../shared/providers/storage_management_provider.dart';

/// Screen for managing app storage, retention policies, and cleanup
class StorageManagementScreen extends ConsumerStatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  ConsumerState<StorageManagementScreen> createState() =>
      _StorageManagementScreenState();
}

class _StorageManagementScreenState
    extends ConsumerState<StorageManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storageState = ref.watch(storageManagementProvider);

    // Show SnackBar when cleanup finishes with a result
    ref.listen<StorageManagementState>(storageManagementProvider,
        (previous, next) {
      if (next.lastResult != null && previous?.lastResult == null) {
        final result = next.lastResult!;
        final label = result.routeDataOnly ? 'route points' : 'rides';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted ${result.deletedCount} $label, freed ~${result.formattedFreedSpace}',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        ref.read(storageManagementProvider.notifier).clearResult();
      }
      if (next.error != null && previous?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(storageManagementProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStorageOverviewCard(theme),
          const SizedBox(height: 16),
          _buildRetentionPolicyCard(theme),
          const SizedBox(height: 16),
          _buildManualActionsCard(theme, storageState),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Storage Overview
  // ---------------------------------------------------------------------------

  Widget _buildStorageOverviewCard(ThemeData theme) {
    final usageAsync = ref.watch(storageUsageProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Storage Overview', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            usageAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Text(
                'Failed to load storage info: $err',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              data: (report) => _buildUsageContent(theme, report),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageContent(ThemeData theme, StorageUsageReport report) {
    final categories = report.categoryBreakdown.values.toList();
    final totalKB = report.estimatedTotalSizeKB;

    // Colours for each category bar segment
    const categoryColors = [
      Color(0xFF4285F4), // rides - blue
      Color(0xFFFBBC04), // routes - yellow
      Color(0xFFEA4335), // warnings - red
      Color(0xFF34A853), // fuel - green
      Color(0xFF9C27B0), // maintenance - purple
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total
        Row(
          children: [
            Icon(Icons.storage_rounded,
                size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Total: ${report.formattedTotalSize}',
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Proportional bar
        if (totalKB > 0)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 14,
              child: Row(
                children: List.generate(categories.length, (i) {
                  final fraction = categories[i].estimatedSizeKB / totalKB;
                  if (fraction <= 0) return const SizedBox.shrink();
                  return Expanded(
                    flex: (fraction * 1000).round().clamp(1, 1000),
                    child: Container(color: categoryColors[i]),
                  );
                }),
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Per-category breakdown
        ...List.generate(categories.length, (i) {
          final cat = categories[i];
          final sizeLabel = cat.estimatedSizeKB >= 1024
              ? '${(cat.estimatedSizeKB / 1024).toStringAsFixed(1)} MB'
              : '${cat.estimatedSizeKB.toStringAsFixed(0)} KB';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: categoryColors[i],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(cat.name, style: theme.textTheme.bodyMedium),
                ),
                Text(
                  '${cat.count} items',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 72,
                  child: Text(
                    sizeLabel,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Retention Policy
  // ---------------------------------------------------------------------------

  Widget _buildRetentionPolicyCard(ThemeData theme) {
    final policyAsync = ref.watch(retentionPolicyProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Retention Policy', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            policyAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Text(
                'Failed to load policy: $err',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              data: (policy) => _buildPolicyContent(theme, policy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyContent(ThemeData theme, RetentionPolicyModel policy) {
    final notifier = ref.read(storageManagementProvider.notifier);
    final dateFormat = DateFormat.yMMMd();

    return Column(
      children: [
        // Auto-cleanup toggle
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto-cleanup'),
          subtitle: const Text('Automatically delete old data'),
          value: policy.autoCleanupEnabled,
          onChanged: (value) {
            final updated = policy.copyWith(autoCleanupEnabled: value);
            notifier.updatePolicy(updated);
          },
        ),

        const Divider(height: 1),

        // Retention period dropdown
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Retention period'),
          trailing: DropdownButton<String>(
            value: policy.retentionPeriod,
            underline: const SizedBox.shrink(),
            items: RetentionPolicyModel.retentionPeriods.map((period) {
              return DropdownMenuItem(
                value: period,
                child: Text(RetentionPolicyModel.getRetentionLabel(period)),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              final updated = policy.copyWith(retentionPeriod: value);
              notifier.updatePolicy(updated);
            },
          ),
        ),

        const Divider(height: 1),

        // Delete route data only toggle
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Delete route data only'),
          subtitle: const Text('Keep ride summaries, remove GPS data'),
          value: policy.deleteRouteDataOnly,
          onChanged: (value) {
            final updated = policy.copyWith(deleteRouteDataOnly: value);
            notifier.updatePolicy(updated);
          },
        ),

        const Divider(height: 1),

        // Export before delete toggle
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Export before delete'),
          subtitle: const Text('Save a backup before cleanup'),
          value: policy.exportBeforeDelete,
          onChanged: (value) {
            final updated = policy.copyWith(exportBeforeDelete: value);
            notifier.updatePolicy(updated);
          },
        ),

        // Export format dropdown (shown only when export is enabled)
        if (policy.exportBeforeDelete) ...[
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Export format'),
            trailing: DropdownButton<String>(
              value: policy.exportFormat,
              underline: const SizedBox.shrink(),
              items: RetentionPolicyModel.exportFormats.map((format) {
                return DropdownMenuItem(
                  value: format,
                  child:
                      Text(RetentionPolicyModel.getExportFormatLabel(format)),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                final updated = policy.copyWith(exportFormat: value);
                notifier.updatePolicy(updated);
              },
            ),
          ),
        ],

        const Divider(height: 1),
        const SizedBox(height: 8),

        // Last cleanup info
        if (policy.lastCleanupDate != null)
          Row(
            children: [
              Icon(Icons.history, size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Last cleanup: ${dateFormat.format(policy.lastCleanupDate!)} '
                  '(${policy.lastCleanupDeletedCount} items removed)',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Icon(Icons.info_outline,
                  size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 8),
              Text(
                'No cleanup has been run yet',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Manual Actions
  // ---------------------------------------------------------------------------

  Widget _buildManualActionsCard(
    ThemeData theme,
    StorageManagementState storageState,
  ) {
    final notifier = ref.read(storageManagementProvider.notifier);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manual Actions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            // Clean Up Now
            _ActionButton(
              icon: Icons.cleaning_services_rounded,
              label: 'Clean Up Now',
              subtitle: 'Delete data based on current retention policy',
              isLoading: storageState.isCleaningUp,
              onPressed: storageState.isCleaningUp
                  ? null
                  : () => _confirmAction(
                        context: context,
                        title: 'Run Cleanup',
                        message:
                            'This will delete data older than the configured '
                            'retention period. This action cannot be undone.',
                        confirmLabel: 'Clean Up',
                        onConfirmed: () => notifier.runCleanup(),
                      ),
            ),
            const SizedBox(height: 8),

            // Delete All Route Data
            _ActionButton(
              icon: Icons.route_rounded,
              label: 'Delete All Route Data',
              subtitle: 'Remove all GPS route points but keep ride summaries',
              isLoading: storageState.isCleaningUp,
              destructive: true,
              onPressed: storageState.isCleaningUp
                  ? null
                  : () => _confirmAction(
                        context: context,
                        title: 'Delete All Route Data',
                        message:
                            'All GPS route points will be permanently deleted. '
                            'Ride summaries (distance, duration, etc.) will be '
                            'kept. This cannot be undone.',
                        confirmLabel: 'Delete Routes',
                        onConfirmed: () => notifier.deleteAllRouteData(),
                      ),
            ),
            const SizedBox(height: 8),

            // Export All Data
            _ActionButton(
              icon: Icons.upload_file_rounded,
              label: 'Export All Data',
              subtitle: 'Export all ride data as JSON',
              isLoading: storageState.isCleaningUp,
              onPressed: storageState.isCleaningUp
                  ? null
                  : () => _handleExportAll(),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a confirmation dialog before performing a destructive action
  Future<void> _confirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirmed,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirmed();
    }
  }

  /// Export all rides as JSON and show feedback
  Future<void> _handleExportAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export All Data'),
        content: const Text(
          'This will export all ride sessions, route points, and warnings as '
          'a JSON file.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final manager = ref.read(storageManagerProvider);
      final isar = StorageService.getInstance();
      final allRides = await isar.rideSessionModels.where().findAll();
      final sessionIds = allRides.map((r) => r.sessionId).toList();
      final exported = await manager.exportRidesAsJson(sessionIds);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported ${exported.length} ride sessions'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// -----------------------------------------------------------------------------
// Reusable action button
// -----------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isLoading;
  final bool destructive;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.isLoading = false,
    this.destructive = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        destructive ? theme.colorScheme.error : theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: color, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
