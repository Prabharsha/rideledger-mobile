import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/ride_session_model.dart';
import '../../../data/models/route_point_model.dart';
import '../../../data/models/warning_event_model.dart';
import '../../../shared/providers/rides_provider.dart';
import '../../../shared/widgets/rl_section_header.dart';
import '../../../shared/widgets/rl_stat_block.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({
    super.key,
    required this.rideId,
    this.sessionIds = const [],
    this.currentIndex = 0,
  });

  final String rideId;
  final List<String> sessionIds;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideAsync = ref.watch(rideByIdProvider(rideId));

    return rideAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child:
              CircularProgressIndicator(color: AppColors.amber, strokeWidth: 2),
        ),
      ),
      error: (_, __) => _ErrorState(onBack: () => context.pop()),
      data: (ride) {
        if (ride == null) return _ErrorState(onBack: () => context.pop());
        return _TripDetailContent(
          ride: ride,
          sessionIds: sessionIds,
          currentIndex: currentIndex,
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48),
            const SizedBox(height: RLSpacing.md),
            Text('Ride not found', style: RLText.headlineSm),
            const SizedBox(height: RLSpacing.sm),
            TextButton(
              onPressed: onBack,
              child: Text(
                'Go back',
                style: RLText.bodyMd.copyWith(color: AppColors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripDetailContent extends ConsumerStatefulWidget {
  const _TripDetailContent({
    required this.ride,
    required this.sessionIds,
    required this.currentIndex,
  });

  final RideSessionModel ride;
  final List<String> sessionIds;
  final int currentIndex;

  @override
  ConsumerState<_TripDetailContent> createState() => _TripDetailContentState();
}

class _TripDetailContentState extends ConsumerState<_TripDetailContent> {
  final MapController _mapController = MapController();
  LatLng? _focusedLocation;

  void _focusMapOn(LatLng location) {
    setState(() => _focusedLocation = location);
  }

  @override
  Widget build(BuildContext context) {
    final routePointsAsync =
        ref.watch(routePointsForSessionProvider(widget.ride.sessionId));
    final warningsAsync =
        ref.watch(warningEventsForSessionProvider(widget.ride.sessionId));

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _TripSummarySection(ride: widget.ride)),
          SliverToBoxAdapter(
            child: _SpeedChartSection(
                ride: widget.ride, routePointsAsync: routePointsAsync),
          ),
          SliverToBoxAdapter(
            child: _RouteMapSection(
              routePointsAsync: routePointsAsync,
              mapController: _mapController,
              focusedLocation: _focusedLocation,
            ),
          ),
          SliverToBoxAdapter(
            child: _WarningsSection(
              warningsAsync: warningsAsync,
              routePointsAsync: routePointsAsync,
              onFocusRequested: _focusMapOn,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final months = [
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
    final d = widget.ride.date;
    final hour = d.hour > 12
        ? d.hour - 12
        : d.hour == 0
            ? 12
            : d.hour;
    final minute = d.minute.toString().padLeft(2, '0');
    final amPm = d.hour >= 12 ? 'PM' : 'AM';
    final dateLabel = '${months[d.month - 1]} ${d.day}, $hour:$minute $amPm';

    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.amber, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.ride.breakInStageName, style: RLText.headlineSm),
          Text(
            dateLabel,
            style: RLText.labelMd.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
      titleSpacing: 0,
      actions: null,
    );
  }
}


class _TripSummarySection extends StatelessWidget {
  const _TripSummarySection({required this.ride});

  final RideSessionModel ride;

  String get _durationLabel {
    final h = ride.durationSeconds ~/ 3600;
    final m = (ride.durationSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final hasFuelData = ride.estimatedFuelUsedLiters > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RLSectionHeader(title: 'Trip Summary'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    _StatCard(
                      value: ride.distanceKm.toStringAsFixed(1),
                      unit: 'km',
                      label: 'Distance',
                    ),
                    const SizedBox(width: RLSpacing.sm),
                    _StatCard(
                        value: _durationLabel, unit: '', label: 'Duration'),
                    const SizedBox(width: RLSpacing.sm),
                    _StatCard(
                      value: ride.averageSpeedKmh.toStringAsFixed(1),
                      unit: 'km/h',
                      label: 'Avg Speed',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RLSpacing.sm),
              IntrinsicHeight(
                child: Row(
                  children: [
                    _StatCard(
                      value: ride.maxSpeedKmh.toStringAsFixed(1),
                      unit: 'km/h',
                      label: 'Max Speed',
                      valueColor: AppColors.amber,
                    ),
                    const SizedBox(width: RLSpacing.sm),
                    _StatCard(
                      value: hasFuelData
                          ? ride.estimatedFuelUsedLiters.toStringAsFixed(2)
                          : '-',
                      unit: hasFuelData ? 'L' : '',
                      label: 'Fuel Used',
                    ),
                    const SizedBox(width: RLSpacing.sm),
                    _StatCard(
                        value: ride.rideType, unit: '', label: 'Trip Type'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
  });

  final String value;
  final String unit;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(RLSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border),
          borderRadius: RLRadius.borderLg,
        ),
        child: RLStatBlock(
          value: value,
          unit: unit,
          label: label,
          valueColor: valueColor,
          compact: true,
        ),
      ),
    );
  }
}

class _SpeedChartSection extends StatelessWidget {
  const _SpeedChartSection({
    required this.ride,
    required this.routePointsAsync,
  });

  final RideSessionModel ride;
  final AsyncValue<List<RoutePointModel>> routePointsAsync;

  List<RoutePointModel> _downsample(List<RoutePointModel> points) {
    if (points.length <= 300) return points;
    final step = (points.length / 300).ceil();
    return [for (int i = 0; i < points.length; i += step) points[i]];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RLSectionHeader(title: 'Speed Profile'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: Container(
            padding: const EdgeInsets.all(RLSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.border),
              borderRadius: RLRadius.borderLg,
            ),
            child: SizedBox(
              height: 180,
              child: routePointsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.amber, strokeWidth: 2),
                ),
                error: (_, __) => Center(
                  child: Text(
                    'Could not load speed data',
                    style: RLText.bodySm.copyWith(color: AppColors.textMuted),
                  ),
                ),
                data: (rawPoints) {
                  if (rawPoints.isEmpty) {
                    return Center(
                      child: Text(
                        'No speed data recorded',
                        style:
                            RLText.bodySm.copyWith(color: AppColors.textMuted),
                      ),
                    );
                  }

                  final sorted = List<RoutePointModel>.from(rawPoints)
                    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                  final points = _downsample(sorted);
                  final startTime = points.first.timestamp;
                  final spots = points
                      .asMap()
                      .entries
                      .map((entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.speedKmh))
                      .toList();
                  final maxY = max(ride.maxSpeedKmh * 1.15, 20.0);

                  return LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: AppColors.border,
                          strokeWidth: 0.5,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 20,
                            getTitlesWidget: (value, _) => Text(
                              value.toStringAsFixed(0),
                              style: RLText.labelSm
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            interval: max(1, points.length / 4).toDouble(),
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index < 0 || index >= points.length) {
                                return const SizedBox.shrink();
                              }
                              final elapsed = points[index]
                                  .timestamp
                                  .difference(startTime)
                                  .inMinutes;
                              return Text(
                                '${elapsed}m',
                                style: RLText.labelSm
                                    .copyWith(color: AppColors.textMuted),
                              );
                            },
                          ),
                        ),
                      ),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: ride.maxSpeedKmh,
                            color: AppColors.amber,
                            strokeWidth: 1,
                            dashArray: [6, 4],
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topRight,
                              labelResolver: (_) =>
                                  'Max ${ride.maxSpeedKmh.toStringAsFixed(0)}',
                              style: RLText.labelSm
                                  .copyWith(color: AppColors.amber),
                            ),
                          ),
                        ],
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: AppColors.slate,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color:
                                AppColors.slateSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => AppColors.bgCardHigh,
                          getTooltipItems: (spots) {
                            return spots
                                .map(
                                  (spot) => LineTooltipItem(
                                    '${spot.y.toStringAsFixed(1)} km/h',
                                    RLText.labelLg
                                        .copyWith(color: AppColors.amber),
                                  ),
                                )
                                .toList();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteMapSection extends StatefulWidget {
  const _RouteMapSection({
    required this.routePointsAsync,
    required this.mapController,
    required this.focusedLocation,
  });

  final AsyncValue<List<RoutePointModel>> routePointsAsync;
  final MapController mapController;
  final LatLng? focusedLocation;

  @override
  State<_RouteMapSection> createState() => _RouteMapSectionState();
}

class _RouteMapSectionState extends State<_RouteMapSection> {
  LatLng? _lastFocusedLocation;

  @override
  void didUpdateWidget(covariant _RouteMapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final focused = widget.focusedLocation;
    if (focused == null || focused == _lastFocusedLocation) return;
    _lastFocusedLocation = focused;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.mapController.move(focused, 16);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RLSectionHeader(title: 'Route Map'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: ClipRRect(
            borderRadius: RLRadius.borderLg,
            child: SizedBox(
              height: 280,
              child: widget.routePointsAsync.when(
                loading: () => Container(
                  color: AppColors.bgCard,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.amber, strokeWidth: 2),
                  ),
                ),
                error: (_, __) => _mapPlaceholder('Could not load route'),
                data: (points) {
                  if (points.length < 2) {
                    return _mapPlaceholder('Route not recorded');
                  }

                  final latLngs = points
                      .map((p) => LatLng(p.latitude, p.longitude))
                      .toList();
                  final bounds = LatLngBounds.fromPoints(latLngs);

                  return FlutterMap(
                    mapController: widget.mapController,
                    options: MapOptions(
                      initialCameraFit: CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(24),
                      ),
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.ride_ledger',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: latLngs,
                            color: AppColors.slate,
                            strokeWidth: 3.5,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: latLngs.first,
                            width: 20,
                            height: 20,
                            child: const _MapDot(color: AppColors.success),
                          ),
                          Marker(
                            point: latLngs.last,
                            width: 20,
                            height: 20,
                            child: const _MapDot(color: AppColors.amber),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: RLSpacing.sm),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: _RouteLegend(),
        ),
      ],
    );
  }

  Widget _mapPlaceholder(String message) {
    return Container(
      color: AppColors.bgCard,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined,
                size: 48, color: AppColors.textMuted),
            const SizedBox(height: RLSpacing.sm),
            Text(message,
                style: RLText.bodySm.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _RouteLegend extends StatelessWidget {
  const _RouteLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LegendPill(label: 'Start', color: AppColors.success),
        const SizedBox(width: RLSpacing.sm),
        const _LegendPill(label: 'End', color: AppColors.amber),
        const Spacer(),
        Text(
          'Tap event target to center map',
          style: RLText.labelSm.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: RLSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: RLRadius.borderPill,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: RLText.labelSm.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MapDot extends StatelessWidget {
  const _MapDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _WarningsSection extends StatelessWidget {
  const _WarningsSection({
    required this.warningsAsync,
    required this.routePointsAsync,
    required this.onFocusRequested,
  });

  final AsyncValue<List<WarningEventModel>> warningsAsync;
  final AsyncValue<List<RoutePointModel>> routePointsAsync;
  final void Function(LatLng location) onFocusRequested;

  @override
  Widget build(BuildContext context) {
    final routePoints =
        routePointsAsync.valueOrNull ?? const <RoutePointModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RLSectionHeader(title: 'Warnings & Events'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RLSpacing.screenH),
          child: warningsAsync.when(
            loading: () => Column(
              children: [
                _SkeletonRow(),
                const SizedBox(height: RLSpacing.sm),
                _SkeletonRow(),
              ],
            ),
            error: (_, __) => Text(
              'Could not load events',
              style: RLText.bodySm.copyWith(color: AppColors.textMuted),
            ),
            data: (warnings) {
              if (warnings.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(RLSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    border: Border.all(color: AppColors.border),
                    borderRadius: RLRadius.borderLg,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: RLSpacing.sm),
                      Text(
                        'No warnings recorded for this ride.',
                        style: RLText.bodySm
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              final sorted = List<WarningEventModel>.from(warnings)
                ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

              return Column(
                children: [
                  for (int i = 0; i < sorted.length; i++)
                    _WarningTimelineRow(
                      warning: sorted[i],
                      routePoints: routePoints,
                      onFocusRequested: onFocusRequested,
                      isLast: i == sorted.length - 1,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: RLRadius.borderLg,
      ),
    );
  }
}

class _WarningTimelineRow extends StatelessWidget {
  const _WarningTimelineRow({
    required this.warning,
    required this.routePoints,
    required this.onFocusRequested,
    required this.isLast,
  });

  final WarningEventModel warning;
  final List<RoutePointModel> routePoints;
  final void Function(LatLng location) onFocusRequested;
  final bool isLast;

  IconData get _icon {
    switch (warning.type) {
      case 'overspeed':
        return Icons.speed_rounded;
      case 'cooldown':
        return Icons.thermostat_rounded;
      case 'low_fuel':
        return Icons.local_gas_station_rounded;
      case 'oil_change_due':
        return Icons.build_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color get _color {
    switch (warning.type) {
      case 'overspeed':
        return AppColors.error;
      case 'cooldown':
        return AppColors.amber;
      case 'low_fuel':
        return AppColors.olive;
      case 'oil_change_due':
        return AppColors.slate;
      default:
        return AppColors.amber;
    }
  }

  String get _timeLabel {
    final t = warning.timestamp;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get _typeLabel {
    return warning.type
        .split('_')
        .map((part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  RoutePointModel? get _closestPoint {
    if (routePoints.isEmpty) return null;

    RoutePointModel? nearest;
    var minGapSeconds = 1 << 30;

    for (final point in routePoints) {
      final gap =
          (point.timestamp.difference(warning.timestamp).inSeconds).abs();
      if (gap < minGapSeconds) {
        minGapSeconds = gap;
        nearest = point;
      }
    }

    return nearest;
  }

  String get _locationLabel {
    final nearest = _closestPoint;
    if (nearest == null) return 'Location unavailable';
    return '${nearest.latitude.toStringAsFixed(5)}, ${nearest.longitude.toStringAsFixed(5)}';
  }

  @override
  Widget build(BuildContext context) {
    final closestPoint = _closestPoint;
    final canFocus = closestPoint != null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 16),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: _color),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(width: 1, color: AppColors.border),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: RLSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: RLSpacing.sm, bottom: isLast ? 0 : RLSpacing.base),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.bgCardHigh,
                      borderRadius: RLRadius.borderMd,
                    ),
                    child: Icon(_icon, size: 18, color: _color),
                  ),
                  const SizedBox(width: RLSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warning.message,
                          style: RLText.bodySm
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Type: $_typeLabel',
                          style: RLText.labelMd
                              .copyWith(color: AppColors.textMuted),
                        ),
                        if (warning.speedKmh != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${warning.speedKmh!.toStringAsFixed(1)} km/h',
                            style: RLText.labelMd
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          _locationLabel,
                          style: RLText.labelMd
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: canFocus ? 'Show on map' : 'Location unavailable',
                    onPressed: canFocus
                        ? () => onFocusRequested(
                              LatLng(
                                closestPoint.latitude,
                                closestPoint.longitude,
                              ),
                            )
                        : null,
                    icon: const Icon(Icons.my_location_rounded, size: 18),
                    color: AppColors.amber,
                    disabledColor: AppColors.textMuted,
                    constraints:
                        const BoxConstraints.tightFor(width: 28, height: 28),
                    padding: EdgeInsets.zero,
                    splashRadius: 16,
                  ),
                  const SizedBox(width: RLSpacing.xs),
                  Text(
                    _timeLabel,
                    style: RLText.labelSm.copyWith(color: AppColors.textMuted),
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
