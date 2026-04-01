import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/break_in_stages.dart';
import '../../../shared/providers/break_in_provider.dart';
import '../../../shared/providers/rides_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';

class BreakInScreen extends ConsumerWidget {
  const BreakInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakInAsync = ref.watch(breakInProgressProvider);
    final profileAsync = ref.watch(bikeProfileProvider);
    final riddenAsync = ref.watch(totalRiddenKmProvider);

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
          breakInAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(color: AppColors.amber)),
            ),
            error: (_, __) => const SliverFillRemaining(
              child: Center(child: Text('Error loading break-in data')),
            ),
            data: (breakIn) {
              if (breakIn == null) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No break-in data found')),
                );
              }

              final profile = profileAsync.valueOrNull;
              final ridden = riddenAsync.valueOrNull ?? 0.0;
              final currentOdom = profile?.currentOdometerKm(appTrackedKm: ridden);
              final kmSinceRebuild = breakIn.currentKm;
              const totalBreakInKm = 2500.0;
              final overallProgress =
                  (kmSinceRebuild / totalBreakInKm).clamp(0.0, 1.0);
              final overallPercent = (overallProgress * 100).round();
              final remaining = (totalBreakInKm - kmSinceRebuild).clamp(0, double.infinity);
              final isComplete = kmSinceRebuild >= totalBreakInKm;

              // Current stage
              final currentStage =
                  BreakInStage.getStageFromKm(kmSinceRebuild);

              return SliverPadding(
                padding: const EdgeInsets.all(RLSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 1. Hero Progress Card ───────────────────────────────
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
                              style: RLText.labelMd
                                  .copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: RLSpacing.sm),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${kmSinceRebuild.toInt()} km',
                                  style: RLText.displaySm,
                                ),
                                const Spacer(),
                                Text(
                                  '/ ${totalBreakInKm.toInt()} km',
                                  style: RLText.bodyLg.copyWith(
                                      color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: RLSpacing.md),
                            ClipRRect(
                              borderRadius: RLRadius.borderPill,
                              child: Container(
                                height: 10,
                                color: AppColors.bgCardHigh,
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: overallProgress,
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
                                  '$overallPercent% complete',
                                  style: RLText.labelMd
                                      .copyWith(color: AppColors.amber),
                                ),
                                const Spacer(),
                                if (!isComplete)
                                  Text(
                                    '${remaining.toInt()} km remaining',
                                    style: RLText.labelMd.copyWith(
                                        color: AppColors.textMuted),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.oliveSurface,
                                      borderRadius: RLRadius.borderPill,
                                    ),
                                    child: Text(
                                      'Complete!',
                                      style: RLText.labelSm
                                          .copyWith(color: AppColors.olive),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: RLSpacing.base),
                            const Divider(color: AppColors.divider, height: 1),
                            const SizedBox(height: RLSpacing.md),
                            // Active stage badge
                            if (!isComplete) ...[
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.amberSurface,
                                  borderRadius: RLRadius.borderPill,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text(
                                  'Stage ${currentStage.stageNumber} of 4 Active',
                                  style: RLText.labelMd
                                      .copyWith(color: AppColors.amber),
                                ),
                              ),
                              const SizedBox(height: RLSpacing.md),
                              Text(
                                '${currentStage.name} · ${currentStage.minRecommendedSpeedKmh.toInt()}–${currentStage.maxRecommendedSpeedKmh.toInt()} km/h',
                                style: RLText.headlineSm,
                              ),
                              const SizedBox(height: RLSpacing.xs + 2),
                              Text(
                                currentStage.description,
                                style: RLText.bodyMd.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                            ],
                            // Odometer row
                            if (currentOdom != null) ...[
                              const SizedBox(height: RLSpacing.md),
                              const Divider(color: AppColors.divider, height: 1),
                              const SizedBox(height: RLSpacing.sm),
                              Row(
                                children: [
                                  const Icon(Icons.speed,
                                      size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Current odometer: ${currentOdom.toStringAsFixed(0)} km',
                                    style: RLText.labelMd.copyWith(
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 2. Yamaha Official Throttle Guidance ────────────────
                      Text(
                        'THROTTLE GUIDANCE',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: RLSpacing.sm),
                      _ThrottleGuidanceCard(kmSinceRebuild: kmSinceRebuild),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 3. Stage Cards ──────────────────────────────────────
                      Text(
                        'STAGES',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: RLSpacing.sm),
                      ...BreakInStage.allStages
                          .where((s) => s.stageNumber <= 4)
                          .map(
                            (stage) => _StageCard(
                              stage: stage,
                              kmSinceRebuild: kmSinceRebuild,
                            ),
                          ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 4. Speed & Gear Reference ───────────────────────────
                      Text(
                        'SPEED BY GEAR (APPROX.)',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: RLSpacing.sm),
                      const _GearSpeedTable(),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Throttle guidance card ─────────────────────────────────────────────────

class _ThrottleGuidanceCard extends StatelessWidget {
  const _ThrottleGuidanceCard({required this.kmSinceRebuild});

  final double kmSinceRebuild;

  static const _stages = [
    (range: '0–150 km', throttle: 'Max 1/3 throttle', rpm: '2500–4000 RPM'),
    (
      range: '150–500 km',
      throttle: 'Max 1/2 throttle',
      rpm: '3000–5000 RPM'
    ),
    (range: '500–1000 km', throttle: 'Max 3/4 throttle', rpm: '3000–6000 RPM'),
    (
      range: '1000+ km',
      throttle: 'Avoid prolonged full throttle',
      rpm: '3500–6500 RPM'
    ),
  ];

  int get _activeIndex {
    if (kmSinceRebuild < 150) return 0;
    if (kmSinceRebuild < 500) return 1;
    if (kmSinceRebuild < 1000) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeIndex;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderXl,
      ),
      child: Column(
        children: List.generate(_stages.length, (i) {
          final s = _stages[i];
          final isActive = i == active;
          final isDone = i < active;
          final color = isDone
              ? AppColors.olive
              : isActive
                  ? AppColors.amber
                  : AppColors.textDisabled;
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: RLSpacing.base, vertical: 12),
            decoration: BoxDecoration(
              border: i < _stages.length - 1
                  ? const Border(
                      bottom: BorderSide(color: AppColors.divider))
                  : null,
              color: isActive
                  ? AppColors.amberSurface.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.oliveSurface
                        : isActive
                            ? AppColors.amberSurface
                            : AppColors.bgCardHigh,
                    shape: BoxShape.circle,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 13, color: AppColors.olive)
                      : Center(
                          child: Text(
                            '${i + 1}',
                            style: RLText.labelSm.copyWith(color: color),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.range,
                        style: RLText.labelMd.copyWith(
                          color: isActive
                              ? AppColors.amber
                              : isDone
                                  ? AppColors.olive
                                  : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        s.throttle,
                        style: RLText.bodySm.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
                Text(
                  s.rpm,
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Stage card ─────────────────────────────────────────────────────────────

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage, required this.kmSinceRebuild});

  final BreakInStage stage;
  final double kmSinceRebuild;

  @override
  Widget build(BuildContext context) {
    final isCompleted = kmSinceRebuild >= stage.endKm;
    final isActive = kmSinceRebuild >= stage.startKm &&
        kmSinceRebuild < stage.endKm;

    final badgeBg = isCompleted
        ? AppColors.oliveSurface
        : isActive
            ? AppColors.amberSurface
            : AppColors.bgCardHigh;

    // Progress within this stage
    final stageProgress = isCompleted
        ? 1.0
        : isActive
            ? ((kmSinceRebuild - stage.startKm) /
                    (stage.endKm - stage.startKm))
                .clamp(0.0, 1.0)
            : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(
          color: isActive ? AppColors.amber.withValues(alpha: 0.4) : AppColors.border,
        ),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          '${stage.stageNumber}',
                          style: RLText.labelMd.copyWith(
                            color: isActive
                                ? AppColors.amber
                                : AppColors.textDisabled,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
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
                          '${stage.minRecommendedSpeedKmh.toInt()}–${stage.maxRecommendedSpeedKmh.toInt()} km/h',
                          style: RLText.labelMd.copyWith(
                            color: isActive
                                ? AppColors.amber
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stage.startKm.toInt()}–${stage.endKm.isFinite ? stage.endKm.toInt() : '∞'} km since rebuild',
                      style: RLText.labelMd
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    if (isActive) ...[
                      const SizedBox(height: RLSpacing.sm),
                      Text(
                        stage.description,
                        style: RLText.bodySm
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Progress bar for active/pending stages
          if (!isCompleted) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: RLRadius.borderPill,
              child: Container(
                height: 3,
                color: AppColors.bgCardHigh,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: stageProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.amber : AppColors.textDisabled,
                      borderRadius: RLRadius.borderPill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Gear speed reference table ─────────────────────────────────────────────

class _GearSpeedTable extends StatelessWidget {
  const _GearSpeedTable();

  static const _headers = ['Gear', '3000', '4000', '5000', '6000'];
  static const _rows = [
    ['1st', '11', '14', '18', '22'],
    ['2nd', '17', '23', '29', '34'],
    ['3rd', '23', '31', '39', '47'],
    ['4th', '30', '39', '49', '59'],
    ['5th', '37', '50', '62', '75'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderXl,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: RLSpacing.base, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: _headers
                  .map(
                    (h) => Expanded(
                      child: Text(
                        h == 'Gear' ? h : '$h RPM',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                        textAlign:
                            h == 'Gear' ? TextAlign.left : TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Data rows
          ..._rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.base, vertical: 10),
              decoration: BoxDecoration(
                border: i < _rows.length - 1
                    ? const Border(
                        bottom: BorderSide(color: AppColors.divider))
                    : null,
              ),
              child: Row(
                children: row.asMap().entries.map((e) {
                  final isGear = e.key == 0;
                  return Expanded(
                    child: Text(
                      isGear ? e.value : '${e.value} km/h',
                      style: isGear
                          ? RLText.labelMd.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            )
                          : RLText.labelSm.copyWith(
                              color: AppColors.textSecondary),
                      textAlign: isGear ? TextAlign.left : TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
