import '../datasources/local_notification_datasource.dart';
import '../models/notification_schedule_model.dart';

/// Repository for notification schedule operations.
///
/// Wraps [LocalNotificationDatasource] and adds higher-level query helpers
/// such as [getUpcomingNotifications].
class NotificationRepository {
  final LocalNotificationDatasource _localDatasource;

  NotificationRepository({
    required LocalNotificationDatasource localDatasource,
  }) : _localDatasource = localDatasource;

  // ---------------------------------------------------------------------------
  // Forwarded CRUD
  // ---------------------------------------------------------------------------

  Future<List<NotificationScheduleModel>> getAllSchedules() =>
      _localDatasource.getAllSchedules();

  Future<List<NotificationScheduleModel>> getActiveSchedules() =>
      _localDatasource.getActiveSchedules();

  Future<List<NotificationScheduleModel>> getSchedulesByCategory(
          String category) =>
      _localDatasource.getSchedulesByCategory(category);

  Future<List<NotificationScheduleModel>> getPendingDistanceTriggers() =>
      _localDatasource.getPendingDistanceTriggers();

  Future<List<NotificationScheduleModel>> getSnoozedSchedules() =>
      _localDatasource.getSnoozedSchedules();

  Future<NotificationScheduleModel?> getScheduleById(
          String notificationId) =>
      _localDatasource.getScheduleById(notificationId);

  Future<void> saveSchedule(NotificationScheduleModel schedule) =>
      _localDatasource.saveSchedule(schedule);

  Future<void> updateSchedule(NotificationScheduleModel schedule) =>
      _localDatasource.updateSchedule(schedule);

  Future<void> deleteSchedule(String notificationId) =>
      _localDatasource.deleteSchedule(notificationId);

  Future<void> markAsFired(String notificationId) =>
      _localDatasource.markAsFired(notificationId);

  Future<void> markAsCompleted(String notificationId, {String? notes}) =>
      _localDatasource.markAsCompleted(notificationId, notes: notes);

  Future<void> snoozeSchedule(
          String notificationId, DateTime snoozedUntil) =>
      _localDatasource.snoozeSchedule(notificationId, snoozedUntil);

  Future<void> unsnooze(String notificationId) =>
      _localDatasource.unsnooze(notificationId);

  // ---------------------------------------------------------------------------
  // Higher-level queries
  // ---------------------------------------------------------------------------

  /// Returns the next [limit] upcoming notifications.
  ///
  /// Combines unfired date-based (sorted by scheduledDate ascending) and
  /// unfired distance-based (sorted by triggerAtKm ascending), then
  /// interleaves them to produce a unified list:
  ///   - Date-based entries come first (sorted by date).
  ///   - Distance-based entries follow (sorted by km).
  Future<List<NotificationScheduleModel>> getUpcomingNotifications({
    int limit = 10,
  }) async {
    final active = await _localDatasource.getActiveSchedules();
    final now = DateTime.now();

    // Separate date-based and distance-based
    final dateBased = active
        .where((s) =>
            s.triggerType == 'date' &&
            !s.fired &&
            s.scheduledDate != null &&
            s.scheduledDate!.isAfter(now))
        .toList()
      ..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));

    final distanceBased = active
        .where((s) =>
            s.triggerType == 'distance' &&
            !s.fired &&
            s.triggerAtKm != null)
        .toList()
      ..sort((a, b) => a.triggerAtKm!.compareTo(b.triggerAtKm!));

    // Merge: date-based first, then distance-based
    final combined = <NotificationScheduleModel>[
      ...dateBased,
      ...distanceBased,
    ];

    if (combined.length > limit) {
      return combined.sublist(0, limit);
    }
    return combined;
  }
}
