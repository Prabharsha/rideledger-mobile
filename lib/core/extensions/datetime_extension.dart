/// DateTime formatting extensions
extension DateTimeExtension on DateTime {
  /// Format as "Mar 26, 2024"
  String toFormattedDate() {
    return '${_monthName(month)} ${day.toString().padLeft(2, '0')}, $year';
  }

  /// Format as "2024-03-26"
  String toIsoDate() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// Format as "14:30"
  String toFormattedTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format as "14:30:45"
  String toFormattedTimeWithSeconds() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  /// Format as "Mar 26, 14:30"
  String toFormattedDateAndTime() {
    return '${toFormattedDate()} ${toFormattedTime()}';
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get day of week name
  String get dayOfWeekName {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return names[weekday - 1];
  }

  /// Get short day of week name
  String get dayOfWeekShort {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  /// Get month name
  String get monthName {
    return _monthName(month);
  }

  static String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[month - 1];
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final days = weekday - 1;
    return subtract(Duration(days: days)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    final days = 7 - weekday;
    return add(Duration(days: days)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59);
  }
}
