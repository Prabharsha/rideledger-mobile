/// Route path constants
class RoutePaths {
  // Onboarding
  static const String onboarding = '/onboarding';
  static const String bikeSetup = '/onboarding/bike-setup';
  static const String breakInProfile = '/onboarding/break-in-profile';
  static const String fuelConfig = '/onboarding/fuel-config';
  static const String commuteSetup = '/onboarding/commute-setup';

  // Main app
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String rideDashboard = '/ride-dashboard';

  // Rides
  static const String rideHistory = '/history';
  static const String rideDetail = '/history/:rideId';
  static const String routeMap = '/history/:rideId/map';

  // Fuel
  static const String fuelDashboard = '/fuel';
  static const String refuelLog = '/fuel/log';
  static const String addRefuel = '/fuel/add';

  // Break-in
  static const String breakInInfo = '/break-in';
  static const String breakInPlanner = '/break-in/planner';
  static const String stageDetail = '/break-in/stage/:stage';

  // Maintenance
  static const String maintenance = '/maintenance';

  // Reports
  static const String reports = '/reports';

  // Settings
  static const String settings = '/settings';
  static const String storageManagement = '/settings/storage';
  static const String notificationSettings = '/settings/notifications';
  static const String trackingModeSettings = '/settings/tracking-mode';
}
