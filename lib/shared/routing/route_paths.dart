/// Route path constants
class RoutePaths {
  RoutePaths._();

  // Splash
  static const String splash = '/splash';

  // Shell tabs (bottom nav)
  static const String home = '/';
  static const String rides = '/rides';
  static const String rideTracking = '/ride-tracking';
  static const String fuel = '/fuel';
  static const String more = '/more';

  // History nested
  static const String rideDetail = '/rides/:rideId';

  // Workshop (accessed from More)
  static const String maintenance = '/maintenance';
  static const String breakIn = '/break-in';
  static const String reports = '/reports';
  static const String settings = '/settings';

  // Onboarding
  static const String onboarding = '/onboarding';
  static const String bikeSetup = '/onboarding/bike-setup';
  static const String breakInProfile = '/onboarding/break-in-profile';
  static const String fuelConfig = '/onboarding/fuel-config';
  static const String commuteSetup = '/onboarding/commute-setup';

  // Legacy (keep for reference)
  static const String dashboard = '/dashboard';
  static const String rideDashboard = '/ride-tracking';
  static const String rideHistory = '/rides';
  static const String fuelDashboard = '/fuel';
  static const String breakInInfo = '/break-in';
  static const String rideDetailLegacy = '/rides/:rideId';
  static const String routeMap = '/rides/:rideId/map';
  static const String refuelLog = '/fuel/log';
  static const String addRefuel = '/fuel/add';
  static const String breakInPlanner = '/break-in/planner';
  static const String stageDetail = '/break-in/stage/:stage';
  static const String reports2 = '/reports';
  static const String storageManagement = '/settings/storage';
  static const String notificationSettings = '/settings/notifications';
  static const String trackingModeSettings = '/settings/tracking-mode';
}
