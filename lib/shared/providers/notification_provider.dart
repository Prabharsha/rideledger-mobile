import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/notification_service.dart';
import '../../data/models/notification_schedule_model.dart';
import '../../data/repositories/notification_repository.dart';
import 'repositories_provider.dart';

// -----------------------------------------------------------------------------
// Data providers
// -----------------------------------------------------------------------------

/// All notification schedules.
final allNotificationSchedulesProvider =
    FutureProvider<List<NotificationScheduleModel>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getAllSchedules();
});

/// Active notifications (enabled AND not completed).
final activeNotificationsProvider =
    FutureProvider<List<NotificationScheduleModel>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getActiveSchedules();
});

/// Next 10 upcoming notifications.
final upcomingNotificationsProvider =
    FutureProvider<List<NotificationScheduleModel>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUpcomingNotifications(limit: 10);
});

// -----------------------------------------------------------------------------
// State
// -----------------------------------------------------------------------------

/// State class for the notification manager.
class NotificationManagerState {
  final bool isProcessing;
  final String? lastError;
  final String? lastAction;

  const NotificationManagerState({
    this.isProcessing = false,
    this.lastError,
    this.lastAction,
  });

  NotificationManagerState copyWith({
    bool? isProcessing,
    String? lastError,
    String? lastAction,
  }) {
    return NotificationManagerState(
      isProcessing: isProcessing ?? this.isProcessing,
      lastError: lastError,
      lastAction: lastAction,
    );
  }
}

// -----------------------------------------------------------------------------
// Notifier
// -----------------------------------------------------------------------------

class NotificationManagerNotifier
    extends StateNotifier<NotificationManagerState> {
  final NotificationRepository _repository;

  NotificationManagerNotifier(this._repository)
      : super(const NotificationManagerState());

  static const _uuid = Uuid();

  /// Create and schedule a new notification reminder.
  Future<void> createReminder({
    required String category,
    required String title,
    required String body,
    required String triggerType,
    DateTime? scheduledDate,
    double? triggerAtKm,
    bool recurring = false,
    String? recurringInterval,
    int? recurringIntervalKm,
    String priority = 'normal',
    String? linkedReminderId,
    String? notes,
  }) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final now = DateTime.now();
      final schedule = NotificationScheduleModel()
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
        ..linkedReminderId = linkedReminderId
        ..notes = notes
        ..priority = priority
        ..createdAt = now
        ..updatedAt = now;

      await _repository.saveSchedule(schedule);

      // Schedule with the OS notification system if date-based
      if (triggerType == 'date' && scheduledDate != null) {
        await NotificationService.instance.scheduleNotification(schedule);
      }

      state = state.copyWith(isProcessing: false, lastAction: 'created');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Snooze a notification for [duration].
  Future<void> snooze(String id, Duration duration) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final schedule = await _repository.getScheduleById(id);
      if (schedule == null) {
        state = state.copyWith(
          isProcessing: false,
          lastError: 'Schedule not found',
        );
        return;
      }

      final snoozedUntil = DateTime.now().add(duration);
      await _repository.snoozeSchedule(id, snoozedUntil);
      await NotificationService.instance
          .snoozeNotificationWithModel(schedule, duration);

      state = state.copyWith(isProcessing: false, lastAction: 'snoozed');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Reschedule a notification to [newDate].
  Future<void> reschedule(String id, DateTime newDate) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final schedule = await _repository.getScheduleById(id);
      if (schedule == null) {
        state = state.copyWith(
          isProcessing: false,
          lastError: 'Schedule not found',
        );
        return;
      }

      // Update the record
      schedule
        ..scheduledDate = newDate
        ..snoozed = false
        ..snoozedUntil = null
        ..fired = false
        ..firedAt = null
        ..updatedAt = DateTime.now();
      await _repository.updateSchedule(schedule);

      // Reschedule with OS
      await NotificationService.instance
          .rescheduleNotificationWithModel(schedule, newDate);

      state =
          state.copyWith(isProcessing: false, lastAction: 'rescheduled');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Mark a notification as completed, optionally with notes.
  /// If recurring, creates the next occurrence.
  Future<void> markComplete(String id, {String? notes}) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final schedule = await _repository.getScheduleById(id);
      if (schedule == null) {
        state = state.copyWith(
          isProcessing: false,
          lastError: 'Schedule not found',
        );
        return;
      }

      await _repository.markAsCompleted(id, notes: notes);
      await NotificationService.instance
          .cancelNotification(id);

      // Handle recurring: create next occurrence
      final next = NotificationService.instance
          .handleRecurringAfterCompletion(schedule);
      if (next != null) {
        await _repository.saveSchedule(next);
        if (next.triggerType == 'date' && next.scheduledDate != null) {
          await NotificationService.instance.scheduleNotification(next);
        }
      }

      state = state.copyWith(isProcessing: false, lastAction: 'completed');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Toggle enabled/disabled state.
  Future<void> toggleEnabled(String id) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final schedule = await _repository.getScheduleById(id);
      if (schedule == null) {
        state = state.copyWith(
          isProcessing: false,
          lastError: 'Schedule not found',
        );
        return;
      }

      schedule
        ..enabled = !schedule.enabled
        ..updatedAt = DateTime.now();
      await _repository.updateSchedule(schedule);

      if (!schedule.enabled) {
        await NotificationService.instance
            .cancelNotification(id);
      } else if (schedule.triggerType == 'date' &&
          schedule.scheduledDate != null) {
        await NotificationService.instance.scheduleNotification(schedule);
      }

      state = state.copyWith(isProcessing: false, lastAction: 'toggled');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Delete a notification permanently.
  Future<void> deleteReminder(String id) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      await NotificationService.instance.cancelNotification(id);
      await _repository.deleteSchedule(id);
      state = state.copyWith(isProcessing: false, lastAction: 'deleted');
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Check distance-based milestones and fire any that have been reached.
  Future<void> checkDistanceMilestones(double currentKm) async {
    state = state.copyWith(isProcessing: true, lastError: null);
    try {
      final pending = await _repository.getPendingDistanceTriggers();
      final triggered = await NotificationService.instance
          .checkDistanceTriggers(currentKm, pending);

      for (final schedule in triggered) {
        await NotificationService.instance
            .fireDistanceNotification(schedule);
        await _repository.markAsFired(schedule.notificationId);
      }

      state = state.copyWith(
        isProcessing: false,
        lastAction: 'distance_check_${triggered.length}',
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      );
    }
  }
}

// -----------------------------------------------------------------------------
// StateNotifierProvider
// -----------------------------------------------------------------------------

final notificationManagerProvider = StateNotifierProvider<
    NotificationManagerNotifier, NotificationManagerState>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationManagerNotifier(repo);
});
