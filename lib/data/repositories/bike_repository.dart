import '../models/bike_profile_model.dart';
import '../datasources/local_bike_datasource.dart';

/// Repository for bike profile operations
class BikeRepository {
  final LocalBikeDatasource _localDatasource;

  BikeRepository({required LocalBikeDatasource localDatasource})
      : _localDatasource = localDatasource;

  /// Get current bike profile
  Future<BikeProfileModel?> getBikeProfile() async {
    return await _localDatasource.getBikeProfile();
  }

  /// Save bike profile (new)
  Future<void> saveBikeProfile(BikeProfileModel profile) async {
    await _localDatasource.saveBikeProfile(profile);
  }

  /// Update bike profile
  Future<void> updateBikeProfile(BikeProfileModel profile) async {
    await _localDatasource.updateBikeProfile(profile);
  }

  /// Check if bike profile exists
  Future<bool> bikeProfileExists() async {
    return await _localDatasource.bikeProfileExists();
  }

  /// Delete bike profile
  Future<void> deleteBikeProfile() async {
    await _localDatasource.deleteBikeProfile();
  }

  /// Update weekly fuel balance
  Future<void> updateWeeklyFuelBalance(double newBalance) async {
    final profile = await _localDatasource.getBikeProfile();
    if (profile != null) {
      profile.weeklyFuelBalanceLiters = newBalance;
      await _localDatasource.updateBikeProfile(profile);
    }
  }

  /// Update fuel economy estimate
  Future<void> updateFuelEconomy(double kmPerLiter) async {
    final profile = await _localDatasource.getBikeProfile();
    if (profile != null) {
      profile.manualFuelEconomyKmPerLiter = kmPerLiter;
      await _localDatasource.updateBikeProfile(profile);
    }
  }
}
