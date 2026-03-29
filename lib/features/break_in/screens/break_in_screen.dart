import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class BreakInScreen extends StatelessWidget {
  const BreakInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breakIn = SampleData.breakIn;
    final activeStage = breakIn.activeStage;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            title: Text('Break-In Planner', style: RLText.headlineMd),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Hero Progress Card ─────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXxl,
                    ),
                    padding: const EdgeInsets.all(RLSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Break-In Progress',
                          style: RLText.labelMd.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: RLSpacing.sm),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${breakIn.currentKm.toInt()} km',
                              style: RLText.displaySm,
                            ),
                            const Spacer(),
                            Text(
                              '/ ${breakIn.targetKm.toInt()} km',
                              style: RLText.bodyLg.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: RLSpacing.md),
                        // Progress bar
                        ClipRRect(
                          borderRadius: RLRadius.borderPill,
                          child: Container(
                            height: 10,
                            color: AppColors.bgCardHigh,
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: breakIn.progressFraction,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.amber,
                                  borderRadius: RLRadius.borderPill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: RLSpacing.sm),
                        Row(
                          children: [
                            Text(
                              '${breakIn.progressPercent}% complete',
                              style: RLText.labelMd.copyWith(
                                color: AppColors.amber,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(breakIn.targetKm - breakIn.currentKm).toInt()} km remaining',
                              style: RLText.labelMd.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: RLSpacing.base),
                        const Divider(color: AppColors.divider, height: 1),
                        const SizedBox(height: RLSpacing.md),
                        // Active stage
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.amberSurface,
                            borderRadius: RLRadius.borderPill,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            'Stage ${activeStage.number} Active',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(height: RLSpacing.md),
                        Text(
                          '${activeStage.name} · ${activeStage.speedRange}',
                          style: RLText.headlineSm,
                        ),
                        const SizedBox(height: RLSpacing.xs + 2),
                        Text(
                          activeStage.advice,
                          style: RLText.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 2. Stages Section Label ───────────────────────────────
                  Text(
                    'STAGES',
                    style: RLText.labelSm.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: RLSpacing.sm),

                  // ── 3. Stage Cards ────────────────────────────────────────
                  ...breakIn.stages.map(
                    (stage) => _StageCard(stage: stage),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 4. Weekly Target Card ─────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    padding: const EdgeInsets.all(RLSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Quota Alignment',
                          style: RLText.labelMd.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: RLSpacing.sm),
                        Text(
                          'At 5 L/week, ~180 km/week pace',
                          style: RLText.bodyMd.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: RLSpacing.xs),
                        Text(
                          'Break-in completes in approx. 1–2 more weeks at current pace.',
                          style: RLText.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stage Card ────────────────────────────────────────────────────────────────

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage});

  final SampleBreakInStage stage;

  @override
  Widget build(BuildContext context) {
    final isCompleted = stage.status == StageStatus.completed;
    final isActive = stage.status == StageStatus.active;

    final badgeBg = isCompleted
        ? AppColors.oliveSurface
        : isActive
            ? AppColors.amberSurface
            : AppColors.bgCardHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage number / check badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: AppColors.olive)
                : Center(
                    child: Text(
                      '${stage.number}',
                      style: RLText.labelMd.copyWith(
                        color: isActive
                            ? AppColors.amber
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(stage.name, style: RLText.headlineSm),
                    ),
                    Text(
                      stage.speedRange,
                      style: RLText.labelMd.copyWith(
                        color: isActive
                            ? AppColors.amber
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RLSpacing.xs),
                Text(
                  '${stage.fromKm}–${stage.toKm} km',
                  style: RLText.labelMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(height: RLSpacing.sm),
                  Text(
                    stage.advice,
                    style: RLText.bodySm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isCompleted) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check, size: 16, color: AppColors.olive),
          ],
        ],
      ),
    );
  }
}
