import 'package:isar/isar.dart';
import '../models/ride_session_model.dart';
import '../models/warning_event_model.dart';
import '../models/route_point_model.dart';
import '../../core/services/storage_service.dart';

/// Local data source for ride sessions
class LocalRidesDatasource {
  late final Isar _isar;

  LocalRidesDatasource() {
    _isar = StorageService.getInstance();
  }

  /// Save ride session
  Future<void> saveRideSession(RideSessionModel ride) async {
    ride.createdAt = DateTime.now();
    ride.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.rideSessionModels.put(ride);
    });
  }

  /// Get ride session by ID
  Future<RideSessionModel?> getRideSessionById(String sessionId) async {
    return await _isar.rideSessionModels
        .filter()
        .sessionIdEqualTo(sessionId)
        .findFirst();
  }

  /// Get all ride sessions
  Future<List<RideSessionModel>> getAllRideSessions() async {
    return await _isar.rideSessionModels
        .where()
        .sortByDateDesc()
        .findAll();
  }

  /// Get ride sessions by date range
  Future<List<RideSessionModel>> getRideSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _isar.rideSessionModels
        .filter()
        .dateBetween(startDate, endDate)
        .sortByDateDesc()
        .findAll();
  }

  /// Get ride sessions by stage
  Future<List<RideSessionModel>> getRideSessionsByStage(
      String stageName) async {
    return await _isar.rideSessionModels
        .filter()
        .breakInStageNameEqualTo(stageName)
        .sortByDateDesc()
        .findAll();
  }

  /// Get ride sessions by traffic stress level
  Future<List<RideSessionModel>> getRideSessionsByStressLevel(
      String stressLevel) async {
    return await _isar.rideSessionModels
        .filter()
        .trafficStressLevelEqualTo(stressLevel)
        .sortByDateDesc()
        .findAll();
  }

  /// Update ride session
  Future<void> updateRideSession(RideSessionModel ride) async {
    ride.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.rideSessionModels.put(ride);
    });
  }

  /// Delete ride session and all associated data
  Future<void> deleteRideSession(String sessionId) async {
    await _isar.writeTxn(() async {
      final ride = await _isar.rideSessionModels
          .filter()
          .sessionIdEqualTo(sessionId)
          .findFirst();
      if (ride != null) {
        await _isar.rideSessionModels.delete(ride.id!);
        // Also delete associated route points and warnings
        await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .deleteAll();
        await _isar.warningEventModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .deleteAll();
      }
    });
  }

  /// Delete ride sessions older than a cutoff date (full deletion)
  Future<int> deleteRideSessionsOlderThan(DateTime cutoffDate) async {
    int deletedCount = 0;
    await _isar.writeTxn(() async {
      final oldRides = await _isar.rideSessionModels
          .filter()
          .dateLessThan(cutoffDate)
          .findAll();

      for (final ride in oldRides) {
        // Delete route points
        await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(ride.sessionId)
            .deleteAll();
        // Delete warnings
        await _isar.warningEventModels
            .filter()
            .sessionIdEqualTo(ride.sessionId)
            .deleteAll();
        // Delete ride
        await _isar.rideSessionModels.delete(ride.id!);
        deletedCount++;
      }
    });
    return deletedCount;
  }

  /// Delete only route data for rides older than a cutoff date (keep summaries)
  Future<int> deleteRouteDataOlderThan(DateTime cutoffDate) async {
    int deletedCount = 0;
    await _isar.writeTxn(() async {
      final oldRides = await _isar.rideSessionModels
          .filter()
          .dateLessThan(cutoffDate)
          .findAll();

      for (final ride in oldRides) {
        // Delete route points only
        final pointsDeleted = await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(ride.sessionId)
            .deleteAll();

        // Clear encoded polyline on ride
        if (ride.encodedRoutePolyline != null || pointsDeleted > 0) {
          ride.encodedRoutePolyline = null;
          ride.updatedAt = DateTime.now();
          await _isar.rideSessionModels.put(ride);
          deletedCount++;
        }
      }
    });
    return deletedCount;
  }

  /// Delete route data for specific ride sessions by session IDs
  Future<int> deleteRouteDataBySessionIds(List<String> sessionIds) async {
    int deletedCount = 0;
    await _isar.writeTxn(() async {
      for (final sessionId in sessionIds) {
        final pointsDeleted = await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .deleteAll();

        final ride = await _isar.rideSessionModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .findFirst();

        if (ride != null &&
            (ride.encodedRoutePolyline != null || pointsDeleted > 0)) {
          ride.encodedRoutePolyline = null;
          ride.updatedAt = DateTime.now();
          await _isar.rideSessionModels.put(ride);
          deletedCount++;
        }
      }
    });
    return deletedCount;
  }

  /// Delete ALL route data across all rides (keep all summaries)
  Future<int> deleteAllRouteData() async {
    final deletedCount = await _isar.routePointModels.count();
    await _isar.writeTxn(() async {
      await _isar.routePointModels.clear();

      // Clear all encoded polylines
      final allRides = await _isar.rideSessionModels.where().findAll();
      for (final ride in allRides) {
        if (ride.encodedRoutePolyline != null) {
          ride.encodedRoutePolyline = null;
          ride.updatedAt = DateTime.now();
          await _isar.rideSessionModels.put(ride);
        }
      }
    });
    return deletedCount;
  }

  /// Delete ride sessions by a list of session IDs (full deletion)
  Future<int> deleteRideSessionsByIds(List<String> sessionIds) async {
    int deletedCount = 0;
    await _isar.writeTxn(() async {
      for (final sessionId in sessionIds) {
        final ride = await _isar.rideSessionModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .findFirst();
        if (ride != null) {
          await _isar.routePointModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .deleteAll();
          await _isar.warningEventModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .deleteAll();
          await _isar.rideSessionModels.delete(ride.id!);
          deletedCount++;
        }
      }
    });
    return deletedCount;
  }

  /// Get total distance ridden
  Future<double> getTotalDistance() async {
    final rides = await _isar.rideSessionModels.where().findAll();
    double total = 0;
    for (final ride in rides) {
      total += ride.distanceKm;
    }
    return total;
  }

  /// Get total fuel used
  Future<double> getTotalFuelUsed() async {
    final rides = await _isar.rideSessionModels.where().findAll();
    double total = 0;
    for (final ride in rides) {
      total += ride.estimatedFuelUsedLiters;
    }
    return total;
  }

  /// Get ride count
  Future<int> getRideCount() async {
    return await _isar.rideSessionModels.count();
  }

  /// Get route point count
  Future<int> getRoutePointCount() async {
    return await _isar.routePointModels.count();
  }

  /// Get warning event count
  Future<int> getWarningEventCount() async {
    return await _isar.warningEventModels.count();
  }

  /// Save warning events for a ride
  Future<void> saveWarningEvents(
    String sessionId,
    List<WarningEventModel> warnings,
  ) async {
    await _isar.writeTxn(() async {
      for (final warning in warnings) {
        await _isar.warningEventModels.put(warning);
      }
    });
  }

  /// Get warning events for a ride
  Future<List<WarningEventModel>> getWarningEventsForSession(
      String sessionId) async {
    return await _isar.warningEventModels
        .filter()
        .sessionIdEqualTo(sessionId)
        .sortByTimestamp()
        .findAll();
  }

  /// Save route points for a ride (single write)
  Future<void> saveRoutePoints(
    String sessionId,
    List<RoutePointModel> points,
  ) async {
    await _isar.writeTxn(() async {
      for (final point in points) {
        await _isar.routePointModels.put(point);
      }
    });
  }

  /// Save route points in batch (more efficient for large writes)
  Future<void> saveRoutePointsBatch(List<RoutePointModel> points) async {
    if (points.isEmpty) return;
    await _isar.writeTxn(() async {
      await _isar.routePointModels.putAll(points);
    });
  }

  /// Get route points for a ride
  Future<List<RoutePointModel>> getRoutePointsForSession(
      String sessionId) async {
    return await _isar.routePointModels
        .filter()
        .sessionIdEqualTo(sessionId)
        .sortByTimestamp()
        .findAll();
  }

  /// Get route point count for a specific session
  Future<int> getRoutePointCountForSession(String sessionId) async {
    return await _isar.routePointModels
        .filter()
        .sessionIdEqualTo(sessionId)
        .count();
  }
}
