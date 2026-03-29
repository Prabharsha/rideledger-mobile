import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// A single metric display: large [value] + small [unit] label beside it,
/// with a tiny [label] description below.
///
/// Use [compact] to shrink the numeric style for tighter spaces (e.g. inside
/// a multi-stat row).
class RLStatBlock extends StatelessWidget {
  const RLStatBlock({
    super.key,
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
    this.compact = false,
  });

  /// The main numeric or text value to display prominently.
  final String value;

  /// Short unit string shown beside the value (e.g. "km", "L", "km/h").
  final String unit;

  /// Descriptive label shown below the value+unit row.
  final String label;

  /// Override color for the value text. Defaults to [AppColors.textPrimary].
  final Color? valueColor;

  /// When true, uses [RLText.numSm] instead of [RLText.numLg] for the value.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectiveValueColor = valueColor ?? AppColors.textPrimary;

    final valueStyle = compact
        ? RLText.numSm.copyWith(color: effectiveValueColor)
        : RLText.numLg.copyWith(color: effectiveValueColor);

    final unitStyle = RLText.labelMd.copyWith(color: AppColors.textMuted);
    final labelStyle = RLText.labelMd.copyWith(color: AppColors.textMuted);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Value + Unit row
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: valueStyle),
            const SizedBox(width: 3),
            Text(unit, style: unitStyle),
          ],
        ),
        const SizedBox(height: 2),
        // Description label
        Text(label, style: labelStyle),
      ],
    );
  }
}
