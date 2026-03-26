import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bike_profile_model.g.dart';

/// Bike profile model for Isar persistence
@collection
@JsonSerializable()
class BikeProfileModel {
  BikeProfileModel();

  Id id = Isar.autoIncrement;

  late String bikeModel; // e.g., "Yamaha TW200 2017"
  late DateTime rebuildDate;
  late double rebuildStartOdometerKm;
  late double firstOilChangeKm; // 350
  late double secondOilChangeKm; // 1000
  late String breakInProfile; // conservative/balanced/aggressive
  late double officeOneWayDistanceKm; // 7.8
  late int officeDaysPerWeek; // 5
  late double weeklyFuelQuotaLiters; // 8.0
  late double weeklyFuelBalanceLiters; // Current balance
  late DateTime weeklyResetDate; // e.g., Monday of each week
  late double manualFuelEconomyKmPerLiter; // 20.0
  late double targetFuelEconomyKmPerLiter; // 25.0
  late bool isFirstLaunch;
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$BikeProfileModelToJson(this);

  /// Create from JSON
  factory BikeProfileModel.fromJson(Map<String, dynamic> json) =>
      _$BikeProfileModelFromJson(json);

  /// Create a copy with updated fields
  BikeProfileModel copyWith({
    String? bikeModel,
    DateTime? rebuildDate,
    double? rebuildStartOdometerKm,
    double? firstOilChangeKm,
    double? secondOilChangeKm,
    String? breakInProfile,
    double? officeOneWayDistanceKm,
    int? officeDaysPerWeek,
    double? weeklyFuelQuotaLiters,
    double? weeklyFuelBalanceLiters,
    DateTime? weeklyResetDate,
    double? manualFuelEconomyKmPerLiter,
    double? targetFuelEconomyKmPerLiter,
    bool? isFirstLaunch,
  }) {
    return BikeProfileModel()
      ..id = id
      ..bikeModel = bikeModel ?? this.bikeModel
      ..rebuildDate = rebuildDate ?? this.rebuildDate
      ..rebuildStartOdometerKm =
          rebuildStartOdometerKm ?? this.rebuildStartOdometerKm
      ..firstOilChangeKm = firstOilChangeKm ?? this.firstOilChangeKm
      ..secondOilChangeKm = secondOilChangeKm ?? this.secondOilChangeKm
      ..breakInProfile = breakInProfile ?? this.breakInProfile
      ..officeOneWayDistanceKm =
          officeOneWayDistanceKm ?? this.officeOneWayDistanceKm
      ..officeDaysPerWeek = officeDaysPerWeek ?? this.officeDaysPerWeek
      ..weeklyFuelQuotaLiters =
          weeklyFuelQuotaLiters ?? this.weeklyFuelQuotaLiters
      ..weeklyFuelBalanceLiters =
          weeklyFuelBalanceLiters ?? this.weeklyFuelBalanceLiters
      ..weeklyResetDate = weeklyResetDate ?? this.weeklyResetDate
      ..manualFuelEconomyKmPerLiter =
          manualFuelEconomyKmPerLiter ?? this.manualFuelEconomyKmPerLiter
      ..targetFuelEconomyKmPerLiter =
          targetFuelEconomyKmPerLiter ?? this.targetFuelEconomyKmPerLiter
      ..isFirstLaunch = isFirstLaunch ?? this.isFirstLaunch
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }
}
