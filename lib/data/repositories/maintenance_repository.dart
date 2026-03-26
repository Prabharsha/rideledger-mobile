import '../models/maintenance_reminder_model.dart';
import '../datasources/local_maintenance_datasource.dart';

/// Repository for maintenance reminder operations
class MaintenanceRepository {
  final LocalMaintenanceDatasource _localDatasource;

  MaintenanceRepository({required LocalMaintenanceDatasource localDatasource})
      : _localDatasource = localDatasource;

  /// Save new maintenance reminder
  Future<void> saveMaintenanceReminder(
      MaintenanceReminderModel reminder) async {
    await _localDatasource.saveMaintenanceReminder(reminder);
  }

  /// Get all reminders
  Future<List<MaintenanceReminderModel>> getAllReminders() async {
    return await _localDatasource.getAllReminders();
  }

  /// Get pending reminders
  Future<List<MaintenanceReminderModel>> getPendingReminders() async {
    return await _localDatasource.getPendingReminders();
  }

  /// Get completed reminders
  Future<List<MaintenanceReminderModel>> getCompletedReminders() async {
    return await _localDatasource.getCompletedReminders();
  }

  /// Get reminder by ID
  Future<MaintenanceReminderModel?> getReminderById(String reminderId) async {
    return await _localDatasource.getReminderById(reminderId);
  }

  /// Get reminder by type
  Future<MaintenanceReminderModel?> getReminderByType(String type) async {
    return await _localDatasource.getReminderByType(type);
  }

  /// Update reminder
  Future<void> updateMaintenanceReminder(
      MaintenanceReminderModel reminder) async {
    await _localDatasource.updateMaintenanceReminder(reminder);
  }

  /// Mark reminder as completed
  Future<void> markReminderCompleted(String reminderId) async {
    await _localDatasource.markReminderCompleted(reminderId);
  }

  /// Delete reminder
  Future<void> deleteMaintenanceReminder(String reminderId) async {
    await _localDatasource.deleteMaintenanceReminder(reminderId);
  }
}
