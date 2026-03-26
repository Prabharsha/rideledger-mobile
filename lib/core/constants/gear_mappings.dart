/// Recommended gear mapping based on speed and riding context
class GearMapping {
  /// Context-aware gear recommendation based on speed and conditions
  static int getRecommendedGear(
    double speedKmh, {
    bool isHeavyTraffic = false,
    bool isClimbing = false,
    double recentAccelerationGPerSec = 0.0,
  }) {
    // Heavy traffic adjusts ranges down by ~10%
    final trafficAdjustment = isHeavyTraffic ? 0.9 : 1.0;
    final climbAdjustment = isClimbing ? 0.85 : 1.0;

    final adjustedSpeed = speedKmh / (trafficAdjustment * climbAdjustment);

    // Base speed-to-gear mapping
    if (adjustedSpeed < 12) {
      return 1; // First gear
    } else if (adjustedSpeed < 30) {
      return 2; // Second gear
    } else if (adjustedSpeed < 45) {
      return 3; // Third gear
    } else if (adjustedSpeed < 60) {
      return 4; // Fourth gear
    } else {
      return 5; // Fifth gear
    }
  }

  /// Get the speed range for a specific gear
  static GearSpeedRange getGearRange(int gear) {
    switch (gear) {
      case 1:
        return GearSpeedRange(min: 0, max: 12, gear: 1);
      case 2:
        return GearSpeedRange(min: 10, max: 30, gear: 2);
      case 3:
        return GearSpeedRange(min: 25, max: 45, gear: 3);
      case 4:
        return GearSpeedRange(min: 40, max: 60, gear: 4);
      case 5:
      default:
        return GearSpeedRange(min: 50, max: 100, gear: 5);
    }
  }

  /// Determine if current gear selection is reasonable for the speed
  static bool isReasonableGearForSpeed(int currentGear, double speedKmh) {
    final range = getGearRange(currentGear);
    return speedKmh >= range.min && speedKmh <= range.max;
  }
}

class GearSpeedRange {
  final int gear;
  final double min;
  final double max;

  GearSpeedRange({
    required this.gear,
    required this.min,
    required this.max,
  });

  bool contains(double speedKmh) => speedKmh >= min && speedKmh <= max;
}
