import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

/// Severity level for [RLWarningBanner].
enum WarningLevel { info, caution, critical }

/// A dismissible inline warning / information banner.
///
/// Renders with a color-coded 4 px left accent bar, background tint, and
/// matching icon. Supply [onDismiss] to show the close (×) button.
class RLWarningBanner extends StatelessWidget {
  const RLWarningBanner({
    super.key,
    required this.message,
    this.level = WarningLevel.caution,
    this.onDismiss,
    this.icon,
  });

  /// The message text to display.
  final String message;

  /// Severity level that controls colors. Defaults to [WarningLevel.caution].
  final WarningLevel level;

  /// Called when the dismiss button is tapped. If null, no button is shown.
  final VoidCallback? onDismiss;

  /// Override the leading icon. Falls back to a sensible default per level.
  final IconData? icon;

  // ── Color resolution ────────────────────────────────────────────────────

  Color get _bgColor {
    switch (level) {
      case WarningLevel.info:
        return AppColors.slateSurface;
      case WarningLevel.caution:
        return AppColors.amberSurface;
      case WarningLevel.critical:
        return AppColors.errorSurface;
    }
  }

  Color get _accentColor {
    switch (level) {
      case WarningLevel.info:
        return AppColors.slate;
      case WarningLevel.caution:
        return AppColors.amber;
      case WarningLevel.critical:
        return AppColors.error;
    }
  }

  IconData get _defaultIcon {
    switch (level) {
      case WarningLevel.info:
        return Icons.info_outline;
      case WarningLevel.caution:
        return Icons.warning_amber_rounded;
      case WarningLevel.critical:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? _defaultIcon;

    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: RLRadius.borderMd,
        border: Border(
          left: BorderSide(color: _accentColor, width: 4),
          top: BorderSide(color: _accentColor.withValues(alpha: 0.25)),
          right: BorderSide(color: _accentColor.withValues(alpha: 0.25)),
          bottom: BorderSide(color: _accentColor.withValues(alpha: 0.25)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RLSpacing.md,
          vertical: RLSpacing.sm + 2, // 10 vertical
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                effectiveIcon,
                size: 20,
                color: _accentColor,
              ),
            ),
            const SizedBox(width: RLSpacing.sm),
            // Message
            Expanded(
              child: Text(
                message,
                style: RLText.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            // Optional dismiss button
            if (onDismiss != null) ...[
              const SizedBox(width: RLSpacing.sm),
              GestureDetector(
                onTap: onDismiss,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
