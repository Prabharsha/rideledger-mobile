import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Commute', 'Leisure'];

  List<SampleRide> get _filteredRides {
    if (_selectedFilter == 'All') return SampleData.rides;
    return SampleData.rides
        .where((r) => r.rideType == _selectedFilter)
        .toList();
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
          SliverPadding(
            padding: const EdgeInsets.all(RLSpacing.md),
            sliver: SliverList.separated(
              itemCount: _filteredRides.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 8, color: Colors.transparent),
              itemBuilder: (context, index) {
                final ride = _filteredRides[index];
                return _RideCard(ride: ride);
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({required this.ride});

  final SampleRide ride;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
  }

  Color get _typeColor =>
      ride.rideType == 'Leisure' ? AppColors.olive : AppColors.amber;

  Color get _typeBorderColor =>
      ride.rideType == 'Leisure' ? AppColors.oliveDim : AppColors.amberDim;

  Color get _typeSurfaceColor =>
      ride.rideType == 'Leisure' ? AppColors.oliveSurface : AppColors.amberSurface;

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
          // Row 1: route + date/type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From → To
              Expanded(
                child: Row(
                  children: [
                    Text(
                      ride.fromLabel,
                      style: RLText.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(width: RLSpacing.xs),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: RLSpacing.xs),
                    Flexible(
                      child: Text(
                        ride.toLabel,
                        style: RLText.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: RLSpacing.sm),
              // Date + ride type chip
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(ride.date),
                    style: RLText.labelMd.copyWith(
                      color: AppColors.textMuted,
                    ),
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
                      ride.rideType,
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
                value: ride.durationLabel.replaceAll('m', '').replaceAll('h ', 'h '),
                unit: ride.duration.inHours > 0 ? '' : 'min',
                label: 'Duration',
              ),
              _MiniStat(
                value: ride.avgSpeedKmh.toStringAsFixed(1),
                unit: 'km/h',
                label: 'Avg Speed',
              ),
              _MiniStat(
                value: ride.fuelUsedL.toStringAsFixed(2),
                unit: 'L',
                label: 'Fuel',
              ),
            ],
          ),

          // Warning row
          if (ride.warningCount > 0) ...[
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
                  '${ride.warningCount} speed warning${ride.warningCount > 1 ? 's' : ''}',
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
