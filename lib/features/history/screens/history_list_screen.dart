import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/ride_session_model.dart';
import '../../../shared/providers/rides_provider.dart';

class HistoryListScreen extends ConsumerStatefulWidget {
  const HistoryListScreen({super.key});

  @override
  ConsumerState<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends ConsumerState<HistoryListScreen> {
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Commute', 'Leisure'];

  List<RideSessionModel> _filteredRides(List<RideSessionModel> rides) {
    if (_selectedFilter == 'All') return rides;
    final type = _selectedFilter.toLowerCase();
    return rides.where((r) => r.rideType.toLowerCase() == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ridesAsync = ref.watch(allRideSessionsProvider);

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
            title: Text('Ride History', style: RLText.headlineMd),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.lg,
                  vertical: RLSpacing.sm,
                ),
                child: Row(
                  children: _filters.map((filter) {
                    final selected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: RLSpacing.sm),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: RLSpacing.md,
                            vertical: RLSpacing.xs + 2,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.amberSurface
                                : AppColors.bgCard,
                            borderRadius: RLRadius.borderPill,
                            border: Border.all(
                              color: selected
                                  ? AppColors.amber
                                  : AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: RLText.labelMd.copyWith(
                              color: selected
                                  ? AppColors.amber
                                  : AppColors.textSecondary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          ridesAsync.when(
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
                  'Could not load rides',
                  style: RLText.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
            data: (allRides) {
              final rides = _filteredRides(allRides);
              if (rides.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.route_outlined,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: RLSpacing.md),
                        Text(
                          'No rides yet',
                          style: RLText.headlineSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your recorded rides will appear here.',
                          style: RLText.bodySm.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(RLSpacing.md),
                sliver: SliverList.separated(
                  itemCount: rides.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 8, color: Colors.transparent),
                  itemBuilder: (context, index) =>
                      _RideCard(ride: rides[index]),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({required this.ride});

  final RideSessionModel ride;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour =
        date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
  }

  String get _rideTypeLabel {
    switch (ride.rideType.toLowerCase()) {
      case 'commute':
        return 'Commute';
      case 'extra':
        return 'Leisure';
      default:
        return ride.rideType;
    }
  }

  String get _durationLabel {
    final h = ride.durationSeconds ~/ 3600;
    final m = (ride.durationSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  Color get _typeColor =>
      ride.rideType.toLowerCase() == 'extra'
          ? AppColors.olive
          : AppColors.amber;

  Color get _typeBorderColor =>
      ride.rideType.toLowerCase() == 'extra'
          ? AppColors.oliveDim
          : AppColors.amberDim;

  Color get _typeSurfaceColor =>
      ride.rideType.toLowerCase() == 'extra'
          ? AppColors.oliveSurface
          : AppColors.amberSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RLSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: RLRadius.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: stage + date/type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ride.breakInStageName,
                  style: RLText.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: RLSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(ride.date),
                    style: RLText.labelMd.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: RLSpacing.xs,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _typeSurfaceColor,
                      borderRadius: RLRadius.borderPill,
                      border: Border.all(color: _typeBorderColor, width: 1),
                    ),
                    child: Text(
                      _rideTypeLabel,
                      style: RLText.labelSm.copyWith(
                        color: _typeColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: RLSpacing.md),

          // Row 2: 4 mini stats
          Row(
            children: [
              _MiniStat(
                value: ride.distanceKm.toStringAsFixed(1),
                unit: 'km',
                label: 'Distance',
              ),
              _MiniStat(
                value: _durationLabel,
                unit: '',
                label: 'Duration',
              ),
              _MiniStat(
                value: ride.averageSpeedKmh.toStringAsFixed(1),
                unit: 'km/h',
                label: 'Avg Speed',
              ),
              _MiniStat(
                value: ride.estimatedFuelUsedLiters.toStringAsFixed(2),
                unit: 'L',
                label: 'Fuel',
              ),
            ],
          ),

          if (ride.overspeedEventCount > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.warning_rounded,
                  size: 14,
                  color: AppColors.amber,
                ),
                const SizedBox(width: RLSpacing.xs),
                Text(
                  '${ride.overspeedEventCount} speed warning${ride.overspeedEventCount > 1 ? 's' : ''}',
                  style: RLText.labelMd.copyWith(color: AppColors.amber),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: RLText.numSm),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: RLText.labelSm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: RLText.labelSm.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
