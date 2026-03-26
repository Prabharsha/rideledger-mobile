import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ride_session_model.dart';
import 'repositories_provider.dart';

/// Provider for all ride sessions
final allRideSessionsProvider =
    FutureProvider<List<RideSessionModel>>((ref) async {
  final ridesRepository = ref.watch(ridesRepositoryProvider);
  return await ridesRepository.getAllRideSessions();
});

/// Provider for total ridden km
final totalRiddenKmProvider = FutureProvider<double>((ref) async {
  final ridesRepository = ref.watch(ridesRepositoryProvider);
  return await ridesRepository.getTotalDistance();
});

/// Provider for total fuel used (estimated)
final totalFuelUsedProvider = FutureProvider<double>((ref) async {
  final ridesRepository = ref.watch(ridesRepositoryProvider);
  return await ridesRepository.getTotalFuelUsed();
});

/// Provider for ride count
final rideCountProvider = FutureProvider<int>((ref) async {
  final ridesRepository = ref.watch(ridesRepositoryProvider);
  return await ridesRepository.getRideCount();
});

/// Provider for recent rides (last 10)
final recentRidesProvider = FutureProvider<List<RideSessionModel>>((ref) async {
  final rides = await ref.watch(allRideSessionsProvider.future);
  return rides.take(10).toList();
});

/// Provider for rides by date range
final ridesByDateRangeProvider =
    FutureProvider.family<List<RideSessionModel>, DateRange>((ref, dateRange) async {
  final ridesRepository = ref.watch(ridesRepositoryProvider);
  return await ridesRepository.getRideSessionsByDateRange(
    dateRange.startDate,
    dateRange.endDate,
  );
});

/// Data class for date range
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });
}
