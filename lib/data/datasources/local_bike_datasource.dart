import 'package:isar/isar.dart';
import '../models/bike_profile_model.dart';
import '../../core/services/storage_service.dart';

/// Local data source for bike profile
class LocalBikeDatasource {
  late final Isar _isar;

  LocalBikeDatasource() {
    _isar = StorageService.getInstance();
  }

  /// Get bike profile
  Future<BikeProfileModel?> getBikeProfile() async {
    return await _isar.bikeProfileModels.where().findFirst();
  }

  /// Save or update bike profile
  Future<void> saveBikeProfile(BikeProfileModel profile) async {
    profile.createdAt = DateTime.now();
    profile.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.bikeProfileModels.put(profile);
    });
  }

  /// Update bike profile
  Future<void> updateBikeProfile(BikeProfileModel profile) async {
    profile.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.bikeProfileModels.put(profile);
    });
  }

  /// Check if bike profile exists
  Future<bool> bikeProfileExists() async {
    final count = await _isar.bikeProfileModels.count();
    return count > 0;
  }

  /// Delete bike profile
  Future<void> deleteBikeProfile() async {
    await _isar.writeTxn(() async {
      await _isar.bikeProfileModels.clear();
    });
  }
}
