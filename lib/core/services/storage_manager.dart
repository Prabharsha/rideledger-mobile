import 'package:isar/isar.dart';
import '../../data/models/fuel_log_model.dart';
import '../../data/models/maintenance_reminder_model.dart';
import '../../data/models/retention_policy_model.dart';
import '../../data/models/ride_session_model.dart';
import '../../data/models/route_point_model.dart';
import '../../data/models/warning_event_model.dart';
import 'storage_service.dart';

/// Per-category storage information
class StorageCategoryInfo {
  final String name;
  final int count;
  final double estimatedSizeKB;

  const StorageCategoryInfo({
    required this.name,
    required this.count,
    required this.estimatedSizeKB,
  });
}

/// Report of overall storage usage across all collections
class StorageUsageReport {
  final int totalRideSessions;
  final int totalRoutePoints;
  final int totalWarningEvents;
  final int totalFuelLogs;
  final int totalMaintenanceReminders;
  final double estimatedRideDataSizeKB;
  final double estimatedRouteDataSizeKB;
  final double estimatedWarningDataSizeKB;
  final double estimatedFuelDataSizeKB;
  final double estimatedMaintenanceDataSizeKB;
  final double estimatedTotalSizeKB;
  final String formattedTotalSize;
  final Map<String, StorageCategoryInfo> categoryBreakdown;

  const StorageUsageReport({
    required this.totalRideSessions,
    required this.totalRoutePoints,
    required this.totalWarningEvents,
    required this.totalFuelLogs,
    required this.totalMaintenanceReminders,
    required this.estimatedRideDataSizeKB,
    required this.estimatedRouteDataSizeKB,
    required this.estimatedWarningDataSizeKB,
    required this.estimatedFuelDataSizeKB,
    required this.estimatedMaintenanceDataSizeKB,
    required this.estimatedTotalSizeKB,
    required this.formattedTotalSize,
    required this.categoryBreakdown,
  });
}

/// Result of a cleanup operation
class CleanupResult {
  final int deletedCount;
  final double freedSpaceEstimateKB;
  final DateTime cutoffDate;
  final bool routeDataOnly;

  const CleanupResult({
    required this.deletedCount,
    required this.freedSpaceEstimateKB,
    required this.cutoffDate,
    required this.routeDataOnly,
  });

  String get formattedFreedSpace => _formatSize(freedSpaceEstimateKB);

  static String _formatSize(double sizeKB) {
    if (sizeKB >= 1024) {
      return '${(sizeKB / 1024).toStringAsFixed(1)} MB';
    }
    return '${sizeKB.toStringAsFixed(0)} KB';
  }
}

/// Manages storage usage tracking, cleanup, and retention for all Isar collections
class StorageManager {
  late final Isar _isar;

  // Size estimates per record in KB
  static const double _rideSizeKB = 0.5;
  static const double _routePointSizeKB = 0.1;
  static const double _warningSizeKB = 0.15;
  static const double _fuelLogSizeKB = 0.2;
  static const double _maintenanceSizeKB = 0.15;

  StorageManager() {
    _isar = StorageService.getInstance();
  }

  /// Format a size in KB to a human-readable string
  static String _formatSize(double sizeKB) {
    if (sizeKB >= 1024) {
      return '${(sizeKB / 1024).toStringAsFixed(1)} MB';
    }
    return '${sizeKB.toStringAsFixed(0)} KB';
  }

  // ---------------------------------------------------------------------------
  // Storage usage calculation
  // ---------------------------------------------------------------------------

  /// Calculate a full storage usage report across all collections
  Future<StorageUsageReport> calculateStorageUsage() async {
    final rideCount = await _isar.rideSessionModels.count();
    final routeCount = await _isar.routePointModels.count();
    final warningCount = await _isar.warningEventModels.count();
    final fuelCount = await _isar.fuelLogModels.count();
    final maintenanceCount = await _isar.maintenanceReminderModels.count();

    final rideSizeKB = rideCount * _rideSizeKB;
    final routeSizeKB = routeCount * _routePointSizeKB;
    final warningSizeKB = warningCount * _warningSizeKB;
    final fuelSizeKB = fuelCount * _fuelLogSizeKB;
    final maintenanceSizeKB = maintenanceCount * _maintenanceSizeKB;
    final totalSizeKB =
        rideSizeKB + routeSizeKB + warningSizeKB + fuelSizeKB + maintenanceSizeKB;

    final categoryBreakdown = <String, StorageCategoryInfo>{
      'rides': StorageCategoryInfo(
        name: 'Ride Sessions',
        count: rideCount,
        estimatedSizeKB: rideSizeKB,
      ),
      'routes': StorageCategoryInfo(
        name: 'Route Points',
        count: routeCount,
        estimatedSizeKB: routeSizeKB,
      ),
      'warnings': StorageCategoryInfo(
        name: 'Warning Events',
        count: warningCount,
        estimatedSizeKB: warningSizeKB,
      ),
      'fuel': StorageCategoryInfo(
        name: 'Fuel Logs',
        count: fuelCount,
        estimatedSizeKB: fuelSizeKB,
      ),
      'maintenance': StorageCategoryInfo(
        name: 'Maintenance Reminders',
        count: maintenanceCount,
        estimatedSizeKB: maintenanceSizeKB,
      ),
    };

    return StorageUsageReport(
      totalRideSessions: rideCount,
      totalRoutePoints: routeCount,
      totalWarningEvents: warningCount,
      totalFuelLogs: fuelCount,
      totalMaintenanceReminders: maintenanceCount,
      estimatedRideDataSizeKB: rideSizeKB,
      estimatedRouteDataSizeKB: routeSizeKB,
      estimatedWarningDataSizeKB: warningSizeKB,
      estimatedFuelDataSizeKB: fuelSizeKB,
      estimatedMaintenanceDataSizeKB: maintenanceSizeKB,
      estimatedTotalSizeKB: totalSizeKB,
      formattedTotalSize: _formatSize(totalSizeKB),
      categoryBreakdown: categoryBreakdown,
    );
  }

  // ---------------------------------------------------------------------------
  // Selective deletion
  // ---------------------------------------------------------------------------

  /// Delete ride sessions (and associated data) older than [cutoffDate].
  ///
  /// If [routeDataOnly] is true, only route points are deleted and the
  /// encodedRoutePolyline field on matching rides is cleared, but the ride
  /// summary records themselves are kept.
  ///
  /// Returns the number of ride sessions affected.
  Future<int> deleteRideSessionsOlderThan(
    DateTime cutoffDate, {
    bool routeDataOnly = false,
  }) async {
    final rides = await _isar.rideSessionModels
        .filter()
        .dateLessThan(cutoffDate)
        .findAll();

    if (rides.isEmpty) return 0;

    final sessionIds = rides.map((r) => r.sessionId).toList();

    await _isar.writeTxn(() async {
      for (final sessionId in sessionIds) {
        // Always delete route points for matched sessions
        await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .deleteAll();

        if (routeDataOnly) {
          // Clear the encoded polyline but keep the ride summary
          final ride = await _isar.rideSessionModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .findFirst();
          if (ride != null) {
            ride.encodedRoutePolyline = null;
            ride.updatedAt = DateTime.now();
            await _isar.rideSessionModels.put(ride);
          }
        } else {
          // Delete ride session and all associated data
          final ride = await _isar.rideSessionModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .findFirst();
          if (ride != null) {
            await _isar.rideSessionModels.delete(ride.id!);
          }
          await _isar.warningEventModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .deleteAll();
        }
      }
    });

    return rides.length;
  }

  /// Delete ride sessions by explicit session IDs.
  ///
  /// If [routeDataOnly] is true, only route data is removed.
  /// Returns the count of sessions affected.
  Future<int> deleteRideSessionsByIds(
    List<String> sessionIds, {
    bool routeDataOnly = false,
  }) async {
    if (sessionIds.isEmpty) return 0;

    int affected = 0;

    await _isar.writeTxn(() async {
      for (final sessionId in sessionIds) {
        final ride = await _isar.rideSessionModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .findFirst();

        if (ride == null) continue;
        affected++;

        // Always delete route points
        await _isar.routePointModels
            .filter()
            .sessionIdEqualTo(sessionId)
            .deleteAll();

        if (routeDataOnly) {
          ride.encodedRoutePolyline = null;
          ride.updatedAt = DateTime.now();
          await _isar.rideSessionModels.put(ride);
        } else {
          await _isar.rideSessionModels.delete(ride.id!);
          await _isar.warningEventModels
              .filter()
              .sessionIdEqualTo(sessionId)
              .deleteAll();
        }
      }
    });

    return affected;
  }

  /// Delete ALL route data across every ride session.
  ///
  /// All RoutePointModels are removed and every ride session's
  /// encodedRoutePolyline is set to null. Ride summaries remain intact.
  /// Returns the number of route points deleted.
  Future<int> deleteAllRouteData() async {
    final routePointCount = await _isar.routePointModels.count();

    await _isar.writeTxn(() async {
      await _isar.routePointModels.clear();

      // Clear encodedRoutePolyline on every ride
      final allRides = await _isar.rideSessionModels.where().findAll();
      for (final ride in allRides) {
        if (ride.encodedRoutePolyline != null) {
          ride.encodedRoutePolyline = null;
          ride.updatedAt = DateTime.now();
          await _isar.rideSessionModels.put(ride);
        }
      }
    });

    return routePointCount;
  }

  /// Run automatic cleanup based on the given retention policy.
  ///
  /// Calculates the cutoff date from the policy's retention period and deletes
  /// data older than that date. Respects the deleteRouteDataOnly flag.
  Future<CleanupResult> runAutoCleanup(RetentionPolicyModel policy) async {
    final retentionDuration =
        RetentionPolicyModel.getRetentionDuration(policy.retentionPeriod);
    final cutoffDate = DateTime.now().subtract(retentionDuration);

    // Estimate freed space before deletion
    final ridesBeforeCleanup = await _isar.rideSessionModels
        .filter()
        .dateLessThan(cutoffDate)
        .findAll();

    double freedEstimateKB = 0;
    for (final ride in ridesBeforeCleanup) {
      final routePointCount = await _isar.routePointModels
          .filter()
          .sessionIdEqualTo(ride.sessionId)
          .count();
      freedEstimateKB += routePointCount * _routePointSizeKB;

      if (!policy.deleteRouteDataOnly) {
        freedEstimateKB += _rideSizeKB;
        final warningCount = await _isar.warningEventModels
            .filter()
            .sessionIdEqualTo(ride.sessionId)
            .count();
        freedEstimateKB += warningCount * _warningSizeKB;
      }
    }

    final deletedCount = await deleteRideSessionsOlderThan(
      cutoffDate,
      routeDataOnly: policy.deleteRouteDataOnly,
    );

    return CleanupResult(
      deletedCount: deletedCount,
      freedSpaceEstimateKB: freedEstimateKB,
      cutoffDate: cutoffDate,
      routeDataOnly: policy.deleteRouteDataOnly,
    );
  }

  // ---------------------------------------------------------------------------
  // Export
  // ---------------------------------------------------------------------------

  /// Export ride data as a list of JSON-compatible maps for the given session IDs.
  ///
  /// Each entry contains the ride session data, its route points, and its
  /// warning events.
  Future<List<Map<String, dynamic>>> exportRidesAsJson(
    List<String> sessionIds,
  ) async {
    final results = <Map<String, dynamic>>[];

    for (final sessionId in sessionIds) {
      final ride = await _isar.rideSessionModels
          .filter()
          .sessionIdEqualTo(sessionId)
          .findFirst();

      if (ride == null) continue;

      final routePoints = await _isar.routePointModels
          .filter()
          .sessionIdEqualTo(sessionId)
          .sortByTimestamp()
          .findAll();

      final warnings = await _isar.warningEventModels
          .filter()
          .sessionIdEqualTo(sessionId)
          .sortByTimestamp()
          .findAll();

      results.add({
        'ride': ride.toJson(),
        'routePoints': routePoints.map((rp) => rp.toJson()).toList(),
        'warnings': warnings.map((w) => w.toJson()).toList(),
      });
    }

    return results;
  }
}
