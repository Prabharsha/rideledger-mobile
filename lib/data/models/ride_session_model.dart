import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_session_model.g.dart';

/// Ride session model for Isar persistence
@collection
@JsonSerializable()
class RideSessionModel {
  RideSessionModel();

  Id? id;

  late String sessionId; // UUID
  late DateTime date;
  late DateTime startTime;
  late DateTime endTime;
  late double startOdometerKm;
  late double endOdometerKm;
  late double distanceKm; // GPS calculated
  late int durationSeconds;
  late double averageSpeedKmh;
  late double maxSpeedKmh;
  late String breakInStageName;
  late int overspeedEventCount;
  late int lowSpeedDurationSeconds;
  late int stopDurationSeconds;
  late String trafficStressLevel; // Easy/Acceptable/Stressful
  late double estimatedFuelUsedLiters;
  late double fuelEconomyUsedKmPerLiter;
  late String rideType; // commute/extra/custom
  late String? encodedRoutePolyline;
  late String? notes;
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RideSessionModelToJson(this);

  /// Create from JSON
  factory RideSessionModel.fromJson(Map<String, dynamic> json) =>
      _$RideSessionModelFromJson(json);

  /// Create a copy with updated fields
  RideSessionModel copyWith({
    String? sessionId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    double? startOdometerKm,
    double? endOdometerKm,
    double? distanceKm,
    int? durationSeconds,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    String? breakInStageName,
    int? overspeedEventCount,
    int? lowSpeedDurationSeconds,
    int? stopDurationSeconds,
    String? trafficStressLevel,
    double? estimatedFuelUsedLiters,
    double? fuelEconomyUsedKmPerLiter,
    String? rideType,
    String? encodedRoutePolyline,
    String? notes,
  }) {
    return RideSessionModel()
      ..id = id
      ..sessionId = sessionId ?? this.sessionId
      ..date = date ?? this.date
      ..startTime = startTime ?? this.startTime
      ..endTime = endTime ?? this.endTime
      ..startOdometerKm = startOdometerKm ?? this.startOdometerKm
      ..endOdometerKm = endOdometerKm ?? this.endOdometerKm
      ..distanceKm = distanceKm ?? this.distanceKm
      ..durationSeconds = durationSeconds ?? this.durationSeconds
      ..averageSpeedKmh = averageSpeedKmh ?? this.averageSpeedKmh
      ..maxSpeedKmh = maxSpeedKmh ?? this.maxSpeedKmh
      ..breakInStageName = breakInStageName ?? this.breakInStageName
      ..overspeedEventCount = overspeedEventCount ?? this.overspeedEventCount
      ..lowSpeedDurationSeconds =
          lowSpeedDurationSeconds ?? this.lowSpeedDurationSeconds
      ..stopDurationSeconds = stopDurationSeconds ?? this.stopDurationSeconds
      ..trafficStressLevel = trafficStressLevel ?? this.trafficStressLevel
      ..estimatedFuelUsedLiters =
          estimatedFuelUsedLiters ?? this.estimatedFuelUsedLiters
      ..fuelEconomyUsedKmPerLiter =
          fuelEconomyUsedKmPerLiter ?? this.fuelEconomyUsedKmPerLiter
      ..rideType = rideType ?? this.rideType
      ..encodedRoutePolyline =
          encodedRoutePolyline ?? this.encodedRoutePolyline
      ..notes = notes ?? this.notes
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }
}
