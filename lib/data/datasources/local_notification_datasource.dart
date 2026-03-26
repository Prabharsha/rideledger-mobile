import 'package:isar/isar.dart';

import '../../core/services/storage_service.dart';
import '../models/notification_schedule_model.dart';

/// Local data source for notification schedule CRUD operations.
class LocalNotificationDatasource {
  late final Isar _isar;

  LocalNotificationDatasource() {
    _isar = StorageService.getInstance();
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Get all notification schedules.
  Future<List<NotificationScheduleModel>> getAllSchedules() async {
    return await _isar.notificationScheduleModels.where().findAll();
  }

  /// Get active schedules: enabled AND not completed.
  Future<List<NotificationScheduleModel>> getActiveSchedules() async {
    return await _isar.notificationScheduleModels
        .filter()
        .enabledEqualTo(true)
        .and()
        .completedEqualTo(false)
        .findAll();
  }

  /// Get schedules filtered by category.
  Future<List<NotificationScheduleModel>> getSchedulesByCategory(
      String category) async {
    return await _isar.notificationScheduleModels
        .filter()
        .categoryEqualTo(category)
        .findAll();
  }

  /// Get pending distance triggers: enabled, not fired, triggerType == 'distance'.
  Future<List<NotificationScheduleModel>> getPendingDistanceTriggers() async {
    return await _isar.notificationScheduleModels
        .filter()
        .enabledEqualTo(true)
        .and()
        .firedEqualTo(false)
        .and()
        .triggerTypeEqualTo('distance')
        .findAll();
  }

  /// Get snoozed schedules.
  Future<List<NotificationScheduleModel>> getSnoozedSchedules() async {
    return await _isar.notificationScheduleModels
        .filter()
        .snoozedEqualTo(true)
        .findAll();
  }

  /// Get a single schedule by its notificationId (UUID).
  Future<NotificationScheduleModel?> getScheduleById(
      String notificationId) async {
    return await _isar.notificationScheduleModels
        .filter()
        .notificationIdEqualTo(notificationId)
        .findFirst();
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Insert or replace a schedule.
  Future<void> saveSchedule(NotificationScheduleModel schedule) async {
    schedule.createdAt = DateTime.now();
    schedule.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.notificationScheduleModels.put(schedule);
    });
  }

  /// Update an existing schedule (put with same Isar id).
  Future<void> updateSchedule(NotificationScheduleModel schedule) async {
    schedule.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.notificationScheduleModels.put(schedule);
    });
  }

  /// Delete a schedule by notificationId (UUID).
  Future<void> deleteSchedule(String notificationId) async {
    await _isar.writeTxn(() async {
      final schedule = await _isar.notificationScheduleModels
          .filter()
          .notificationIdEqualTo(notificationId)
          .findFirst();
      if (schedule != null && schedule.id != null) {
        await _isar.notificationScheduleModels.delete(schedule.id!);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Status mutations
  // ---------------------------------------------------------------------------

  /// Mark a schedule as fired.
  Future<void> markAsFired(String notificationId) async {
    final schedule = await getScheduleById(notificationId);
    if (schedule != null) {
      schedule
        ..fired = true
        ..firedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.notificationScheduleModels.put(schedule);
      });
    }
  }

  /// Mark a schedule as completed, optionally attaching notes.
  Future<void> markAsCompleted(String notificationId, {String? notes}) async {
    final schedule = await getScheduleById(notificationId);
    if (schedule != null) {
      schedule
        ..completed = true
        ..completedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      if (notes != null) {
        schedule.notes = notes;
      }
      await _isar.writeTxn(() async {
        await _isar.notificationScheduleModels.put(schedule);
      });
    }
  }

  /// Set snooze state and snooze-until date.
  Future<void> snoozeSchedule(
      String notificationId, DateTime snoozedUntil) async {
    final schedule = await getScheduleById(notificationId);
    if (schedule != null) {
      schedule
        ..snoozed = true
        ..snoozedUntil = snoozedUntil
        ..updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.notificationScheduleModels.put(schedule);
      });
    }
  }

  /// Clear snooze state.
  Future<void> unsnooze(String notificationId) async {
    final schedule = await getScheduleById(notificationId);
    if (schedule != null) {
      schedule
        ..snoozed = false
        ..snoozedUntil = null
        ..updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.notificationScheduleModels.put(schedule);
      });
    }
  }
}
