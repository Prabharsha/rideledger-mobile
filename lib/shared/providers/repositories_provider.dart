import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_bike_datasource.dart';
import '../../data/datasources/local_rides_datasource.dart';
import '../../data/datasources/local_fuel_datasource.dart';
import '../../data/datasources/local_maintenance_datasource.dart';
import '../../data/datasources/local_retention_datasource.dart';
import '../../data/datasources/local_notification_datasource.dart';
import '../../data/repositories/bike_repository.dart';
import '../../data/repositories/rides_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/maintenance_repository.dart';
import '../../data/repositories/retention_repository.dart';
import '../../data/repositories/notification_repository.dart';

/// Bike repository provider
final bikeRepositoryProvider = Provider<BikeRepository>((ref) {
  return BikeRepository(
    localDatasource: LocalBikeDatasource(),
  );
});

/// Rides repository provider
final ridesRepositoryProvider = Provider<RidesRepository>((ref) {
  return RidesRepository(
    localDatasource: LocalRidesDatasource(),
  );
});

/// Fuel repository provider
final fuelRepositoryProvider = Provider<FuelRepository>((ref) {
  return FuelRepository(
    localDatasource: LocalFuelDatasource(),
  );
});

/// Maintenance repository provider
final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepository(
    localDatasource: LocalMaintenanceDatasource(),
  );
});

/// Retention policy repository provider
final retentionRepositoryProvider = Provider<RetentionRepository>((ref) {
  return RetentionRepository(
    localDatasource: LocalRetentionDatasource(),
  );
});

/// Notification schedule repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    localDatasource: LocalNotificationDatasource(),
  );
});
