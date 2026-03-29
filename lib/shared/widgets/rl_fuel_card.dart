import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_card.dart';
import 'rl_progress_bar.dart';

/// Fuel quota status card.
///
/// Displays this-week usage vs quota with a color-coded progress bar, then a
/// divider row with current tank level, estimated range, and fuel economy.
class RLFuelQuotaCard extends StatelessWidget {
  const RLFuelQuotaCard({
    super.key,
    required this.weeklyQuota,
    required this.weekUsed,
    required this.currentFuel,
    required this.tankCapacity,
    required this.economyKmL,
  });

  /// Litres allowed for the week.
  final double weeklyQuota;

  /// Litres already used this week.
  final double weekUsed;

  /// Current estimated fuel in the tank (L).
  final double currentFuel;

  /// Full tank capacity (L).
  final double tankCapacity;

  /// Rolling average fuel economy (km/L).
  final double economyKmL;

  double get _usageFraction =>
      (weeklyQuota > 0 ? weekUsed / weeklyQuota : 0.0).clamp(0.0, 1.0);

  /// Bar fill color based on usage percentage thresholds.
  Color get _barColor {
    final pct = _usageFraction;
    if (pct > 0.90) return AppColors.error;
    if (pct > 0.60) return AppColors.amber;
    return AppColors.olive;
  }

  double get _estimatedRangeKm => currentFuel * economyKmL;

  @override
  Widget build(BuildContext context) {
    return RLCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: label + used / quota ──────────────────────────────────
          Row(
            children: [
              Text(
                'THIS WEEK',
                style: RLText.labelMd.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: weekUsed.toStringAsFixed(1),
                      style: RLText.numSm.copyWith(color: AppColors.amber),
                    ),
                    TextSpan(
                      text: ' / ${weeklyQuota.toStringAsFixed(1)} L',
                      style:
                          RLText.labelMd.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: RLSpacing.sm),

          // ── Progress bar ───────────────────────────────────────────────
          RLProgressBar(
            value: _usageFraction,
            color: _barColor,
            height: 8,
          ),

          const SizedBox(height: RLSpacing.base),

          // ── Divider ────────────────────────────────────────────────────
          const Divider(
            color: AppColors.divider,
            height: 1,
            thickness: 1,
          ),

          const SizedBox(height: RLSpacing.base),

          // ── Bottom row: tank | range | economy ─────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomStat(
                value: currentFuel.toStringAsFixed(1),
                unit: 'L',
                label: 'Current tank',
              ),
              _Divider(),
              _BottomStat(
                value: '~${_estimatedRangeKm.round()}',
                unit: 'km',
                label: 'Est. range',
              ),
              _Divider(),
              _BottomStat(
                value: economyKmL.toStringAsFixed(1),
                unit: 'km/L',
                label: 'Economy',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _BottomStat extends StatelessWidget {
  const _BottomStat({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: RLText.numSm.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: RLText.labelSm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: RLText.labelMd.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: VerticalDivider(
        color: AppColors.border,
        width: 1,
        thickness: 1,
      ),
    );
  }
}
