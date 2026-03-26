import 'package:uuid/uuid.dart';

import '../../data/models/bike_profile_model.dart';
import '../../data/models/notification_schedule_model.dart';

/// Factory that creates the standard set of notification schedules for a
/// newly created bike profile.
///
/// These cover oil changes, break-in milestones, fuel quota resets, and
/// recurring service intervals.
class DefaultNotificationsFactory {
  static const _uuid = Uuid();

  /// Create the default notification schedules for [profile].
  static List<NotificationScheduleModel> createDefaultNotifications(
    BikeProfileModel profile,
  ) {
    final now = DateTime.now();
    final schedules = <NotificationScheduleModel>[];

    // -----------------------------------------------------------------------
    // Oil change reminders (distance-based, high priority)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'oil_change',
      title: 'First Oil Change Due',
      body:
          'Your first oil change is due at ${profile.firstOilChangeKm.toStringAsFixed(0)} km. Use the manufacturer-recommended oil.',
      triggerType: 'distance',
      triggerAtKm: profile.firstOilChangeKm,
      priority: 'high',
      now: now,
    ));

    schedules.add(_make(
      category: 'oil_change',
      title: 'Second Oil Change Due',
      body:
          'Your second oil change is due at ${profile.secondOilChangeKm.toStringAsFixed(0)} km. Continue with the recommended oil grade.',
      triggerType: 'distance',
      triggerAtKm: profile.secondOilChangeKm,
      priority: 'high',
      now: now,
    ));

    // -----------------------------------------------------------------------
    // Break-in milestones (distance-based)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'break_in_milestone',
      title: 'Break-In: 200 km Reached',
      body:
          'You have reached 200 km. The initial break-in phase is progressing well.',
      triggerType: 'distance',
      triggerAtKm: 200,
      priority: 'normal',
      now: now,
    ));

    schedules.add(_make(
      category: 'break_in_milestone',
      title: 'Break-In: 500 km Reached',
      body:
          'Halfway through break-in. You can begin gradually increasing RPM range.',
      triggerType: 'distance',
      triggerAtKm: 500,
      priority: 'normal',
      now: now,
    ));

    schedules.add(_make(
      category: 'break_in_milestone',
      title: 'Break-In: 800 km Reached',
      body:
          'Almost done! Continue varying engine speed. Full break-in at 1000 km.',
      triggerType: 'distance',
      triggerAtKm: 800,
      priority: 'normal',
      now: now,
    ));

    schedules.add(_make(
      category: 'break_in_milestone',
      title: 'Break-In Complete!',
      body:
          'Congratulations! 1000 km reached. Your engine is fully broken in. Enjoy full performance.',
      triggerType: 'distance',
      triggerAtKm: 1000,
      priority: 'high',
      now: now,
    ));

    // -----------------------------------------------------------------------
    // Weekly fuel quota reset (recurring, date-based)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'fuel_quota_reset',
      title: 'Weekly Fuel Quota Reset',
      body:
          'Your weekly fuel quota of ${profile.weeklyFuelQuotaLiters.toStringAsFixed(1)} L has been reset.',
      triggerType: 'date',
      scheduledDate: _nextOccurrence(profile.weeklyResetDate),
      recurring: true,
      recurringInterval: 'weekly',
      priority: 'normal',
      now: now,
    ));

    // -----------------------------------------------------------------------
    // Spark plug check (distance-based)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'maintenance',
      title: 'Spark Plug Check',
      body:
          'Check spark plug condition and gap at 500 km. Replace if fouled or worn.',
      triggerType: 'distance',
      triggerAtKm: 500,
      priority: 'normal',
      now: now,
    ));

    // -----------------------------------------------------------------------
    // Chain / tensioner check (distance-based)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'maintenance',
      title: 'Chain & Tensioner Check',
      body:
          'Inspect chain tension and lubrication at 300 km. Adjust per manual specs.',
      triggerType: 'distance',
      triggerAtKm: 300,
      priority: 'normal',
      now: now,
    ));

    // -----------------------------------------------------------------------
    // General service reminder every 1000 km (recurring, distance-based)
    // -----------------------------------------------------------------------
    schedules.add(_make(
      category: 'service',
      title: 'General Service Reminder',
      body:
          'Perform a general service check: oil, chain, brakes, tires, lights.',
      triggerType: 'distance',
      triggerAtKm: 1000,
      recurring: true,
      recurringIntervalKm: 1000,
      priority: 'normal',
      now: now,
    ));

    return schedules;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static NotificationScheduleModel _make({
    required String category,
    required String title,
    required String body,
    required String triggerType,
    required String priority,
    required DateTime now,
    double? triggerAtKm,
    DateTime? scheduledDate,
    bool recurring = false,
    String? recurringInterval,
    int? recurringIntervalKm,
  }) {
    return NotificationScheduleModel()
      ..notificationId = _uuid.v4()
      ..category = category
      ..title = title
      ..body = body
      ..triggerType = triggerType
      ..scheduledDate = scheduledDate
      ..triggerAtKm = triggerAtKm
      ..recurring = recurring
      ..recurringInterval = recurringInterval
      ..recurringIntervalKm = recurringIntervalKm
      ..enabled = true
      ..fired = false
      ..firedAt = null
      ..completed = false
      ..completedAt = null
      ..snoozed = false
      ..snoozedUntil = null
      ..linkedReminderId = null
      ..notes = null
      ..priority = priority
      ..createdAt = now
      ..updatedAt = now;
  }

  /// Compute the next occurrence of a weekly reset date.
  ///
  /// If the reset date's weekday+time has already passed this week, advance
  /// to next week.
  static DateTime _nextOccurrence(DateTime resetDate) {
    final now = DateTime.now();
    final targetWeekday = resetDate.weekday;
    final hour = resetDate.hour;
    final minute = resetDate.minute;

    // Find the next occurrence of this weekday
    var daysUntil = targetWeekday - now.weekday;
    if (daysUntil < 0) {
      daysUntil += 7;
    }

    var next = DateTime(
      now.year,
      now.month,
      now.day + daysUntil,
      hour,
      minute,
    );

    // If it's today but the time has passed, push to next week
    if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
      next = next.add(const Duration(days: 7));
    }

    return next;
  }
}
