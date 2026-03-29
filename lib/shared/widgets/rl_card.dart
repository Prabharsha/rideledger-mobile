import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Base card widget for the RideLedger design system.
///
/// Uses only border + background color to create elevation — no Material
/// drop shadows. When [onTap] is provided the card responds with an amber
/// ink splash via [InkWell].
class RLCard extends StatelessWidget {
  const RLCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
  });

  final Widget child;

  /// Inner padding. Defaults to [EdgeInsets.all(16)].
  final EdgeInsetsGeometry? padding;

  /// Card surface color. Defaults to [AppColors.bgCard].
  final Color? color;

  /// If provided, wraps the card in an [InkWell] with amber splash.
  final VoidCallback? onTap;

  /// Corner radius. Defaults to [RLRadius.borderLg].
  final BorderRadius? borderRadius;

  /// Border width. Defaults to [RLSizes.cardBorderWidth] (1 px).
  final double? borderWidth;

  /// Border color. Defaults to [AppColors.border].
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? RLRadius.borderLg;
    final effectiveColor = color ?? AppColors.bgCard;
    final effectivePadding = padding ?? const EdgeInsets.all(RLSpacing.base);
    final effectiveBorderWidth = borderWidth ?? RLSizes.cardBorderWidth;
    final effectiveBorderColor = borderColor ?? AppColors.border;

    final card = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
      ),
      child: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );

    if (onTap == null) return card;

    // Wrap in InkWell for tappable ripple.
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: effectiveRadius,
          border: Border.all(
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          splashColor: AppColors.amber.withValues(alpha: 0.06),
          highlightColor: AppColors.amber.withValues(alpha: 0.04),
          child: Padding(
            padding: effectivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
