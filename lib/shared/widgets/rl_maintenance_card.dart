import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/sample_data.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_card.dart';

/// A single maintenance reminder card.
///
/// Shows a status icon, task title + subtitle, and a trailing badge that
/// either displays remaining kilometres or a "Done" chip.
class RLMaintenanceCard extends StatelessWidget {
  const RLMaintenanceCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final SampleMaintenance item;
  final VoidCallback? onTap;

  // ── Status icon resolution ───────────────────────────────────────────────

  IconData get _statusIcon {
    switch (item.status) {
      case MaintenanceStatus.done:
        return Icons.check_circle_outline;
      case MaintenanceStatus.overdue:
        return Icons.warning_amber_rounded;
      case MaintenanceStatus.due:
        return Icons.access_time_rounded;
      case MaintenanceStatus.upcoming:
        return Icons.info_outline;
    }
  }

  Color get _statusColor {
    switch (item.status) {
      case MaintenanceStatus.done:
        return AppColors.olive;
      case MaintenanceStatus.overdue:
        return AppColors.error;
      case MaintenanceStatus.due:
        return AppColors.amber;
      case MaintenanceStatus.upcoming:
        return AppColors.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RLCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Status icon ────────────────────────────────────────────────
          Icon(
            _statusIcon,
            size: RLSizes.iconMd,
            color: _statusColor,
          ),

          const SizedBox(width: RLSpacing.md),

          // ── Title + subtitle ───────────────────────────────────────────
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: RLText.bodySm.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          const SizedBox(width: RLSpacing.sm),

          // ── Trailing badge ─────────────────────────────────────────────
          _TrailingBadge(item: item),
        ],
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _TrailingBadge extends StatelessWidget {
  const _TrailingBadge({required this.item});

  final SampleMaintenance item;

  @override
  Widget build(BuildContext context) {
    if (item.status == MaintenanceStatus.done) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: RLSpacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.oliveSurface,
          borderRadius: RLRadius.borderPill,
          border: Border.all(color: AppColors.oliveDim),
        ),
        child: Text(
          'Done',
          style: RLText.labelSm.copyWith(color: AppColors.olive),
        ),
      );
    }

    // Show km remaining for non-done items that have km data.
    final km = item.kmRemaining;
    if (km > 0 || item.dueAtKm != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: RLSpacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.amberSurface,
          borderRadius: RLRadius.borderPill,
          border: Border.all(color: AppColors.amberDim),
        ),
        child: Text(
          '${km.round()} km',
          style: RLText.labelSm.copyWith(color: AppColors.amber),
        ),
      );
    }

    // Date-based items with no km data — show a neutral upcoming chip.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.slateSurface,
        borderRadius: RLRadius.borderPill,
        border: Border.all(color: AppColors.slateDim),
      ),
      child: Text(
        'Upcoming',
        style: RLText.labelSm.copyWith(color: AppColors.slate),
      ),
    );
  }
}
