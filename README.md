# RideLedger - TW200 Break-In Assistant + Fuel Quota Manager

A production-quality Flutter mobile app for tracking engine break-in, fuel quota management, and ride statistics for a 2017 Yamaha TW200 in Sri Lanka.

## 🏍️ Features

- **Engine Break-In Tracking**: Automatic stage detection (0-1000 km) with recommended speed/gear guidance
- **Fuel Quota Management**: Weekly Sri Lankan fuel quota tracking with projections
- **Live Riding Dashboard**: Large speed display, break-in stage, recommended gear, warnings
- **Ride History**: Complete ride history with routes, duration, distance, fuel estimates
- **Route Mapping**: GPS tracking, route visualization, historical route playback
- **Maintenance Reminders**: Track oil changes, spark plug checks, and other maintenance items
- **Reports & Export**: CSV, PDF, and JSON export of riding/fuel/break-in data
- **Offline-First**: All data stored locally (Isar), no backend required

## 🚀 Getting Started

### Prerequisites
- Flutter 3.16.0 or higher
- Dart 3.0.0 or higher
- Android Studio or VS Code
- Physical Android device or emulator

### Installation

1. **Clone the repo** (or extract the provided folder)
```bash
cd RideLedger
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Generate code** (models, serialization, etc)
```bash
flutter pub run build_runner build
```

4. **Run the app**
```bash
flutter run
```

Or run on a specific device:
```bash
flutter run -d <device_id>
```

## 📁 Project Structure

```
lib/
├── core/                      # Constants, theme, utilities, services
│   ├── constants/             # App-wide constants
│   ├── theme/                 # Material3 theme definitions
│   ├── extensions/            # Dart extension methods
│   ├── utils/                 # Business logic utilities
│   └── services/              # Core services (Isar, location, etc)
│
├── data/                      # Data layer (models, repositories)
│   ├── models/                # Isar & JSON models
│   ├── datasources/           # Local data access
│   └── repositories/          # Data access abstractions
│
├── domain/                    # Domain layer (entities, use cases)
│   ├── entities/              # Business entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases
│
├── features/                  # Feature modules
│   ├── onboarding/            # Initial setup flow
│   ├── dashboard/             # Home & live riding screens
│   ├── break_in/              # Break-in info & planning
│   ├── fuel/                  # Fuel quota & planning
│   ├── rides/                 # Active ride & tracking
│   ├── history/               # Ride history & details
│   ├── maintenance/           # Maintenance tracking
│   ├── reports/               # Data export
│   └── settings/              # App configuration
│
├── shared/                    # Shared widgets, providers, routing
│   ├── widgets/               # Reusable UI components
│   ├── providers/             # Riverpod providers
│   └── routing/               # Navigation configuration
│
├── main.dart                  # App entry point
└── pubspec.yaml               # Dependencies

```

## 🛠️ Architecture

**Clean Architecture** with clear separation of concerns:
- **Presentation Layer**: Screens, widgets, Riverpod state
- **Data Layer**: Models, repositories, local persistence (Isar)
- **Domain Layer**: Business logic, use cases, entities

**State Management**: Riverpod with providers for:
- Global state (bike profile, app lifecycle)
- Feature state (active ride, fuel balance)
- Async state (ride history, fuel logs)

**Navigation**: GoRouter with named routes

**Local Persistence**: Isar database with indexing for fast queries

## 📦 Key Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **isar**: Local database
- **geolocator**: GPS & location
- **flutter_map**: Route visualization
- **fl_chart**: Charts and analytics
- **csv/pdf**: Export formats
- **wakelock_plus**: Screen-on during rides

See `pubspec.yaml` for all dependencies.

## 🚴 How to Use

### 1. **Onboarding** (First Launch)
- Configure bike model and rebuild date
- Select break-in profile (conservative/balanced/aggressive)
- Enter weekly fuel quota and commute details
- Set current fuel economy

### 2. **Live Riding Dashboard**
- Tap "Start Ride" to begin tracking
- Watch large speed display and break-in progress
- Follow recommended gear guidance
- Heed warnings (overspeed, traffic heat, low fuel)
- Tap "End Ride" to save session

### 3. **View History**
- Browse all rides with maps and statistics
- Filter by date, stage, traffic stress
- View detailed route on flutter_map
- Export individual rides

### 4. **Manage Fuel**
- Log refuels with odometer & liters
- View weekly usage and remaining quota
- Check projected range
- Plan extra break-in rides within quota

### 5. **Track Maintenance**
- Mark maintenance items as complete
- Monitor progress toward oil change milestones
- Review completion history

### 6. **Export Reports**
- Generate CSV/PDF/JSON reports
- Export single rides or full history
- Share via email, messaging, etc.

## 🔧 Development

### Adding a New Screen

1. Create feature folder under `lib/features/`
2. Add `screens/`, `widgets/`, `providers/` subdirs
3. Create screen widget (stateless + Riverpod)
4. Create providers for business logic
5. Add route to `lib/shared/routing/app_router.dart`
6. Import screen and wire up GoRouter

Example pattern:
```dart
// screens/my_feature_screen.dart
class MyFeatureScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myDataProvider);
    return data.when(
      data: (value) => MyContent(value: value),
      loading: () => const LoadingIndicator(),
      error: (err, st) => ErrorWidget(error: err),
    );
  }
}
```

### Adding Business Logic

Create providers in feature's `providers/` folder:
```dart
// Sync provider for simple calculations
final myCalculationProvider = Provider<double>((ref) {
  return someCalculation();
});

// Async provider for database queries
final myDataProvider = FutureProvider<List<Data>>((ref) {
  final repo = ref.watch(myRepositoryProvider);
  return await repo.fetchData();
});

// State provider for mutable state
final myStateProvider = StateProvider<int>((ref) => 0);
```

### Code Generation

After modifying Isar models:
```bash
flutter pub run build_runner build
```

This generates:
- `.g.dart` Isar schemas
- `.g.dart` JSON serialization code

### Testing

Run tests (add in `test/` folder):
```bash
flutter test
```

## 📝 Development Notes

### GPS & Location
- Uses geolocator for real GPS
- Stream updates every 1 second during active ride
- Falls back to GPS simulation in testing

### Route Storage
- Routes stored efficiently (sampled every 5 seconds or 50m)
- Use encoded polyline for compression
- Delete old routes to manage storage

### Break-In Calculation
- Based on: `rebuildStartOdometerKm + totalRiddenKm`
- Stages auto-update as you ride
- No RPM integration in v1 (reserved for v2)

### Fuel Quota Logic
- Weekly reset on configured day (default Monday)
- Used fuel = sum of ride estimates + manual refuel logs
- Remaining = quota - used (never negative)
- Projected range = remaining * km/L

### Traffic Stress Detection
- Analyzes speed patterns, stop-go cycles, duration
- Classifies ride as Easy/Acceptable/Stressful
- Used to suggest cooldown breaks

## 🐛 Debugging

### Enable debug logging
```bash
flutter run -v
```

### Check Isar database
```dart
final isar = StorageService.getInstance();
final profiles = await isar.bikeProfileModels.where().findAll();
print(profiles);
```

### Clear all data (dev only)
```dart
await StorageService.clearAll();
```

## 🔮 Future Enhancements (v2+)

- **RPM Integration**: Bluetooth tachometer connection for real RPM display
- **Gear Detection**: Accurate gear from RPM + speed combo
- **Advanced Analytics**: Engine stress heatmaps, ideal operating ranges
- **Weather Integration**: Wind, temperature, conditions logging
- **Social Features**: Ride sharing, community tips
- **Cloud Sync**: Optional backup to cloud
- **Smartwatch Support**: WearOS integration

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for detailed roadmap.

## 📄 License

This project is proprietary software for personal use.

## 🤝 Contributing

This is a personal project. For modifications or enhancements, please discuss directly.

## 📧 Contact

For questions or feedback, contact the developer.

---

**Happy Riding!** 🏍️

Remember: Respect your newly rebuilt engine, follow the break-in recommendations, and stay within Sri Lanka's fuel quota. Safe travels!
