import 'package:flutter/material.dart';

/// RideLedger Design System — Color Tokens
///
/// Dark-first premium palette built around three accent tracks:
///   • Amber  — active ride / highlight / warning
///   • Olive  — fuel / eco / calm success
///   • Slate  — info / route / map
///
/// All backgrounds use warm-leaning charcoals to avoid harsh blue-black.
/// Text uses warm off-whites instead of pure white for eye comfort.
class AppColors {
  AppColors._();

  // ── Backgrounds ───────────────────────────────────────────────────────────
  /// Deepest app background — outermost layer
  static const bgDeep = Color(0xFF12131A);

  /// Standard scaffold / screen background
  static const bgBase = Color(0xFF191B24);

  /// Card surface — first elevation
  static const bgCard = Color(0xFF20232E);

  /// Elevated card / secondary popover
  static const bgCardHigh = Color(0xFF272B38);

  /// Bottom sheet / modal overlay
  static const bgSheet = Color(0xFF1C1F2A);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Primary text — warm off-white (not pure white)
  static const textPrimary = Color(0xFFEDEAE4);

  /// Secondary text — muted warm grey
  static const textSecondary = Color(0xFF9A9892);

  /// Tertiary / placeholder text
  static const textMuted = Color(0xFF65625F);

  /// Disabled text
  static const textDisabled = Color(0xFF454340);

  /// Text on accent-colored backgrounds
  static const textInverse = Color(0xFF1A1918);

  // ── Amber — active ride / warning / highlight ─────────────────────────────
  static const amber = Color(0xFFC9964A);
  static const amberLight = Color(0xFFDFB070);
  static const amberDim = Color(0xFF7A5A2A);
  static const amberSurface = Color(0xFF21180C);

  // ── Olive — fuel / eco / calm success ────────────────────────────────────
  static const olive = Color(0xFF8F9E62);
  static const oliveLight = Color(0xFFAAB87C);
  static const oliveDim = Color(0xFF4A5430);
  static const oliveSurface = Color(0xFF181F10);

  // ── Slate — info / route / map ────────────────────────────────────────────
  static const slate = Color(0xFF5E81A8);
  static const slateLight = Color(0xFF7A9EC0);
  static const slateDim = Color(0xFF2E4A66);
  static const slateSurface = Color(0xFF101D2A);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const success = Color(0xFF7AAF6A);
  static const successSurface = Color(0xFF141F10);

  static const warning = amber;
  static const warningSurface = amberSurface;

  static const error = Color(0xFFBF5A50);
  static const errorSurface = Color(0xFF271210);

  static const info = slate;
  static const infoSurface = slateSurface;

  // ── Structural ────────────────────────────────────────────────────────────
  /// Subtle card borders
  static const border = Color(0xFF252A38);

  /// Focused / interactive borders
  static const borderFocus = Color(0xFF3A4056);

  /// Section dividers — barely visible
  static const divider = Color(0xFF191C25);

  // ── Splash ────────────────────────────────────────────────────────────────
  static const splashBg = Color(0xFF1A1B1E);
  static const splashAccent = Color(0xFFC9964A);
  static const splashText = Color(0xFFE8E4DC);
  static const splashSubtext = Color(0xFF6E6B66);

  // ── Legacy aliases — preserved for gradual refactor ───────────────────────
  static const primary = Color(0xFF1976D2);
  static const primaryDark = Color(0xFF1565C0);
  static const primaryLight = Color(0xFF42A5F5);
  static const accent = amber;
  static const accentLight = amberLight;
  static const darkBg = bgDeep;
  static const darkSurface = bgCard;
  static const darkSurfaceVariant = bgCardHigh;
  static const lightBg = Color(0xFFF4F2EE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0EDE8);
  static const darkText = Color(0xFF1A1918);
  static const lightText = textPrimary;
  static const mutedText = textSecondary;
  static const gaugeGreen = success;
  static const gaugeYellow = warning;
  static const gaugeRed = error;
  static const gaugeLow = Color(0xFFB0AEA8);
  static const speedNormal = success;
  static const speedWarning = warning;
  static const speedDanger = error;
  static const dashboardBg = bgDeep;
  static const dashboardText = textPrimary;
  static const dashboardAccent = amber;
  static const gradientStart = Color(0xFF1976D2);
  static const gradientEnd = Color(0xFF0D47A1);
}
