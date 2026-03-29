import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class FuelDashboardScreen extends StatelessWidget {
  const FuelDashboardScreen({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}';

  @override
  Widget build(BuildContext context) {
    final usedFraction =
        (SampleData.weekUsedLiters / SampleData.weeklyQuotaLiters)
            .clamp(0.0, 1.0);
    final usedPercent = (usedFraction * 100).round();
    final remaining =
        (SampleData.weeklyQuotaLiters - SampleData.weekUsedLiters)
            .toStringAsFixed(1);
    final progressColor =
        usedFraction < 0.8 ? AppColors.olive : AppColors.amber;

    // Fuel economy trend data (last 3 refuels — use fuelLogs)
    final logs = SampleData.fuelLogs;

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
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── 1. Weekly Quota Card ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(RLSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: RLRadius.borderXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This Week',
                                style: RLText.labelMd.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${SampleData.weekUsedLiters} / ${SampleData.weeklyQuotaLiters} L',
                            style: RLText.headlineMd.copyWith(
                              color: AppColors.amber,
                            ),
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
                                    width:
                                        constraints.maxWidth * usedFraction,
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
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$remaining L remaining',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.olive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: RLSpacing.base),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: RLSpacing.md),
                      // 3 mini stats
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            _QuotaMiniStat(
                              value:
                                  '${SampleData.currentFuelLiters.toStringAsFixed(1)} L',
                              label: 'Current',
                            ),
                            _VerticalDivider(),
                            _QuotaMiniStat(
                              value:
                                  '~${(SampleData.currentFuelLiters * SampleData.fuelEconomyKmL).round()} km',
                              label: 'Est. Range',
                            ),
                            _VerticalDivider(),
                            _QuotaMiniStat(
                              value: SampleData.fuelEconomyKmL
                                  .toStringAsFixed(1),
                              label: 'km/L',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RLSpacing.base),

                // ── 2. Fuel Economy Trend Header ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: RLSpacing.sm),
                  child: Text(
                    'FUEL ECONOMY',
                    style: RLText.labelMd.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // ── 3. Economy Card ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(RLSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: RLRadius.borderXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last 3 refuels average',
                        style: RLText.labelMd.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: RLSpacing.xs + 2),
                      Text(
                        '${SampleData.fuelEconomyKmL.toStringAsFixed(1)} km/L',
                        style: RLText.displaySm,
                      ),
                      const SizedBox(height: RLSpacing.md),
                      // 3 trend cards
                      Row(
                        children: List.generate(logs.length, (i) {
                          final log = logs[i];
                          // Economy for each log — approximated from adjacent
                          final economies = [36.0, 35.9, 35.3];
                          final economy = economies[i];
                          final prevEconomy = i < economies.length - 1
                              ? economies[i + 1]
                              : null;
                          final isUp = prevEconomy == null ||
                              economy >= prevEconomy;
                          final change = prevEconomy != null
                              ? (economy - prevEconomy).abs()
                              : 0.0;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: i < logs.length - 1 ? 8 : 0),
                              child: _TrendCard(
                                date: _formatDate(log.date),
                                economy: economy,
                                isUp: isUp,
                                change: change,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RLSpacing.base),

                // ── 4. Refuel Log Header ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: RLSpacing.sm),
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

                // ── 5. Refuel Log Items ───────────────────────────────────
                ...SampleData.fuelLogs.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: RLSpacing.sm),
                    child: _RefuelLogItem(item: item, formatDate: _formatDate),
                  ),
                ),

                // ── 6. Bottom padding ─────────────────────────────────────
                const SizedBox(height: 100),
              ]),
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

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.date,
    required this.economy,
    required this.isUp,
    required this.change,
  });

  final String date;
  final double economy;
  final bool isUp;
  final double change;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCardHigh,
        borderRadius: RLRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(economy.toStringAsFixed(1), style: RLText.numSm),
              const SizedBox(width: 2),
              Text(
                'km/L',
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (change > 0)
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10,
                  color: isUp ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 2),
                Text(
                  change.toStringAsFixed(1),
                  style: RLText.labelSm.copyWith(
                    color: isUp ? AppColors.success : AppColors.error,
                    fontSize: 9,
                  ),
                ),
              ],
            )
          else
            Text(
              '—',
              style: RLText.labelSm.copyWith(color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }
}

class _RefuelLogItem extends StatelessWidget {
  const _RefuelLogItem({
    required this.item,
    required this.formatDate,
  });

  final SampleFuelLog item;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final totalCost =
        (item.liters * item.pricePerLiter).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: RLRadius.borderLg,
      ),
      child: Row(
        children: [
          // Icon container
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
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.liters.toStringAsFixed(1)} L',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'at ₹${item.pricePerLiter.toStringAsFixed(2)}/L · Odometer: ${item.odometer.toInt()} km',
                  style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: RLSpacing.sm),
          // Cost
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$totalCost', style: RLText.numSm),
              const SizedBox(height: 2),
              Text(
                'total',
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
