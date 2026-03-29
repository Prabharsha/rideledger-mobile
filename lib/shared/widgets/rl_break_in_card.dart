import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/sample_data.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_card.dart';
import 'rl_progress_bar.dart';

/// Break-in progress overview card.
///
/// Displays overall kilometre progress with a large progress bar, percentage,
/// a divider, and the active stage details (name, speed range, advice).
class RLBreakInCard extends StatelessWidget {
  const RLBreakInCard({
    super.key,
    required this.progress,
  });

  final SampleBreakInProgress progress;

  @override
  Widget build(BuildContext context) {
    final activeStage = progress.activeStage;
    final totalStages = progress.stages.length;

    return RLCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: label + stage badge ───────────────────────────────────
          Row(
            children: [
              Text(
                'BREAK-IN PROGRESS',
                style: RLText.labelMd.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberSurface,
                  borderRadius: RLRadius.borderPill,
                  border: Border.all(color: AppColors.amberDim),
                ),
                child: Text(
                  'Stage ${activeStage.number} of $totalStages',
                  style: RLText.labelSm.copyWith(color: AppColors.amber),
                ),
              ),
            ],
          ),

          const SizedBox(height: RLSpacing.md),

          // ── Progress bar ───────────────────────────────────────────────
          RLProgressBar(
            value: progress.progressFraction,
            color: AppColors.amber,
            height: 8,
          ),

          const SizedBox(height: RLSpacing.sm),

          // ── km label + percentage ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${progress.currentKm.round()}',
                style: RLText.numSm.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(width: 3),
              Text(
                '/ ${progress.targetKm.round()} km',
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              Text(
                '${progress.progressPercent}%',
                style: RLText.labelMd.copyWith(color: AppColors.amber),
              ),
            ],
          ),

          const SizedBox(height: RLSpacing.base),

          // ── Divider ────────────────────────────────────────────────────
          const Divider(color: AppColors.divider, height: 1, thickness: 1),

          const SizedBox(height: RLSpacing.base),

          // ── Active stage detail ────────────────────────────────────────
          Text(
            activeStage.name,
            style: RLText.headlineSm.copyWith(color: AppColors.textPrimary),
          ),

          const SizedBox(height: RLSpacing.xs),

          Text(
            activeStage.speedRange,
            style: RLText.labelLg.copyWith(color: AppColors.amber),
          ),

          const SizedBox(height: RLSpacing.sm),

          Text(
            activeStage.advice,
            style: RLText.bodySm.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
