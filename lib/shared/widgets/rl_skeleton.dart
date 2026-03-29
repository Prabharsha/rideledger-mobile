import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// A single rectangular skeleton placeholder that pulses between
/// [AppColors.bgCard] and [AppColors.bgCardHigh].
///
/// Uses a [TweenAnimationBuilder] with a repeating animation so no external
/// shimmer package is needed.
class RLSkeleton extends StatefulWidget {
  const RLSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;

  /// Corner radius. Defaults to [RLRadius.borderSm].
  final BorderRadius? borderRadius;

  @override
  State<RLSkeleton> createState() => _RLSkeletonState();
}

class _RLSkeletonState extends State<RLSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: AppColors.bgCard,
      end: AppColors.bgCardHigh,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        widget.borderRadius ?? RLRadius.borderSm;

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value ?? AppColors.bgCard,
            borderRadius: effectiveRadius,
          ),
        );
      },
    );
  }
}

/// A pre-built skeleton layout that mirrors the height and structure of
/// [RLRideSummaryCard] — useful as a drop-in loading placeholder.
class RLSkeletonCard extends StatelessWidget {
  const RLSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RLSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: chip + date
          Row(
            children: [
              RLSkeleton(width: 68, height: 20, borderRadius: RLRadius.borderPill),
              const Spacer(),
              RLSkeleton(width: 48, height: 14),
            ],
          ),
          const SizedBox(height: 10),

          // Route row
          Row(
            children: [
              RLSkeleton(width: 52, height: 13),
              const SizedBox(width: RLSpacing.xs),
              RLSkeleton(width: 14, height: 13),
              const SizedBox(width: RLSpacing.xs),
              RLSkeleton(width: 72, height: 13),
            ],
          ),
          const SizedBox(height: RLSpacing.sm),

          // Stats row
          Row(
            children: [
              RLSkeleton(width: 56, height: 15),
              const SizedBox(width: RLSpacing.lg),
              RLSkeleton(width: 40, height: 15),
              const SizedBox(width: RLSpacing.lg),
              RLSkeleton(width: 44, height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
