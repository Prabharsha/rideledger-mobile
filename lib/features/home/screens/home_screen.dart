import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HomeContent(),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. TOP HEADER ──────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.only(
            top: topPad,
            left: RLSpacing.screenH,
            right: RLSpacing.screenH,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: greeting + title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning',
                    style: RLText.labelMd.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'RideLedger',
                    style: RLText.headlineLg.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Notification icon with badge
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      size: 24,
                      color: AppColors.textSecondary,
                    ),
                    // Badge dot — show when there are reminders
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgBase,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Avatar circle with motorcycle icon
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.bgCardHigh,
                child: const Icon(
                  Icons.motorcycle,
                  size: 20,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        ),

        // ── 2. STATUS HERO CARD ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: RLSpacing.screenH,
            right: RLSpacing.screenH,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: RLRadius.borderXl,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: const EdgeInsets.all(RLSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Today's Rides" label + badge
                Row(
                  children: [
                    Text(
                      "Today's Rides",
                      style: RLText.labelMd.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RLSpacing.sm,
                        vertical: RLSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberSurface,
                        borderRadius: RLRadius.borderPill,
                      ),
                      child: Text(
                        '3 rides',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.amber,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 3 quick stats row
                IntrinsicHeight(
                  child: Row(
                    children: [
                      // Distance
                      Expanded(
                        child: _QuickStat(
                          value: '45.2',
                          unit: 'km',
                          label: 'Today',
                          valueColor: AppColors.textPrimary,
                        ),
                      ),
                      _VerticalDivider(),
                      // Ride time
                      Expanded(
                        child: _QuickStat(
                          value: '2h 04m',
                          unit: '',
                          label: 'Ride Time',
                          valueColor: AppColors.textPrimary,
                        ),
                      ),
                      _VerticalDivider(),
                      // Fuel
                      Expanded(
                        child: _QuickStat(
                          value: '0.0',
                          unit: 'L',
                          label: 'Fuel',
                          valueColor: AppColors.olive,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Start Ride button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: RLRadius.borderMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: AppColors.textInverse,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Start Ride',
                          style: RLText.btnLg.copyWith(
                            color: AppColors.textInverse,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── 3. BREAK-IN SECTION ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: RLSpacing.screenH,
            right: RLSpacing.screenH,
            bottom: 8,
          ),
          child: Text(
            'BREAK-IN',
            style: RLText.labelMd.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.8,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: RLRadius.borderXl,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: const EdgeInsets.all(RLSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage badge + km counter
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RLSpacing.sm,
                        vertical: RLSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberSurface,
                        borderRadius: RLRadius.borderPill,
                      ),
                      child: Text(
                        'Stage 3 of 4',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.amber,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${SampleData.breakIn.currentKm.toInt()} / '
                      '${SampleData.breakIn.targetKm.toInt()} km',
                      style: RLText.labelMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Progress bar
                ClipRRect(
                  borderRadius: RLRadius.borderPill,
                  child: Container(
                    height: 6,
                    width: double.infinity,
                    color: AppColors.bgCardHigh,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: SampleData.breakIn.progressFraction,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          borderRadius: RLRadius.borderPill,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Stage name + percent
                Row(
                  children: [
                    Text(
                      SampleData.breakIn.activeStage.name,
                      style: RLText.bodySm.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${SampleData.breakIn.progressPercent}%',
                      style: RLText.labelMd.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Speed advice
                Text(
                  '${SampleData.breakIn.activeStage.speedRange} · '
                  'Mix urban and highway',
                  style: RLText.labelMd.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── 4. SERVICE REMINDERS SECTION ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: RLSpacing.screenH,
            right: RLSpacing.screenH,
            bottom: 8,
          ),
          child: Row(
            children: [
              Text(
                'SERVICE REMINDERS',
                style: RLText.labelMd.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1.8,
                ),
              ),
              const Spacer(),
              Text(
                'See all',
                style: RLText.labelMd.copyWith(
                  color: AppColors.amber,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),

        // First 2 maintenance items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: Column(
            children: SampleData.maintenance
                .take(2)
                .map((item) => _MaintenanceCard(item: item))
                .toList(),
          ),
        ),

        // ── 5. RECENT RIDES SECTION ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: RLSpacing.screenH,
            right: RLSpacing.screenH,
            bottom: 8,
          ),
          child: Text(
            'RECENT RIDES',
            style: RLText.labelMd.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.8,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: Column(
            children: SampleData.rides
                .take(2)
                .map((ride) => _RideCard(ride: ride))
                .toList(),
          ),
        ),

        // ── 6. BOTTOM PADDING ───────────────────────────────────────────────
        const SizedBox(height: 100),
      ],
    );
  }
}

// ── Quick Stat widget ─────────────────────────────────────────────────────────
class _QuickStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final Color valueColor;

  const _QuickStat({
    required this.value,
    required this.unit,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: RLText.numLg.copyWith(color: valueColor),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    unit,
                    style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: RLText.labelSm.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ── Vertical Divider widget ───────────────────────────────────────────────────
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

// ── Maintenance Card widget ───────────────────────────────────────────────────
class _MaintenanceCard extends StatelessWidget {
  final SampleMaintenance item;

  const _MaintenanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderLg,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCardHigh,
              borderRadius: RLRadius.borderSm,
            ),
            child: Icon(
              item.icon,
              size: RLSizes.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: RLText.labelMd.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status badge
          _MaintenanceStatusBadge(status: item.status, item: item),
        ],
      ),
    );
  }
}

class _MaintenanceStatusBadge extends StatelessWidget {
  final MaintenanceStatus status;
  final SampleMaintenance item;

  const _MaintenanceStatusBadge({
    required this.status,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color textColor;
    Color bgColor;

    switch (status) {
      case MaintenanceStatus.done:
        label = 'Done';
        textColor = AppColors.olive;
        bgColor = AppColors.oliveSurface;
        break;
      case MaintenanceStatus.overdue:
        label = 'Due now';
        textColor = AppColors.error;
        bgColor = AppColors.errorSurface;
        break;
      case MaintenanceStatus.due:
        label = 'Due now';
        textColor = AppColors.error;
        bgColor = AppColors.errorSurface;
        break;
      case MaintenanceStatus.upcoming:
        final kmLeft = item.kmRemaining.toInt();
        label = '$kmLeft km';
        textColor = AppColors.amber;
        bgColor = AppColors.amberSurface;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RLSpacing.sm,
        vertical: RLSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: RLRadius.borderPill,
      ),
      child: Text(
        label,
        style: RLText.labelSm.copyWith(color: textColor),
      ),
    );
  }
}

// ── Ride Card widget ──────────────────────────────────────────────────────────
class _RideCard extends StatelessWidget {
  final SampleRide ride;

  const _RideCard({required this.ride});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderLg,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From → To + date
          Row(
            children: [
              Expanded(
                child: Text(
                  '${ride.fromLabel}  →  ${ride.toLabel}',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(ride.date),
                style: RLText.labelSm.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Mini stats row
          IntrinsicHeight(
            child: Row(
              children: [
                // Distance
                Expanded(
                  child: _RideMiniStat(
                    value: ride.distanceKm.toStringAsFixed(1),
                    unit: 'km',
                    label: 'Distance',
                  ),
                ),
                _RideStatDivider(),
                // Duration
                Expanded(
                  child: _RideMiniStat(
                    value: ride.durationLabel,
                    unit: '',
                    label: 'Duration',
                  ),
                ),
                _RideStatDivider(),
                // Fuel
                Expanded(
                  child: _RideMiniStat(
                    value: ride.fuelUsedL.toStringAsFixed(2),
                    unit: 'L',
                    label: 'Fuel',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RideMiniStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;

  const _RideMiniStat({
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: RLText.numSm.copyWith(color: AppColors.textPrimary),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: RLText.labelSm.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _RideStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.sm),
    );
  }
}
