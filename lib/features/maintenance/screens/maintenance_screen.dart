import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  int _tabIndex = 0;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
    final upcoming = SampleData.maintenance
        .where((m) => m.status != MaintenanceStatus.done)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...upcoming.map((item) => _MaintenanceCard(item: item)),
        const SizedBox(height: RLSpacing.base),
        // Add Custom Reminder
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            border: Border.all(color: AppColors.border),
            borderRadius: RLRadius.borderLg,
          ),
          padding: const EdgeInsets.all(RLSpacing.base),
          child: Row(
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.amber,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Add Custom Reminder',
                style: RLText.bodyMd.copyWith(color: AppColors.textPrimary),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final done = SampleData.maintenance
        .where((m) => m.status == MaintenanceStatus.done)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(done.length, (index) {
          final item = done[index];
          final isLast = index == done.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline column
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
                        item.title,
                        style: RLText.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.lastDoneDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Done on ${_formatDate(item.lastDoneDate!)}',
                          style: RLText.labelMd.copyWith(
                            color: AppColors.textMuted,
                          ),
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
  }
}

// ── Tab Button ────────────────────────────────────────────────────────────────

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

// ── Maintenance Card ──────────────────────────────────────────────────────────

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.item});

  final SampleMaintenance item;

  Color get _iconColor {
    switch (item.status) {
      case MaintenanceStatus.upcoming:
        return AppColors.amber;
      case MaintenanceStatus.overdue:
        return AppColors.error;
      case MaintenanceStatus.due:
        return AppColors.warning;
      case MaintenanceStatus.done:
        return AppColors.olive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
      padding: const EdgeInsets.all(RLSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCardHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                ),
                if (item.dueAtKm != null && item.currentKm != null) ...[
                  const SizedBox(height: 6),
                  // Progress bar
                  ClipRRect(
                    borderRadius: RLRadius.borderPill,
                    child: Container(
                      height: 3,
                      color: AppColors.bgCardHigh,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (item.currentKm! / item.dueAtKm!)
                            .clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: RLRadius.borderPill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.currentKm!.toInt()} / ${item.dueAtKm!.toInt()} km',
                    style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status badge
          _StatusBadge(status: item.status, kmRemaining: item.kmRemaining),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.kmRemaining});

  final MaintenanceStatus status;
  final double kmRemaining;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MaintenanceStatus.upcoming:
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.amberSurface,
            borderRadius: RLRadius.borderPill,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            '${kmRemaining.toInt()} km',
            style: RLText.labelSm.copyWith(color: AppColors.amber),
          ),
        );
      case MaintenanceStatus.overdue:
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.errorSurface,
            borderRadius: RLRadius.borderPill,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'Overdue',
            style: RLText.labelSm.copyWith(color: AppColors.error),
          ),
        );
      case MaintenanceStatus.due:
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.warningSurface,
            borderRadius: RLRadius.borderPill,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'Due',
            style: RLText.labelSm.copyWith(color: AppColors.warning),
          ),
        );
      case MaintenanceStatus.done:
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.oliveSurface,
            borderRadius: RLRadius.borderPill,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'Done',
            style: RLText.labelSm.copyWith(color: AppColors.olive),
          ),
        );
    }
  }
}
