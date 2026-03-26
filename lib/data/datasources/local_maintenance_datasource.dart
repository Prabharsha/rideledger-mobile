import 'package:isar/isar.dart';
import '../models/maintenance_reminder_model.dart';
import '../../core/services/storage_service.dart';

/// Local data source for maintenance reminders
class LocalMaintenanceDatasource {
  late final Isar _isar;

  LocalMaintenanceDatasource() {
    _isar = StorageService.getInstance();
  }

  /// Save maintenance reminder
  Future<void> saveMaintenanceReminder(
      MaintenanceReminderModel reminder) async {
    reminder.createdAt = DateTime.now();
    reminder.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.maintenanceReminderModels.put(reminder);
    });
  }

  /// Get all maintenance reminders
  Future<List<MaintenanceReminderModel>> getAllReminders() async {
    return await _isar.maintenanceReminderModels.where().findAll();
  }

  /// Get pending maintenance reminders (not completed)
  Future<List<MaintenanceReminderModel>> getPendingReminders() async {
    return await _isar.maintenanceReminderModels
        .filter()
        .completedEqualTo(false)
        .findAll();
  }

  /// Get completed maintenance reminders
  Future<List<MaintenanceReminderModel>> getCompletedReminders() async {
    return await _isar.maintenanceReminderModels
        .filter()
        .completedEqualTo(true)
        .findAll();
  }

  /// Get reminder by ID
  Future<MaintenanceReminderModel?> getReminderById(String reminderId) async {
    return await _isar.maintenanceReminderModels
        .filter()
        .reminderIdEqualTo(reminderId)
        .findFirst();
  }

  /// Get reminder by type
  Future<MaintenanceReminderModel?> getReminderByType(String type) async {
    return await _isar.maintenanceReminderModels
        .filter()
        .typeEqualTo(type)
        .findFirst();
  }

  /// Update maintenance reminder
  Future<void> updateMaintenanceReminder(
      MaintenanceReminderModel reminder) async {
    reminder.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.maintenanceReminderModels.put(reminder);
    });
  }

  /// Mark reminder as completed
  Future<void> markReminderCompleted(String reminderId) async {
    final reminder = await getReminderById(reminderId);
    if (reminder != null) {
      reminder.completed = true;
      reminder.completedAt = DateTime.now();
      await updateMaintenanceReminder(reminder);
    }
  }

  /// Delete maintenance reminder
  Future<void> deleteMaintenanceReminder(String reminderId) async {
    await _isar.writeTxn(() async {
      final reminder = await _isar.maintenanceReminderModels
          .filter()
          .reminderIdEqualTo(reminderId)
          .findFirst();
      if (reminder != null) {
        await _isar.maintenanceReminderModels.delete(reminder.id!);
      }
    });
  }
}
