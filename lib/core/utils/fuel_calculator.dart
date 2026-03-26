/// Fuel calculation utilities
class FuelCalculator {
  /// Calculate estimated fuel consumed for a ride
  static double calculateEstimatedFuelUsed({
    required double distanceKm,
    required double fuelEconomyKmPerLiter,
  }) {
    if (fuelEconomyKmPerLiter <= 0) return 0;
    return distanceKm / fuelEconomyKmPerLiter;
  }

  /// Calculate projected rideable distance
  static double calculateProjectedRange({
    required double fuelLitersAvailable,
    required double fuelEconomyKmPerLiter,
  }) {
    if (fuelEconomyKmPerLiter <= 0) return 0;
    return fuelLitersAvailable * fuelEconomyKmPerLiter;
  }

  /// Calculate weekly commute fuel requirement
  static double calculateWeeklyCommuteFuel({
    required double oneWayDistanceKm,
    required int daysPerWeek,
    required double fuelEconomyKmPerLiter,
  }) {
    if (fuelEconomyKmPerLiter <= 0) return 0;
    final totalCommuteDistance = oneWayDistanceKm * 2 * daysPerWeek;
    return totalCommuteDistance / fuelEconomyKmPerLiter;
  }

  /// Calculate actual fuel economy from refuel data
  static double calculateActualFuelEconomy({
    required double distanceSinceLastRefuelKm,
    required double litersFueledThisTime,
  }) {
    if (litersFueledThisTime <= 0) return 0;
    return distanceSinceLastRefuelKm / litersFueledThisTime;
  }

  /// Calculate rolling average fuel economy
  static double calculateRollingAverageFuelEconomy(
      List<FuelEconomyEntry> entries) {
    if (entries.isEmpty) return 0;

    double totalDistance = 0;
    double totalFuel = 0;

    for (final entry in entries) {
      totalDistance += entry.distanceKm;
      totalFuel += entry.litersUsed;
    }

    if (totalFuel <= 0) return 0;
    return totalDistance / totalFuel;
  }

  /// Calculate fuel cost per km
  static double calculateCostPerKm({
    required double costPerLiter,
    required double fuelEconomyKmPerLiter,
  }) {
    if (fuelEconomyKmPerLiter <= 0) return 0;
    return costPerLiter / fuelEconomyKmPerLiter;
  }

  /// Calculate fuel cost for a ride
  static double calculateRideCost({
    required double distanceKm,
    required double fuelEconomyKmPerLiter,
    required double costPerLiter,
  }) {
    final fuelUsed =
        calculateEstimatedFuelUsed(
          distanceKm: distanceKm,
          fuelEconomyKmPerLiter: fuelEconomyKmPerLiter,
        );
    return fuelUsed * costPerLiter;
  }

  /// Check if weekly fuel balance is low (below 25% of quota)
  static bool isFuelBalanceLow({
    required double currentBalance,
    required double weeklyQuota,
  }) {
    return currentBalance < (weeklyQuota * 0.25);
  }

  /// Get remaining fuel for extra rides (after planned commute)
  static double calculateExtraRideCapacity({
    required double remainingFuel,
    required double plannedCommuteFuel,
    required double fuelEconomyKmPerLiter,
  }) {
    final extraFuel = remainingFuel - plannedCommuteFuel;
    if (extraFuel <= 0) return 0;
    return calculateProjectedRange(
      fuelLitersAvailable: extraFuel,
      fuelEconomyKmPerLiter: fuelEconomyKmPerLiter,
    );
  }
}

/// Entry for fuel economy tracking
class FuelEconomyEntry {
  final double distanceKm;
  final double litersUsed;

  FuelEconomyEntry({
    required this.distanceKm,
    required this.litersUsed,
  });
}
