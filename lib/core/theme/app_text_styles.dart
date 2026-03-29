import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// RideLedger Design System — Typography Scale
///
/// Uses system fonts (SF Pro on iOS, Roboto on Android).
/// Numeric display styles use tabular figures for aligned stats.
/// Line heights are tuned for dark-background reading comfort.
class RLText {
  RLText._();

  // ── Display — large hero numbers (speed, big stats) ───────────────────────
  static const displayXl = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w200,
    color: AppColors.textPrimary,
    letterSpacing: -3,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const displayLg = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w200,
    color: AppColors.textPrimary,
    letterSpacing: -2,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const displayMd = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const displaySm = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ── Headline ──────────────────────────────────────────────────────────────
  static const headlineLg = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const headlineMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const headlineSm = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Body ─────────────────────────────────────────────────────────────────
  static const bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.55,
  );

  static const bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const bodySm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  // ── Label — caps/tags/units/metadata ─────────────────────────────────────
  static const labelLg = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
    height: 1.3,
  );

  static const labelMd = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.6,
    height: 1.3,
  );

  static const labelSm = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 1.0,
    height: 1.2,
  );

  // ── Numeric / monospace stats ─────────────────────────────────────────────
  static const numLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const numMd = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const numSm = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ── Button labels ─────────────────────────────────────────────────────────
  static const btnLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.0,
  );

  static const btnMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.0,
  );

  static const btnSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.0,
  );
}
