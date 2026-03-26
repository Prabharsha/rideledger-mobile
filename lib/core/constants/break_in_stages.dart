/// Break-in stages for the TW200 engine rebuild
class BreakInStage {
  final int stageNumber;
  final String name;
  final double startKm;
  final double endKm;
  final double minRecommendedSpeedKmh;
  final double maxRecommendedSpeedKmh;
  final String description;

  const BreakInStage({
    required this.stageNumber,
    required this.name,
    required this.startKm,
    required this.endKm,
    required this.minRecommendedSpeedKmh,
    required this.maxRecommendedSpeedKmh,
    required this.description,
  });

  /// Get stage from total rebuild kilometers
  static BreakInStage getStageFromKm(double totalRebuildKm) {
    if (totalRebuildKm < 200) {
      return stage1;
    } else if (totalRebuildKm < 500) {
      return stage2;
    } else if (totalRebuildKm < 800) {
      return stage3;
    } else if (totalRebuildKm < 1000) {
      return stage4;
    } else {
      return stage5;
    }
  }

  static const stage1 = BreakInStage(
    stageNumber: 1,
    name: 'Engine Settling',
    startKm: 0,
    endKm: 200,
    minRecommendedSpeedKmh: 30,
    maxRecommendedSpeedKmh: 45,
    description:
        'Soft throttle only. Avoid hard acceleration. No long continuous runs. Gentle break-in period.',
  );

  static const stage2 = BreakInStage(
    stageNumber: 2,
    name: 'Initial Conditioning',
    startKm: 200,
    endKm: 500,
    minRecommendedSpeedKmh: 40,
    maxRecommendedSpeedKmh: 55,
    description:
        'Allow mild speed variation. Still avoid hard acceleration. Ring and cylinder conditioning phase.',
  );

  static const stage3 = BreakInStage(
    stageNumber: 3,
    name: 'Progressive Riding',
    startKm: 500,
    endKm: 800,
    minRecommendedSpeedKmh: 40,
    maxRecommendedSpeedKmh: 60,
    description:
        'Longer rides allowed. Still avoid aggressive riding. Bearing and seal settling phase.',
  );

  static const stage4 = BreakInStage(
    stageNumber: 4,
    name: 'Final Conditioning',
    startKm: 800,
    endKm: 1000,
    minRecommendedSpeedKmh: 50,
    maxRecommendedSpeedKmh: 70,
    description:
        'Nearly normal riding. Avoid sustained high speed or hard pulls. Final break-in phase.',
  );

  static const stage5 = BreakInStage(
    stageNumber: 5,
    name: 'Break-in Complete',
    startKm: 1000,
    endKm: double.infinity,
    minRecommendedSpeedKmh: 0,
    maxRecommendedSpeedKmh: 100,
    description:
        'Break-in complete. Switch to normal maintenance mode. Enjoy your rebuilt engine!',
  );

  static const List<BreakInStage> allStages = [
    stage1,
    stage2,
    stage3,
    stage4,
    stage5,
  ];
}
