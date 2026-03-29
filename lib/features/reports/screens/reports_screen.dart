import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            title: const Text('Reports & Export', style: RLText.headlineMd),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Export All',
                  style: RLText.labelLg.copyWith(color: AppColors.amber),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Date Filter Row ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: RLSpacing.base,
                      vertical: RLSpacing.md,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: RLSpacing.sm),
                        Text(
                          'Last 30 days',
                          style: RLText.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Change',
                          style: RLText.labelMd.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                        const SizedBox(width: RLSpacing.xs),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.amber,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.md),

                  // ── 2. Quick Stats Row ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(value: '5', unit: '', label: 'Rides'),
                      ),
                      const SizedBox(width: RLSpacing.sm),
                      Expanded(
                        child: _StatCard(
                          value: '133',
                          unit: 'km',
                          label: 'Distance',
                        ),
                      ),
                      const SizedBox(width: RLSpacing.sm),
                      Expanded(
                        child: _StatCard(
                          value: '3.66',
                          unit: 'L',
                          label: 'Fuel',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 3. Available Reports Label ────────────────────────────
                  Text(
                    'AVAILABLE REPORTS',
                    style: RLText.labelSm.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: RLSpacing.sm),

                  // ── 4. Report Type Cards ──────────────────────────────────
                  ...SampleData.reportTypes.map(
                    (report) => _ReportCard(report: report),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 5. Export All Card ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.amberSurface,
                      border: Border.all(color: AppColors.amberDim),
                      borderRadius: RLRadius.borderXl,
                    ),
                    padding: const EdgeInsets.all(RLSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.download_outlined,
                              size: 24,
                              color: AppColors.amber,
                            ),
                            const SizedBox(width: RLSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Full Data Export',
                                    style: RLText.headlineSm,
                                  ),
                                  const SizedBox(height: RLSpacing.xs),
                                  Text(
                                    'All ride, fuel, and service records',
                                    style: RLText.bodyMd.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: RLSpacing.base),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: RLRadius.borderMd,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'JSON',
                                  style: RLText.labelMd.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: RLRadius.borderMd,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'CSV',
                                  style: RLText.labelMd.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

// ── Stat Card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: RLText.numMd),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ],
          ),
          const SizedBox(height: RLSpacing.xs),
          Text(
            label,
            style: RLText.labelMd.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── Report Card ───────────────────────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final SampleReportType report;

  @override
  Widget build(BuildContext context) {
    final isRideHistory = report.id == 'rpt1';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bgCardHigh,
              borderRadius: RLRadius.borderLg,
            ),
            child: Icon(
              report.icon,
              size: 22,
              color: isRideHistory ? AppColors.amber : AppColors.slate,
            ),
          ),
          const SizedBox(width: RLSpacing.md),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.title, style: RLText.headlineSm),
                const SizedBox(height: 2),
                Text(
                  report.subtitle,
                  style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: RLSpacing.sm),
          // Format chips + export button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: report.formats
                    .map(
                      (fmt) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHigh,
                            borderRadius: RLRadius.borderSm,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Text(
                            fmt,
                            style: RLText.labelSm.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: RLSpacing.xs),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: RLRadius.borderMd,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Text(
                  'Export',
                  style: RLText.labelMd.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
