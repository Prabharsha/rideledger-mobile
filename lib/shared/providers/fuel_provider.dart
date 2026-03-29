import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fuel_log_model.dart';
import '../../core/utils/fuel_calculator.dart';
import 'repositories_provider.dart';
import 'bike_profile_provider.dart';

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

/// Data class for fuel range
class FuelRange {
  final double currentRange;
  final double projectedRange;

  FuelRange({
    required this.currentRange,
    required this.projectedRange,
  });
}
