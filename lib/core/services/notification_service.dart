import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:uuid/uuid.dart';

import '../../data/models/notification_schedule_model.dart';

/// Callback for handling notification taps in the background/terminated state.
@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) {
  NotificationService._lastTappedPayload = response.payload;
}

/// Service for managing local notifications.
///
/// Handles scheduling, snoozing, rescheduling, cancelling, and firing
/// both date-based and distance-based notifications via flutter_local_notifications.
class NotificationService {
  NotificationService._();

  static NotificationService? _instance;
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// The payload of the last tapped notification, stored for later handling.
  static String? _lastTappedPayload;

  /// Retrieve and clear the last tapped notification payload.
  static String? consumeLastTappedPayload() {
    final payload = _lastTappedPayload;
    _lastTappedPayload = null;
    return payload;
  }

  /// Singleton accessor. Call [initialize] before accessing.
  static NotificationService get instance {
    assert(_instance != null,
        'NotificationService.initialize() must be called before accessing instance');
    return _instance!;
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initialize the notification plugin, channels, and permissions.
  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request permissions on Android 13+
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _instance = NotificationService._();
  }

  // ---------------------------------------------------------------------------
  // Android channel helpers
  // ---------------------------------------------------------------------------

  /// Returns the [AndroidNotificationDetails] appropriate for a given category.
  AndroidNotificationDetails _androidDetailsForCategory(String category) {
    switch (category) {
      case 'oil_change':
      case 'break_in_milestone':
        return const AndroidNotificationDetails(
          'ride_ledger_reminders_high',
          'Important Ride Reminders',
          channelDescription:
              'High-importance reminders for oil changes and break-in milestones',
          importance: Importance.high,
          priority: Priority.high,
        );
      case 'service':
      case 'fuel_quota_reset':
        return const AndroidNotificationDetails(
          'ride_ledger_reminders',
          'Ride Reminders',
          channelDescription: 'Service and fuel quota reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );
      case 'custom':
      case 'maintenance':
      default:
        return const AndroidNotificationDetails(
          'ride_ledger_reminders',
          'Ride Reminders',
          channelDescription: 'General ride ledger reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );
    }
  }

  NotificationDetails _detailsForSchedule(NotificationScheduleModel schedule) {
    final android = _androidDetailsForCategory(schedule.category);
    const ios = DarwinNotificationDetails();
    return NotificationDetails(android: android, iOS: ios);
  }

  // ---------------------------------------------------------------------------
  // Numeric ID helpers (flutter_local_notifications uses int IDs)
  // ---------------------------------------------------------------------------

  /// Derives a stable int id from the notification UUID.
  int _numericId(String notificationId) {
    return notificationId.hashCode & 0x7FFFFFFF;
  }

  // ---------------------------------------------------------------------------
  // Schedule / Cancel
  // ---------------------------------------------------------------------------

  /// Schedule a local notification at [schedule.scheduledDate].
  ///
  /// Only applies to date-based triggers. Distance-based triggers are handled
  /// by [checkDistanceTriggers] + [fireDistanceNotification].
  Future<void> scheduleNotification(
      NotificationScheduleModel schedule) async {
    if (schedule.triggerType != 'date' || schedule.scheduledDate == null) {
      return;
    }

    final scheduledTZ =
        tz.TZDateTime.from(schedule.scheduledDate!, tz.local);

    // If the date is in the past, skip scheduling (avoid plugin error).
    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      _numericId(schedule.notificationId),
      schedule.title,
      schedule.body,
      scheduledTZ,
      _detailsForSchedule(schedule),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: schedule.notificationId,
    );
  }

  /// Cancel a scheduled notification by its UUID.
  Future<void> cancelNotification(String notificationId) async {
    await _plugin.cancel(_numericId(notificationId));
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  // ---------------------------------------------------------------------------
  // Snooze
  // ---------------------------------------------------------------------------

  /// Standard snooze durations offered to the user.
  static const Map<String, Duration> standardSnoozeDurations = {
    '15 minutes': Duration(minutes: 15),
    '1 hour': Duration(hours: 1),
    '3 hours': Duration(hours: 3),
    // 'Tomorrow morning' and 'Next week' are computed dynamically.
  };

  /// Compute "tomorrow morning 8 AM" duration from now.
  static Duration get snoozeTomorrowMorning {
    final now = DateTime.now();
    final tomorrow8am =
        DateTime(now.year, now.month, now.day + 1, 8);
    return tomorrow8am.difference(now);
  }

  /// Compute "next week same time" duration.
  static Duration get snoozeNextWeek => const Duration(days: 7);

  /// Snooze a notification for [snoozeDuration] from now.
  ///
  /// Cancels the existing scheduled notification, then schedules a new one
  /// at `now + snoozeDuration`.
  Future<void> snoozeNotification(
      String notificationId, Duration snoozeDuration) async {
    await cancelNotification(notificationId);

    final newDate = DateTime.now().add(snoozeDuration);
    final scheduledTZ = tz.TZDateTime.from(newDate, tz.local);

    // We don't have the full model here, so we fire a generic snooze reminder.
    await _plugin.zonedSchedule(
      _numericId(notificationId),
      'Snoozed Reminder',
      'You have a snoozed reminder waiting.',
      scheduledTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ride_ledger_reminders',
          'Ride Reminders',
          channelDescription: 'Snoozed ride ledger reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: notificationId,
    );
  }

  /// Snooze with full model context so title/body are preserved.
  Future<void> snoozeNotificationWithModel(
    NotificationScheduleModel schedule,
    Duration snoozeDuration,
  ) async {
    await cancelNotification(schedule.notificationId);

    final newDate = DateTime.now().add(snoozeDuration);
    final scheduledTZ = tz.TZDateTime.from(newDate, tz.local);

    await _plugin.zonedSchedule(
      _numericId(schedule.notificationId),
      schedule.title,
      schedule.body,
      scheduledTZ,
      _detailsForSchedule(schedule),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: schedule.notificationId,
    );
  }

  // ---------------------------------------------------------------------------
  // Reschedule
  // ---------------------------------------------------------------------------

  /// Reschedule an existing notification to [newDate].
  Future<void> rescheduleNotification(
      String notificationId, DateTime newDate) async {
    await cancelNotification(notificationId);

    final scheduledTZ = tz.TZDateTime.from(newDate, tz.local);

    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      _numericId(notificationId),
      'Rescheduled Reminder',
      'You have a rescheduled reminder.',
      scheduledTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ride_ledger_reminders',
          'Ride Reminders',
          channelDescription: 'Rescheduled ride ledger reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: notificationId,
    );
  }

  /// Reschedule with full model context.
  Future<void> rescheduleNotificationWithModel(
    NotificationScheduleModel schedule,
    DateTime newDate,
  ) async {
    await cancelNotification(schedule.notificationId);

    final scheduledTZ = tz.TZDateTime.from(newDate, tz.local);

    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      _numericId(schedule.notificationId),
      schedule.title,
      schedule.body,
      scheduledTZ,
      _detailsForSchedule(schedule),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: schedule.notificationId,
    );
  }

  // ---------------------------------------------------------------------------
  // Distance-based triggers
  // ---------------------------------------------------------------------------

  /// Check all pending distance-based notifications against [currentTotalKm].
  ///
  /// Returns those that should fire (triggerAtKm <= currentTotalKm).
  Future<List<NotificationScheduleModel>> checkDistanceTriggers(
    double currentTotalKm,
    List<NotificationScheduleModel> pendingDistanceSchedules,
  ) async {
    return pendingDistanceSchedules
        .where((s) =>
            s.triggerAtKm != null && s.triggerAtKm! <= currentTotalKm)
        .toList();
  }

  /// Fire an immediate notification for a distance-based trigger.
  Future<void> fireDistanceNotification(
      NotificationScheduleModel schedule) async {
    await _plugin.show(
      _numericId(schedule.notificationId),
      schedule.title,
      schedule.body,
      _detailsForSchedule(schedule),
      payload: schedule.notificationId,
    );
  }

  // ---------------------------------------------------------------------------
  // Recurring logic
  // ---------------------------------------------------------------------------

  /// After a notification is completed, compute and return the next occurrence
  /// if the schedule is recurring.
  ///
  /// Returns `null` if the schedule is not recurring.
  NotificationScheduleModel? handleRecurringAfterCompletion(
    NotificationScheduleModel schedule, {
    double? currentTotalKm,
  }) {
    if (!schedule.recurring) return null;

    final uuid = const Uuid();
    final now = DateTime.now();

    final next = NotificationScheduleModel()
      ..notificationId = uuid.v4()
      ..category = schedule.category
      ..title = schedule.title
      ..body = schedule.body
      ..triggerType = schedule.triggerType
      ..recurring = true
      ..recurringInterval = schedule.recurringInterval
      ..recurringIntervalKm = schedule.recurringIntervalKm
      ..enabled = true
      ..fired = false
      ..firedAt = null
      ..completed = false
      ..completedAt = null
      ..snoozed = false
      ..snoozedUntil = null
      ..linkedReminderId = schedule.linkedReminderId
      ..notes = null
      ..priority = schedule.priority
      ..createdAt = now
      ..updatedAt = now;

    if (schedule.triggerType == 'date' && schedule.scheduledDate != null) {
      DateTime nextDate;
      switch (schedule.recurringInterval) {
        case 'daily':
          nextDate = schedule.scheduledDate!.add(const Duration(days: 1));
          break;
        case 'weekly':
          nextDate = schedule.scheduledDate!.add(const Duration(days: 7));
          break;
        case 'monthly':
          nextDate = DateTime(
            schedule.scheduledDate!.year,
            schedule.scheduledDate!.month + 1,
            schedule.scheduledDate!.day,
            schedule.scheduledDate!.hour,
            schedule.scheduledDate!.minute,
          );
          break;
        default:
          // If no interval specified, default to weekly
          nextDate = schedule.scheduledDate!.add(const Duration(days: 7));
      }

      // If the computed next date is in the past, advance to the future.
      while (nextDate.isBefore(now)) {
        switch (schedule.recurringInterval) {
          case 'daily':
            nextDate = nextDate.add(const Duration(days: 1));
            break;
          case 'weekly':
            nextDate = nextDate.add(const Duration(days: 7));
            break;
          case 'monthly':
            nextDate = DateTime(
              nextDate.year,
              nextDate.month + 1,
              nextDate.day,
              nextDate.hour,
              nextDate.minute,
            );
            break;
          default:
            nextDate = nextDate.add(const Duration(days: 7));
        }
      }

      next
        ..scheduledDate = nextDate
        ..triggerAtKm = null;
    } else if (schedule.triggerType == 'distance') {
      final intervalKm = schedule.recurringIntervalKm ?? 0;
      final baseKm = currentTotalKm ?? schedule.triggerAtKm ?? 0;
      next
        ..triggerAtKm = baseKm + intervalKm
        ..scheduledDate = null;
    }

    return next;
  }
}
