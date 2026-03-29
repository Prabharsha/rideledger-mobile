import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _voiceAlerts = true;
  bool _wakeLock = true;
  bool _metricUnits = true;
  bool _breakInMode = true;

  // ── Helper: section label ─────────────────────────────────────────────────

  Widget _sectionLabel(String s) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Text(
        s,
        style: RLText.labelSm.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Helper: divider ───────────────────────────────────────────────────────

  Widget _divider() {
    return Container(
      height: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.base),
    );
  }

  // ── Helper: settings tile ─────────────────────────────────────────────────

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: RLSpacing.base,
        vertical: RLSpacing.xs,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgCardHigh,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
      title: Text(
        title,
        style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: RLText.labelMd.copyWith(color: AppColors.textMuted),
            ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.textMuted,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            title: Text('Settings', style: RLText.headlineMd),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Bike Profile Card ──────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    padding: const EdgeInsets.all(RLSpacing.base),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.amberSurface,
                          child: const Icon(
                            Icons.motorcycle,
                            size: 24,
                            color: AppColors.amber,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Bike',
                                style: RLText.labelMd.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Yamaha TW200',
                                style: RLText.headlineSm,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '2026 · 513 km',
                                style: RLText.labelMd.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHigh,
                            borderRadius: RLRadius.borderMd,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Text(
                            'Edit',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 2. Ride Settings ──────────────────────────────────────
                  _sectionLabel('RIDE SETTINGS'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          Icons.speed,
                          'Tracking Mode',
                          'GPS accuracy & battery',
                          trailing: Text(
                            'Balanced',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.record_voice_over,
                          'Voice Alerts',
                          'Speed & stage warnings',
                          trailing: Switch(
                            value: _voiceAlerts,
                            onChanged: (v) =>
                                setState(() => _voiceAlerts = v),
                            activeThumbColor: AppColors.amber,
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.timer_outlined,
                          'Keep Screen On',
                          'While riding',
                          trailing: Switch(
                            value: _wakeLock,
                            onChanged: (v) =>
                                setState(() => _wakeLock = v),
                            activeThumbColor: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 3. Display ────────────────────────────────────────────
                  _sectionLabel('DISPLAY'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          Icons.straighten,
                          'Units',
                          'Distance and speed',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'km/h',
                                style: RLText.labelMd.copyWith(
                                  color: AppColors.amber,
                                ),
                              ),
                              const SizedBox(width: RLSpacing.sm),
                              Switch(
                                value: _metricUnits,
                                onChanged: (v) =>
                                    setState(() => _metricUnits = v),
                                activeThumbColor: AppColors.amber,
                              ),
                            ],
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.dark_mode_outlined,
                          'Theme',
                          'Dark mode always active',
                          trailing: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.amberSurface,
                              borderRadius: RLRadius.borderPill,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              'Dark',
                              style: RLText.labelSm.copyWith(
                                color: AppColors.amber,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 4. Break-In ───────────────────────────────────────────
                  _sectionLabel('BREAK-IN'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          Icons.timeline,
                          'Break-In Mode',
                          'Track stage compliance',
                          trailing: Switch(
                            value: _breakInMode,
                            onChanged: (v) =>
                                setState(() => _breakInMode = v),
                            activeThumbColor: AppColors.amber,
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.warning_amber_rounded,
                          'Speed Warnings',
                          'Alert when exceeding stage limit',
                          trailing: Text(
                            'Enabled',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.olive,
                            ),
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.restart_alt,
                          'Reset Progress',
                          'Clear break-in data',
                          trailing: const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 5. Data ───────────────────────────────────────────────
                  _sectionLabel('DATA'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          Icons.storage_outlined,
                          'Storage',
                          'Manage ride data',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '12.4 MB',
                                style: RLText.labelMd.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: RLSpacing.xs),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.notifications_outlined,
                          'Notifications',
                          'Reminders & alerts',
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.cloud_upload_outlined,
                          'Backup & Restore',
                          'Export all data',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: RLSpacing.lg),

                  // ── 6. About ──────────────────────────────────────────────
                  _sectionLabel('ABOUT'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      border: Border.all(color: AppColors.border),
                      borderRadius: RLRadius.borderXl,
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          Icons.info_outline,
                          'About RideLedger',
                          'Version 1.0.0',
                          trailing: const SizedBox.shrink(),
                        ),
                        _divider(),
                        _settingsTile(
                          Icons.bug_report_outlined,
                          'Send Feedback',
                          '',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
