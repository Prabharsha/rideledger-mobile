import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import 'rl_card.dart';
import 'rl_section_header.dart';

/// A single settings list tile with a rounded icon container on the left,
/// title + optional subtitle, and a configurable trailing widget.
///
/// When [onTap] is provided and [trailing] is null, a [Icons.chevron_right]
/// arrow is shown automatically.
class RLSettingsTile extends StatelessWidget {
  const RLSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Custom trailing widget. Defaults to a chevron when [onTap] is set.
  final Widget? trailing;

  final VoidCallback? onTap;

  /// Tint for the leading icon. Defaults to [AppColors.textSecondary].
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.textSecondary;

    Widget? effectiveTrailing = trailing;
    if (effectiveTrailing == null && onTap != null) {
      effectiveTrailing = const Icon(
        Icons.chevron_right,
        size: RLSizes.iconMd,
        color: AppColors.textMuted,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: RLRadius.borderLg,
        splashColor: AppColors.amber.withValues(alpha: 0.05),
        highlightColor: AppColors.amber.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: RLSpacing.base,
            vertical: RLSpacing.md,
          ),
          child: Row(
            children: [
              // ── Icon container ───────────────────────────────────────
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bgCardHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: RLSizes.iconMd,
                  color: effectiveIconColor,
                ),
              ),

              const SizedBox(width: RLSpacing.md),

              // ── Title + subtitle ─────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: RLText.bodyMd.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: RLText.labelMd.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Trailing ─────────────────────────────────────────────
              if (effectiveTrailing != null) ...[
                const SizedBox(width: RLSpacing.sm),
                effectiveTrailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A labelled group of [RLSettingsTile]s wrapped in a card container.
class RLSettingsSection extends StatelessWidget {
  const RLSettingsSection({
    super.key,
    required this.title,
    required this.tiles,
  });

  /// Section heading text.
  final String title;

  /// The tiles to display inside the card.
  final List<RLSettingsTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RLSectionHeader(title: title),
        RLCard(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                tiles[i],
                if (i < tiles.length - 1)
                  const Divider(
                    color: AppColors.divider,
                    height: 1,
                    thickness: 1,
                    indent: RLSpacing.base + 36 + RLSpacing.md,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
