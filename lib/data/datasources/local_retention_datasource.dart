import 'package:isar/isar.dart';
import '../models/retention_policy_model.dart';
import '../../core/services/storage_service.dart';

/// Local data source for retention policy persistence
class LocalRetentionDatasource {
  late final Isar _isar;

  LocalRetentionDatasource() {
    _isar = StorageService.getInstance();
  }

  /// Get the single retention policy record, if one exists
  Future<RetentionPolicyModel?> getRetentionPolicy() async {
    return await _isar.retentionPolicyModels.where().findFirst();
  }

  /// Save a new retention policy record
  Future<void> saveRetentionPolicy(RetentionPolicyModel policy) async {
    policy.createdAt = DateTime.now();
    policy.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.retentionPolicyModels.put(policy);
    });
  }

  /// Update an existing retention policy record
  Future<void> updateRetentionPolicy(RetentionPolicyModel policy) async {
    policy.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.retentionPolicyModels.put(policy);
    });
  }

  /// Check whether a retention policy already exists
  Future<bool> retentionPolicyExists() async {
    final count = await _isar.retentionPolicyModels.count();
    return count > 0;
  }
}
