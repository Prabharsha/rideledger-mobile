import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database
  await StorageService.initialize();

  // Initialize local notifications
  await NotificationService.initialize();

  // Prevent app from sleeping during rides (controlled by tracking mode)
  await WakelockPlus.enable();

  runApp(
    const ProviderScope(
      child: RideLedgerApp(),
    ),
  );
}

class RideLedgerApp extends StatelessWidget {
  const RideLedgerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RideLedger',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
