import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/onboarding_provider.dart';
import '../../../shared/routing/route_paths.dart';

/// Full 4-step onboarding with a premium dark UI.
///
/// Steps:
///   0 — Bike Setup (model, rebuild date, odometer)
///   1 — Break-In Profile (conservative / balanced / aggressive)
///   2 — Fuel Config (weekly quota, economy estimate)
///   3 — Commute Setup (distance, days/week) + Save
class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  Future<void> _complete() async {
    await ref.read(onboardingStateProvider.notifier).complete();
    final state = ref.read(onboardingStateProvider);
    if (state.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }
    if (mounted) context.go(RoutePaths.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress indicator ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  RLSpacing.screenH, RLSpacing.lg, RLSpacing.screenH, 0),
              child: _StepProgressBar(currentStep: _currentPage),
            ),

            // ── Page content ──────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _BikeSetupStep(onNext: _nextPage),
                  _BreakInProfileStep(onNext: _nextPage),
                  _FuelConfigStep(onNext: _nextPage),
                  _CommuteSetupStep(
                    isLoading: onboardingState.isLoading,
                    onComplete: _complete,
                  ),
                ],
              ),
            ),

            // ── Back button area ──────────────────────────────────────────
            if (_currentPage > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    RLSpacing.screenH, 0, RLSpacing.screenH, RLSpacing.lg),
                child: GestureDetector(
                  onTap: _prevPage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Back',
                        style: RLText.labelMd
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(height: RLSpacing.lg),
          ],
        ),
      ),
    );
  }
}

// ── Step progress bar ─────────────────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  final int currentStep;

  const _StepProgressBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final done = i < currentStep;
        final active = i == currentStep;
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
            decoration: BoxDecoration(
              color: done || active ? AppColors.amber : AppColors.bgCardHigh,
              borderRadius: RLRadius.borderPill,
            ),
            child: done
                ? Container(color: AppColors.amber)
                : active
                    ? FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: RLRadius.borderPill,
                          ),
                        ),
                      )
                    : null,
          ),
        );
      }),
    );
  }
}

// ── Step header ───────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: RLRadius.borderLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 26, color: iconColor),
        ),
        const SizedBox(height: RLSpacing.base),
        Text(title, style: RLText.headlineLg),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: RLText.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ── Shared input field ────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hint;
  final String? suffix;

  const _InputField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: RLText.labelMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            hintStyle: RLText.bodyMd.copyWith(color: AppColors.textMuted),
            suffixStyle:
                RLText.labelMd.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.bgCard,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RLSpacing.base,
              vertical: RLSpacing.md,
            ),
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
              borderSide: const BorderSide(color: AppColors.amber, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Primary CTA button ────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: onTap != null && !isLoading
              ? AppColors.amber
              : AppColors.amberDim,
          borderRadius: RLRadius.borderMd,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.textInverse,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Center(
                child: Text(
                  label,
                  style: RLText.btnLg.copyWith(color: AppColors.textInverse),
                ),
              ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 1 — Bike Setup
// ═════════════════════════════════════════════════════════════════════════════

class _BikeSetupStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _BikeSetupStep({required this.onNext});

  @override
  ConsumerState<_BikeSetupStep> createState() => _BikeSetupStepState();
}

class _BikeSetupStepState extends ConsumerState<_BikeSetupStep> {
  late final TextEditingController _modelCtrl;
  late final TextEditingController _vehicleNumberCtrl;
  late final TextEditingController _rebuildOdomCtrl;   // odometer at rebuild
  late final TextEditingController _currentOdomCtrl;   // current odometer
  DateTime _rebuildDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _modelCtrl = TextEditingController(text: 'Yamaha TW200 2017');
    _vehicleNumberCtrl = TextEditingController();
    _rebuildOdomCtrl = TextEditingController(text: '0');
    _currentOdomCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _modelCtrl.dispose();
    _vehicleNumberCtrl.dispose();
    _rebuildOdomCtrl.dispose();
    _currentOdomCtrl.dispose();
    super.dispose();
  }

  double? get _rebuildOdom => double.tryParse(_rebuildOdomCtrl.text);
  double? get _currentOdom => double.tryParse(_currentOdomCtrl.text);

  double get _kmAlreadyDone {
    final r = _rebuildOdom ?? 0;
    final c = _currentOdom ?? 0;
    return (c - r).clamp(0.0, double.infinity);
  }

  bool get _isValid =>
      _modelCtrl.text.trim().isNotEmpty &&
      (_rebuildOdom ?? -1) >= 0 &&
      (_currentOdom ?? -1) >= (_rebuildOdom ?? 0);

  void _continue() {
    if (!_isValid) return;
    ref.read(onboardingStateProvider.notifier).setBikeSetup(
          bikeModel: _modelCtrl.text.trim(),
          vehicleNumber: _vehicleNumberCtrl.text.trim().isEmpty
              ? null
              : _vehicleNumberCtrl.text.trim().toUpperCase(),
          rebuildDate: _rebuildDate,
          rebuildOdometerKm: _rebuildOdom!,
          rebuildStartOdometerKm: _kmAlreadyDone,
        );
    widget.onNext();
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RLSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: RLSpacing.lg),
          const _StepHeader(
            icon: Icons.motorcycle,
            iconColor: AppColors.amber,
            title: 'Your Bike',
            subtitle: 'Tell us about your motorcycle to set up break-in tracking.',
          ),
          const SizedBox(height: RLSpacing.xl),

          _InputField(
            label: 'BIKE MODEL',
            controller: _modelCtrl,
            hint: 'e.g., Yamaha TW200 2017',
          ),

          const SizedBox(height: RLSpacing.lg),

          _InputField(
            label: 'VEHICLE NUMBER (OPTIONAL)',
            controller: _vehicleNumberCtrl,
            hint: 'e.g., KA01AB1234',
          ),

          const SizedBox(height: 6),
          Text(
            'Used for odd/even fuel refill restriction. Leave blank to skip.',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.lg),

          // Rebuild / purchase date
          Text(
            'ENGINE REBUILD / PURCHASE DATE',
            style: RLText.labelMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _rebuildDate,
                firstDate: DateTime(2015),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.amber,
                      onPrimary: AppColors.textInverse,
                      surface: AppColors.bgCard,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => _rebuildDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RLSpacing.base,
                vertical: RLSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(RLRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Text(
                    _formatDate(_rebuildDate),
                    style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: RLSpacing.lg),

          _InputField(
            label: 'ODOMETER READING AT REBUILD',
            controller: _rebuildOdomCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '0',
            suffix: 'km',
          ),

          const SizedBox(height: 6),
          Text(
            'What was the odometer reading when the engine was rebuilt?',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.lg),

          _InputField(
            label: 'CURRENT ODOMETER READING',
            controller: _currentOdomCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '0',
            suffix: 'km',
          ),

          const SizedBox(height: 6),
          // Calculated km already done
          ValueListenableBuilder(
            valueListenable: _currentOdomCtrl,
            builder: (_, __, ___) => ValueListenableBuilder(
              valueListenable: _rebuildOdomCtrl,
              builder: (_, __, ___) {
                final done = _kmAlreadyDone;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RLSpacing.base,
                    vertical: RLSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amberSurface,
                    borderRadius: RLRadius.borderMd,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 16, color: AppColors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Already done since rebuild: ${done.toStringAsFixed(0)} km',
                        style: RLText.labelMd
                            .copyWith(color: AppColors.amber),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: RLSpacing.xl),

          _PrimaryButton(
            label: 'Continue',
            onTap: _isValid ? _continue : null,
          ),

          const SizedBox(height: RLSpacing.xl),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 2 — Break-In Profile
// ═════════════════════════════════════════════════════════════════════════════

class _BreakInProfileStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _BreakInProfileStep({required this.onNext});

  @override
  ConsumerState<_BreakInProfileStep> createState() =>
      _BreakInProfileStepState();
}

class _BreakInProfileStepState extends ConsumerState<_BreakInProfileStep> {
  String _selected = 'balanced';

  static const _profiles = [
    (
      id: 'conservative',
      label: 'Conservative',
      sub: '30–45 km/h first 200 km',
      desc: 'Gentlest on the engine. Best choice if you ride in heavy traffic or want maximum longevity.',
      icon: Icons.shield_outlined,
      color: AppColors.olive,
    ),
    (
      id: 'balanced',
      label: 'Balanced',
      sub: '35–50 km/h first 200 km',
      desc: 'The recommended default. Good protection while still allowing normal city riding.',
      icon: Icons.tune,
      color: AppColors.amber,
    ),
    (
      id: 'aggressive',
      label: 'Aggressive',
      sub: '40–55 km/h first 200 km',
      desc: 'For experienced riders who want a faster break-in. Still safe — just less conservative.',
      icon: Icons.speed,
      color: AppColors.error,
    ),
  ];

  void _continue() {
    ref
        .read(onboardingStateProvider.notifier)
        .setBreakInProfile(profile: _selected);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RLSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: RLSpacing.lg),
          const _StepHeader(
            icon: Icons.timeline,
            iconColor: AppColors.amber,
            title: 'Break-In Style',
            subtitle:
                'Choose how aggressively you want to approach the break-in period.',
          ),
          const SizedBox(height: RLSpacing.xl),

          ..._profiles.map((p) {
            final selected = _selected == p.id;
            return GestureDetector(
              onTap: () => setState(() => _selected = p.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: RLSpacing.md),
                padding: const EdgeInsets.all(RLSpacing.base),
                decoration: BoxDecoration(
                  color: selected ? AppColors.bgCard : AppColors.bgCard,
                  borderRadius: RLRadius.borderLg,
                  border: Border.all(
                    color: selected ? p.color : AppColors.border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected
                            ? p.color.withValues(alpha: 0.15)
                            : AppColors.bgCardHigh,
                        borderRadius: RLRadius.borderMd,
                      ),
                      child: Icon(p.icon, size: 20, color: selected ? p.color : AppColors.textMuted),
                    ),
                    const SizedBox(width: RLSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                p.label,
                                style: RLText.headlineSm.copyWith(
                                  color: selected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              if (p.id == 'balanced')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.amberSurface,
                                    borderRadius: RLRadius.borderPill,
                                  ),
                                  child: Text(
                                    'Recommended',
                                    style: RLText.labelSm.copyWith(
                                      color: AppColors.amber,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.sub,
                            style: RLText.labelMd.copyWith(
                              color: selected ? p.color : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.desc,
                            style: RLText.labelMd.copyWith(
                              color: AppColors.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: RLSpacing.sm),
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 20,
                      color: selected ? p.color : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: RLSpacing.lg),
          _PrimaryButton(label: 'Continue', onTap: _continue),
          const SizedBox(height: RLSpacing.md),
          GestureDetector(
            onTap: () {
              ref
                  .read(onboardingStateProvider.notifier)
                  .setBreakInProfile(profile: 'balanced');
              widget.onNext();
            },
            child: Center(
              child: Text(
                'Skip — use recommended defaults',
                style: RLText.labelMd.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: RLSpacing.xl),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 3 — Fuel Config
// ═════════════════════════════════════════════════════════════════════════════

class _FuelConfigStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _FuelConfigStep({required this.onNext});

  @override
  ConsumerState<_FuelConfigStep> createState() => _FuelConfigStepState();
}

class _FuelConfigStepState extends ConsumerState<_FuelConfigStep> {
  late final TextEditingController _quotaCtrl;
  late final TextEditingController _economyCtrl;
  int _resetWeekday = 1; // 1 = Monday … 7 = Sunday

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _quotaCtrl = TextEditingController(text: '5.0');
    _economyCtrl = TextEditingController(text: '35.0');
  }

  @override
  void dispose() {
    _quotaCtrl.dispose();
    _economyCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      (double.tryParse(_quotaCtrl.text) ?? -1) > 0 &&
      (double.tryParse(_economyCtrl.text) ?? -1) > 0;

  void _continue() {
    if (!_isValid) return;
    final quota = double.parse(_quotaCtrl.text);
    final economy = double.parse(_economyCtrl.text);
    ref.read(onboardingStateProvider.notifier).setFuelConfig(
          weeklyQuota: quota,
          currentBalance: quota,
          currentKmPerL: economy,
          weeklyResetWeekday: _resetWeekday,
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RLSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: RLSpacing.lg),
          const _StepHeader(
            icon: Icons.local_gas_station_outlined,
            iconColor: AppColors.olive,
            title: 'Fuel Tracker',
            subtitle: 'Set up your weekly budget and fuel economy baseline.',
          ),
          const SizedBox(height: RLSpacing.xl),

          _InputField(
            label: 'WEEKLY FUEL QUOTA',
            controller: _quotaCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '5.0',
            suffix: 'L / week',
          ),

          const SizedBox(height: 6),
          Text(
            'How many litres do you want to budget per week?',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.lg),

          _InputField(
            label: 'CURRENT FUEL ECONOMY',
            controller: _economyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '35.0',
            suffix: 'km/L',
          ),

          const SizedBox(height: 6),
          Text(
            'Your best estimate from previous experience or manufacturer spec.',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.lg),

          // Weekly reset day picker
          Text(
            'WEEKLY QUOTA RESET DAY',
            style: RLText.labelMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(7, (i) {
              final day = i + 1;
              final selected = day == _resetWeekday;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _resetWeekday = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: i < 6 ? 5 : 0),
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.amberSurface
                          : AppColors.bgCard,
                      borderRadius: RLRadius.borderMd,
                      border: Border.all(
                        color:
                            selected ? AppColors.amber : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dayLabels[i],
                        style: RLText.labelSm.copyWith(
                          color: selected
                              ? AppColors.amber
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            'Your quota resets every ${_dayLabels[_resetWeekday - 1]}.',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.xl),
          _PrimaryButton(label: 'Continue', onTap: _isValid ? _continue : null),
          const SizedBox(height: RLSpacing.xl),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP 4 — Commute Setup + Complete
// ═════════════════════════════════════════════════════════════════════════════

class _CommuteSetupStep extends ConsumerStatefulWidget {
  final bool isLoading;
  final VoidCallback onComplete;

  const _CommuteSetupStep({
    required this.isLoading,
    required this.onComplete,
  });

  @override
  ConsumerState<_CommuteSetupStep> createState() => _CommuteSetupStepState();
}

class _CommuteSetupStepState extends ConsumerState<_CommuteSetupStep> {
  late final TextEditingController _distanceCtrl;
  int _daysPerWeek = 5;

  @override
  void initState() {
    super.initState();
    _distanceCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _distanceCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      (double.tryParse(_distanceCtrl.text) ?? -1) >= 0;

  void _complete() {
    if (!_isValid) return;
    ref.read(onboardingStateProvider.notifier).setCommuteSetup(
          oneWayDistance: double.parse(_distanceCtrl.text),
          daysPerWeek: _daysPerWeek,
        );
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RLSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: RLSpacing.lg),
          const _StepHeader(
            icon: Icons.work_outline,
            iconColor: AppColors.slate,
            title: 'Daily Commute',
            subtitle: 'Help us calculate your weekly fuel usage and ride patterns.',
          ),
          const SizedBox(height: RLSpacing.xl),

          _InputField(
            label: 'ONE-WAY DISTANCE TO OFFICE',
            controller: _distanceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '0',
            suffix: 'km',
          ),

          const SizedBox(height: 6),
          Text(
            'Enter 0 if you\'re not a regular commuter.',
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.lg),

          Text(
            'COMMUTE DAYS PER WEEK',
            style: RLText.labelMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Day selector
          Row(
            children: List.generate(7, (i) {
              final day = i + 1;
              final selected = day <= _daysPerWeek;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _daysPerWeek = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: i < 6 ? 6 : 0),
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.amberSurface
                          : AppColors.bgCard,
                      borderRadius: RLRadius.borderMd,
                      border: Border.all(
                        color: selected ? AppColors.amber : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: RLText.bodyMd.copyWith(
                          color: selected
                              ? AppColors.amber
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '$_daysPerWeek day${_daysPerWeek > 1 ? 's' : ''} per week',
            style: RLText.labelMd.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: RLSpacing.xl),

          // Summary card
          Container(
            padding: const EdgeInsets.all(RLSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: RLRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALL SET',
                  style: RLText.labelSm.copyWith(
                    color: AppColors.olive,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'RideLedger is ready to track your break-in period, monitor fuel usage, and keep your records.',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: RLSpacing.xl),

          _PrimaryButton(
            label: 'Start Riding',
            onTap: _isValid ? _complete : null,
            isLoading: widget.isLoading,
          ),

          const SizedBox(height: RLSpacing.xl),
        ],
      ),
    );
  }
}
