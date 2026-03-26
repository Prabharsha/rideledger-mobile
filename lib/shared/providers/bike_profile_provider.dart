import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bike_profile_model.dart';
import 'repositories_provider.dart';

/// Provider for current bike profile
final bikeProfileProvider =
    FutureProvider<BikeProfileModel?>((ref) async {
  final bikeRepository = ref.watch(bikeRepositoryProvider);
  return await bikeRepository.getBikeProfile();
});

/// Provider for checking if onboarding is complete
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final bikeRepository = ref.watch(bikeRepositoryProvider);
  final profile = await bikeRepository.getBikeProfile();
  return profile != null && !profile.isFirstLaunch;
});
