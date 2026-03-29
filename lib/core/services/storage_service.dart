import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
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
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        BikeProfileModelSchema,
        RideSessionModelSchema,
        FuelLogModelSchema,
        RoutePointModelSchema,
        MaintenanceReminderModelSchema,
        WarningEventModelSchema,
        RetentionPolicyModelSchema,
        NotificationScheduleModelSchema,
      ],
      directory: dir.path,
    );
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
      await _isar.collection<BikeProfileModel>().clear();
      await _isar.collection<RideSessionModel>().clear();
      await _isar.collection<FuelLogModel>().clear();
      await _isar.collection<RoutePointModel>().clear();
      await _isar.collection<MaintenanceReminderModel>().clear();
      await _isar.collection<WarningEventModel>().clear();
      await _isar.collection<RetentionPolicyModel>().clear();
      await _isar.collection<NotificationScheduleModel>().clear();
    });
  }
}
