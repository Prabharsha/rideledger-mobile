import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// Convert internal type string to a readable title + icon
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
              child: _tabIndex == 0
                  ? _buildUpcomingTab()
                  : _buildHistoryTab(),
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
          child: CircularProgressIndicator(
              color: AppColors.amber, strokeWidth: 2),
        ),
      ),
      error: (_, __) => _EmptyState(
        icon: Icons.error_outline,
        message: 'Could not load reminders',
      ),
      data: (items) {
        final profile = profileAsync.valueOrNull;
        final ridden = riddenKmAsync.valueOrNull ?? 0;
        final currentKm =
            (profile?.rebuildStartOdometerKm ?? 0) + ridden;

        if (items.isEmpty) {
          return Column(
            children: [
              _EmptyState(
                icon: Icons.check_circle_outline,
                message: 'No upcoming reminders',
                hint: 'Add a custom reminder below.',
              ),
              const SizedBox(height: RLSpacing.base),
              _AddReminderButton(),
              const SizedBox(height: 100),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items.map((item) {
              final (title, icon) = _typeInfo(item.type);
              final kmRemaining = (item.dueAtKm - currentKm).clamp(0, double.infinity);
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
            _AddReminderButton(),
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
          child: CircularProgressIndicator(
              color: AppColors.amber, strokeWidth: 2),
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
                          if (item.notes != null &&
                              item.notes!.isNotEmpty) ...[
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

// ── Tab Button ─────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding:
            const EdgeInsets.symmetric(horizontal: RLSpacing.base),
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
            color:
                selected ? AppColors.amber : AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Maintenance Card ───────────────────────────────────────────────────────

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
    final statusLabel =
        isOverdue ? 'Overdue' : '${kmRemaining.toInt()} km';
    final statusBg = isOverdue ? AppColors.errorSurface : AppColors.amberSurface;

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
                      style: RLText.labelMd
                          .copyWith(color: AppColors.textMuted),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                child: Text(
                  statusLabel,
                  style: RLText.labelSm.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
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

// ── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    this.hint,
  });

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
            Text(
              message,
              style: RLText.headlineSm
                  .copyWith(color: AppColors.textSecondary),
            ),
            if (hint != null) ...[
              const SizedBox(height: 6),
              Text(
                hint!,
                style:
                    RLText.bodySm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Add reminder button ────────────────────────────────────────────────────

class _AddReminderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            style:
                RLText.bodyMd.copyWith(color: AppColors.textPrimary),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right,
              color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
