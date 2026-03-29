import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

/// A single row in a vertical service-history timeline.
///
/// The left column renders a dot (and a connecting line below unless [isLast]
/// is true). The right column shows [title], [subtitle], and a right-aligned
/// formatted [date].
class RLTimelineRow extends StatelessWidget {
  const RLTimelineRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isLast = false,
    this.icon,
    this.dotColor,
  });

  final String title;
  final String subtitle;
  final DateTime date;

  /// When true the vertical connector line below the dot is omitted.
  final bool isLast;

  /// Optional icon rendered inside the dot circle.
  final IconData? icon;

  /// Dot fill color. Defaults to [AppColors.amber].
  final Color? dotColor;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _formattedDate =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  @override
  Widget build(BuildContext context) {
    final effectiveDotColor = dotColor ?? AppColors.amber;
    const dotSize = 8.0;
    const lineWidth = 1.0;
    const connectorHeight = 40.0;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? RLSpacing.xs : RLSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline column ──────────────────────────────────────────
          SizedBox(
            width: dotSize + RLSpacing.base,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dot
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: effectiveDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                // Connector line
                if (!isLast)
                  Container(
                    width: lineWidth,
                    height: connectorHeight,
                    color: AppColors.border,
                  ),
              ],
            ),
          ),

          const SizedBox(width: RLSpacing.md),

          // ── Content column ───────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + subtitle
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: RLText.bodySm.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: RLText.labelMd.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: RLSpacing.sm),

                // Date — right-aligned
                Text(
                  _formattedDate,
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
