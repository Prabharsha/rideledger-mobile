/// App strings and messages
class AppStrings {
  // App info
  static const appName = 'RideLedger';
  static const appSubtitle = 'TW200 Break-In Assistant';

  // Onboarding
  static const onboardingTitle = 'Welcome to RideLedger';
  static const onboardingSubtitle = 'Let\'s set up your TW200 rebuild tracking';
  static const bikeSetupTitle = 'Bike Setup';
  static const breakInProfileTitle = 'Break-In Profile';
  static const fuelConfigTitle = 'Fuel Configuration';
  static const commuteSetupTitle = 'Commute Setup';
  static const continueButton = 'Continue';
  static const skipButton = 'Skip';
  static const finishButton = 'Start Riding';

  // Dashboard
  static const dashboardTitle = 'RideLedger';
  static const currentSpeed = 'Speed';
  static const recommendedGear = 'Recommended Gear';
  static const breakInProgress = 'Break-In Progress';
  static const estimatedRange = 'Est. Range';
  static const fuelRemaining = 'Fuel Remaining';

  // Warnings
  static const warningReduceSpeed = 'Reduce speed for break-in';
  static const warningShiftUp = 'Shift up';
  static const warningTrafficHeat = 'Traffic heat buildup risk';
  static const warningCooldown = 'Take a cooldown break soon';
  static const warningOilChangeDue = 'Oil change due soon';
  static const warningFuelLow = 'Weekly fuel quota low';
  static const warningOverspeed = 'Speed exceeds break-in limit';
  static const warningThermalWarm = 'Device warming up — consider Power Saver mode';
  static const warningThermalHot = 'Extended tracking — take a break to cool down';

  // Ride control
  static const startRide = 'Start Ride';
  static const endRide = 'End Ride';
  static const rideActive = 'Ride Active';
  static const ridePaused = 'Ride Paused';
  static const rideType = 'Ride Type';
  static const rideTypeCommute = 'Commute';
  static const rideTypeExtra = 'Extra Break-In';
  static const rideTypeCustom = 'Custom';

  // History
  static const rideHistory = 'Ride History';
  static const totalDistance = 'Total Distance';
  static const totalDuration = 'Total Duration';
  static const averageSpeed = 'Average Speed';
  static const maxSpeed = 'Max Speed';
  static const noRidesYet = 'No rides yet';

  // Fuel
  static const fuelDashboard = 'Fuel Dashboard';
  static const weeklyQuota = 'Weekly Quota';
  static const used = 'Used';
  static const remaining = 'Remaining';
  static const refuelLog = 'Refuel Log';
  static const addRefuel = 'Add Refuel';
  static const fuelEconomy = 'Fuel Economy';

  // Break-In
  static const breakInInfo = 'Break-In Info';
  static const stage = 'Stage';
  static const stageProgress = 'Stage Progress';
  static const nextMilestone = 'Next Milestone';
  static const recommendedSpeed = 'Recommended Speed';

  // Maintenance
  static const maintenance = 'Maintenance';
  static const oilChange1 = 'First Oil Change (350 km)';
  static const oilChange2 = 'Second Oil Change (1000 km)';
  static const sparkPlugCheck = 'Spark Plug Check';
  static const markComplete = 'Mark Complete';
  static const completed = 'Completed';

  // Reports
  static const reports = 'Reports';
  static const exportData = 'Export Data';
  static const exportCSV = 'Export as CSV';
  static const exportPDF = 'Export as PDF';
  static const exportJSON = 'Export as JSON';
  static const exporting = 'Exporting...';
  static const exportSuccess = 'Export successful';
  static const exportError = 'Export failed';

  // Settings
  static const settings = 'Settings';
  static const theme = 'Theme';
  static const themeLight = 'Light';
  static const themeDark = 'Dark';
  static const themeAuto = 'Auto (Sunrise/Sunset)';
  static const units = 'Units';
  static const alerts = 'Alerts';
  static const about = 'About';

  // Tracking Mode
  static const trackingMode = 'Tracking Mode';
  static const trackingModePowerSaver = 'Power Saver';
  static const trackingModePowerSaverDesc =
      'Minimal GPS usage. Best for battery life. Lower route accuracy.';
  static const trackingModeBalanced = 'Balanced';
  static const trackingModeBalancedDesc =
      'Good balance of accuracy and battery. Recommended for daily commutes.';
  static const trackingModeHighAccuracy = 'High Accuracy';
  static const trackingModeHighAccuracyDesc =
      'Maximum route precision. Higher battery and CPU usage.';
  static const batteryImpact = 'Battery Impact';
  static const thermalProtection = 'Thermal Protection';
  static const thermalProtectionDesc =
      'Automatically suggest breaks and reduce tracking intensity when device runs hot.';

  // Storage Management
  static const storageManagement = 'Storage Management';
  static const storageOverview = 'Storage Overview';
  static const storageUsed = 'Storage Used';
  static const rideSummaries = 'Ride Summaries';
  static const routeData = 'Route Data';
  static const warningData = 'Warning Data';
  static const fuelData = 'Fuel Data';
  static const retentionPolicy = 'Retention Policy';
  static const autoCleanup = 'Auto-Cleanup';
  static const autoCleanupDesc =
      'Automatically delete old data based on retention period.';
  static const retentionPeriod = 'Retention Period';
  static const deleteRouteDataOnly = 'Route Data Only';
  static const deleteRouteDataOnlyDesc =
      'Keep ride summaries but delete GPS route data to save space.';
  static const exportBeforeDelete = 'Export Before Delete';
  static const exportBeforeDeleteDesc =
      'Automatically export data before cleaning up.';
  static const cleanUpNow = 'Clean Up Now';
  static const deleteAllRouteData = 'Delete All Route Data';
  static const exportAllData = 'Export All Data';
  static const lastCleanup = 'Last Cleanup';
  static const cleanupResult = 'Cleanup Result';
  static const confirmCleanup = 'Confirm Cleanup';
  static const confirmCleanupMessage =
      'This will permanently delete data older than the retention period. This cannot be undone.';
  static const confirmDeleteRoutes = 'Confirm Delete Routes';
  static const confirmDeleteRoutesMessage =
      'This will delete all stored GPS route data. Ride summaries will be kept. This cannot be undone.';
  static const cleanupComplete = 'Cleanup complete';
  static const itemsDeleted = 'items deleted';
  static const spaceFreed = 'space freed';
  static const retentionOneWeek = '1 Week';
  static const retentionTwoWeeks = '2 Weeks';
  static const retentionOneMonth = '1 Month';
  static const retentionThreeMonths = '3 Months';
  static const retentionSixMonths = '6 Months';
  static const retentionOneYear = '1 Year';
  static const retentionForever = 'Forever';

  // Notifications
  static const notifications = 'Notifications';
  static const notificationSettings = 'Notification Settings';
  static const notificationCategories = 'Categories';
  static const serviceReminders = 'Service Reminders';
  static const maintenanceAlerts = 'Maintenance Alerts';
  static const breakInMilestones = 'Break-In Milestones';
  static const oilChangeReminders = 'Oil Change Reminders';
  static const fuelQuotaReset = 'Fuel Quota Reset';
  static const customReminders = 'Custom Reminders';
  static const defaultReminderTime = 'Default Reminder Time';
  static const upcomingNotifications = 'Upcoming';
  static const addCustomReminder = 'Add Reminder';
  static const snooze = 'Snooze';
  static const reschedule = 'Reschedule';
  static const snooze15Min = '15 minutes';
  static const snooze1Hour = '1 hour';
  static const snooze3Hours = '3 hours';
  static const snoozeTomorrow = 'Tomorrow morning';
  static const snoozeNextWeek = 'Next week';
  static const triggerTypeDate = 'Date';
  static const triggerTypeDistance = 'Distance (km)';
  static const priority = 'Priority';
  static const priorityLow = 'Low';
  static const priorityNormal = 'Normal';
  static const priorityHigh = 'High';
  static const recurring = 'Recurring';
  static const recurringInterval = 'Repeat Interval';
  static const recurringDaily = 'Daily';
  static const recurringWeekly = 'Weekly';
  static const recurringMonthly = 'Monthly';
  static const noUpcomingNotifications = 'No upcoming notifications';
  static const notificationSnoozed = 'Snoozed';
  static const notificationCompleted = 'Completed';
  static const notificationEnabled = 'Enabled';
  static const notificationDisabled = 'Disabled';

  // Common
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const add = 'Add';
  static const loading = 'Loading...';
  static const error = 'Error';
  static const success = 'Success';
  static const ok = 'OK';
  static const noData = 'No data available';
  static const confirm = 'Confirm';
  static const enable = 'Enable';
  static const disable = 'Disable';
  static const never = 'Never';
}
