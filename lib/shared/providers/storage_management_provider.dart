import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_manager.dart';
import '../../data/models/retention_policy_model.dart';
import '../../data/repositories/retention_repository.dart';
import 'repositories_provider.dart';

// -----------------------------------------------------------------------------
// State
// -----------------------------------------------------------------------------

/// State for the storage management notifier
class StorageManagementState {
  final bool isCleaningUp;
  final CleanupResult? lastResult;
  final String? error;

  const StorageManagementState({
    this.isCleaningUp = false,
    this.lastResult,
    this.error,
  });

  StorageManagementState copyWith({
    bool? isCleaningUp,
    CleanupResult? lastResult,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return StorageManagementState(
      isCleaningUp: isCleaningUp ?? this.isCleaningUp,
      lastResult: clearResult ? null : (lastResult ?? this.lastResult),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// -----------------------------------------------------------------------------
// Providers
// -----------------------------------------------------------------------------

/// Provider for the current retention policy
final retentionPolicyProvider = FutureProvider<RetentionPolicyModel>((ref) async {
  final repository = ref.watch(retentionRepositoryProvider);
  return await repository.getOrCreateDefaultPolicy();
});

/// Provider for the StorageManager instance
final storageManagerProvider = Provider<StorageManager>((ref) {
  return StorageManager();
});

/// Provider for computing current storage usage
final storageUsageProvider = FutureProvider<StorageUsageReport>((ref) async {
  final manager = ref.watch(storageManagerProvider);
  return await manager.calculateStorageUsage();
});

/// StateNotifier that drives cleanup operations and policy updates
final storageManagementProvider =
    StateNotifierProvider<StorageManagementNotifier, StorageManagementState>(
  (ref) => StorageManagementNotifier(ref),
);

// -----------------------------------------------------------------------------
// Notifier
// -----------------------------------------------------------------------------

class StorageManagementNotifier extends StateNotifier<StorageManagementState> {
  final Ref _ref;

  StorageManagementNotifier(this._ref)
      : super(const StorageManagementState());

  StorageManager get _manager => _ref.read(storageManagerProvider);
  RetentionRepository get _repository => _ref.read(retentionRepositoryProvider);

  /// Run cleanup using the current retention policy
  Future<void> runCleanup() async {
    state = state.copyWith(
      isCleaningUp: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final policy = await _repository.getOrCreateDefaultPolicy();
      final result = await _manager.runAutoCleanup(policy);

      // Update policy with last cleanup info
      final updatedPolicy = policy.copyWith(
        lastCleanupDate: DateTime.now(),
        lastCleanupDeletedCount: result.deletedCount,
      );
      await _repository.updateRetentionPolicy(updatedPolicy);

      // Invalidate dependent providers so the UI refreshes
      _ref.invalidate(retentionPolicyProvider);
      _ref.invalidate(storageUsageProvider);

      state = state.copyWith(isCleaningUp: false, lastResult: result);
    } catch (e) {
      state = state.copyWith(isCleaningUp: false, error: e.toString());
    }
  }

  /// Delete specific ride sessions by their IDs
  Future<void> deleteRideSessions(
    List<String> sessionIds, {
    bool routeDataOnly = false,
  }) async {
    state = state.copyWith(
      isCleaningUp: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final deletedCount = await _manager.deleteRideSessionsByIds(
        sessionIds,
        routeDataOnly: routeDataOnly,
      );

      final freedKB = routeDataOnly
          ? deletedCount * 0.1 // rough per-session route estimate
          : deletedCount * 0.5;

      _ref.invalidate(storageUsageProvider);

      state = state.copyWith(
        isCleaningUp: false,
        lastResult: CleanupResult(
          deletedCount: deletedCount,
          freedSpaceEstimateKB: freedKB,
          cutoffDate: DateTime.now(),
          routeDataOnly: routeDataOnly,
        ),
      );
    } catch (e) {
      state = state.copyWith(isCleaningUp: false, error: e.toString());
    }
  }

  /// Delete all route data across every ride session
  Future<void> deleteAllRouteData() async {
    state = state.copyWith(
      isCleaningUp: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final deletedPoints = await _manager.deleteAllRouteData();
      final freedKB = deletedPoints * 0.1;

      _ref.invalidate(storageUsageProvider);

      state = state.copyWith(
        isCleaningUp: false,
        lastResult: CleanupResult(
          deletedCount: deletedPoints,
          freedSpaceEstimateKB: freedKB,
          cutoffDate: DateTime.now(),
          routeDataOnly: true,
        ),
      );
    } catch (e) {
      state = state.copyWith(isCleaningUp: false, error: e.toString());
    }
  }

  /// Update the retention policy and persist the change
  Future<void> updatePolicy(RetentionPolicyModel updatedPolicy) async {
    state = state.copyWith(clearError: true);

    try {
      await _repository.updateRetentionPolicy(updatedPolicy);
      _ref.invalidate(retentionPolicyProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear the last result (e.g. after the user dismisses a SnackBar)
  void clearResult() {
    state = state.copyWith(clearResult: true);
  }

  /// Clear the last error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
