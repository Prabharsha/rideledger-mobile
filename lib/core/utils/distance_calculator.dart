import 'dart:math' as math;

/// Distance and route calculation utilities
class DistanceCalculator {
  static const earthRadiusKm = 6371.0; // Earth radius in kilometers

  /// Calculate distance between two coordinates using Haversine formula
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const latOffset = math.pi / 180.0;

    final dLat = (lat2 - lat1) * latOffset;
    final dLon = (lon2 - lon1) * latOffset;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * latOffset) *
            math.cos(lat2 * latOffset) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadiusKm * c;

    return distance; // in kilometers
  }

  /// Calculate total distance from a series of points
  static double calculateTotalDistance(
    List<LatLngPoint> points,
  ) {
    if (points.length < 2) return 0;

    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += calculateDistance(
        lat1: points[i].latitude,
        lon1: points[i].longitude,
        lat2: points[i + 1].latitude,
        lon2: points[i + 1].longitude,
      );
    }
    return total;
  }

  /// Calculate speed from distance and time
  static double calculateSpeed({
    required double distanceKm,
    required Duration duration,
  }) {
    if (duration.inSeconds == 0) return 0;
    final hours = duration.inSeconds / 3600.0;
    return distanceKm / hours;
  }

  /// Calculate elevation gain from point series (if elevation data available)
  static double calculateElevationGain(List<ElevatedPoint> points) {
    if (points.length < 2) return 0;

    double gain = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final delta = points[i + 1].elevationM - points[i].elevationM;
      if (delta > 0) {
        gain += delta;
      }
    }
    return gain; // in meters
  }

  /// Check if route is climbing (positive elevation change)
  static bool isClimbing(List<ElevatedPoint> recentPoints) {
    if (recentPoints.length < 2) return false;

    final windowSize = recentPoints.length > 5 ? 5 : recentPoints.length;
    final recentWindow = recentPoints.sublist(recentPoints.length - windowSize);

    final elevationGain = calculateElevationGain(recentWindow);
    final distance = calculateTotalDistance(
      recentWindow.map((p) => LatLngPoint(p.latitude, p.longitude)).toList(),
    );

    // If climbing 50m+ over less than 500m, consider it climbing
    return elevationGain > 50 && distance < 500;
  }

  /// Simplify route points using Douglas-Peucker algorithm
  static List<LatLngPoint> simplifyRoute(
    List<LatLngPoint> points, {
    double epsilonKm = 0.01,
  }) {
    if (points.length <= 2) return points;

    final simplified = _douglasPeucker(points, epsilonKm);
    return simplified;
  }

  static List<LatLngPoint> _douglasPeucker(
    List<LatLngPoint> points,
    double epsilon,
  ) {
    double maxDist = 0;
    int maxIndex = 0;

    // Find point with maximum distance from line
    for (int i = 1; i < points.length - 1; i++) {
      final dist = _perpendicularDistance(points[i], points[0], points[points.length - 1]);
      if (dist > maxDist) {
        maxDist = dist;
        maxIndex = i;
      }
    }

    // If max distance is greater than epsilon, recursively simplify
    if (maxDist > epsilon) {
      final rec1 = _douglasPeucker(points.sublist(0, maxIndex + 1), epsilon);
      final rec2 = _douglasPeucker(points.sublist(maxIndex), epsilon);

      final result = rec1.sublist(0, rec1.length - 1) + rec2;
      return result;
    } else {
      return [points[0], points[points.length - 1]];
    }
  }

  static double _perpendicularDistance(
    LatLngPoint point,
    LatLngPoint lineStart,
    LatLngPoint lineEnd,
  ) {
    return calculateDistance(
      lat1: point.latitude,
      lon1: point.longitude,
      lat2: lineStart.latitude,
      lon2: lineStart.longitude,
    );
  }
}

/// Latitude/Longitude point
class LatLngPoint {
  final double latitude;
  final double longitude;

  LatLngPoint(this.latitude, this.longitude);
}

/// Point with elevation data
class ElevatedPoint extends LatLngPoint {
  final double elevationM;

  ElevatedPoint(
    double latitude,
    double longitude,
    this.elevationM,
  ) : super(latitude, longitude);
}
