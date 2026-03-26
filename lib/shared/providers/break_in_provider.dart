import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/break_in_stages.dart';
import '../../data/models/bike_profile_model.dart';
import 'bike_profile_provider.dart';
import 'rides_provider.dart';

/// Provider for current break-in stage
final currentBreakInStageProvider =
    FutureProvider<BreakInStage?>((ref) async {
  final profile = await ref.watch(bikeProfileProvider.future);
  if (profile == null) return null;

  final totalRiddenKm = await ref.watch(totalRiddenKmProvider.future);
  final currentKm = profile.rebuildStartOdometerKm + totalRiddenKm;

  return BreakInStage.getStageFromKm(currentKm);
});

/// Provider for break-in progress (e.g., "126/500 km")
final breakInProgressProvider = FutureProvider<BreakInProgress?>((ref) async {
  final profile = await ref.watch(bikeProfileProvider.future);
  if (profile == null) return null;

  final totalRiddenKm = await ref.watch(totalRiddenKmProvider.future);
  final currentKm = profile.rebuildStartOdometerKm + totalRiddenKm;
  final stage = BreakInStage.getStageFromKm(currentKm);

  return BreakInProgress(
    currentKm: currentKm,
    stageStartKm: stage.startKm,
    stageEndKm: stage.endKm,
    stageName: stage.name,
    stageNumber: stage.stageNumber,
    percentComplete:
        ((currentKm - stage.startKm) / (stage.endKm - stage.startKm) * 100)
            .clamp(0, 100),
  );
});

/// Provider for projected km to reach next milestone
final projectToNextMilestoneProvider =
    FutureProvider<ProjectedMilestone?>((ref) async {
  final progress = await ref.watch(breakInProgressProvider.future);
  if (progress == null) return null;

  const milestones = [200.0, 500.0, 800.0, 1000.0];
  final nextMilestone =
      milestones.firstWhere((m) => m > progress.currentKm, orElse: () => 0.0);

  if (nextMilestone == 0) {
    return null; // All milestones reached
  }

  final kmRemaining = nextMilestone - progress.currentKm;

  return ProjectedMilestone(
    milestone: nextMilestone,
    kmRemaining: kmRemaining,
  );
});

/// Data class for break-in progress
class BreakInProgress {
  final double currentKm;
  final double stageStartKm;
  final double stageEndKm;
  final String stageName;
  final int stageNumber;
  final double percentComplete;

  BreakInProgress({
    required this.currentKm,
    required this.stageStartKm,
    required this.stageEndKm,
    required this.stageName,
    required this.stageNumber,
    required this.percentComplete,
  });
}

/// Data class for projected milestone
class ProjectedMilestone {
  final double milestone;
  final double kmRemaining;

  ProjectedMilestone({
    required this.milestone,
    required this.kmRemaining,
  });
}
