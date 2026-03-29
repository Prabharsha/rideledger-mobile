import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

// ── RLPrimaryButton ───────────────────────────────────────────────────────────

/// Full-width (or intrinsic-width) elevated button with the amber accent fill.
class RLPrimaryButton extends StatelessWidget {
  const RLPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// When true shows a small [CircularProgressIndicator] instead of the label.
  final bool isLoading;

  /// When true the button stretches to fill available horizontal space.
  final bool fullWidth;

  /// Optional icon shown to the left of the label.
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 50,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          disabledBackgroundColor: AppColors.amberDim,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: RLRadius.borderMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.textInverse),
                ),
              )
            : Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: RLSizes.iconMd),
                    const SizedBox(width: RLSpacing.sm),
                  ],
                  Text(label, style: RLText.btnLg.copyWith(color: AppColors.textInverse)),
                ],
              ),
      ),
    );

    return button;
  }
}

// ── RLSecondaryButton ─────────────────────────────────────────────────────────

/// Card-surface button with amber text and a dim amber border.
class RLSecondaryButton extends StatelessWidget {
  const RLSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bgCard,
          disabledBackgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.amber,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: RLRadius.borderMd,
            side: const BorderSide(color: AppColors.amberDim),
          ),
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.amber),
                ),
              )
            : Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: RLSizes.iconMd),
                    const SizedBox(width: RLSpacing.sm),
                  ],
                  Text(label, style: RLText.btnLg.copyWith(color: AppColors.amber)),
                ],
              ),
      ),
    );
  }
}

// ── RLOutlineButton ───────────────────────────────────────────────────────────

/// Transparent-background button with amber border and amber text.
class RLOutlineButton extends StatelessWidget {
  const RLOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.amber,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.amber),
          shape: RoundedRectangleBorder(
            borderRadius: RLRadius.borderMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.lg),
        ),
        child: Text(
          label,
          style: RLText.btnLg.copyWith(color: AppColors.amber),
        ),
      ),
    );
  }
}

// ── RLIconButton ──────────────────────────────────────────────────────────────

/// Rounded icon-only button. Tappable target is at least 44 px.
class RLIconButton extends StatelessWidget {
  const RLIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconColor,
    this.size = RLSizes.tapTarget,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// Accessible tooltip text.
  final String? tooltip;

  /// Icon tint. Defaults to [AppColors.textSecondary].
  final Color? iconColor;

  /// Overall button size (width & height). Defaults to 44.
  final double size;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? AppColors.textSecondary;

    Widget button = Material(
      color: AppColors.bgCard,
      borderRadius: RLRadius.borderMd,
      child: InkWell(
        onTap: onPressed,
        borderRadius: RLRadius.borderMd,
        splashColor: AppColors.amber.withValues(alpha: 0.08),
        highlightColor: AppColors.amber.withValues(alpha: 0.04),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: RLSizes.iconMd,
            color: effectiveColor,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
