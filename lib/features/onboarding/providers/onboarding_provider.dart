import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/bike_profile_model.dart';
import '../../../shared/providers/repositories_provider.dart';

/// Onboarding form state
class OnboardingState {
  // Step 1: Bike Setup
  final String? bikeModel;
  final DateTime? rebuildDate;
  final double? rebuildStartOdometerKm;

  // Step 2: Break-In Profile
  final String? breakInProfile; // conservative/balanced/aggressive

  // Step 3: Fuel Config
  final double? weeklyFuelQuotaLiters;
  final double? weeklyFuelBalanceLiters;
  final double? manualFuelEconomyKmPerLiter;
  final double? targetFuelEconomyKmPerLiter;

  // Step 4: Commute Setup
  final double? officeOneWayDistanceKm;
  final int? officeDaysPerWeek;

  // UI State
  final int currentStep; // 0-3
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.bikeModel,
    this.rebuildDate,
    this.rebuildStartOdometerKm,
    this.breakInProfile,
    this.weeklyFuelQuotaLiters,
    this.weeklyFuelBalanceLiters,
    this.manualFuelEconomyKmPerLiter,
    this.targetFuelEconomyKmPerLiter,
    this.officeOneWayDistanceKm,
    this.officeDaysPerWeek,
    this.currentStep = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Copy with updates
  OnboardingState copyWith({
    String? bikeModel,
    DateTime? rebuildDate,
    double? rebuildStartOdometerKm,
    String? breakInProfile,
    double? weeklyFuelQuotaLiters,
    double? weeklyFuelBalanceLiters,
    double? manualFuelEconomyKmPerLiter,
    double? targetFuelEconomyKmPerLiter,
    double? officeOneWayDistanceKm,
    int? officeDaysPerWeek,
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      bikeModel: bikeModel ?? this.bikeModel,
      rebuildDate: rebuildDate ?? this.rebuildDate,
      rebuildStartOdometerKm:
          rebuildStartOdometerKm ?? this.rebuildStartOdometerKm,
      breakInProfile: breakInProfile ?? this.breakInProfile,
      weeklyFuelQuotaLiters:
          weeklyFuelQuotaLiters ?? this.weeklyFuelQuotaLiters,
      weeklyFuelBalanceLiters:
          weeklyFuelBalanceLiters ?? this.weeklyFuelBalanceLiters,
      manualFuelEconomyKmPerLiter:
          manualFuelEconomyKmPerLiter ?? this.manualFuelEconomyKmPerLiter,
      targetFuelEconomyKmPerLiter:
          targetFuelEconomyKmPerLiter ?? this.targetFuelEconomyKmPerLiter,
      officeOneWayDistanceKm:
          officeOneWayDistanceKm ?? this.officeOneWayDistanceKm,
      officeDaysPerWeek: officeDaysPerWeek ?? this.officeDaysPerWeek,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Check if all fields are filled
  bool isComplete() {
    return bikeModel != null &&
        rebuildDate != null &&
        rebuildStartOdometerKm != null &&
        breakInProfile != null &&
        weeklyFuelQuotaLiters != null &&
        weeklyFuelBalanceLiters != null &&
        manualFuelEconomyKmPerLiter != null &&
        targetFuelEconomyKmPerLiter != null &&
        officeOneWayDistanceKm != null &&
        officeDaysPerWeek != null;
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingNotifier({required this.ref}) : super(const OnboardingState());

  /// Step 1: Set bike setup
  void setBikeSetup({
    required String bikeModel,
    required DateTime rebuildDate,
    required double rebuildStartOdometerKm,
  }) {
    state = state.copyWith(
      bikeModel: bikeModel,
      rebuildDate: rebuildDate,
      rebuildStartOdometerKm: rebuildStartOdometerKm,
      currentStep: 1,
    );
  }

  /// Step 2: Set break-in profile
  void setBreakInProfile({required String profile}) {
    state = state.copyWith(
      breakInProfile: profile,
      currentStep: 2,
    );
  }

  /// Step 3: Set fuel config
  void setFuelConfig({
    required double weeklyQuota,
    required double currentBalance,
    required double currentKmPerL,
    required double targetKmPerL,
  }) {
    state = state.copyWith(
      weeklyFuelQuotaLiters: weeklyQuota,
      weeklyFuelBalanceLiters: currentBalance,
      manualFuelEconomyKmPerLiter: currentKmPerL,
      targetFuelEconomyKmPerLiter: targetKmPerL,
      currentStep: 3,
    );
  }

  /// Step 4: Set commute setup
  void setCommuteSetup({
    required double oneWayDistance,
    required int daysPerWeek,
  }) {
    state = state.copyWith(
      officeOneWayDistanceKm: oneWayDistance,
      officeDaysPerWeek: daysPerWeek,
      currentStep: 4,
    );
  }

  /// Save onboarding and create bike profile
  Future<void> complete() async {
    if (!state.isComplete()) {
      state = state.copyWith(errorMessage: 'Please fill in all fields');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final profile = BikeProfileModel()
        ..bikeModel = state.bikeModel!
        ..rebuildDate = state.rebuildDate!
        ..rebuildStartOdometerKm = state.rebuildStartOdometerKm!
        ..firstOilChangeKm = 350
        ..secondOilChangeKm = 1000
        ..breakInProfile = state.breakInProfile!
        ..officeOneWayDistanceKm = state.officeOneWayDistanceKm!
        ..officeDaysPerWeek = state.officeDaysPerWeek!
        ..weeklyFuelQuotaLiters = state.weeklyFuelQuotaLiters!
        ..weeklyFuelBalanceLiters = state.weeklyFuelBalanceLiters!
        ..weeklyResetDate = _getNextMonday()
        ..manualFuelEconomyKmPerLiter = state.manualFuelEconomyKmPerLiter!
        ..targetFuelEconomyKmPerLiter = state.targetFuelEconomyKmPerLiter!
        ..isFirstLaunch = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      final bikeRepository = ref.watch(bikeRepositoryProvider);
      await bikeRepository.saveBikeProfile(profile);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save profile: $e',
      );
    }
  }

  /// Get next Monday for weekly reset
  DateTime _getNextMonday() {
    final now = DateTime.now();
    final daysUntilMonday = (1 - now.weekday) % 7;
    return now.add(Duration(days: daysUntilMonday)).copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
        );
  }

  /// Go to previous step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}

/// Onboarding state provider
final onboardingStateProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref: ref);
});
