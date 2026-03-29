import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/sample_data.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_card.dart';

/// A compact ride history summary card.
///
/// Displays the ride type chip, date, route (from → to), three key stats
/// (distance, duration, fuel), and an optional warning badge when
/// [SampleRide.warningCount] is greater than zero.
class RLRideSummaryCard extends StatelessWidget {
  const RLRideSummaryCard({
    super.key,
    required this.ride,
    this.onTap,
  });

  final SampleRide ride;
  final VoidCallback? onTap;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _formattedDate =>
      '${_months[ride.date.month - 1]} ${ride.date.day}';

  @override
  Widget build(BuildContext context) {
    return RLCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: ride type chip + date ──────────────────────────────
          Row(
            children: [
              _RideTypeChip(label: ride.rideType),
              const Spacer(),
              if (ride.warningCount > 0) ...[
                _WarningBadge(count: ride.warningCount),
                const SizedBox(width: RLSpacing.sm),
              ],
              Text(
                _formattedDate,
                style: RLText.labelMd.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Route row: from → to ─────────────────────────────────────────
          Row(
            children: [
              Text(
                ride.fromLabel,
                style: RLText.bodySm.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: RLSpacing.xs),
              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: RLSpacing.xs),
              Expanded(
                child: Text(
                  ride.toLabel,
                  style:
                      RLText.bodySm.copyWith(color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: RLSpacing.sm),

          // ── Stats row: distance | duration | fuel ────────────────────────
          Row(
            children: [
              _MiniStat(
                value: ride.distanceKm.toStringAsFixed(1),
                unit: 'km',
              ),
              const SizedBox(width: RLSpacing.lg),
              _MiniStat(
                value: ride.durationLabel,
                unit: '',
              ),
              const SizedBox(width: RLSpacing.lg),
              _MiniStat(
                value: ride.fuelUsedL.toStringAsFixed(2),
                unit: 'L',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _RideTypeChip extends StatelessWidget {
  const _RideTypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RLSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.amberDim),
        borderRadius: RLRadius.borderPill,
      ),
      child: Text(
        label,
        style: RLText.labelSm.copyWith(color: AppColors.amber),
      ),
    );
  }
}

class _WarningBadge extends StatelessWidget {
  const _WarningBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.amberSurface,
        borderRadius: RLRadius.borderPill,
        border: Border.all(color: AppColors.amberDim),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 11, color: AppColors.amber),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: RLText.labelSm.copyWith(color: AppColors.amber),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: RLText.numSm.copyWith(color: AppColors.textPrimary)),
        if (unit.isNotEmpty) ...[
          const SizedBox(width: 2),
          Text(unit,
              style: RLText.labelSm.copyWith(color: AppColors.textMuted)),
        ],
      ],
    );
  }
}
