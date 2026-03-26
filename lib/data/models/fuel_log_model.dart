import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fuel_log_model.g.dart';

/// Fuel log entry model for Isar persistence
@collection
@JsonSerializable()
class FuelLogModel {
  FuelLogModel();

  Id? id;

  late String fuelLogId; // UUID
  late DateTime date;
  late double odometerKm; // Bike's actual odometer
  late double litersAdded;
  late double? pricePerLiter;
  late double? totalCost;
  late String? note;
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$FuelLogModelToJson(this);

  /// Create from JSON
  factory FuelLogModel.fromJson(Map<String, dynamic> json) =>
      _$FuelLogModelFromJson(json);

  /// Create a copy with updated fields
  FuelLogModel copyWith({
    String? fuelLogId,
    DateTime? date,
    double? odometerKm,
    double? litersAdded,
    double? pricePerLiter,
    double? totalCost,
    String? note,
  }) {
    return FuelLogModel()
      ..id = id
      ..fuelLogId = fuelLogId ?? this.fuelLogId
      ..date = date ?? this.date
      ..odometerKm = odometerKm ?? this.odometerKm
      ..litersAdded = litersAdded ?? this.litersAdded
      ..pricePerLiter = pricePerLiter ?? this.pricePerLiter
      ..totalCost = totalCost ?? this.totalCost
      ..note = note ?? this.note
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }
}
