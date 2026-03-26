import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_schedule_model.g.dart';

/// Notification schedule model for Isar persistence.
///
/// Supports both date-based and distance-based trigger types,
/// with recurring logic, snooze, and completion tracking.
@collection
@JsonSerializable()
class NotificationScheduleModel {
  NotificationScheduleModel();

  Id? id;

  /// Unique identifier (UUID v4)
  late String notificationId;

  /// Category: 'service', 'maintenance', 'break_in_milestone',
  /// 'oil_change', 'fuel_quota_reset', 'custom'
  late String category;

  /// Notification title shown to user
  late String title;

  /// Notification body/description
  late String body;

  /// Trigger type: 'date' or 'distance'
  late String triggerType;

  /// Scheduled date for date-based triggers
  DateTime? scheduledDate;

  /// Trigger at this total km (since rebuild) for distance-based triggers
  double? triggerAtKm;

  /// Whether this notification recurs after completion
  late bool recurring;

  /// Recurring interval for date-based: 'daily', 'weekly', 'monthly', or null
  String? recurringInterval;

  /// Distance interval for recurring distance-based (e.g. every 500 km)
  int? recurringIntervalKm;

  /// User can disable without deleting
  late bool enabled;

  /// Whether this notification has been shown
  late bool fired;

  /// When the notification was shown
  DateTime? firedAt;

  /// User marked this notification as done
  late bool completed;

  /// When the user marked it complete
  DateTime? completedAt;

  /// Currently snoozed
  late bool snoozed;

  /// Snooze expiry time
  DateTime? snoozedUntil;

  /// Optional FK to MaintenanceReminderModel.reminderId
  String? linkedReminderId;

  /// User-added notes
  String? notes;

  /// Priority: 'low', 'normal', 'high'
  late String priority;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$NotificationScheduleModelToJson(this);

  /// Create from JSON
  factory NotificationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleModelFromJson(json);

  /// Create a copy with updated fields
  NotificationScheduleModel copyWith({
    String? notificationId,
    String? category,
    String? title,
    String? body,
    String? triggerType,
    DateTime? scheduledDate,
    double? triggerAtKm,
    bool? recurring,
    String? recurringInterval,
    int? recurringIntervalKm,
    bool? enabled,
    bool? fired,
    DateTime? firedAt,
    bool? completed,
    DateTime? completedAt,
    bool? snoozed,
    DateTime? snoozedUntil,
    String? linkedReminderId,
    String? notes,
    String? priority,
  }) {
    return NotificationScheduleModel()
      ..id = id
      ..notificationId = notificationId ?? this.notificationId
      ..category = category ?? this.category
      ..title = title ?? this.title
      ..body = body ?? this.body
      ..triggerType = triggerType ?? this.triggerType
      ..scheduledDate = scheduledDate ?? this.scheduledDate
      ..triggerAtKm = triggerAtKm ?? this.triggerAtKm
      ..recurring = recurring ?? this.recurring
      ..recurringInterval = recurringInterval ?? this.recurringInterval
      ..recurringIntervalKm = recurringIntervalKm ?? this.recurringIntervalKm
      ..enabled = enabled ?? this.enabled
      ..fired = fired ?? this.fired
      ..firedAt = firedAt ?? this.firedAt
      ..completed = completed ?? this.completed
      ..completedAt = completedAt ?? this.completedAt
      ..snoozed = snoozed ?? this.snoozed
      ..snoozedUntil = snoozedUntil ?? this.snoozedUntil
      ..linkedReminderId = linkedReminderId ?? this.linkedReminderId
      ..notes = notes ?? this.notes
      ..priority = priority ?? this.priority
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }

  /// Human-readable label for a category string
  static String getCategoryLabel(String category) {
    switch (category) {
      case 'service':
        return 'Service Reminder';
      case 'maintenance':
        return 'Maintenance Alert';
      case 'break_in_milestone':
        return 'Break-In Milestone';
      case 'oil_change':
        return 'Oil Change';
      case 'fuel_quota_reset':
        return 'Fuel Quota Reset';
      case 'custom':
        return 'Custom Reminder';
      default:
        return 'Notification';
    }
  }

  /// Icon name string for a category
  static String getCategoryIcon(String category) {
    switch (category) {
      case 'service':
        return 'build';
      case 'maintenance':
        return 'engineering';
      case 'break_in_milestone':
        return 'flag';
      case 'oil_change':
        return 'oil_barrel';
      case 'fuel_quota_reset':
        return 'local_gas_station';
      case 'custom':
        return 'notifications';
      default:
        return 'notifications_none';
    }
  }
}
