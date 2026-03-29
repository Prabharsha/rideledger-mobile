import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/routing/route_paths.dart';

/// Animated splash screen — "Compass Route" concept.
///
/// Animation sequence (~2.8 s total):
///   0.15 s  — hold on dark background
///   0.15–1.75 s — logo reveals: glow → arc draws → needle → route line traces
///   1.35–2.15 s — "RideLedger" slides + fades in, tagline follows
///   2.30–2.75 s — full screen fades out
///   navigate  — goes to [RoutePaths.home]
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // --- Controllers ---
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _exitCtrl;

  // --- Logo animations (driven by _logoCtrl, 0–1600 ms) ---
  late final Animation<double> _glowOpacity;
  late final Animation<double> _arcProgress;
  late final Animation<double> _lineProgress;
  late final Animation<double> _logoOpacity;

  // --- Text animations (driven by _textCtrl, 0–800 ms) ---
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;

  // --- Exit animation (driven by _exitCtrl, 0–450 ms) ---
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // Glow fades in over first 35 % of logo animation
    _glowOpacity = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    // Arc draws from 10 % → 65 %
    _arcProgress = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.10, 0.65, curve: Curves.easeOut),
    );
    // Route line traces from 45 % → 95 %
    _lineProgress = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.45, 0.95, curve: Curves.easeInOut),
    );
    // Entire logo symbol fades in over first 25 %
    _logoOpacity = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    _textOpacity = CurvedAnimation(
      parent: _textCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textCtrl,
      curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
    ));
    _taglineOpacity = CurvedAnimation(
      parent: _textCtrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Brief pause so the background is visible before animation starts
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    _textCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    await _exitCtrl.forward();

    if (mounted) {
      context.go(RoutePaths.home);
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoCtrl, _textCtrl, _exitCtrl]),
      builder: (context, _) {
        return Opacity(
          opacity: _exitFade.value,
          child: Scaffold(
            backgroundColor: AppColors.splashBg,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo mark — drawn entirely in CustomPainter
                  SizedBox(
                    width: 148,
                    height: 156,
                    child: CustomPaint(
                      painter: _LogoPainter(
                        glowIntensity: _glowOpacity.value,
                        arcProgress: _arcProgress.value,
                        lineProgress: _lineProgress.value,
                        opacity: _logoOpacity.value,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App name: "Ride" light + "Ledger" amber bold
                  FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: const _AppNameText(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: const Text(
                      'Every road. Perfectly logged.',
                      style: TextStyle(
                        color: AppColors.splashSubtext,
                        fontSize: 12.5,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// App name typography
// ---------------------------------------------------------------------------

class _AppNameText extends StatelessWidget {
  const _AppNameText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Ride',
            style: TextStyle(
              color: AppColors.splashText,
              fontSize: 34,
              fontWeight: FontWeight.w300,
              letterSpacing: 3.5,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: 'Ledger',
            style: TextStyle(
              color: AppColors.splashAccent,
              fontSize: 34,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logo CustomPainter — "Compass Route" mark
//
// Mark anatomy:
//   • Thin outer ring (very subtle)
//   • Bold amber arc spanning the bottom ~120° (speedometer sweep)
//   • Three evenly-spaced radial tick marks along the arc (odometer feel)
//   • Thin amber needle from center pointing at arc midpoint (6 o'clock)
//   • Small center pivot dot
//   • Route/ledger line descending from ring bottom with slight curve
//   • Three horizontal tick marks along the line (ledger notation)
//   • Destination dot at the line's end
// ---------------------------------------------------------------------------

class _LogoPainter extends CustomPainter {
  final double glowIntensity;
  final double arcProgress;
  final double lineProgress;
  final double opacity;

  const _LogoPainter({
    required this.glowIntensity,
    required this.arcProgress,
    required this.lineProgress,
    required this.opacity,
  });

  // Canvas constants
  static const double _cx = 74;       // Center x in a 148-wide canvas
  static const double _cy = 66;       // Center y (upper portion of 156-tall canvas)
  static const double _ringR = 44.0;  // Outer ring radius

  // Arc: from 4 o'clock (30° from right) to 8 o'clock (150° from right)
  // In Flutter canvas angles (0 = right, clockwise):
  //   4 o'clock  = π/6  (30°)
  //   8 o'clock  = 5π/6 (150°)  → sweep = 2π/3 (120°) clockwise
  static const double _arcStart = math.pi / 6;
  static const double _arcSweep = 2 * math.pi / 3;

  @override
  void paint(Canvas canvas, Size size) {
    // ── Glow ──────────────────────────────────────────────────────────────
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.splashAccent.withValues(alpha: 0.22 * glowIntensity),
            AppColors.splashAccent.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromCircle(
            center: const Offset(_cx, _cy),
            radius: 80,
          ),
        );
      canvas.drawCircle(const Offset(_cx, _cy), 80, glowPaint);
    }

    // ── Outer ring (ghost) ────────────────────────────────────────────────
    canvas.drawCircle(
      const Offset(_cx, _cy),
      _ringR,
      Paint()
        ..color = AppColors.splashText.withValues(alpha: 0.12 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── Speed arc (amber, thick) ──────────────────────────────────────────
    if (arcProgress > 0) {
      final arcPaint = Paint()
        ..color = AppColors.splashAccent.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: const Offset(_cx, _cy), radius: _ringR - 1.5),
        _arcStart,
        _arcSweep * arcProgress,
        false,
        arcPaint,
      );

      // ── Radial tick marks on the arc ─────────────────────────────────
      if (arcProgress > 0.28) {
        final tickAlpha = ((arcProgress - 0.28) / 0.72).clamp(0.0, 1.0);
        final tickPaint = Paint()
          ..color = AppColors.splashText.withValues(alpha: 0.38 * opacity * tickAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..strokeCap = StrokeCap.round;

        for (int i = 1; i <= 3; i++) {
          // Place at 25%, 50%, 75% of total arc sweep
          final tickThreshold = 0.28 + (i / 4.0) * 0.72;
          if (arcProgress < tickThreshold) continue;

          final angle = _arcStart + _arcSweep * (i / 4.0);
          final inner = _ringR - 8.0;
          final outer = _ringR - 15.0;
          canvas.drawLine(
            Offset(_cx + inner * math.cos(angle), _cy + inner * math.sin(angle)),
            Offset(_cx + outer * math.cos(angle), _cy + outer * math.sin(angle)),
            tickPaint,
          );
        }
      }

      // ── Needle ────────────────────────────────────────────────────────
      if (arcProgress > 0.68) {
        final needleAlpha = ((arcProgress - 0.68) / 0.32).clamp(0.0, 1.0);
        // Needle points at arc midpoint (6 o'clock = π/2 = 90°)
        const needleAngle = math.pi / 2;
        const needleLen = _ringR - 16.0;

        canvas.drawLine(
          const Offset(_cx, _cy),
          Offset(
            _cx + needleLen * math.cos(needleAngle),
            _cy + needleLen * math.sin(needleAngle),
          ),
          Paint()
            ..color = AppColors.splashAccent.withValues(alpha: 0.75 * opacity * needleAlpha)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round,
        );

        // Pivot dot
        canvas.drawCircle(
          const Offset(_cx, _cy),
          3.2,
          Paint()
            ..color = AppColors.splashAccent
                .withValues(alpha: 0.90 * opacity * needleAlpha),
        );
      }
    }

    // ── Route / ledger line ───────────────────────────────────────────────
    if (lineProgress > 0) {
      final lineTop = _cy + _ringR + 4.0;
      final lineBot = size.height - 12.0;
      final span = lineBot - lineTop;

      // Slight rightward curve: cubic bezier
      final path = Path()
        ..moveTo(_cx, lineTop)
        ..cubicTo(
          _cx, lineTop + span * 0.22,        // cp1
          _cx - 5, lineTop + span * 0.52,    // cp2
          _cx - 5, lineBot,                  // end
        );

      // Animate path draw using PathMetrics
      final pm = path.computeMetrics().first;
      final drawn = pm.extractPath(0, pm.length * lineProgress);

      canvas.drawPath(
        drawn,
        Paint()
          ..color = AppColors.splashAccent.withValues(alpha: 0.50 * opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );

      // ── Ledger tick marks ─────────────────────────────────────────────
      final ledgerPaint = Paint()
        ..color = AppColors.splashText.withValues(alpha: 0.28 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round;

      // Three ticks at 28%, 55%, 78% of the line
      const tickTs = [0.28, 0.55, 0.78];
      for (final t in tickTs) {
        if (lineProgress < t + 0.06) continue;
        final y = lineTop + span * t;
        // x offset mirrors the bezier drift: -5 * t
        final x = _cx - 5 * t;
        canvas.drawLine(Offset(x - 7, y), Offset(x + 7, y), ledgerPaint);
      }

      // ── Destination dot ───────────────────────────────────────────────
      if (lineProgress > 0.90) {
        final dotAlpha = ((lineProgress - 0.90) / 0.10).clamp(0.0, 1.0);
        canvas.drawCircle(
          Offset(_cx - 5, lineBot),
          3.8,
          Paint()
            ..color = AppColors.splashAccent
                .withValues(alpha: 0.95 * opacity * dotAlpha),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.glowIntensity != glowIntensity ||
      old.arcProgress != arcProgress ||
      old.lineProgress != lineProgress ||
      old.opacity != opacity;
}
