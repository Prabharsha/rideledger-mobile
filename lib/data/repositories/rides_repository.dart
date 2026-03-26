import '../models/ride_session_model.dart';
import '../models/warning_event_model.dart';
import '../models/route_point_model.dart';
import '../datasources/local_rides_datasource.dart';

/// Repository for ride session operations
class RidesRepository {
  final LocalRidesDatasource _localDatasource;

  RidesRepository({required LocalRidesDatasource localDatasource})
      : _localDatasource = localDatasource;

  /// Save new ride session
  Future<void> saveRideSession(RideSessionModel ride) async {
    await _localDatasource.saveRideSession(ride);
  }

  /// Get ride by ID
  Future<RideSessionModel?> getRideSessionById(String sessionId) async {
    return await _localDatasource.getRideSessionById(sessionId);
  }

  /// Get all rides
  Future<List<RideSessionModel>> getAllRideSessions() async {
    return await _localDatasource.getAllRideSessions();
  }

  /// Get rides by date range
  Future<List<RideSessionModel>> getRideSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _localDatasource.getRideSessionsByDateRange(
        startDate, endDate);
  }

  /// Get rides by break-in stage
  Future<List<RideSessionModel>> getRideSessionsByStage(
      String stageName) async {
    return await _localDatasource.getRideSessionsByStage(stageName);
  }

  /// Get rides by traffic stress level
  Future<List<RideSessionModel>> getRideSessionsByStressLevel(
      String stressLevel) async {
    return await _localDatasource.getRideSessionsByStressLevel(stressLevel);
  }

  /// Update ride session
  Future<void> updateRideSession(RideSessionModel ride) async {
    await _localDatasource.updateRideSession(ride);
  }

  /// Delete ride session (and associated route points + warnings)
  Future<void> deleteRideSession(String sessionId) async {
    await _localDatasource.deleteRideSession(sessionId);
  }

  // --- Bulk deletion methods for storage management ---

  /// Delete ride sessions older than a cutoff date (full deletion)
  Future<int> deleteRideSessionsOlderThan(DateTime cutoffDate) async {
    return await _localDatasource.deleteRideSessionsOlderThan(cutoffDate);
  }

  /// Delete only route data for rides older than cutoff (keep summaries)
  Future<int> deleteRouteDataOlderThan(DateTime cutoffDate) async {
    return await _localDatasource.deleteRouteDataOlderThan(cutoffDate);
  }

  /// Delete route data for specific rides by session IDs
  Future<int> deleteRouteDataBySessionIds(List<String> sessionIds) async {
    return await _localDatasource.deleteRouteDataBySessionIds(sessionIds);
  }

  /// Delete ALL route data across all rides (keep summaries)
  Future<int> deleteAllRouteData() async {
    return await _localDatasource.deleteAllRouteData();
  }

  /// Delete ride sessions by a list of session IDs (full deletion)
  Future<int> deleteRideSessionsByIds(List<String> sessionIds) async {
    return await _localDatasource.deleteRideSessionsByIds(sessionIds);
  }

  // --- Statistics ---

  /// Get total distance ridden
  Future<double> getTotalDistance() async {
    return await _localDatasource.getTotalDistance();
  }

  /// Get total fuel used
  Future<double> getTotalFuelUsed() async {
    return await _localDatasource.getTotalFuelUsed();
  }

  /// Get ride count
  Future<int> getRideCount() async {
    return await _localDatasource.getRideCount();
  }

  /// Get route point count (all rides)
  Future<int> getRoutePointCount() async {
    return await _localDatasource.getRoutePointCount();
  }

  /// Get warning event count (all rides)
  Future<int> getWarningEventCount() async {
    return await _localDatasource.getWarningEventCount();
  }

  /// Get route point count for a specific ride
  Future<int> getRoutePointCountForSession(String sessionId) async {
    return await _localDatasource.getRoutePointCountForSession(sessionId);
  }

  // --- Warning events ---

  /// Save warning events for a ride
  Future<void> saveWarningEvents(
    String sessionId,
    List<WarningEventModel> warnings,
  ) async {
    await _localDatasource.saveWarningEvents(sessionId, warnings);
  }

  /// Get warning events for a ride
  Future<List<WarningEventModel>> getWarningEventsForSession(
      String sessionId) async {
    return await _localDatasource.getWarningEventsForSession(sessionId);
  }

  // --- Route points ---

  /// Save route points for a ride
  Future<void> saveRoutePoints(
    String sessionId,
    List<RoutePointModel> points,
  ) async {
    await _localDatasource.saveRoutePoints(sessionId, points);
  }

  /// Save route points in batch (more efficient for large writes)
  Future<void> saveRoutePointsBatch(List<RoutePointModel> points) async {
    await _localDatasource.saveRoutePointsBatch(points);
  }

  /// Get route points for a ride
  Future<List<RoutePointModel>> getRoutePointsForSession(
      String sessionId) async {
    return await _localDatasource.getRoutePointsForSession(sessionId);
  }
}
