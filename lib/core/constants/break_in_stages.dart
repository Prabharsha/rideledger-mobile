/// Break-in stages for the TW200 engine rebuild.
///
/// Boundaries and guidance are aligned with the Yamaha TW200 rebuild break-in
/// plan (PDF: tw200_break_in_plan_with_gears_5665.pdf, Section 3).
/// All km values are distance-since-rebuild (not odometer).
class BreakInStage {
  final int stageNumber;
  final String name;
  final double startKm;
  final double endKm;
  final String description;

  // Practical speed window for this stage (km/h).
  // Derived from the stage's RPM ceiling applied across the main cruising
  // gears (3rd–5th) using stock TW200 gear/tire ratios.
  final double minRecommendedSpeedKmh;
  final double maxRecommendedSpeedKmh;

  const BreakInStage({
    required this.stageNumber,
    required this.name,
    required this.startKm,
    required this.endKm,
    required this.description,
    required this.minRecommendedSpeedKmh,
    required this.maxRecommendedSpeedKmh,
  });

  /// Returns the correct stage for [kmSinceRebuild].
  static BreakInStage getStageFromKm(double kmSinceRebuild) {
    if (kmSinceRebuild < 300) return stage1;
    if (kmSinceRebuild < 1000) return stage2;
    if (kmSinceRebuild < 2000) return stage3;
    if (kmSinceRebuild < 2500) return stage4;
    return stage5;
  }

  // ── Stage definitions ───────────────────────────────────────────────────

  /// 0–300 km after rebuild.
  /// Preferred RPM: ~2500–4000. Throttle: max 1/3.
  static const stage1 = BreakInStage(
    stageNumber: 1,
    name: 'Engine Settling',
    startKm: 0,
    endKm: 300,
    minRecommendedSpeedKmh: 20,
    maxRecommendedSpeedKmh: 40,
    description:
        'Mostly 2nd–4th gear. Avoid above 1/3 throttle. After each hour, '
        'stop and let the engine cool 5–10 min. Vary speed; do not hold one '
        'throttle opening.',
  );

  /// 300–1000 km after rebuild.
  /// Preferred RPM: ~3000–5000. Throttle: max 1/2, no full-throttle pulls.
  static const stage2 = BreakInStage(
    stageNumber: 2,
    name: 'Initial Conditioning',
    startKm: 300,
    endKm: 1000,
    minRecommendedSpeedKmh: 25,
    maxRecommendedSpeedKmh: 55,
    description:
        'Use 2nd–5th gears, but do not lug the engine in 5th. Increase ride '
        'length gradually. No full-throttle pulls.',
  );

  /// 1000–2000 km after rebuild.
  /// Preferred RPM: ~3000–6000.
  static const stage3 = BreakInStage(
    stageNumber: 3,
    name: 'Progressive Riding',
    startKm: 1000,
    endKm: 2000,
    minRecommendedSpeedKmh: 30,
    maxRecommendedSpeedKmh: 65,
    description:
        'Normal traffic use becomes safer. All gears allowed. Still vary speed '
        'and avoid long sustained high-RPM cruising.',
  );

  /// 2000–2500 km after rebuild.
  /// Preferred RPM: ~3500–6500.
  static const stage4 = BreakInStage(
    stageNumber: 4,
    name: 'Final Conditioning',
    startKm: 2000,
    endKm: 2500,
    minRecommendedSpeedKmh: 35,
    maxRecommendedSpeedKmh: 75,
    description:
        'Near-normal riding. Short bursts of stronger acceleration acceptable '
        'once fully warm, but avoid prolonged full throttle or overheating.',
  );

  /// 2500+ km after rebuild — break-in complete.
  static const stage5 = BreakInStage(
    stageNumber: 5,
    name: 'Break-In Complete',
    startKm: 2500,
    endKm: double.infinity,
    minRecommendedSpeedKmh: 0,
    maxRecommendedSpeedKmh: 100,
    description:
        'Break-in complete. Normal riding allowed. Continue regular oil '
        'changes and maintenance.',
  );

  static const List<BreakInStage> allStages = [
    stage1,
    stage2,
    stage3,
    stage4,
    stage5,
  ];
}
