import '../models/retention_policy_model.dart';
import '../datasources/local_retention_datasource.dart';

/// Repository for retention policy operations
class RetentionRepository {
  final LocalRetentionDatasource _localDatasource;

  RetentionRepository({required LocalRetentionDatasource localDatasource})
      : _localDatasource = localDatasource;

  /// Get the current retention policy, if one exists
  Future<RetentionPolicyModel?> getRetentionPolicy() async {
    return await _localDatasource.getRetentionPolicy();
  }

  /// Save a new retention policy
  Future<void> saveRetentionPolicy(RetentionPolicyModel policy) async {
    await _localDatasource.saveRetentionPolicy(policy);
  }

  /// Update an existing retention policy
  Future<void> updateRetentionPolicy(RetentionPolicyModel policy) async {
    await _localDatasource.updateRetentionPolicy(policy);
  }

  /// Get the existing retention policy or create and persist a default one
  Future<RetentionPolicyModel> getOrCreateDefaultPolicy() async {
    final existing = await _localDatasource.getRetentionPolicy();
    if (existing != null) return existing;

    final defaultPolicy = RetentionPolicyModel.createDefault();
    await _localDatasource.saveRetentionPolicy(defaultPolicy);

    // Return the persisted version (which now has an Isar-assigned id)
    final saved = await _localDatasource.getRetentionPolicy();
    return saved!;
  }
}
