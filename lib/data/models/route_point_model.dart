import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_point_model.g.dart';

/// Route point model for storing GPS coordinates
@collection
@JsonSerializable()
class RoutePointModel {
  RoutePointModel();

  Id? id;

  late String pointId; // UUID
  late String sessionId; // FK to RideSessionModel

  @Index()
  late DateTime timestamp;

  late double latitude;
  late double longitude;
  late double speedKmh;
  late double? accuracyM;
  late double? altitudeM;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RoutePointModelToJson(this);

  /// Create from JSON
  factory RoutePointModel.fromJson(Map<String, dynamic> json) =>
      _$RoutePointModelFromJson(json);

  RoutePointModel copyWith({
    String? pointId,
    String? sessionId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? speedKmh,
    double? accuracyM,
    double? altitudeM,
  }) {
    return RoutePointModel()
      ..id = id
      ..pointId = pointId ?? this.pointId
      ..sessionId = sessionId ?? this.sessionId
      ..timestamp = timestamp ?? this.timestamp
      ..latitude = latitude ?? this.latitude
      ..longitude = longitude ?? this.longitude
      ..speedKmh = speedKmh ?? this.speedKmh
      ..accuracyM = accuracyM ?? this.accuracyM
      ..altitudeM = altitudeM ?? this.altitudeM;
  }
}
