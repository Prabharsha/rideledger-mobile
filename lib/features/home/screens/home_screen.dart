import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/maintenance_reminder_model.dart';
import '../../../data/models/ride_session_model.dart';
import '../../../shared/providers/maintenance_provider.dart';
import '../../../shared/providers/repositories_provider.dart';
import '../../../shared/providers/rides_provider.dart';
import '../../../shared/providers/break_in_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/providers/fuel_provider.dart';
import '../../../shared/routing/route_paths.dart';

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

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  static String _fmtDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top + 16.0;

    final allRides = ref.watch(allRideSessionsProvider).valueOrNull ?? [];
    final breakIn = ref.watch(breakInProgressProvider).valueOrNull;
    final currentStage = ref.watch(currentBreakInStageProvider).valueOrNull;
    final profile = ref.watch(bikeProfileProvider).valueOrNull;
    final totalRiddenKm = ref.watch(totalRiddenKmProvider).valueOrNull ?? 0.0;
    final currentOdometerKm = profile?.currentOdometerKm(appTrackedKm: totalRiddenKm);
    final tankFuel = ref.watch(tankFuelProvider).valueOrNull;
    final pendingReminders =
        ref.watch(pendingRemindersProvider).valueOrNull ?? [];

    // Today's aggregates
    final now = DateTime.now();
    final todayRides = allRides
        .where((r) =>
            r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day)
        .toList();
    final todayDistKm = todayRides.fold(0.0, (s, r) => s + r.distanceKm);
    final todayDurSec = todayRides.fold(0, (s, r) => s + r.durationSeconds);
    final todayFuelL =
        todayRides.fold(0.0, (s, r) => s + r.estimatedFuelUsedLiters);

    // Last 2 rides
    final recentRides = allRides.take(2).toList();

    // Break-in helpers
    final progressFraction = breakIn != null && breakIn.stageEndKm.isFinite
        ? ((breakIn.currentKm - breakIn.stageStartKm) /
                (breakIn.stageEndKm - breakIn.stageStartKm))
            .clamp(0.0, 1.0)
        : (breakIn != null ? 1.0 : 0.0);
    final stageLabel = breakIn == null
        ? '--'
        : breakIn.stageNumber <= 4
            ? 'Stage ${breakIn.stageNumber} of 4'
            : 'Complete';
    final kmText = breakIn == null
        ? '--'
        : breakIn.stageEndKm.isFinite
            ? '${breakIn.currentKm.toInt()} / ${breakIn.stageEndKm.toInt()} km'
            : '${breakIn.currentKm.toInt()} km';
    final speedRange = currentStage != null
        ? '${currentStage.minRecommendedSpeedKmh.toInt()} – ${currentStage.maxRecommendedSpeedKmh.toInt()} km/h'
        : '--';

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

        // ── 1b. ODOMETER STRIP ──────────────────────────────────────────────
        if (currentOdometerKm != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: RLSpacing.screenH,
              right: RLSpacing.screenH,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.speed_outlined,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 5),
                Text(
                  'Odometer',
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(width: 8),
                Text(
                  '${currentOdometerKm.toInt()} km',
                  style: RLText.labelSm.copyWith(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // ── 2. STATUS HERO CARD ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
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
                        '${todayRides.length} ${todayRides.length == 1 ? "ride" : "rides"}',
                        style: RLText.labelSm.copyWith(
                          color: AppColors.amber,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickStat(
                          value: todayDistKm.toStringAsFixed(1),
                          unit: 'km',
                          label: 'Today',
                          valueColor: AppColors.textPrimary,
                        ),
                      ),
                      _VerticalDivider(),
                      Expanded(
                        child: _QuickStat(
                          value: _fmtDuration(todayDurSec),
                          unit: '',
                          label: 'Ride Time',
                          valueColor: AppColors.textPrimary,
                        ),
                      ),
                      _VerticalDivider(),
                      Expanded(
                        child: _QuickStat(
                          value: todayFuelL.toStringAsFixed(2),
                          unit: 'L',
                          label: 'Fuel',
                          valueColor: AppColors.olive,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => context.push(RoutePaths.rideTracking),
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

        // ── 3. FUEL SECTION ──────────────────────────────────────────────────
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
                'FUEL',
                style: RLText.labelMd.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1.8,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push(RoutePaths.fuel),
                child: Text(
                  'Refuel log \u2192',
                  style: RLText.labelMd.copyWith(
                    color: AppColors.amber,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: _HomeFuelCard(fuelState: tankFuel),
        ),

        // ── 4. BREAK-IN SECTION ─────────────────────────────────────────────
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
                        stageLabel,
                        style: RLText.labelSm.copyWith(
                          color: AppColors.amber,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      kmText,
                      style: RLText.labelMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: RLRadius.borderPill,
                  child: Container(
                    height: 6,
                    width: double.infinity,
                    color: AppColors.bgCardHigh,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressFraction,
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

                Row(
                  children: [
                    Text(
                      breakIn?.stageName ?? '--',
                      style: RLText.bodySm.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      breakIn != null
                          ? '${breakIn.percentComplete.round()}%'
                          : '--',
                      style: RLText.labelMd.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '$speedRange · Mix urban and highway',
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
              GestureDetector(
                onTap: () => context.push(RoutePaths.maintenance),
                child: Text(
                  'See all',
                  style: RLText.labelMd.copyWith(
                    color: AppColors.amber,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: pendingReminders.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RLSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: RLRadius.borderLg,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: RLSpacing.sm),
                      Text(
                        'All services up to date.',
                        style: RLText.bodySm
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: pendingReminders.take(2).map((reminder) {
                    return _ServiceReminderCard(
                      reminder: reminder,
                      currentKm: currentOdometerKm ?? 0,
                      onMarkDone: () async {
                        await ref
                            .read(maintenanceRepositoryProvider)
                            .markReminderCompleted(reminder.reminderId);
                        ref.invalidate(pendingRemindersProvider);
                        ref.invalidate(completedRemindersProvider);
                      },
                    );
                  }).toList(),
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
          child: recentRides.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RLSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: RLRadius.borderLg,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Text(
                    'No rides yet. Start your first ride!',
                    style:
                        RLText.bodySm.copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children:
                      recentRides.map((ride) => _RideCard(ride: ride)).toList(),
                ),
        ),

        // ── 6. BOTTOM PADDING ───────────────────────────────────────────────
        const SizedBox(height: 100),
      ],
    );
  }
}

// ── Home Fuel Card ────────────────────────────────────────────────────────────

class _HomeFuelCard extends StatelessWidget {
  final TankFuelState? fuelState;
  const _HomeFuelCard({required this.fuelState});

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    final fuel = fuelState;

    if (fuel == null || !fuel.hasData) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(RLSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: RLRadius.borderXl,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_gas_station_outlined,
                size: 18, color: AppColors.textMuted),
            const SizedBox(width: 10),
            Text(
              'No refuel logs yet. Add your first fill-up!',
              style: RLText.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    final pct = fuel.percentFull;
    final fuelColor = pct > 0.50
        ? AppColors.success
        : pct > 0.25
            ? AppColors.amber
            : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderXl,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + liters left + % badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.local_gas_station_rounded, size: 18, color: fuelColor),
              const SizedBox(width: 8),
              Text(
                '${fuel.litersRemaining.toStringAsFixed(1)} L remaining',
                style: RLText.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.sm,
                  vertical: RLSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: fuelColor.withValues(alpha: 0.15),
                  borderRadius: RLRadius.borderPill,
                ),
                child: Text(
                  '${(pct * 100).round()}%',
                  style: RLText.labelSm.copyWith(
                    color: fuelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Tank level bar
          ClipRRect(
            borderRadius: RLRadius.borderPill,
            child: Container(
              height: 7,
              width: double.infinity,
              color: AppColors.bgCardHigh,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: pct.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: fuelColor,
                    borderRadius: RLRadius.borderPill,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Stat row: range - economy - last fill
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _FuelMiniStat(
                    value: '~${fuel.rangeKm.toStringAsFixed(0)}',
                    unit: 'km',
                    label: 'Range',
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Expanded(
                  child: _FuelMiniStat(
                    value: fuel.economyKmPerL.toStringAsFixed(1),
                    unit: 'km/L',
                    label: 'Economy',
                    color: AppColors.olive,
                  ),
                ),
                Container(
                  width: 1,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Expanded(
                  child: _FuelMiniStat(
                    value: fuel.lastRefuelDate != null
                        ? _timeAgo(fuel.lastRefuelDate!)
                        : '--',
                    unit: '',
                    label: 'Last fill',
                    color: AppColors.textSecondary,
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

class _FuelMiniStat extends StatelessWidget {
  final String value, unit, label;
  final Color color;

  const _FuelMiniStat({
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: RLText.numSm.copyWith(color: color)),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(unit,
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted)),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(label,
            style: RLText.labelSm.copyWith(color: AppColors.textMuted)),
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

// ── Service Reminder Card widget ──────────────────────────────────────────────
class _ServiceReminderCard extends StatelessWidget {
  const _ServiceReminderCard({
    required this.reminder,
    required this.currentKm,
    required this.onMarkDone,
  });

  final MaintenanceReminderModel reminder;
  final double currentKm;
  final VoidCallback onMarkDone;

  static String _typeLabel(String type) {
    switch (type) {
      case 'oil_change_1':
        return '1st Oil Change';
      case 'oil_change_2':
        return '2nd Oil Change';
      case 'chain_lube':
        return 'Chain Lubrication';
      case 'air_filter':
        return 'Air Filter Check';
      case 'spark_plug':
        return 'Spark Plug';
      case 'tire_pressure':
        return 'Tire Pressure';
      default:
        return type
            .replaceAll('_', ' ')
            .replaceFirstMapped(
                RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase());
    }
  }

  static IconData _typeIcon(String type) {
    switch (type) {
      case 'oil_change_1':
      case 'oil_change_2':
        return Icons.water_drop_outlined;
      case 'chain_lube':
        return Icons.settings_outlined;
      case 'air_filter':
        return Icons.air;
      case 'spark_plug':
        return Icons.bolt;
      case 'tire_pressure':
        return Icons.circle_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = currentKm >= reminder.dueAtKm;
    final kmRemaining =
        (reminder.dueAtKm - currentKm).clamp(0, double.infinity);
    final progress = (currentKm / reminder.dueAtKm).clamp(0.0, 1.0);
    final statusColor = isOverdue ? AppColors.error : AppColors.amber;
    final statusLabel = isOverdue ? 'Overdue' : '${kmRemaining.toInt()} km';
    final statusBg =
        isOverdue ? AppColors.errorSurface : AppColors.amberSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderLg,
        border: Border.all(
          color: isOverdue
              ? AppColors.error.withValues(alpha: 0.35)
              : AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + title/subtitle + status badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bgCardHigh,
                  borderRadius: RLRadius.borderSm,
                ),
                child: Icon(
                  _typeIcon(reminder.type),
                  size: RLSizes.iconMd,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel(reminder.type),
                      style: RLText.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Due at ${reminder.dueAtKm.toInt()} km',
                      style:
                          RLText.labelMd.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.sm,
                  vertical: RLSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: RLRadius.borderPill,
                ),
                child: Text(
                  statusLabel,
                  style: RLText.labelSm.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: RLRadius.borderPill,
            child: Container(
              height: 3,
              color: AppColors.bgCardHigh,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: RLRadius.borderPill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Bottom row: km progress + mark done pill button
          Row(
            children: [
              Text(
                '${currentKm.toInt()} / ${reminder.dueAtKm.toInt()} km',
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onMarkDone,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.oliveSurface,
                    borderRadius: RLRadius.borderPill,
                    border: Border.all(color: AppColors.oliveDim, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: AppColors.olive,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Mark done',
                        style: RLText.labelSm.copyWith(color: AppColors.olive),
                      ),
                    ],
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

// ── Ride Card widget ──────────────────────────────────────────────────────────
class _RideCard extends StatelessWidget {
  final RideSessionModel ride;

  const _RideCard({required this.ride});

  static String _fmtDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  static String _fmtDuration(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

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
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_capitalize(ride.rideType)} Ride',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _fmtDate(ride.date),
                style: RLText.labelSm.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _RideMiniStat(
                    value: ride.distanceKm.toStringAsFixed(1),
                    unit: 'km',
                    label: 'Distance',
                  ),
                ),
                _RideStatDivider(),
                Expanded(
                  child: _RideMiniStat(
                    value: _fmtDuration(ride.durationSeconds),
                    unit: '',
                    label: 'Duration',
                  ),
                ),
                _RideStatDivider(),
                Expanded(
                  child: _RideMiniStat(
                    value: ride.estimatedFuelUsedLiters.toStringAsFixed(2),
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
