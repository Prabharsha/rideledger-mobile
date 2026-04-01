import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/routing/route_paths.dart';

/// Splash screen — clean text-only animation.
///
/// Sequence (~2.4 s total):
///   0.0 s  — progress bar starts
///   0.3 s  — app name fades + slides in
///   0.9 s  — tagline fades in, onboarding check fires
///   2.0 s  — exit fade → navigate
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  // ── Text ─────────────────────────────────────────────────────────────────
  late final AnimationController _textCtrl;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;

  // ── Progress bar ─────────────────────────────────────────────────────────
  late final AnimationController _progressCtrl;

  // ── Exit fade ─────────────────────────────────────────────────────────────
  late final AnimationController _exitCtrl;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200));
    _exitCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));

    _textOpacity = CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOutCubic)));
    _taglineOpacity = CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.50, 1.0, curve: Curves.easeOut));

    _exitFade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));

    _runSequence();
  }

  Future<void> _runSequence() async {
    _progressCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _textCtrl.forward();

    // Check onboarding while text is animating
    final onboardingFuture = ref
        .read(onboardingCompleteProvider.future)
        .catchError((_) => false);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    final onboardingDone = await onboardingFuture;

    await _exitCtrl.forward();
    if (mounted) {
      context.go(onboardingDone ? RoutePaths.home : RoutePaths.onboarding);
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _progressCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_textCtrl, _progressCtrl, _exitCtrl]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _exitFade,
          child: Scaffold(
            backgroundColor: const Color(0xFF0C0D10),
            body: Stack(
              children: [
                // ── Centred app name + tagline ──────────────────────────────
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App name
                      FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textSlide,
                          child: const _AppNameText(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Tagline
                      FadeTransition(
                        opacity: _taglineOpacity,
                        child: const Text(
                          'Every road. Perfectly logged.',
                          style: TextStyle(
                            color: Color(0xFF6E6B66),
                            fontSize: 12.5,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Loading progress bar ────────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _progressCtrl.value,
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(
                        AppColors.amber,
                        AppColors.olive,
                        _progressCtrl.value,
                      )!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── App name typography ───────────────────────────────────────────────────────

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
              color: Color(0xFFE8E4DC),
              fontSize: 38,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: 'Ledger',
            style: TextStyle(
              color: Color(0xFFE5B060),
              fontSize: 38,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
