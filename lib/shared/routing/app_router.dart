import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_paths.dart';

// Feature screens - import as they are created
// import '../../features/onboarding/screens/onboarding_screen.dart';
// import '../../features/dashboard/screens/home_dashboard_screen.dart';
// import '../../features/dashboard/screens/ride_dashboard_screen.dart';
// import '../../features/history/screens/history_list_screen.dart';
// import '../../features/settings/screens/storage_management_screen.dart';
// import '../../features/settings/screens/notification_settings_screen.dart';
// import '../../features/settings/screens/tracking_mode_settings_screen.dart';

/// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: RoutePaths.dashboard,
          name: 'dashboard',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: RoutePaths.rideDashboard,
          name: 'rideDashboard',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: RoutePaths.rideHistory,
          name: 'rideHistory',
          builder: (context, state) => const Placeholder(),
          routes: [
            GoRoute(
              path: ':rideId',
              name: 'rideDetail',
              builder: (context, state) {
                final rideId = state.pathParameters['rideId']!;
                return Placeholder();
              },
              routes: [
                GoRoute(
                  path: 'map',
                  name: 'routeMap',
                  builder: (context, state) {
                    final rideId = state.pathParameters['rideId']!;
                    return Placeholder();
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.fuelDashboard,
          name: 'fuelDashboard',
          builder: (context, state) => const Placeholder(),
          routes: [
            GoRoute(
              path: 'log',
              name: 'refuelLog',
              builder: (context, state) => const Placeholder(),
            ),
            GoRoute(
              path: 'add',
              name: 'addRefuel',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.breakInInfo,
          name: 'breakInInfo',
          builder: (context, state) => const Placeholder(),
          routes: [
            GoRoute(
              path: 'planner',
              name: 'breakInPlanner',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.maintenance,
          name: 'maintenance',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: RoutePaths.reports,
          name: 'reports',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: RoutePaths.settings,
          name: 'settings',
          builder: (context, state) => const Placeholder(),
          routes: [
            GoRoute(
              path: 'storage',
              name: 'storageManagement',
              builder: (context, state) => const Placeholder(),
              // Replace with: StorageManagementScreen()
            ),
            GoRoute(
              path: 'notifications',
              name: 'notificationSettings',
              builder: (context, state) => const Placeholder(),
              // Replace with: NotificationSettingsScreen()
            ),
            GoRoute(
              path: 'tracking-mode',
              name: 'trackingModeSettings',
              builder: (context, state) => const Placeholder(),
              // Replace with: TrackingModeSettingsScreen()
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      name: 'onboarding',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: 'bike-setup',
          name: 'bikeSetup',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: 'break-in-profile',
          name: 'breakInProfile',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: 'fuel-config',
          name: 'fuelConfig',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: 'commute-setup',
          name: 'commuteSetup',
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
