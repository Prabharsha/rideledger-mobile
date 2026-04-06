import 'package:isar/isar.dart';
import '../models/fuel_log_model.dart';
import '../../core/services/storage_service.dart';

/// Local data source for fuel logs
class LocalFuelDatasource {
  late final Isar _isar;

  LocalFuelDatasource() {
    _isar = StorageService.getInstance();
  }

  /// Save fuel log entry
  Future<void> saveFuelLog(FuelLogModel fuelLog) async {
    fuelLog.createdAt = DateTime.now();
    fuelLog.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.fuelLogModels.put(fuelLog);
    });
  }

  /// Get all fuel logs
  Future<List<FuelLogModel>> getAllFuelLogs() async {
    return await _isar.fuelLogModels.where().sortByDateDesc().findAll();
  }

  /// Get fuel logs by date range
  Future<List<FuelLogModel>> getFuelLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _isar.fuelLogModels
        .filter()
        .dateBetween(startDate, endDate)
        .sortByDateDesc()
        .findAll();
  }

  /// Get fuel logs for the current week.
  /// [weeklyResetDate] is the next upcoming reset point (end of window).
  /// The current week spans the 7 days leading up to that date.
  Future<List<FuelLogModel>> getFuelLogsForWeek(DateTime weeklyResetDate) async {
    final weekStartDate = weeklyResetDate.subtract(const Duration(days: 7));
    return await getFuelLogsByDateRange(weekStartDate, weeklyResetDate);
  }

  /// Get latest fuel log
  Future<FuelLogModel?> getLatestFuelLog() async {
    return await _isar.fuelLogModels.where().sortByDateDesc().findFirst();
  }

  /// Get fuel log by ID
  Future<FuelLogModel?> getFuelLogById(String fuelLogId) async {
    return await _isar.fuelLogModels
        .filter()
        .fuelLogIdEqualTo(fuelLogId)
        .findFirst();
  }

  /// Update fuel log
  Future<void> updateFuelLog(FuelLogModel fuelLog) async {
    fuelLog.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.fuelLogModels.put(fuelLog);
    });
  }

  /// Delete fuel log
  Future<void> deleteFuelLog(String fuelLogId) async {
    await _isar.writeTxn(() async {
      final log = await _isar.fuelLogModels
          .filter()
          .fuelLogIdEqualTo(fuelLogId)
          .findFirst();
      if (log != null) {
        await _isar.fuelLogModels.delete(log.id!);
      }
    });
  }

  /// Get total fuel added (all time)
  Future<double> getTotalFuelAdded() async {
    final logs = await _isar.fuelLogModels.where().findAll();
    double total = 0;
    for (final log in logs) {
      total += log.litersAdded;
    }
    return total;
  }

  /// Get fuel log count
  Future<int> getFuelLogCount() async {
    return await _isar.fuelLogModels.count();
  }
}
