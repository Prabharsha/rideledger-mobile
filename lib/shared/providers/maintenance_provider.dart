import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/maintenance_reminder_model.dart';
import 'repositories_provider.dart';

/// All pending (not yet completed) maintenance reminders.
/// Shared between the Maintenance screen and the Home screen reminders widget.
final pendingRemindersProvider =
    FutureProvider<List<MaintenanceReminderModel>>((ref) async {
  return ref.watch(maintenanceRepositoryProvider).getPendingReminders();
});

/// All completed maintenance reminders.
final completedRemindersProvider =
    FutureProvider<List<MaintenanceReminderModel>>((ref) async {
  return ref.watch(maintenanceRepositoryProvider).getCompletedReminders();
});
