import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/fuel_log_model.dart';
import '../../../shared/providers/app_settings_provider.dart';
import '../../../shared/providers/fuel_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/providers/repositories_provider.dart';

class FuelDashboardScreen extends ConsumerWidget {
  const FuelDashboardScreen({super.key});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  String _weekRange(DateTime resetDate) {
    // resetDate is the next occurrence of the reset weekday — go back 7 days for the start
    final start = resetDate.subtract(const Duration(days: 7));
    final end = resetDate.subtract(const Duration(days: 1));
    return '${_months[start.month - 1]} ${start.day} – ${_months[end.month - 1]} ${end.day}';
  }

  void _showAddRefuelSheet(BuildContext context, WidgetRef ref,
      {double? lastOdometer, required String pricePerLiterUnit}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddRefuelSheet(
        lastOdometer: lastOdometer,
        pricePerLiterUnit: pricePerLiterUnit,
      ),
    ).then((_) {
      ref.invalidate(allFuelLogsProvider);
      ref.invalidate(weeklyFuelLogsProvider);
      ref.invalidate(weeklyFuelUsedProvider);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(bikeProfileProvider);
    final weeklyUsedAsync = ref.watch(weeklyFuelUsedProvider);
    final allLogsAsync = ref.watch(allFuelLogsProvider);
    final appSettings = ref.watch(appSettingsProvider).valueOrNull ??
        const AppSettingsState(currencyCode: 'LKR');
    final currencySymbol = appSettings.currencySymbol;
    final pricePerLiterUnit = appSettings.pricePerLiterUnit;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text('Fuel Tracker', style: RLText.headlineMd),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.amber),
                onPressed: () {
                  final lastOdom =
                      allLogsAsync.valueOrNull?.firstOrNull?.odometerKm;
                  _showAddRefuelSheet(
                    context,
                    ref,
                    lastOdometer: lastOdom,
                    pricePerLiterUnit: pricePerLiterUnit,
                  );
                },
                tooltip: 'Add refuel',
              ),
            ],
          ),
          profileAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.amber,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (_, __) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Could not load fuel data',
                  style: RLText.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
            data: (profile) {
              if (profile == null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No bike profile found',
                      style: RLText.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                );
              }

              final quota = profile.weeklyFuelQuotaLiters;
              final weeklyUsed = weeklyUsedAsync.valueOrNull ?? 0.0;
              final usedFraction = (weeklyUsed / quota).clamp(0.0, 1.0);
              final usedPercent = (usedFraction * 100).round();
              final remaining = (quota - weeklyUsed).toStringAsFixed(1);
              final progressColor =
                  usedFraction < 0.8 ? AppColors.olive : AppColors.amber;
              final economy = profile.manualFuelEconomyKmPerLiter;
              final balance = (quota - weeklyUsed).clamp(0.0, quota);
              final weekRange = _weekRange(profile.weeklyResetDate);

              return SliverPadding(
                padding: const EdgeInsets.all(RLSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── 1. Weekly Quota Card ──────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(RLSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        border: Border.all(color: AppColors.border, width: 1),
                        borderRadius: RLRadius.borderXl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This Week',
                                    style: RLText.labelMd
                                        .copyWith(color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    weekRange,
                                    style: RLText.labelSm.copyWith(
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${weeklyUsed.toStringAsFixed(1)} / ${quota.toStringAsFixed(1)} L',
                                style: RLText.headlineMd
                                    .copyWith(color: AppColors.amber),
                              ),
                            ],
                          ),
                          const SizedBox(height: RLSpacing.md),
                          ClipRRect(
                            borderRadius: RLRadius.borderPill,
                            child: SizedBox(
                              height: 8,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: constraints.maxWidth,
                                        color: AppColors.bgCardHigh,
                                      ),
                                      Container(
                                        width:
                                            constraints.maxWidth * usedFraction,
                                        color: progressColor,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: RLSpacing.xs + 2),
                          Row(
                            children: [
                              Text(
                                '$usedPercent% used',
                                style: RLText.labelMd
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                              const Spacer(),
                              Text(
                                '$remaining L remaining',
                                style: RLText.labelMd
                                    .copyWith(color: AppColors.olive),
                              ),
                            ],
                          ),
                          const SizedBox(height: RLSpacing.base),
                          const Divider(color: AppColors.divider, height: 1),
                          const SizedBox(height: RLSpacing.md),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _QuotaMiniStat(
                                  value: '${balance.toStringAsFixed(1)} L',
                                  label: 'Balance',
                                ),
                                _VerticalDivider(),
                                _QuotaMiniStat(
                                  value: '~${(balance * economy).round()} km',
                                  label: 'Est. Range',
                                ),
                                _VerticalDivider(),
                                _QuotaMiniStat(
                                  value: economy.toStringAsFixed(1),
                                  label: 'km/L',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: RLSpacing.base),

                    // ── 2. Odd/Even Restriction Banner ─────────────────────────
                    _OddEvenBanner(vehicleNumber: profile.vehicleNumber),

                    const SizedBox(height: RLSpacing.base),

                    // ── 3. Refuel Log Header ────────────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: RLSpacing.sm),
                      child: Row(
                        children: [
                          Text(
                            'REFUEL LOG',
                            style: RLText.labelMd.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              final lastOdom = allLogsAsync
                                  .valueOrNull?.firstOrNull?.odometerKm;
                              _showAddRefuelSheet(
                                context,
                                ref,
                                lastOdometer: lastOdom,
                                pricePerLiterUnit: pricePerLiterUnit,
                              );
                            },
                            child: Text(
                              'Add',
                              style: RLText.labelMd.copyWith(
                                color: AppColors.amber,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── 4. Refuel Log Items ─────────────────────────────────────
                    ...?allLogsAsync.valueOrNull?.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: RLSpacing.sm),
                        child: _RefuelLogItem(
                          item: item,
                          formatDate: _formatDate,
                          currencySymbol: currencySymbol,
                        ),
                      ),
                    ),

                    if ((allLogsAsync.valueOrNull ?? []).isEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: RLSpacing.xl),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_gas_station_outlined,
                                size: 40,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: RLSpacing.md),
                              Text(
                                'No refuels logged yet',
                                style: RLText.bodySm
                                    .copyWith(color: AppColors.textMuted),
                              ),
                              const SizedBox(height: RLSpacing.sm),
                              GestureDetector(
                                onTap: () => _showAddRefuelSheet(
                                  context,
                                  ref,
                                  pricePerLiterUnit: pricePerLiterUnit,
                                ),
                                child: Text(
                                  'Add your first refuel',
                                  style: RLText.labelMd
                                      .copyWith(color: AppColors.amber),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Add Refuel Bottom Sheet ────────────────────────────────────────────────

class _AddRefuelSheet extends ConsumerStatefulWidget {
  const _AddRefuelSheet({this.lastOdometer, required this.pricePerLiterUnit});
  final double? lastOdometer;
  final String pricePerLiterUnit;

  @override
  ConsumerState<_AddRefuelSheet> createState() => _AddRefuelSheetState();
}

class _AddRefuelSheetState extends ConsumerState<_AddRefuelSheet> {
  late final TextEditingController _litersCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _odometerCtrl;
  late final TextEditingController _noteCtrl;
  DateTime _date = DateTime.now();
  bool _saving = false;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  void _onFormChanged() {
    if (!mounted || _saving) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _litersCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _odometerCtrl = TextEditingController(
        text: widget.lastOdometer?.toStringAsFixed(0) ?? '');
    _noteCtrl = TextEditingController();
    _litersCtrl.addListener(_onFormChanged);
    _odometerCtrl.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _litersCtrl.removeListener(_onFormChanged);
    _odometerCtrl.removeListener(_onFormChanged);
    _litersCtrl.dispose();
    _priceCtrl.dispose();
    _odometerCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      (double.tryParse(_litersCtrl.text) ?? 0) > 0 &&
      (double.tryParse(_odometerCtrl.text) ?? -1) >= 0;

  Future<void> _save() async {
    if (!_isValid) return;
    setState(() => _saving = true);
    try {
      final log = FuelLogModel()
        ..fuelLogId = const Uuid().v4()
        ..date = _date
        ..odometerKm = double.parse(_odometerCtrl.text)
        ..litersAdded = double.parse(_litersCtrl.text)
        ..pricePerLiter = double.tryParse(_priceCtrl.text)
        ..totalCost = double.tryParse(_priceCtrl.text) != null
            ? double.parse(_litersCtrl.text) * double.parse(_priceCtrl.text)
            : null
        ..note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await ref.read(fuelRepositoryProvider).saveFuelLog(log);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboard, String? suffix, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: RLText.labelSm.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            hintStyle: RLText.bodyMd.copyWith(color: AppColors.textMuted),
            suffixStyle:
                RLText.labelMd.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.bgCardHigh,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: RLSpacing.base, vertical: RLSpacing.md),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Add Refuel', style: RLText.headlineSm),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 20, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date picker
            Text('DATE',
                style: RLText.labelSm.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
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
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: RLSpacing.base, vertical: RLSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.bgCardHigh,
                  borderRadius: BorderRadius.circular(RLRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_months[_date.month - 1]} ${_date.day}, ${_date.year}',
                      style:
                          RLText.bodyMd.copyWith(color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),
            _field(
              'LITERS ADDED',
              _litersCtrl,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              suffix: 'L',
              hint: '0.0',
            ),
            const SizedBox(height: 14),
            _field(
              'PRICE PER LITER (OPTIONAL)',
              _priceCtrl,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              suffix: widget.pricePerLiterUnit,
              hint: '0.00',
            ),
            const SizedBox(height: 14),
            _field(
              'ODOMETER READING',
              _odometerCtrl,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              suffix: 'km',
              hint: '0',
            ),
            const SizedBox(height: 14),
            _field(
              'NOTE (OPTIONAL)',
              _noteCtrl,
              hint: 'e.g., Full tank at Shell',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isValid ? AppColors.amber : AppColors.amberDim,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RLRadius.lg),
                  ),
                ),
                onPressed: _isValid && !_saving ? _save : null,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: AppColors.textInverse, strokeWidth: 2),
                      )
                    : Text(
                        'Save Refuel',
                        style:
                            RLText.btnLg.copyWith(color: AppColors.textInverse),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Odd/Even Restriction Banner ─────────────────────────────────────────────

class _OddEvenBanner extends StatelessWidget {
  const _OddEvenBanner({required this.vehicleNumber});

  final String? vehicleNumber;

  int? _lastDigit() {
    if (vehicleNumber == null || vehicleNumber!.isEmpty) return null;
    for (int i = vehicleNumber!.length - 1; i >= 0; i--) {
      final code = vehicleNumber!.codeUnitAt(i);
      if (code >= 48 && code <= 57) return code - 48;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final digit = _lastDigit();
    if (digit == null) return const SizedBox.shrink();

    final today = DateTime.now().day;
    final canRefuel = digit % 2 == today % 2;
    final plateLabel = vehicleNumber!.toUpperCase();
    final parity = digit % 2 == 0 ? 'even' : 'odd';
    final todayParity = today % 2 == 0 ? 'even' : 'odd';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RLSpacing.base,
        vertical: RLSpacing.md,
      ),
      decoration: BoxDecoration(
        color: canRefuel
            ? AppColors.olive.withValues(alpha: 0.12)
            : AppColors.error.withValues(alpha: 0.10),
        borderRadius: RLRadius.borderLg,
        border: Border.all(
          color: canRefuel
              ? AppColors.olive.withValues(alpha: 0.4)
              : AppColors.error.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            canRefuel ? Icons.check_circle_outline : Icons.block_outlined,
            size: 20,
            color: canRefuel ? AppColors.olive : AppColors.error,
          ),
          const SizedBox(width: RLSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: RLText.bodySm.copyWith(
                  color: canRefuel ? AppColors.olive : AppColors.error,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: canRefuel
                        ? 'Refueling allowed today. '
                        : 'Refueling not allowed today. ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                        '$plateLabel ends in $digit ($parity plate) · today is $todayParity.',
                    style: RLText.labelMd.copyWith(
                      color: canRefuel
                          ? AppColors.olive.withValues(alpha: 0.8)
                          : AppColors.error.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets ──────────────────────────────────────────────────────

class _QuotaMiniStat extends StatelessWidget {
  const _QuotaMiniStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: RLText.numSm),
          const SizedBox(height: 2),
          Text(
            label,
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.sm),
    );
  }
}

class _RefuelLogItem extends StatelessWidget {
  const _RefuelLogItem({
    required this.item,
    required this.formatDate,
    required this.currencySymbol,
  });
  final FuelLogModel item;
  final String Function(DateTime) formatDate;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final totalCost =
        (item.litersAdded * (item.pricePerLiter ?? 0)).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: RLRadius.borderLg,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCardHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_gas_station,
              size: 18,
              color: AppColors.olive,
            ),
          ),
          const SizedBox(width: RLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.litersAdded.toStringAsFixed(1)} L',
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'at $currencySymbol${item.pricePerLiter?.toStringAsFixed(2) ?? '--'}/L · Odo: ${item.odometerKm.toInt()} km',
                  style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: RLSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((item.pricePerLiter ?? 0) > 0)
                Text('$currencySymbol$totalCost', style: RLText.numSm),
              const SizedBox(height: 2),
              Text(
                formatDate(item.date),
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
