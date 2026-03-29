import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import 'route_paths.dart';

// ── Feature screens ────────────────────────────────────────────────────────
import '../../features/splash/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/history/screens/history_list_screen.dart';
import '../../features/ride_tracking/screens/ride_tracking_screen.dart';
import '../../features/fuel/screens/fuel_dashboard_screen.dart';
import '../../features/more/screens/more_screen.dart';
import '../../features/maintenance/screens/maintenance_screen.dart';
import '../../features/break_in/screens/break_in_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

/// Root GoRouter for RideLedger.
///
/// Structure:
///   /splash                 — SplashScreen (no shell)
///   ShellRoute (AppShell)   — bottom nav tabs
///     /                     — HomeScreen
///     /rides                — HistoryListScreen
///     /ride-tracking        — RideTrackingScreen
///     /fuel                 — FuelDashboardScreen
///     /more                 — MoreScreen
///   /maintenance            — MaintenanceScreen (no bottom nav)
///   /break-in               — BreakInScreen     (no bottom nav)
///   /reports                — ReportsScreen     (no bottom nav)
///   /settings               — SettingsScreen    (no bottom nav)
final goRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    // ── Splash ──────────────────────────────────────────────────────────────
    GoRoute(
      path: RoutePaths.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Shell — bottom navigation tabs ──────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        // Home
        GoRoute(
          path: RoutePaths.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Rides / ride history
        GoRoute(
          path: RoutePaths.rides,
          name: 'rides',
          builder: (context, state) => const HistoryListScreen(),
        ),

        // Active ride tracking
        GoRoute(
          path: RoutePaths.rideTracking,
          name: 'rideTracking',
          builder: (context, state) => const RideTrackingScreen(),
        ),

        // Fuel dashboard
        GoRoute(
          path: RoutePaths.fuel,
          name: 'fuel',
          builder: (context, state) => const FuelDashboardScreen(),
        ),

        // More hub
        GoRoute(
          path: RoutePaths.more,
          name: 'more',
          builder: (context, state) => const MoreScreen(),
        ),
      ],
    ),

    // ── Workshop screens — accessed from More, no bottom nav ────────────────
    GoRoute(
      path: RoutePaths.maintenance,
      name: 'maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: RoutePaths.breakIn,
      name: 'breakIn',
      builder: (context, state) => const BreakInScreen(),
    ),
    GoRoute(
      path: RoutePaths.reports,
      name: 'reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],

  // ── Error fallback ────────────────────────────────────────────────────────
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF191B24),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFBF5A50),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEDEAE4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9A9892),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
