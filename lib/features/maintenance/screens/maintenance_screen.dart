import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/maintenance_reminder_model.dart';
import '../../../shared/providers/repositories_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/providers/rides_provider.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final _pendingRemindersProvider =
    FutureProvider<List<MaintenanceReminderModel>>((ref) async {
  return ref.watch(maintenanceRepositoryProvider).getPendingReminders();
});

final _completedRemindersProvider =
    FutureProvider<List<MaintenanceReminderModel>>((ref) async {
  return ref.watch(maintenanceRepositoryProvider).getCompletedReminders();
});

// ── Screen ─────────────────────────────────────────────────────────────────

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  int _tabIndex = 0;

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

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  (String, IconData) _typeInfo(String type) {
    switch (type) {
      case 'oil_change_1':
        return ('1st Oil Change', Icons.water_drop_outlined);
      case 'oil_change_2':
        return ('2nd Oil Change', Icons.water_drop_outlined);
      case 'chain_lube':
        return ('Chain Lubrication', Icons.settings_outlined);
      case 'air_filter':
        return ('Air Filter Check', Icons.air);
      case 'spark_plug':
        return ('Spark Plug', Icons.bolt);
      case 'tire_pressure':
        return ('Tire Pressure', Icons.circle_outlined);
      default:
        return (
          type.replaceAll('_', ' ').replaceFirstMapped(
              RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase()),
          Icons.build_outlined,
        );
    }
  }

  void _showAddReminderSheet(double currentKm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddReminderSheet(currentKm: currentKm),
    ).then((_) {
      ref.invalidate(_pendingRemindersProvider);
      ref.invalidate(_completedRemindersProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgBase,
            elevation: 0,
            title: const Text('Maintenance', style: RLText.headlineMd),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'Upcoming',
                      selected: _tabIndex == 0,
                      onTap: () => setState(() => _tabIndex = 0),
                    ),
                    const SizedBox(width: 4),
                    _TabButton(
                      label: 'History',
                      selected: _tabIndex == 1,
                      onTap: () => setState(() => _tabIndex = 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.base),
            sliver: SliverToBoxAdapter(
              child: _tabIndex == 0 ? _buildUpcomingTab() : _buildHistoryTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    final pendingAsync = ref.watch(_pendingRemindersProvider);
    final profileAsync = ref.watch(bikeProfileProvider);
    final riddenKmAsync = ref.watch(totalRiddenKmProvider);

    return pendingAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child:
              CircularProgressIndicator(color: AppColors.amber, strokeWidth: 2),
        ),
      ),
      error: (_, __) => _EmptyState(
        icon: Icons.error_outline,
        message: 'Could not load reminders',
      ),
      data: (items) {
        final profile = profileAsync.valueOrNull;
        final ridden = riddenKmAsync.valueOrNull ?? 0;
        final currentKm = (profile?.rebuildOdometerKm ?? 0) +
            (profile?.rebuildStartOdometerKm ?? 0) +
            ridden;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (items.isEmpty)
              _EmptyState(
                icon: Icons.check_circle_outline,
                message: 'No upcoming reminders',
                hint: 'Add a custom reminder below.',
              )
            else
              ...items.map((item) {
                final (title, icon) = _typeInfo(item.type);
                final kmRemaining =
                    (item.dueAtKm - currentKm).clamp(0, double.infinity);
                final progress = currentKm / item.dueAtKm;
                return _MaintenanceCard(
                  title: title,
                  subtitle: 'Due at ${item.dueAtKm.toInt()} km',
                  icon: icon,
                  currentKm: currentKm,
                  dueAtKm: item.dueAtKm,
                  progress: progress.clamp(0.0, 1.0),
                  kmRemaining: kmRemaining.toDouble(),
                  isOverdue: currentKm >= item.dueAtKm,
                  onMarkDone: () async {
                    await ref
                        .read(maintenanceRepositoryProvider)
                        .markReminderCompleted(item.reminderId);
                    ref.invalidate(_pendingRemindersProvider);
                    ref.invalidate(_completedRemindersProvider);
                  },
                );
              }),
            const SizedBox(height: RLSpacing.base),
            _AddReminderButton(onTap: () => _showAddReminderSheet(currentKm)),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    final completedAsync = ref.watch(_completedRemindersProvider);

    return completedAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child:
              CircularProgressIndicator(color: AppColors.amber, strokeWidth: 2),
        ),
      ),
      error: (_, __) => _EmptyState(
        icon: Icons.error_outline,
        message: 'Could not load history',
      ),
      data: (items) {
        if (items.isEmpty) {
          return _EmptyState(
            icon: Icons.history_outlined,
            message: 'No service history yet',
            hint: 'Completed reminders will appear here.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              final (title, _) = _typeInfo(item.type);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.olive,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1,
                            height: 44,
                            color: AppColors.divider,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: RLText.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.completedAt != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Done on ${_formatDate(item.completedAt!)}',
                              style: RLText.labelMd
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                          if (item.notes != null && item.notes!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.notes!,
                              style: RLText.labelMd
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }
}

// ── Add Reminder Bottom Sheet ───────────────────────────────────────────────

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet({required this.currentKm});
  final double currentKm;

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  late final TextEditingController _dueKmCtrl;
  late final TextEditingController _customTypeCtrl;
  late final TextEditingController _notesCtrl;
  bool _saving = false;

  static const _presets = [
    ('Oil Change', 'oil_change_1'),
    ('Chain Lube', 'chain_lube'),
    ('Air Filter', 'air_filter'),
    ('Spark Plug', 'spark_plug'),
    ('Tire Pressure', 'tire_pressure'),
    ('Custom', 'custom'),
  ];

  String _selectedType = 'oil_change_1';
  bool get _isCustom => _selectedType == 'custom';

  @override
  void initState() {
    super.initState();
    _dueKmCtrl = TextEditingController(
        text: (widget.currentKm + 500).toStringAsFixed(0));
    _customTypeCtrl = TextEditingController();
    _notesCtrl = TextEditingController();

    // Rebuild while typing so button enable/disable state stays in sync.
    _dueKmCtrl.addListener(_onFormChanged);
    _customTypeCtrl.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _dueKmCtrl.removeListener(_onFormChanged);
    _customTypeCtrl.removeListener(_onFormChanged);
    _dueKmCtrl.dispose();
    _customTypeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _isValid {
    final km = double.tryParse(_dueKmCtrl.text) ?? 0;
    if (km <= 0) return false;
    if (_isCustom && _customTypeCtrl.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _save() async {
    if (!_isValid) return;
    setState(() => _saving = true);
    try {
      final type = _isCustom
          ? _customTypeCtrl.text.trim().toLowerCase().replaceAll(' ', '_')
          : _selectedType;
      final reminder = MaintenanceReminderModel()
        ..reminderId = const Uuid().v4()
        ..type = type
        ..dueAtKm = double.parse(_dueKmCtrl.text)
        ..completed = false
        ..completedAt = null
        ..notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await ref
          .read(maintenanceRepositoryProvider)
          .saveMaintenanceReminder(reminder);
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

  Widget _inputField(String label, TextEditingController ctrl,
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
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Add Reminder', style: RLText.headlineSm),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 20, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Type selector
            Text('TYPE',
                style: RLText.labelSm.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((p) {
                final selected = _selectedType == p.$2;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = p.$2),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.amberSurface
                          : AppColors.bgCardHigh,
                      borderRadius: RLRadius.borderPill,
                      border: Border.all(
                        color: selected ? AppColors.amber : AppColors.border,
                      ),
                    ),
                    child: Text(
                      p.$1,
                      style: RLText.labelMd.copyWith(
                        color: selected
                            ? AppColors.amber
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (_isCustom) ...[
              const SizedBox(height: 14),
              _inputField('CUSTOM TYPE NAME', _customTypeCtrl,
                  hint: 'e.g., Valve Clearance'),
            ],

            const SizedBox(height: 14),
            _inputField(
              'DUE AT ODOMETER',
              _dueKmCtrl,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              suffix: 'km',
              hint: '${(widget.currentKm + 500).toStringAsFixed(0)}',
            ),
            const SizedBox(height: 4),
            Text(
              'Current odometer: ${widget.currentKm.toStringAsFixed(0)} km',
              style: RLText.labelSm.copyWith(color: AppColors.textMuted),
            ),

            const SizedBox(height: 14),
            _inputField('NOTES (OPTIONAL)', _notesCtrl,
                hint: 'e.g., Use 10W-40 oil'),

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
                        'Save Reminder',
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

// ── Tab Button ─────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  const _TabButton(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: RLSpacing.base),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.amber : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: RLText.labelMd.copyWith(
            color: selected ? AppColors.amber : AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Maintenance Card ────────────────────────────────────────────────────────

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.currentKm,
    required this.dueAtKm,
    required this.progress,
    required this.kmRemaining,
    required this.isOverdue,
    required this.onMarkDone,
  });

  final String title, subtitle;
  final IconData icon;
  final double currentKm, dueAtKm, progress, kmRemaining;
  final bool isOverdue;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final statusColor = isOverdue ? AppColors.error : AppColors.amber;
    final statusLabel = isOverdue ? 'Overdue' : '${kmRemaining.toInt()} km';
    final statusBg =
        isOverdue ? AppColors.errorSurface : AppColors.amberSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bgCardHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: RLText.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style:
                          RLText.labelMd.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: RLRadius.borderPill,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  statusLabel,
                  style: RLText.labelSm.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: RLRadius.borderPill,
            child: Container(
              height: 3,
              color: AppColors.bgCardHigh,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: RLRadius.borderPill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${currentKm.toInt()} / ${dueAtKm.toInt()} km',
                style: RLText.labelSm.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onMarkDone,
                child: Text(
                  'Mark done',
                  style: RLText.labelSm.copyWith(color: AppColors.olive),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message, this.hint});
  final IconData icon;
  final String message;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppColors.textMuted),
            const SizedBox(height: RLSpacing.md),
            Text(message,
                style:
                    RLText.headlineSm.copyWith(color: AppColors.textSecondary)),
            if (hint != null) ...[
              const SizedBox(height: 6),
              Text(hint!,
                  style: RLText.bodySm.copyWith(color: AppColors.textMuted)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Add Reminder Button ────────────────────────────────────────────────────

class _AddReminderButton extends StatelessWidget {
  const _AddReminderButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border),
          borderRadius: RLRadius.borderLg,
        ),
        padding: const EdgeInsets.all(RLSpacing.base),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline,
                color: AppColors.amber, size: 20),
            const SizedBox(width: 10),
            Text(
              'Add Custom Reminder',
              style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
