/// Double formatting extensions
extension DoubleExtension on double {
  /// Round to [places] decimal places
  double roundToDecimals(int places) {
    final multiplier = 10.0 * places;
    return (this * multiplier).round() / multiplier;
  }

  /// Format as "123.45" with 2 decimal places
  String toStringWithDecimals(int places) {
    return toStringAsFixed(places);
  }

  /// Format as "123.4 km"
  String toKmString({int decimals = 1}) {
    return '${toStringAsFixed(decimals)} km';
  }

  /// Format as "45.6 km/h"
  String toSpeedString({int decimals = 1}) {
    return '${toStringAsFixed(decimals)} km/h';
  }

  /// Format as "8.5 L"
  String toLitersString({int decimals = 1}) {
    return '${toStringAsFixed(decimals)} L';
  }

  /// Format as "20.5 km/L"
  String toFuelEconomyString({int decimals = 1}) {
    return '${toStringAsFixed(decimals)} km/L';
  }

  /// Clamp to min/max values
  double clamp(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
