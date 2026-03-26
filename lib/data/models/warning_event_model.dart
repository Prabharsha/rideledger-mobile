import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'warning_event_model.g.dart';

/// Warning event model for tracking alerts during a ride
@collection
@JsonSerializable()
class WarningEventModel {
  WarningEventModel();

  Id? id;

  late String warningId; // UUID
  late String sessionId; // FK to RideSessionModel

  @Index()
  late DateTime timestamp;

  late String type; // overspeed, cooldown, low_fuel, oil_change_due
  late String message;
  late double? speedKmh;
  late String? breakInStageName;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WarningEventModelToJson(this);

  /// Create from JSON
  factory WarningEventModel.fromJson(Map<String, dynamic> json) =>
      _$WarningEventModelFromJson(json);

  WarningEventModel copyWith({
    String? warningId,
    String? sessionId,
    DateTime? timestamp,
    String? type,
    String? message,
    double? speedKmh,
    String? breakInStageName,
  }) {
    return WarningEventModel()
      ..id = id
      ..warningId = warningId ?? this.warningId
      ..sessionId = sessionId ?? this.sessionId
      ..timestamp = timestamp ?? this.timestamp
      ..type = type ?? this.type
      ..message = message ?? this.message
      ..speedKmh = speedKmh ?? this.speedKmh
      ..breakInStageName = breakInStageName ?? this.breakInStageName;
  }
}
