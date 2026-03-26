import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'maintenance_reminder_model.g.dart';

/// Maintenance reminder model for Isar persistence
@collection
@JsonSerializable()
class MaintenanceReminderModel {
  MaintenanceReminderModel();

  Id? id;

  late String reminderId; // UUID
  late String type; // oil_change_1, oil_change_2, spark_plug_check, etc
  late double dueAtKm;
  late bool completed;
  late DateTime? completedAt;
  late String? notes;
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$MaintenanceReminderModelToJson(this);

  /// Create from JSON
  factory MaintenanceReminderModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceReminderModelFromJson(json);

  /// Create a copy with updated fields
  MaintenanceReminderModel copyWith({
    String? reminderId,
    String? type,
    double? dueAtKm,
    bool? completed,
    DateTime? completedAt,
    String? notes,
  }) {
    return MaintenanceReminderModel()
      ..id = id
      ..reminderId = reminderId ?? this.reminderId
      ..type = type ?? this.type
      ..dueAtKm = dueAtKm ?? this.dueAtKm
      ..completed = completed ?? this.completed
      ..completedAt = completedAt ?? this.completedAt
      ..notes = notes ?? this.notes
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }
}
