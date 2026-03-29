import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// A custom horizontal progress bar.
///
/// Fills left to right from 0.0 to 1.0. No animation — renders at the given
/// [value] immediately. Use [RLRadius.borderPill] by default so it looks
/// like a smooth pill-shaped track.
class RLProgressBar extends StatelessWidget {
  const RLProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 6,
    this.borderRadius,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  /// Fill fraction — must be between 0.0 and 1.0.
  final double value;

  /// Fill color. Defaults to [AppColors.amber].
  final Color? color;

  /// Track background color. Defaults to [AppColors.bgCard].
  final Color? backgroundColor;

  /// Height of the bar in logical pixels. Defaults to 6.
  final double height;

  /// Corner radius. Defaults to [RLRadius.borderPill].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? RLRadius.borderPill;
    final effectiveBg = backgroundColor ?? AppColors.bgCardHigh;
    final effectiveColor = color ?? AppColors.amber;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = (totalWidth * value.clamp(0.0, 1.0));

        return ClipRRect(
          borderRadius: effectiveRadius,
          child: SizedBox(
            width: totalWidth,
            height: height,
            child: Stack(
              children: [
                // Track
                Container(
                  width: totalWidth,
                  height: height,
                  color: effectiveBg,
                ),
                // Fill
                Container(
                  width: fillWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: effectiveColor,
                    borderRadius: effectiveRadius,
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
