import '../models/fuel_log_model.dart';
import '../datasources/local_fuel_datasource.dart';

/// Repository for fuel log operations
class FuelRepository {
  final LocalFuelDatasource _localDatasource;

  FuelRepository({required LocalFuelDatasource localDatasource})
      : _localDatasource = localDatasource;

  /// Save new fuel log
  Future<void> saveFuelLog(FuelLogModel fuelLog) async {
    await _localDatasource.saveFuelLog(fuelLog);
  }

  /// Get all fuel logs
  Future<List<FuelLogModel>> getAllFuelLogs() async {
    return await _localDatasource.getAllFuelLogs();
  }

  /// Get fuel logs by date range
  Future<List<FuelLogModel>> getFuelLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _localDatasource.getFuelLogsByDateRange(startDate, endDate);
  }

  /// Get fuel logs for current week
  Future<List<FuelLogModel>> getFuelLogsForWeek(DateTime weekStartDate) async {
    return await _localDatasource.getFuelLogsForWeek(weekStartDate);
  }

  /// Get latest fuel log
  Future<FuelLogModel?> getLatestFuelLog() async {
    return await _localDatasource.getLatestFuelLog();
  }

  /// Get fuel log by ID
  Future<FuelLogModel?> getFuelLogById(String fuelLogId) async {
    return await _localDatasource.getFuelLogById(fuelLogId);
  }

  /// Update fuel log
  Future<void> updateFuelLog(FuelLogModel fuelLog) async {
    await _localDatasource.updateFuelLog(fuelLog);
  }

  /// Delete fuel log
  Future<void> deleteFuelLog(String fuelLogId) async {
    await _localDatasource.deleteFuelLog(fuelLogId);
  }

  /// Get total fuel added
  Future<double> getTotalFuelAdded() async {
    return await _localDatasource.getTotalFuelAdded();
  }

  /// Get fuel log count
  Future<int> getFuelLogCount() async {
    return await _localDatasource.getFuelLogCount();
  }
}
