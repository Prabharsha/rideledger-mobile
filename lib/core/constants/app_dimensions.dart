import 'package:flutter/material.dart';

/// RideLedger Design System — Spacing, Radius, and Size Tokens
///
/// All values follow a 4-pt base grid.
/// Screen padding uses asymmetric values for comfortable mobile reading.

// ── Spacing ──────────────────────────────────────────────────────────────────
class RLSpacing {
  RLSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double section = 56;

  /// Standard horizontal screen margin
  static const double screenH = 20;

  /// Standard vertical screen margin (top/bottom of content)
  static const double screenV = 16;

  // Helpers
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapBase = SizedBox(height: base);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl);

  static const SizedBox hGapXs = SizedBox(width: xs);
  static const SizedBox hGapSm = SizedBox(width: sm);
  static const SizedBox hGapMd = SizedBox(width: md);
  static const SizedBox hGapBase = SizedBox(width: base);

  // Edge insets
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: screenV,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(base);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(xl);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

// ── Corner Radii ─────────────────────────────────────────────────────────────
class RLRadius {
  RLRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 100;

  static const Radius rSm = Radius.circular(sm);
  static const Radius rMd = Radius.circular(md);
  static const Radius rLg = Radius.circular(lg);
  static const Radius rXl = Radius.circular(xl);
  static const Radius rXxl = Radius.circular(xxl);
  static const Radius rPill = Radius.circular(pill);

  static const BorderRadius borderSm = BorderRadius.all(rSm);
  static const BorderRadius borderMd = BorderRadius.all(rMd);
  static const BorderRadius borderLg = BorderRadius.all(rLg);
  static const BorderRadius borderXl = BorderRadius.all(rXl);
  static const BorderRadius borderXxl = BorderRadius.all(rXxl);
  static const BorderRadius borderPill = BorderRadius.all(rPill);
}

// ── Sizes ────────────────────────────────────────────────────────────────────
class RLSizes {
  RLSizes._();

  /// Bottom navigation bar height
  static const double bottomNavHeight = 68;

  /// Minimum tappable target
  static const double tapTarget = 44;

  /// Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 28;

  /// Avatar / profile image
  static const double avatar = 40;

  /// Card elevation — expressed as border opacity offset, not Material shadow
  static const double cardBorderWidth = 1;
}
