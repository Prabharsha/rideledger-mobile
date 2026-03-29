import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

/// A section label with an optional trailing text-button action.
///
/// The [title] is rendered ALL CAPS in a muted label style. If [actionLabel]
/// and [onAction] are both provided, a tappable label appears on the right
/// side in amber.
class RLSectionHeader extends StatelessWidget {
  const RLSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  /// Section label text — will be uppercased automatically.
  final String title;

  /// Optional trailing button label (e.g. "See all").
  final String? actionLabel;

  /// Callback for the trailing button. Only shown when this is non-null.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final showAction = actionLabel != null && onAction != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RLSpacing.screenH,
        RLSpacing.lg,  // top 20
        RLSpacing.screenH,
        RLSpacing.sm,  // bottom 8
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: RLText.labelLg.copyWith(
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
          ),
          if (showAction)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: RLSpacing.sm),
                child: Text(
                  actionLabel!,
                  style: RLText.labelLg.copyWith(
                    color: AppColors.amber,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
