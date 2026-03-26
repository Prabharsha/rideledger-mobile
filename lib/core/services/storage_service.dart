import 'package:isar/isar.dart';
import '../../data/models/bike_profile_model.dart';
import '../../data/models/ride_session_model.dart';
import '../../data/models/fuel_log_model.dart';
import '../../data/models/route_point_model.dart';
import '../../data/models/maintenance_reminder_model.dart';
import '../../data/models/warning_event_model.dart';
import '../../data/models/retention_policy_model.dart';
import '../../data/models/notification_schedule_model.dart';

/// Service for initializing and managing Isar database
class StorageService {
  static late final Isar _isar;

  /// Initialize Isar database
  static Future<void> initialize() async {
    _isar = await Isar.open([
      BikeProfileModelSchema,
      RideSessionModelSchema,
      FuelLogModelSchema,
      RoutePointModelSchema,
      MaintenanceReminderModelSchema,
      WarningEventModelSchema,
      RetentionPolicyModelSchema,
      NotificationScheduleModelSchema,
    ]);
  }

  /// Get Isar instance
  static Isar getInstance() {
    return _isar;
  }

  /// Close Isar database
  static Future<void> close() async {
    await _isar.close();
  }

  /// Clear all data (dev/testing only)
  static Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.bikeProfileModels.clear();
      await _isar.rideSessionModels.clear();
      await _isar.fuelLogModels.clear();
      await _isar.routePointModels.clear();
      await _isar.maintenanceReminderModels.clear();
      await _isar.warningEventModels.clear();
      await _isar.retentionPolicyModels.clear();
      await _isar.notificationScheduleModels.clear();
    });
  }
}

/// Extension on Isar for easier access to collections
extension IsarCollections on Isar {
  IsarCollection<BikeProfileModel> get bikeProfileModels =>
      collection<BikeProfileModel>();

  IsarCollection<RideSessionModel> get rideSessionModels =>
      collection<RideSessionModel>();

  IsarCollection<FuelLogModel> get fuelLogModels =>
      collection<FuelLogModel>();

  IsarCollection<RoutePointModel> get routePointModels =>
      collection<RoutePointModel>();

  IsarCollection<MaintenanceReminderModel> get maintenanceReminderModels =>
      collection<MaintenanceReminderModel>();

  IsarCollection<WarningEventModel> get warningEventModels =>
      collection<WarningEventModel>();

  IsarCollection<RetentionPolicyModel> get retentionPolicyModels =>
      collection<RetentionPolicyModel>();

  IsarCollection<NotificationScheduleModel> get notificationScheduleModels =>
      collection<NotificationScheduleModel>();
}
