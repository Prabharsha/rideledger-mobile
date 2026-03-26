# RideLedger - Implementation Guide

## ✅ Completed Phase 1 Scaffold

This document outlines what's been created and what still needs to be built.

### Core Files Created

#### 1. **Constants & Configuration**
- `lib/core/constants/break_in_stages.dart` - Break-in stage definitions
- `lib/core/constants/gear_mappings.dart` - Context-aware gear recommendations
- `lib/core/constants/app_colors.dart` - Color palette (light/dark/dashboard themes)
- `lib/core/constants/app_strings.dart` - UI strings and messages

#### 2. **Theme System**
- `lib/core/theme/app_theme.dart` - Material3 theme definitions for light/dark/dashboard modes

#### 3. **Utilities & Extensions**
- `lib/core/extensions/duration_extension.dart` - Duration formatting
- `lib/core/extensions/double_extension.dart` - Number formatting
- `lib/core/extensions/datetime_extension.dart` - Date/time utilities
- `lib/core/utils/fuel_calculator.dart` - Fuel math and projections
- `lib/core/utils/distance_calculator.dart` - Haversine distance, polyline simplification

#### 4. **Data Models (Isar + JSON)**
- `lib/data/models/bike_profile_model.dart` - Bike configuration
- `lib/data/models/ride_session_model.dart` - Ride data
- `lib/data/models/fuel_log_model.dart` - Refuel history
- `lib/data/models/route_point_model.dart` - GPS points
- `lib/data/models/maintenance_reminder_model.dart` - Maintenance tracking
- `lib/data/models/warning_event_model.dart` - Ride warnings

#### 5. **Data Layer**
- `lib/core/services/storage_service.dart` - Isar initialization & management
- `lib/data/datasources/local_*.dart` - Local datasources (4 files)
- `lib/data/repositories/*.dart` - Repository implementations (4 files)

#### 6. **Riverpod Providers**
- `lib/shared/providers/repositories_provider.dart` - Repository instances
- `lib/shared/providers/bike_profile_provider.dart` - Bike profile & onboarding state
- `lib/shared/providers/break_in_provider.dart` - Break-in stage calculations
- `lib/shared/providers/rides_provider.dart` - Ride history & statistics
- `lib/shared/providers/fuel_provider.dart` - Fuel quota & projections

#### 7. **Routing & Entry**
- `lib/shared/routing/route_paths.dart` - Route constants
- `lib/shared/routing/app_router.dart` - GoRouter configuration (scaffold with TODOs)
- `lib/main.dart` - App entry point
- `pubspec.yaml` - All dependencies configured

---

## 📋 Next Steps - What Still Needs to Be Built

### Phase 1 Continuation: UI Screens & Widgets

#### Shared Widgets (Priority 1)
Create `lib/shared/widgets/`:
- `app_scaffold.dart` - Base scaffold with bottom nav
- `custom_app_bar.dart` - App bar with theme toggle
- `custom_button.dart` - Styled buttons
- `custom_card.dart` - Card containers
- `section_header.dart` - Section titles
- `stat_display.dart` - Stat blocks (for speed, distance, etc)
- `loading_indicator.dart` - Loading spinner
- `empty_state_widget.dart` - Empty state UI

#### Onboarding Feature
Create `lib/features/onboarding/`:
- `screens/onboarding_screen.dart` - Welcome screen
- `screens/bike_setup_screen.dart` - Bike model/rebuild info (Step 1)
- `screens/break_in_profile_screen.dart` - Break-in conservative/balanced/aggressive (Step 2)
- `screens/fuel_config_screen.dart` - Weekly quota, current balance, reset date (Step 3)
- `screens/commute_setup_screen.dart` - One-way distance, days/week (Step 4)
- `providers/onboarding_provider.dart` - StateNotifier for multi-step form
- `widgets/step_indicator.dart` - Step progress display
- `widgets/setup_form_fields.dart` - Reusable form inputs

**Key Logic**:
- Save BikeProfileModel to Isar when onboarding complete
- Mark `isFirstLaunch = false`
- Navigate to dashboard on completion

#### Dashboard Feature (Home Screen)
Create `lib/features/dashboard/screens/home_dashboard_screen.dart`:
- Bottom navigation with 6 tabs: Dashboard, Breaks-In, Fuel, History, Maintenance, Settings
- Display quick stats: total km, fuel balance, break-in stage
- "Start Ride" button
- Maintenance alerts if due

#### Live Riding Dashboard
Create `lib/features/dashboard/screens/ride_dashboard_screen.dart`:
- **Priority**: Speed (huge center display, 80+ pt font, white on black)
- Break-in stage + progress bar (e.g., "Stage 2: 126/500 km")
- Recommended gear (from speed-based mapping + traffic detection)
- Stage max speed
- Single warning banner (red/yellow, highest priority alert)
- Ride timer
- Fuel remaining indicator
- Bottom sheet with ride controls (Start/Stop/Save)

Create supporting widgets:
- `lib/features/dashboard/widgets/speed_display.dart`
- `lib/features/dashboard/widgets/break_in_progress_indicator.dart`
- `lib/features/dashboard/widgets/recommended_gear_display.dart`
- `lib/features/dashboard/widgets/warning_banner.dart`
- `lib/features/dashboard/widgets/ride_timer.dart`
- `lib/features/dashboard/widgets/fuel_remaining_badge.dart`

Create providers:
- `lib/features/dashboard/providers/current_ride_provider.dart` - Active ride state (StateNotifier)
- `lib/features/dashboard/providers/speed_provider.dart` - Real-time speed from geolocator
- `lib/features/dashboard/providers/location_provider.dart` - GPS stream
- `lib/features/dashboard/providers/dashboard_state_provider.dart` - Dashboard UI state

#### Ride Tracking
Create `lib/features/rides/`:
- `screens/active_ride_screen.dart` - Screen while ride is running
- `screens/ride_summary_screen.dart` - Summary after ride ends
- `widgets/ride_control_panel.dart` - Start/Stop/Save buttons
- `widgets/ride_stats_card.dart` - Distance, duration, avg speed
- `widgets/cooldown_suggestion_banner.dart` - Cooldown alerts
- `providers/active_ride_provider.dart` - Track active ride state
- `providers/ride_tracking_provider.dart` - Location & distance calculations
- `providers/route_recorder_provider.dart` - Route points recording

**Key Logic**:
- On start ride: create RideSessionModel, begin GPS stream, record route points (every 5 sec or 50m)
- On stop ride: finalize session, save to Isar, detect overspeed/traffic stress
- Estimate fuel used: `distanceKm / fuelEconomyKmPerLiter`
- Save RideSessionModel + RoutePointModels + WarningEventModels

#### Break-In Feature
Create `lib/features/break_in/`:
- `screens/break_in_info_screen.dart` - Current stage info
- `screens/stage_detail_screen.dart` - Detailed stage info
- `screens/break_in_planner_screen.dart` - Projected dates to reach milestones
- `widgets/stage_card.dart` - Stage display card
- `widgets/progress_gauge.dart` - Visual progress gauge
- `widgets/stage_timeline.dart` - All stages timeline

**Key Logic**:
- Calculate current stage from: `rebuildStartOdometerKm + totalRiddenKm`
- Warn if speed exceeds stage max
- Show recommended gear and speed for stage

#### Fuel Feature
Create `lib/features/fuel/`:
- `screens/fuel_dashboard_screen.dart` - Weekly quota, remaining, projected range
- `screens/fuel_log_screen.dart` - List of refuels
- `screens/refuel_form_screen.dart` - Add new refuel entry
- `screens/fuel_stats_screen.dart` - Charts (fuel economy trend)
- `screens/fuel_planner_screen.dart` - Weekly commute + extra ride capacity
- `widgets/fuel_gauge.dart` - Circular fuel gauge
- `widgets/refuel_history_list.dart` - Recent refuels list
- `widgets/fuel_stats_chart.dart` - fl_chart integration
- `widgets/weekly_planner_card.dart` - Commute + extra ride summary
- `providers/fuel_balance_provider.dart` - Weekly balance calc
- `providers/fuel_economy_provider.dart` - Calculated or manual economy
- `providers/fuel_consumption_provider.dart` - Per-ride fuel estimate
- `providers/weekly_reset_provider.dart` - Week boundaries

**Key Logic**:
- Weekly reset on configured day (e.g., Monday)
- Used = sum of ride estimates + manual logs
- Remaining = quota - used
- Projected range = remaining * km/L

#### History Feature
Create `lib/features/history/`:
- `screens/history_list_screen.dart` - Paginated ride history with filters
- `screens/ride_detail_screen.dart` - Full ride info + map
- `screens/route_map_screen.dart` - Full-screen route display (flutter_map)
- `screens/daily_summary_screen.dart` - Today's summary
- `widgets/history_list_item.dart` - List tile for each ride
- `widgets/ride_map_widget.dart` - Embedded map preview
- `widgets/stats_summary_card.dart` - Ride statistics
- `widgets/filter_chip_group.dart` - Filter by date, stage, stress
- `providers/ride_history_provider.dart` - Filtered history
- `providers/ride_filters_provider.dart` - Filter state
- `providers/daily_summary_provider.dart` - Daily aggregate stats

**Key Logic**:
- Calculate traffic stress from: low-speed duration, stop-go cycles, overspeed events
- Compress route for storage (encoded polyline or simplified points)
- Show mini map preview using flutter_map

#### Maintenance Feature
Create `lib/features/maintenance/`:
- `screens/maintenance_dashboard_screen.dart` - Current reminders, completed history
- `screens/maintenance_detail_screen.dart` - Reminder details
- `screens/maintenance_form_screen.dart` - Mark complete
- `widgets/maintenance_card.dart` - Reminder card
- `widgets/maintenance_checklist.dart` - Checklist widget
- `widgets/oil_change_milestone.dart` - Oil change status
- `providers/maintenance_provider.dart` - Reminders list
- `providers/maintenance_due_provider.dart` - Due reminders only

**Key Logic**:
- Pre-populate reminders: oil change 1 @ 350km, oil change 2 @ 1000km
- Track completion date when marked done

---

### Phase 2: Route Mapping & Advanced Planning

Will include:
- Route simplification & polyline encoding
- Flutter_map integration for route display
- Ride detail screen with full analytics
- Break-in + fuel combined planner
- Multi-day/weekly planning

### Phase 3: Reports & Polish

Will include:
- CSV export (ride history, fuel logs, break-in progress)
- PDF export (formatted report with charts)
- JSON export (full data)
- Settings screen (theme, units, alerts)
- Voice alerts (audio beeps only, no TTS)
- Accessibility improvements

---

## 🚀 How to Continue

### 1. Run Code Generation
```bash
cd RideLedger
flutter pub get
flutter pub run build_runner build
```

This generates:
- `.g.dart` files for Isar models (schemas)
- `.g.dart` files for JSON serialization

### 2. Create Onboarding (First Priority)
Start with `onboarding_screen.dart` → `bike_setup_screen.dart` → etc.
Use Riverpod `StateNotifier` to track multi-step form state.

### 3. Test Data
Create `lib/core/utils/seed_data.dart` with sample bike profile, rides, and fuel logs for testing.

### 4. Implement Live Dashboard
Build speed display, then add break-in stage, gear, warnings, timer.
Use geolocator for real GPS (simulate with mock if needed).

### 5. Add Route Tracking
Record route points during ride, save to Isar, display on flutter_map.

### 6. Build History
Implement ride history with filtering, detail screens, and map preview.

### 7. Complete Fuel Management
Full fuel dashboard, refuel logging, weekly reset logic, planning.

---

## 📐 Architecture Pattern

All feature screens follow this pattern:

```
features/feature_name/
  screens/
    feature_screen.dart           # Main UI
  providers/
    feature_state_provider.dart   # StateNotifier or FutureProvider
  widgets/
    custom_widget_1.dart
    custom_widget_2.dart
```

Screens are stateless, use Riverpod for state.
Widgets are reusable UI components.
Providers manage business logic.

---

## 🔌 Extension Points for v2 (RPM Integration)

Key files marked with `// TODO: RPM Integration`:
- `lib/core/utils/gear_calculation.dart` - Accept optional RPM parameter
- `lib/features/break_in/providers/overspeed_warning_provider.dart` - Cross-check RPM/gear
- `lib/core/utils/traffic_stress_calculator.dart` - Use RPM load instead of speed proxy
- `lib/core/utils/fuel_calculator.dart` - Integrate RPM load curve

In v2, add:
- BLE service for tachometer connection
- RPM stream provider
- Real gear detection
- Accurate stress/load calculation

---

## 📚 Key Resources

- **Flutter docs**: https://docs.flutter.dev
- **Riverpod**: https://riverpod.dev
- **GoRouter**: https://pub.dev/packages/go_router
- **Isar**: https://isar.dev
- **flutter_map**: https://pub.dev/packages/flutter_map
- **fl_chart**: https://pub.dev/packages/fl_chart

---

## 📝 TODO Checklist for Phase 1

- [ ] Run `flutter pub run build_runner build` to generate models
- [ ] Create onboarding screens (5 files)
- [ ] Create home dashboard screen
- [ ] Create live riding dashboard with speed display
- [ ] Create ride start/stop logic
- [ ] Implement GPS tracking and route recording
- [ ] Create ride summary screen
- [ ] Create ride history list and detail screens
- [ ] Create break-in info screens
- [ ] Create fuel dashboard and refuel form
- [ ] Create maintenance screens
- [ ] Add seed data for testing
- [ ] Test end-to-end: Onboard → Ride → Save → View history

Good luck! 🏍️
