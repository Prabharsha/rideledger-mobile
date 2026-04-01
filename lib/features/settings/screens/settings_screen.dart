import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/bike_profile_model.dart';
import '../../../shared/providers/app_settings_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/providers/repositories_provider.dart';
import '../../../shared/providers/rides_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _supportedCurrencies = ['LKR', 'USD', 'INR', 'EUR', 'GBP'];

  // These are initialised from the loaded profile in build()
  bool _voiceAlerts = true;
  bool _wakeLock = true;
  bool _metricUnits = true;
  bool _breakInMode = true;
  bool _speedWarnings = true;
  bool _profileLoaded = false;

  // Odometer calibration
  final _odometerCtrl = TextEditingController();

  @override
  void dispose() {
    _odometerCtrl.dispose();
    super.dispose();
  }

  void _showCurrencyPicker(String selectedCurrency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Currency', style: RLText.headlineSm),
              const SizedBox(height: 12),
              ..._supportedCurrencies.map(
                (currency) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(currency, style: RLText.bodyMd),
                  trailing: currency == selectedCurrency
                      ? const Icon(Icons.check, color: AppColors.amber)
                      : null,
                  onTap: () async {
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setCurrencyCode(currency);
                    if (mounted) Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Save a single field to the bike profile ───────────────────────────────

  Future<void> _saveProfile(
      BikeProfileModel profile, BikeProfileModel updated) async {
    await ref.read(bikeRepositoryProvider).saveBikeProfile(updated);
    ref.invalidate(bikeProfileProvider);
  }

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

  Widget _divider() {
    return Container(
      height: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.base),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
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

  void _showOdometerCalibration(BikeProfileModel profile, double currentOdom) {
    _odometerCtrl.text = currentOdom.toStringAsFixed(1);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calibrate Odometer', style: RLText.headlineSm),
            const SizedBox(height: 6),
            Text(
              'Set the current odometer reading to match your physical meter.',
              style: RLText.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _odometerCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Odometer (km)',
                labelStyle:
                    RLText.labelMd.copyWith(color: AppColors.textSecondary),
                suffixText: 'km',
                filled: true,
                fillColor: AppColors.bgCardHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(RLRadius.lg),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(RLRadius.lg),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(RLRadius.lg),
                  borderSide:
                      const BorderSide(color: AppColors.amber, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RLRadius.lg),
                  ),
                ),
                onPressed: () async {
                  final val = double.tryParse(_odometerCtrl.text);
                  if (val == null || val < 0) return;
                  // Adjust rebuildOdometerKm so the displayed odometer
                  // equals val when appTrackedKm = totalRiddenKm.
                  final ridden = await ref.read(totalRiddenKmProvider.future);
                  // new rebuildOdometerKm = val - rebuildStartOdometerKm - ridden
                  final newRebuildOdom =
                      val - profile.rebuildStartOdometerKm - ridden;
                  final updated = profile.copyWith(
                    rebuildOdometerKm: newRebuildOdom.clamp(0, double.infinity),
                  );
                  await _saveProfile(profile, updated);
                  if (mounted) Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: RLText.btnLg.copyWith(color: AppColors.textInverse),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(bikeProfileProvider);
    final riddenAsync = ref.watch(totalRiddenKmProvider);
    final appSettingsAsync = ref.watch(appSettingsProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(child: CircularProgressIndicator(color: AppColors.amber)),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(child: Text('Error loading settings')),
      ),
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            backgroundColor: AppColors.bgBase,
            body: Center(child: Text('No profile found')),
          );
        }

        // Sync toggle state from profile on first load
        if (!_profileLoaded) {
          _profileLoaded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _breakInMode = profile.breakInModeEnabled;
              });
            }
          });
        }

        final ridden = riddenAsync.valueOrNull ?? 0.0;
        final currentOdom = profile.currentOdometerKm(appTrackedKm: ridden);

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
                      // ── 1. Bike Profile Card ────────────────────────────────
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
                                  Text(
                                    profile.bikeModel,
                                    style: RLText.headlineSm,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${currentOdom.toStringAsFixed(0)} km',
                                    style: RLText.labelMd.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 2. Ride Settings ────────────────────────────────────
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
                                onChanged: (v) => setState(() => _wakeLock = v),
                                activeThumbColor: AppColors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 3. Display ──────────────────────────────────────────
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
                              Icons.attach_money,
                              'Currency',
                              'Used in fuel price and totals',
                              trailing: Text(
                                appSettingsAsync.valueOrNull?.currencyCode ??
                                    'LKR',
                                style: RLText.labelMd
                                    .copyWith(color: AppColors.amber),
                              ),
                              onTap: () => _showCurrencyPicker(
                                appSettingsAsync.valueOrNull?.currencyCode ??
                                    'LKR',
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
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  'Dark',
                                  style: RLText.labelSm
                                      .copyWith(color: AppColors.amber),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 4. Break-In ─────────────────────────────────────────
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
                                onChanged: (v) async {
                                  setState(() => _breakInMode = v);
                                  final updated = profile.copyWith(
                                    isBreakInEnabled: v,
                                  );
                                  await _saveProfile(profile, updated);
                                },
                                activeThumbColor: AppColors.amber,
                              ),
                            ),
                            _divider(),
                            _settingsTile(
                              Icons.warning_amber_rounded,
                              'Speed Warnings',
                              'Alert when exceeding stage limit',
                              trailing: Switch(
                                value: _speedWarnings,
                                onChanged: (v) =>
                                    setState(() => _speedWarnings = v),
                                activeThumbColor: AppColors.amber,
                              ),
                            ),
                            _divider(),
                            _settingsTile(
                              Icons.restart_alt,
                              'Reset Break-In Progress',
                              'Clear break-in data',
                              onTap: () => _confirmReset(profile),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 5. Odometer ─────────────────────────────────────────
                      _sectionLabel('ODOMETER'),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          border: Border.all(color: AppColors.border),
                          borderRadius: RLRadius.borderXl,
                        ),
                        child: _settingsTile(
                          Icons.speed,
                          'Calibrate Odometer',
                          'Current: ${currentOdom.toStringAsFixed(0)} km',
                          trailing: Text(
                            'Edit',
                            style:
                                RLText.labelMd.copyWith(color: AppColors.amber),
                          ),
                          onTap: () =>
                              _showOdometerCalibration(profile, currentOdom),
                        ),
                      ),

                      const SizedBox(height: RLSpacing.lg),

                      // ── 6. Data ─────────────────────────────────────────────
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
                                    '—',
                                    style: RLText.labelMd
                                        .copyWith(color: AppColors.textMuted),
                                  ),
                                  const SizedBox(width: RLSpacing.xs),
                                  const Icon(Icons.chevron_right,
                                      size: 18, color: AppColors.textMuted),
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

                      // ── 7. About ────────────────────────────────────────────
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
      },
    );
  }

  void _confirmReset(BikeProfileModel profile) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: Text('Reset Break-In?', style: RLText.headlineSm),
        content: Text(
          'This will set the km-since-rebuild counter to zero. Your ride history will not be deleted.',
          style: RLText.bodySm.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: RLText.labelMd.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              final updated = profile.copyWith(rebuildStartOdometerKm: 0);
              await _saveProfile(profile, updated);
              if (mounted) Navigator.pop(context);
            },
            child: Text('Reset',
                style: RLText.labelMd.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
