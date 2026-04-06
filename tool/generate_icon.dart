// tool/generate_icon.dart
//
// Generates a premium speedometer-style app icon for RideLedger.
//
// Usage:
//   dart pub get
//   dart run tool/generate_icon.dart
//
// Produces:
//   assets/icon/app_icon.png          — full 1024×1024 icon (iOS + Android legacy)
//   assets/icon/app_icon_foreground.png — foreground layer for Android adaptive icon

import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  _generate(
    outPath: 'assets/icon/app_icon.png',
    transparent: false,
  );
  _generate(
    outPath: 'assets/icon/app_icon_foreground.png',
    transparent: true,
  );
  print('✓  App icons written to assets/icon/');
  print('   Run: dart run flutter_launcher_icons');
}

void _generate({required String outPath, required bool transparent}) {
  const size = 1024;
  const cx = size / 2.0;
  const cy = size / 2.0;

  final canvas = img.Image(width: size, height: size);

  // ── Palette ──────────────────────────────────────────────────────────────
  final bg       = img.ColorRgba8(14,  15,  20,  transparent ? 0   : 255);
  final bgCard   = img.ColorRgba8(22,  25,  35,  transparent ? 0   : 255);
  final amber    = img.ColorRgba8(201, 150, 74,  255);
  final amberHi  = img.ColorRgba8(230, 190, 110, 255);
  final olive    = img.ColorRgba8(143, 158, 98,  255);
  final orange   = img.ColorRgba8(204, 107, 42,  255);
  final red      = img.ColorRgba8(191, 90,  80,  255);

  // ── 1. Background ─────────────────────────────────────────────────────────
  if (!transparent) {
    _fillCircle(canvas, cx, cy, size / 2.0, bg);
    _fillCircle(canvas, cx, cy, 492.0, bgCard);
  }

  // ── 2. Speedometer arc  ───────────────────────────────────────────────────
  // 270° sweep from 135° (lower-left / 7-o'clock) clockwise to 405° (lower-right / 5-o'clock)
  // going through 270° (12-o'clock / top).
  const startDeg = 135.0;
  const sweepDeg = 270.0;
  const arcOuter = 450.0;
  const arcInner = 388.0;

  for (double deg = startDeg; deg <= startDeg + sweepDeg; deg += 0.10) {
    final frac  = (deg - startDeg) / sweepDeg;
    final color = frac < 0.30 ? olive
                : frac < 0.63 ? amber
                : frac < 0.82 ? orange
                              : red;
    final rad = deg * pi / 180;
    for (double r = arcInner; r <= arcOuter; r++) {
      final xi = (cx + r * cos(rad)).round();
      final yi = (cy + r * sin(rad)).round();
      if (xi >= 0 && xi < size && yi >= 0 && yi < size) {
        canvas.setPixel(xi, yi, color);
      }
    }
  }

  // ── 3. Tick marks ─────────────────────────────────────────────────────────
  // 11 ticks (major every 2nd) cut dark gaps through the arc.
  for (int i = 0; i <= 10; i++) {
    final frac   = i / 10.0;
    final deg    = startDeg + frac * sweepDeg;
    final rad    = deg * pi / 180;
    final isMaj  = i % 2 == 0;
    final tickIn = isMaj ? arcInner - 32.0 : arcInner - 14.0;
    img.drawLine(
      canvas,
      x1: (cx + tickIn   * cos(rad)).round(),
      y1: (cy + tickIn   * sin(rad)).round(),
      x2: (cx + arcOuter * cos(rad)).round(),
      y2: (cy + arcOuter * sin(rad)).round(),
      color: transparent ? img.ColorRgba8(0, 0, 0, 0) : bg,
      thickness: isMaj ? 6 : 4,
      antialias: true,
    );
  }

  // ── 4. Dark inner disc ────────────────────────────────────────────────────
  _fillCircle(canvas, cx, cy, 366.0, transparent ? img.ColorRgba8(0,0,0,0) : bgCard);

  // ── 5. Amber accent ring (partial, matching the arc sweep) ────────────────
  for (double deg = startDeg; deg <= startDeg + sweepDeg; deg += 0.18) {
    final rad = deg * pi / 180;
    for (double r = 314.0; r <= 325.0; r++) {
      final xi = (cx + r * cos(rad)).round();
      final yi = (cy + r * sin(rad)).round();
      if (xi >= 0 && xi < size && yi >= 0 && yi < size) {
        canvas.setPixel(xi, yi, amber);
      }
    }
  }

  // ── 6. Inner dark fill ────────────────────────────────────────────────────
  _fillCircle(canvas, cx, cy, 300.0, transparent ? img.ColorRgba8(0,0,0,0) : bg);

  // ── 7. Needle (pointing at ~62% of arc — amber/orange boundary) ───────────
  const needleFrac = 0.62;
  final needleDeg = startDeg + needleFrac * sweepDeg;
  final needleRad = needleDeg * pi / 180;

  // Tail (short, behind centre)
  final tx = cx - 50 * cos(needleRad);
  final ty = cy - 50 * sin(needleRad);
  // Tip
  final nx = cx + 268 * cos(needleRad);
  final ny = cy + 268 * sin(needleRad);

  img.drawLine(canvas,
    x1: tx.round(), y1: ty.round(),
    x2: nx.round(), y2: ny.round(),
    color: amberHi, thickness: 9, antialias: true);

  // ── 8. Centre hub ─────────────────────────────────────────────────────────
  _fillCircle(canvas, cx, cy, 44.0, amber);
  _fillCircle(canvas, cx, cy, 28.0, transparent ? img.ColorRgba8(0,0,0,0) : bg);
  _fillCircle(canvas, cx, cy, 12.0, amberHi);

  // ── Save ──────────────────────────────────────────────────────────────────
  Directory('assets/icon').createSync(recursive: true);
  File(outPath).writeAsBytesSync(img.encodePng(canvas));
  print('   → $outPath');
}

/// Fills a solid anti-aliased circle on [canvas].
void _fillCircle(
    img.Image canvas, double cx, double cy, double radius, img.Color color) {
  final r  = radius.ceil();
  final r2 = radius * radius;
  final x0 = (cx - r).floor().clamp(0, canvas.width - 1);
  final x1 = (cx + r).ceil().clamp(0, canvas.width - 1);
  final y0 = (cy - r).floor().clamp(0, canvas.height - 1);
  final y1 = (cy + r).ceil().clamp(0, canvas.height - 1);

  for (var y = y0; y <= y1; y++) {
    for (var x = x0; x <= x1; x++) {
      final dx = x - cx, dy = y - cy;
      if (dx * dx + dy * dy <= r2) {
        canvas.setPixel(x, y, color);
      }
    }
  }
}
