import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fuel_log_model.dart';
import '../../core/utils/fuel_calculator.dart';
import 'repositories_provider.dart';
import 'bike_profile_provider.dart';
import 'rides_provider.dart';

// ── TW200 tank constant ───────────────────────────────────────────────────────
const kTW200TankLiters = 7.5;

// ════════════════════════════════════════════════════════════════════════════
// Existing weekly-quota providers
// ════════════════════════════════════════════════════════════════════════════

/// Provider for all fuel logs
final allFuelLogsProvider = FutureProvider<List<FuelLogModel>>((ref) async {
  final fuelRepository = ref.watch(fuelRepositoryProvider);
  return await fuelRepository.getAllFuelLogs();
});

/// Provider for total fuel added
final totalFuelAddedProvider = FutureProvider<double>((ref) async {
  final fuelRepository = ref.watch(fuelRepositoryProvider);
  return await fuelRepository.getTotalFuelAdded();
});

/// Provider for fuel logs this week
final weeklyFuelLogsProvider = FutureProvider<List<FuelLogModel>>((ref) async {
  final bikeRepository = ref.watch(bikeRepositoryProvider);
  final profile = await bikeRepository.getBikeProfile();
  if (profile == null) return [];

  final fuelRepository = ref.watch(fuelRepositoryProvider);
  return await fuelRepository.getFuelLogsForWeek(profile.weeklyResetDate);
});

/// Provider for weekly fuel used
final weeklyFuelUsedProvider = FutureProvider<double>((ref) async {
  final weeklyLogs = await ref.watch(weeklyFuelLogsProvider.future);
  double total = 0;
  for (final log in weeklyLogs) {
    total += log.litersAdded;
  }
  return total;
});

/// Provider for available fuel range
final availableFuelRangeProvider = FutureProvider<FuelRange>((ref) async {
  final profile = await ref.watch(bikeProfileProvider.future);
  if (profile == null) {
    return FuelRange(currentRange: 0, projectedRange: 0);
  }

  final currentKmPerL = profile.manualFuelEconomyKmPerLiter;
  final targetKmPerL = profile.targetFuelEconomyKmPerLiter;
  final balance = profile.weeklyFuelBalanceLiters;

  return FuelRange(
    currentRange: FuelCalculator.calculateProjectedRange(
      fuelLitersAvailable: balance,
      fuelEconomyKmPerLiter: currentKmPerL,
    ),
    projectedRange: FuelCalculator.calculateProjectedRange(
      fuelLitersAvailable: balance,
      fuelEconomyKmPerLiter: targetKmPerL,
    ),
  );
});

/// Provider for weekly commute fuel requirement
final weeklyCommuteFuelProvider = FutureProvider<double>((ref) async {
  final profile = await ref.watch(bikeProfileProvider.future);
  if (profile == null) return 0;

  return FuelCalculator.calculateWeeklyCommuteFuel(
    oneWayDistanceKm: profile.officeOneWayDistanceKm,
    daysPerWeek: profile.officeDaysPerWeek,
    fuelEconomyKmPerLiter: profile.manualFuelEconomyKmPerLiter,
  );
});

/// Provider for extra ride capacity
final extraRideCapacityProvider = FutureProvider<double>((ref) async {
  final profile = await ref.watch(bikeProfileProvider.future);
  if (profile == null) return 0;

  final commuteFuel = await ref.watch(weeklyCommuteFuelProvider.future);

  return FuelCalculator.calculateExtraRideCapacity(
    remainingFuel: profile.weeklyFuelBalanceLiters,
    plannedCommuteFuel: commuteFuel,
    fuelEconomyKmPerLiter: profile.manualFuelEconomyKmPerLiter,
  );
});

// ════════════════════════════════════════════════════════════════════════════
// Tank-level fuel state — based on actual refuel logs + ride history
// ════════════════════════════════════════════════════════════════════════════

/// Physical state of the fuel tank, derived from refuel logs and ride history.
class TankFuelState {
  final double litersRemaining;
  final double rangeKm;
  final double economyKmPerL;
  final double percentFull;
  final double tankCapacityL;
  final DateTime? lastRefuelDate;
  final double kmSinceLastRefuel;
  final bool hasData;

  const TankFuelState({
    required this.litersRemaining,
    required this.rangeKm,
    required this.economyKmPerL,
    required this.percentFull,
    required this.tankCapacityL,
    required this.lastRefuelDate,
    required this.kmSinceLastRefuel,
    required this.hasData,
  });

  static const empty = TankFuelState(
    litersRemaining: 0,
    rangeKm: 0,
    economyKmPerL: 0,
    percentFull: 0,
    tankCapacityL: kTW200TankLiters,
    lastRefuelDate: null,
    kmSinceLastRefuel: 0,
    hasData: false,
  );
}

/// Chronological event used for the running balance walk.
class _FuelEvent {
  final DateTime date;
  final double deltaLiters;
  const _FuelEvent({required this.date, required this.deltaLiters});
}

/// Tank fuel state provider — invalidated whenever fuel logs or rides change.
final tankFuelProvider = FutureProvider<TankFuelState>((ref) async {
  final fuelLogs = await ref.watch(allFuelLogsProvider.future);
  final rides = await ref.watch(allRideSessionsProvider.future);
  final profile = await ref.watch(bikeProfileProvider.future);
  final totalRiddenKm = await ref.watch(totalRiddenKmProvider.future);

  if (fuelLogs.isEmpty || profile == null) return TankFuelState.empty;

  // ── 1. Fuel economy from actual refuel intervals ──────────────────────────
  final sortedLogs = [...fuelLogs]..sort((a, b) => a.date.compareTo(b.date));

  double economy = profile.manualFuelEconomyKmPerLiter;
  if (sortedLogs.length >= 2) {
    final intervals = <FuelEconomyEntry>[];
    for (int i = 1; i < sortedLogs.length; i++) {
      final distKm =
          sortedLogs[i].odometerKm - sortedLogs[i - 1].odometerKm;
      if (distKm > 0 && sortedLogs[i].litersAdded > 0) {
        intervals.add(FuelEconomyEntry(
          distanceKm: distKm,
          litersUsed: sortedLogs[i].litersAdded,
        ));
      }
    }
    final recent = intervals.length > 3
        ? intervals.sublist(intervals.length - 3)
        : intervals;
    if (recent.isNotEmpty) {
      final calc = FuelCalculator.calculateRollingAverageFuelEconomy(recent);
      if (calc > 0) economy = calc;
    }
  }

  // ── 2. Running balance walk ───────────────────────────────────────────────
  final events = <_FuelEvent>[];

  for (final log in fuelLogs) {
    events.add(_FuelEvent(date: log.date, deltaLiters: log.litersAdded));
  }

  for (final ride in rides) {
    final consumed = ride.estimatedFuelUsedLiters > 0
        ? ride.estimatedFuelUsedLiters
        : (economy > 0 ? ride.distanceKm / economy : 0.0);
    events.add(_FuelEvent(date: ride.date, deltaLiters: -consumed));
  }

  events.sort((a, b) => a.date.compareTo(b.date));

  double balance = 0.0;
  for (final e in events) {
    balance = (balance + e.deltaLiters).clamp(0.0, kTW200TankLiters);
  }

  // ── 3. Km since last refuel ───────────────────────────────────────────────
  final lastLog = sortedLogs.last;
  final currentOdom =
      profile.currentOdometerKm(appTrackedKm: totalRiddenKm);
  final kmSinceRefuel =
      (currentOdom - lastLog.odometerKm).clamp(0.0, double.infinity);

  return TankFuelState(
    litersRemaining: balance,
    rangeKm: economy > 0 ? balance * economy : 0.0,
    economyKmPerL: economy,
    percentFull: (balance / kTW200TankLiters).clamp(0.0, 1.0),
    tankCapacityL: kTW200TankLiters,
    lastRefuelDate: lastLog.date,
    kmSinceLastRefuel: kmSinceRefuel,
    hasData: true,
  );
});

// ── Data classes ──────────────────────────────────────────────────────────────
class FuelRange {
  final double currentRange;
  final double projectedRange;

  FuelRange({
    required this.currentRange,
    required this.projectedRange,
  });
}
