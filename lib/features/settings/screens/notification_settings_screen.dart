import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/notification_schedule_model.dart';
import '../../../shared/providers/notification_provider.dart';

/// Full-featured notification settings screen.
///
/// Shows notification categories with toggles, upcoming notifications with
/// action buttons (snooze, reschedule, complete, delete), and a FAB to add
/// custom reminders.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  TimeOfDay _defaultReminderTime = const TimeOfDay(hour: 8, minute: 0);
  final Set<int> _selectedWeekdays = {DateTime.monday};

  static const _categories = [
    'service',
    'maintenance',
    'break_in_milestone',
    'oil_change',
    'fuel_quota_reset',
    'custom',
  ];

  static const _weekdayLabels = {
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  // ---------------------------------------------------------------------------
  // Icon helper
  // ---------------------------------------------------------------------------

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'service':
        return Icons.build;
      case 'maintenance':
        return Icons.engineering;
      case 'break_in_milestone':
        return Icons.flag;
      case 'oil_change':
        return Icons.oil_barrel;
      case 'fuel_quota_reset':
        return Icons.local_gas_station;
      case 'custom':
        return Icons.notifications;
      default:
        return Icons.notifications_none;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final allSchedules = ref.watch(allNotificationSchedulesProvider);
    final upcoming = ref.watch(upcomingNotificationsProvider);
    final managerState = ref.watch(notificationManagerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomReminderSheet(context),
        icon: const Icon(Icons.add_alarm),
        label: const Text('Add Reminder'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allNotificationSchedulesProvider);
          ref.invalidate(upcomingNotificationsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Processing indicator
            if (managerState.isProcessing)
              const LinearProgressIndicator(),

            // Error banner
            if (managerState.lastError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      managerState.lastError!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),

            // ------ Notification Categories Card ------
            _buildCategoriesCard(theme, allSchedules),
            const SizedBox(height: 16),

            // ------ Default Reminder Time Card ------
            _buildDefaultTimeCard(theme),
            const SizedBox(height: 16),

            // ------ Upcoming Notifications Card ------
            _buildUpcomingCard(theme, upcoming),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Categories Card
  // ---------------------------------------------------------------------------

  Widget _buildCategoriesCard(
    ThemeData theme,
    AsyncValue<List<NotificationScheduleModel>> allSchedules,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Categories',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            allSchedules.when(
              data: (schedules) {
                return Column(
                  children: _categories.map((cat) {
                    final countActive = schedules
                        .where((s) =>
                            s.category == cat &&
                            s.enabled &&
                            !s.completed)
                        .length;
                    final anyEnabled = schedules
                        .where((s) => s.category == cat)
                        .any((s) => s.enabled);

                    return ListTile(
                      leading: Icon(
                        _iconForCategory(cat),
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        NotificationScheduleModel.getCategoryLabel(cat),
                      ),
                      subtitle: Text('$countActive active'),
                      trailing: Switch(
                        value: anyEnabled,
                        onChanged: (value) =>
                            _toggleCategory(cat, value, schedules),
                      ),
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                'Failed to load categories: $e',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCategory(
    String category,
    bool enabled,
    List<NotificationScheduleModel> schedules,
  ) async {
    final manager = ref.read(notificationManagerProvider.notifier);
    final inCategory =
        schedules.where((s) => s.category == category).toList();
    for (final s in inCategory) {
      if (s.enabled != enabled) {
        await manager.toggleEnabled(s.notificationId);
      }
    }
    ref.invalidate(allNotificationSchedulesProvider);
    ref.invalidate(upcomingNotificationsProvider);
  }

  // ---------------------------------------------------------------------------
  // Default Time Card
  // ---------------------------------------------------------------------------

  Widget _buildDefaultTimeCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default Reminder Time',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading:
                  Icon(Icons.access_time, color: theme.colorScheme.primary),
              title: const Text('Reminder Time'),
              subtitle: Text(_defaultReminderTime.format(context)),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _defaultReminderTime,
                );
                if (picked != null) {
                  setState(() => _defaultReminderTime = picked);
                }
              },
            ),
            const Divider(),
            Text(
              'Weekly Reminder Days',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _weekdayLabels.entries.map((entry) {
                final selected = _selectedWeekdays.contains(entry.key);
                return FilterChip(
                  label: Text(entry.value),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectedWeekdays.add(entry.key);
                      } else {
                        _selectedWeekdays.remove(entry.key);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Upcoming Notifications Card
  // ---------------------------------------------------------------------------

  Widget _buildUpcomingCard(
    ThemeData theme,
    AsyncValue<List<NotificationScheduleModel>> upcoming,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Notifications',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            upcoming.when(
              data: (schedules) {
                if (schedules.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No upcoming notifications',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the button below to add a reminder',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: schedules.map((s) {
                    return _buildNotificationTile(theme, s);
                  }).toList(),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                'Failed to load: $e',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
      ThemeData theme, NotificationScheduleModel schedule) {
    final isSnoozed = schedule.snoozed;
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');
    String triggerInfo;
    if (schedule.triggerType == 'date' && schedule.scheduledDate != null) {
      triggerInfo = dateFormat.format(schedule.scheduledDate!);
    } else if (schedule.triggerType == 'distance' &&
        schedule.triggerAtKm != null) {
      triggerInfo = '${schedule.triggerAtKm!.toStringAsFixed(0)} km';
    } else {
      triggerInfo = 'No trigger set';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSnoozed
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Icon(
            _iconForCategory(schedule.category),
            color: isSnoozed
                ? theme.colorScheme.outline
                : theme.colorScheme.primary,
          ),
          title: Text(
            schedule.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isSnoozed
                ? TextStyle(
                    color: theme.colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  )
                : null,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    schedule.triggerType == 'date'
                        ? Icons.calendar_today
                        : Icons.speed,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    triggerInfo,
                    style: theme.textTheme.bodySmall,
                  ),
                  if (isSnoozed) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.snooze,
                        size: 14, color: theme.colorScheme.outline),
                    const SizedBox(width: 2),
                    Text(
                      'Snoozed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            onSelected: (action) =>
                _handleAction(action, schedule),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'snooze',
                child: ListTile(
                  leading: Icon(Icons.snooze),
                  title: Text('Snooze'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (schedule.triggerType == 'date')
                const PopupMenuItem(
                  value: 'reschedule',
                  child: ListTile(
                    leading: Icon(Icons.edit_calendar),
                    title: Text('Reschedule'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuItem(
                value: 'complete',
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text('Mark Complete'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Delete',
                      style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _handleAction(String action, NotificationScheduleModel schedule) {
    switch (action) {
      case 'snooze':
        _showSnoozePicker(schedule);
        break;
      case 'reschedule':
        _showReschedulePicker(schedule);
        break;
      case 'complete':
        _showCompleteDialog(schedule);
        break;
      case 'delete':
        _showDeleteConfirmation(schedule);
        break;
    }
  }

  void _showSnoozePicker(NotificationScheduleModel schedule) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final options = <MapEntry<String, Duration>>[
          const MapEntry('15 minutes', Duration(minutes: 15)),
          const MapEntry('1 hour', Duration(hours: 1)),
          const MapEntry('3 hours', Duration(hours: 3)),
          MapEntry('Tomorrow morning (8 AM)',
              NotificationService.snoozeTomorrowMorning),
          MapEntry('Next week', NotificationService.snoozeNextWeek),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Snooze "${schedule.title}"',
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              ...options.map((entry) => ListTile(
                    leading: const Icon(Icons.snooze),
                    title: Text(entry.key),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      ref
                          .read(notificationManagerProvider.notifier)
                          .snooze(schedule.notificationId, entry.value);
                      _refreshProviders();
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showReschedulePicker(NotificationScheduleModel schedule) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: schedule.scheduledDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: schedule.scheduledDate != null
          ? TimeOfDay.fromDateTime(schedule.scheduledDate!)
          : _defaultReminderTime,
    );
    if (pickedTime == null || !mounted) return;

    final newDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    ref
        .read(notificationManagerProvider.notifier)
        .reschedule(schedule.notificationId, newDate);
    _refreshProviders();
  }

  void _showCompleteDialog(NotificationScheduleModel schedule) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Mark Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mark "${schedule.title}" as completed?'),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Add any notes about this task...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                final notes = notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim();
                ref
                    .read(notificationManagerProvider.notifier)
                    .markComplete(schedule.notificationId, notes: notes);
                _refreshProviders();
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(NotificationScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Reminder'),
          content: Text(
            'Permanently delete "${schedule.title}"? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                ref
                    .read(notificationManagerProvider.notifier)
                    .deleteReminder(schedule.notificationId);
                _refreshProviders();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Add Custom Reminder Bottom Sheet
  // ---------------------------------------------------------------------------

  void _showAddCustomReminderSheet(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final kmController = TextEditingController();
    final notesController = TextEditingController();

    String triggerType = 'date';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = _defaultReminderTime;
    String priority = 'normal';
    bool recurring = false;
    String recurringInterval = 'weekly';
    int recurringIntervalKm = 500;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'New Custom Reminder',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g., Chain lubrication',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Body
                    TextField(
                      controller: bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Details about this reminder...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Trigger type selector
                    Text(
                      'Trigger Type',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'date',
                          label: Text('Date'),
                          icon: Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: 'distance',
                          label: Text('Distance'),
                          icon: Icon(Icons.speed),
                        ),
                      ],
                      selected: {triggerType},
                      onSelectionChanged: (set) {
                        setSheetState(() => triggerType = set.first);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Date picker (date-based)
                    if (triggerType == 'date') ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_month),
                        title: Text(DateFormat('MMM d, yyyy')
                            .format(selectedDate)),
                        subtitle: Text(selectedTime.format(ctx)),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 2)),
                          );
                          if (date != null) {
                            setSheetState(() => selectedDate = date);
                          }
                          if (!context.mounted) return;
                          final time = await showTimePicker(
                            context: ctx,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setSheetState(() => selectedTime = time);
                          }
                        },
                      ),
                    ],

                    // Km input (distance-based)
                    if (triggerType == 'distance') ...[
                      TextField(
                        controller: kmController,
                        decoration: const InputDecoration(
                          labelText: 'Trigger at (km)',
                          hintText: 'Total km since rebuild',
                          border: OutlineInputBorder(),
                          suffixText: 'km',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Priority
                    Text(
                      'Priority',
                      style: Theme.of(ctx).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'low', label: Text('Low')),
                        ButtonSegment(
                            value: 'normal', label: Text('Normal')),
                        ButtonSegment(
                            value: 'high', label: Text('High')),
                      ],
                      selected: {priority},
                      onSelectionChanged: (set) {
                        setSheetState(() => priority = set.first);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Recurring toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Recurring'),
                      subtitle:
                          const Text('Repeat after completion'),
                      value: recurring,
                      onChanged: (v) {
                        setSheetState(() => recurring = v);
                      },
                    ),

                    if (recurring) ...[
                      if (triggerType == 'date') ...[
                        DropdownButtonFormField<String>(
                          initialValue: recurringInterval,
                          decoration: const InputDecoration(
                            labelText: 'Repeat Interval',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'daily', child: Text('Daily')),
                            DropdownMenuItem(
                                value: 'weekly',
                                child: Text('Weekly')),
                            DropdownMenuItem(
                                value: 'monthly',
                                child: Text('Monthly')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setSheetState(
                                  () => recurringInterval = v);
                            }
                          },
                        ),
                      ],
                      if (triggerType == 'distance') ...[
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Repeat every (km)',
                            hintText: 'e.g., 500',
                            border: OutlineInputBorder(),
                            suffixText: 'km',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            final parsed = int.tryParse(v);
                            if (parsed != null) {
                              recurringIntervalKm = parsed;
                            }
                          },
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],

                    // Notes
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Save
                    FilledButton.icon(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                content: Text('Title is required')),
                          );
                          return;
                        }

                        DateTime? scheduledDate;
                        double? triggerAtKm;

                        if (triggerType == 'date') {
                          scheduledDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        } else {
                          triggerAtKm =
                              double.tryParse(kmController.text);
                          if (triggerAtKm == null) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Enter a valid km value')),
                            );
                            return;
                          }
                        }

                        final notes =
                            notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim();

                        ref
                            .read(
                                notificationManagerProvider.notifier)
                            .createReminder(
                              category: 'custom',
                              title: titleController.text.trim(),
                              body: bodyController.text.trim().isEmpty
                                  ? titleController.text.trim()
                                  : bodyController.text.trim(),
                              triggerType: triggerType,
                              scheduledDate: scheduledDate,
                              triggerAtKm: triggerAtKm,
                              recurring: recurring,
                              recurringInterval:
                                  triggerType == 'date' && recurring
                                      ? recurringInterval
                                      : null,
                              recurringIntervalKm:
                                  triggerType == 'distance' &&
                                          recurring
                                      ? recurringIntervalKm
                                      : null,
                              priority: priority,
                              notes: notes,
                            );

                        Navigator.of(ctx).pop();
                        _refreshProviders();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Reminder created')),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Reminder'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _refreshProviders() {
    ref.invalidate(allNotificationSchedulesProvider);
    ref.invalidate(upcomingNotificationsProvider);
    ref.invalidate(activeNotificationsProvider);
  }
}
