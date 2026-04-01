import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/fuel_log_model.dart';
import '../../../shared/providers/fuel_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';

class FuelDashboardScreen extends ConsumerWidget {
  const FuelDashboardScreen({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(bikeProfileProvider);
    final weeklyUsedAsync = ref.watch(weeklyFuelUsedProvider);
    final allLogsAsync = ref.watch(allFuelLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text('Fuel Tracker', style: RLText.headlineMd),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.textSecondary),
                onPressed: null,
                tooltip: 'Add refuel',
              ),
            ],
          ),
          profileAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.amber,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (_, __) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Could not load fuel data',
                  style: RLText.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
            data: (profile) {
              if (profile == null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No bike profile found',
                      style:
                          RLText.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                );
              }

              final quota = profile.weeklyFuelQuotaLiters;
              final weeklyUsed =
                  weeklyUsedAsync.valueOrNull ?? 0.0;
              final usedFraction = (weeklyUsed / quota).clamp(0.0, 1.0);
              final usedPercent = (usedFraction * 100).round();
              final remaining = (quota - weeklyUsed).toStringAsFixed(1);
              final progressColor =
                  usedFraction < 0.8 ? AppColors.olive : AppColors.amber;
              final economy = profile.manualFuelEconomyKmPerLiter;
              final balance = profile.weeklyFuelBalanceLiters;

              return SliverPadding(
                padding: const EdgeInsets.all(RLSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── 1. Weekly Quota Card ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(RLSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        border:
                            Border.all(color: AppColors.border, width: 1),
                        borderRadius: RLRadius.borderXl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'This Week',
                                style: RLText.labelMd
                                    .copyWith(color: AppColors.textMuted),
                              ),
                              const Spacer(),
                              Text(
                                '${weeklyUsed.toStringAsFixed(1)} / ${quota.toStringAsFixed(1)} L',
                                style: RLText.headlineMd
                                    .copyWith(color: AppColors.amber),
                              ),
                            ],
                          ),
                          const SizedBox(height: RLSpacing.md),
                          // Progress bar
                          ClipRRect(
                            borderRadius: RLRadius.borderPill,
                            child: SizedBox(
                              height: 8,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: constraints.maxWidth,
                                        color: AppColors.bgCardHigh,
                                      ),
                                      Container(
                                        width: constraints.maxWidth *
                                            usedFraction,
                                        color: progressColor,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: RLSpacing.xs + 2),
                          Row(
                            children: [
                              Text(
                                '$usedPercent% used',
                                style: RLText.labelMd.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                              const Spacer(),
                              Text(
                                '$remaining L remaining',
                                style: RLText.labelMd
                                    .copyWith(color: AppColors.olive),
                              ),
                            ],
                          ),
                          const SizedBox(height: RLSpacing.base),
                          const Divider(
                              color: AppColors.divider, height: 1),
                          const SizedBox(height: RLSpacing.md),
                          // 3 mini stats
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _QuotaMiniStat(
                                  value:
                                      '${balance.toStringAsFixed(1)} L',
                                  label: 'Balance',
                                ),
                                _VerticalDivider(),
                                _QuotaMiniStat(
                                  value:
                                      '~${(balance * economy).round()} km',
                                  label: 'Est. Range',
                                ),
                                _VerticalDivider(),
                                _QuotaMiniStat(
                                  value: economy.toStringAsFixed(1),
                                  label: 'km/L',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: RLSpacing.base),

                    // ── 2. Odd/Even Restriction Banner ────────────────────
                    _OddEvenBanner(vehicleNumber: profile.vehicleNumber),

                    const SizedBox(height: RLSpacing.base),

                    // ── 3. Refuel Log Header ──────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: RLSpacing.sm),
                      child: Row(
                        children: [
                          Text(
                            'REFUEL LOG',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: null,
                            child: Text(
                              'Add',
                              style: RLText.labelMd.copyWith(
                                color: AppColors.amber,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── 3. Refuel Log Items ───────────────────────────────
                    ...allLogsAsync.valueOrNull?.map(
                          (item) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: RLSpacing.sm),
                            child: _RefuelLogItem(
                                item: item, formatDate: _formatDate),
                          ),
                        ) ??
                        [
                          // Empty state
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: RLSpacing.xl),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_gas_station_outlined,
                                    size: 40,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(height: RLSpacing.md),
                                  Text(
                                    'No refuels logged yet',
                                    style: RLText.bodySm.copyWith(
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Odd/Even Restriction Banner ────────────────────────────────────────────

class _OddEvenBanner extends StatelessWidget {
  const _OddEvenBanner({required this.vehicleNumber});

  final String? vehicleNumber;

  /// Returns the last digit of the vehicle number, or null if unavailable.
  int? _lastDigit() {
    if (vehicleNumber == null || vehicleNumber!.isEmpty) return null;
    for (int i = vehicleNumber!.length - 1; i >= 0; i--) {
      final code = vehicleNumber!.codeUnitAt(i);
      if (code >= 48 && code <= 57) return code - 48;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final digit = _lastDigit();
    if (digit == null) return const SizedBox.shrink();

    final today = DateTime.now().day;
    final canRefuel = digit % 2 == today % 2;
    final plateLabel = vehicleNumber!.toUpperCase();
    final parity = digit % 2 == 0 ? 'even' : 'odd';
    final todayParity = today % 2 == 0 ? 'even' : 'odd';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RLSpacing.base,
        vertical: RLSpacing.md,
      ),
      decoration: BoxDecoration(
        color: canRefuel
            ? AppColors.olive.withValues(alpha: 0.12)
            : AppColors.error.withValues(alpha: 0.10),
        borderRadius: RLRadius.borderLg,
        border: Border.all(
          color: canRefuel
              ? AppColors.olive.withValues(alpha: 0.4)
              : AppColors.error.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            canRefuel ? Icons.check_circle_outline : Icons.block_outlined,
            size: 20,
            color: canRefuel ? AppColors.olive : AppColors.error,
          ),
          const SizedBox(width: RLSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: RLText.bodySm.copyWith(
                  color: canRefuel ? AppColors.olive : AppColors.error,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: canRefuel
                        ? 'Refueling allowed today. '
                        : 'Refueling not allowed today. ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: '$plateLabel ends in $digit ($parity plate) · today is $todayParity.',
                    style: RLText.labelMd.copyWith(
                      color: canRefuel
                          ? AppColors.olive.withValues(alpha: 0.8)
                          : AppColors.error.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets ─────────────────────────────────────────────────────

class _QuotaMiniStat extends StatelessWidget {
  const _QuotaMiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: RLText.numSm),
          const SizedBox(height: 2),
          Text(
            label,
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.sm),
    );
  }
}

class _RefuelLogItem extends StatelessWidget {
  const _RefuelLogItem({
    required this.item,
    required this.formatDate,
  });

  final FuelLogModel item;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final totalCost = (item.litersAdded * (item.pricePerLiter ?? 0)).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: RLRadius.borderLg,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCardHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_gas_station,
              size: 18,
              color: AppColors.olive,
            ),
          ),
          const SizedBox(width: RLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.litersAdded.toStringAsFixed(1)} L',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'at ₹${item.pricePerLiter?.toStringAsFixed(2) ?? '--'}/L · Odo: ${item.odometerKm.toInt()} km',
                  style:
                      RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: RLSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$totalCost', style: RLText.numSm),
              const SizedBox(height: 2),
              Text(
                formatDate(item.date),
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
