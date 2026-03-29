import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';
import '../../../shared/routing/route_paths.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.base,
                  vertical: RLSpacing.lg,
                ),
                child: Row(
                  children: [
                    Text('More', style: RLText.headlineLg),
                  ],
                ),
              ),

              // ── 2. Navigation Cards Grid ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: RLSpacing.base),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _NavCard(
                            icon: Icons.build_outlined,
                            iconColor: AppColors.olive,
                            title: 'Maintenance',
                            subtitle: 'Service & reminders',
                            onTap: () => context.go(RoutePaths.maintenance),
                          ),
                        ),
                        const SizedBox(width: RLSpacing.md),
                        Expanded(
                          child: _NavCard(
                            icon: Icons.timeline,
                            iconColor: AppColors.amber,
                            title: 'Break-In',
                            subtitle: 'Stage progress & guidance',
                            onTap: () => context.go(RoutePaths.breakIn),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RLSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _NavCard(
                            icon: Icons.download_outlined,
                            iconColor: AppColors.slate,
                            title: 'Reports',
                            subtitle: 'PDF, CSV & full backup',
                            onTap: () => context.go(RoutePaths.reports),
                          ),
                        ),
                        const SizedBox(width: RLSpacing.md),
                        Expanded(
                          child: _NavCard(
                            icon: Icons.settings_outlined,
                            iconColor: AppColors.textSecondary,
                            title: 'Settings',
                            subtitle: 'Preferences & bike profile',
                            onTap: () => context.go(RoutePaths.settings),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: RLSpacing.lg),

              // ── 3. Quick Stats Section ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.base,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: RLSpacing.sm),
                      child: Text(
                        'AT A GLANCE',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        border:
                            Border.all(color: AppColors.border, width: 1),
                        borderRadius: RLRadius.borderXl,
                      ),
                      child: Column(
                        children: [
                          _StatRow(
                            label: 'Odometer',
                            value:
                                '${SampleData.currentOdometer.toStringAsFixed(1)} km',
                            valueColor: AppColors.amber,
                            isFirst: true,
                          ),
                          const _RowDivider(),
                          _StatRow(
                            label: 'Total Rides',
                            value: '${SampleData.totalRides}',
                          ),
                          const _RowDivider(),
                          _StatRow(
                            label: 'Break-In',
                            value:
                                '${SampleData.breakIn.progressPercent}%',
                            valueColor: AppColors.amber,
                          ),
                          const _RowDivider(),
                          _StatRow(
                            label: 'Next Service',
                            value: 'Oil Change · 87 km',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 4. Bottom padding ──────────────────────────────────────
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Navigation Card ────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(RLSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: RLRadius.borderXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.bgCardHigh,
                borderRadius: RLRadius.borderLg,
              ),
              child: Icon(
                icon,
                size: RLSizes.iconLg,
                color: iconColor,
              ),
            ),
            const SizedBox(height: RLSpacing.md),
            Text(title, style: RLText.headlineSm),
            const SizedBox(height: RLSpacing.xs),
            Text(
              subtitle,
              style: RLText.bodySm.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Row ───────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final topRadius = isFirst ? const Radius.circular(RLRadius.xl) : Radius.zero;
    final bottomRadius =
        isLast ? const Radius.circular(RLRadius.xl) : Radius.zero;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: topRadius,
        topRight: topRadius,
        bottomLeft: bottomRadius,
        bottomRight: bottomRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RLSpacing.base,
          vertical: RLSpacing.md,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: RLText.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: RLText.bodyMd.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row Divider ────────────────────────────────────────────────────────────

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: RLSpacing.base,
      endIndent: RLSpacing.base,
    );
  }
}
