/// Duration formatting extensions
extension DurationExtension on Duration {
  /// Format duration as "1h 23m 45s"
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format duration as "1:23:45"
  String toHmsString() {
    final hours = inHours.toString().padLeft(1, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    if (inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  /// Format duration as "23m 45s"
  String toMinutesSecondString() {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }
}
