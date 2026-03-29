import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_buttons.dart';

/// Empty state display for screens with no data.
///
/// Renders a centred column with a large icon, title, optional subtitle, and
/// an optional primary action button.
class RLEmptyState extends StatelessWidget {
  const RLEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  /// Icon to display at the top (48 px, [AppColors.textDisabled]).
  final IconData icon;

  /// Primary heading text.
  final String title;

  /// Optional supporting text below the title.
  final String? subtitle;

  /// Label for the optional action button.
  final String? actionLabel;

  /// Callback for the action button. Button is only shown when both
  /// [actionLabel] and [onAction] are non-null.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final showButton = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: RLSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.textDisabled,
            ),

            const SizedBox(height: RLSpacing.base),

            Text(
              title,
              style: RLText.headlineSm.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: RLSpacing.sm),
              Text(
                subtitle!,
                style: RLText.bodyMd.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],

            if (showButton) ...[
              const SizedBox(height: RLSpacing.xl),
              RLPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
