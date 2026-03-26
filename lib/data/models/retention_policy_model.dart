// NOTE: After generating this file's .g.dart, add RetentionPolicyModelSchema
// to the Isar.open() call in StorageService.initialize()
// (lib/core/services/storage_service.dart).

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'retention_policy_model.g.dart';

/// Retention policy model for controlling automatic storage cleanup
@collection
@JsonSerializable()
class RetentionPolicyModel {
  RetentionPolicyModel();

  Id? id;

  late bool autoCleanupEnabled;
  late String retentionPeriod;
  late bool deleteRouteDataOnly;
  late bool exportBeforeDelete;
  late String exportFormat;
  late DateTime? lastCleanupDate;
  late int lastCleanupDeletedCount;
  late DateTime createdAt;
  late DateTime updatedAt;

  /// Valid retention period values
  static const List<String> retentionPeriods = [
    'one_week',
    'two_weeks',
    'one_month',
    'three_months',
    'six_months',
    'one_year',
    'forever',
  ];

  /// Valid export format values
  static const List<String> exportFormats = [
    'csv',
    'json',
    'pdf',
  ];

  /// Maps a retention period string to its corresponding Duration
  static Duration getRetentionDuration(String period) {
    switch (period) {
      case 'one_week':
        return const Duration(days: 7);
      case 'two_weeks':
        return const Duration(days: 14);
      case 'one_month':
        return const Duration(days: 30);
      case 'three_months':
        return const Duration(days: 90);
      case 'six_months':
        return const Duration(days: 180);
      case 'one_year':
        return const Duration(days: 365);
      case 'forever':
        return const Duration(days: 36500);
      default:
        return const Duration(days: 36500);
    }
  }

  /// Returns a human-readable label for a retention period string
  static String getRetentionLabel(String period) {
    switch (period) {
      case 'one_week':
        return '1 Week';
      case 'two_weeks':
        return '2 Weeks';
      case 'one_month':
        return '1 Month';
      case 'three_months':
        return '3 Months';
      case 'six_months':
        return '6 Months';
      case 'one_year':
        return '1 Year';
      case 'forever':
        return 'Forever';
      default:
        return period;
    }
  }

  /// Returns a human-readable label for an export format string
  static String getExportFormatLabel(String format) {
    switch (format) {
      case 'csv':
        return 'CSV';
      case 'json':
        return 'JSON';
      case 'pdf':
        return 'PDF';
      default:
        return format.toUpperCase();
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RetentionPolicyModelToJson(this);

  /// Create from JSON
  factory RetentionPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$RetentionPolicyModelFromJson(json);

  /// Create a copy with updated fields
  RetentionPolicyModel copyWith({
    bool? autoCleanupEnabled,
    String? retentionPeriod,
    bool? deleteRouteDataOnly,
    bool? exportBeforeDelete,
    String? exportFormat,
    DateTime? lastCleanupDate,
    int? lastCleanupDeletedCount,
  }) {
    return RetentionPolicyModel()
      ..id = id
      ..autoCleanupEnabled = autoCleanupEnabled ?? this.autoCleanupEnabled
      ..retentionPeriod = retentionPeriod ?? this.retentionPeriod
      ..deleteRouteDataOnly = deleteRouteDataOnly ?? this.deleteRouteDataOnly
      ..exportBeforeDelete = exportBeforeDelete ?? this.exportBeforeDelete
      ..exportFormat = exportFormat ?? this.exportFormat
      ..lastCleanupDate = lastCleanupDate ?? this.lastCleanupDate
      ..lastCleanupDeletedCount =
          lastCleanupDeletedCount ?? this.lastCleanupDeletedCount
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }

  /// Create a default policy
  static RetentionPolicyModel createDefault() {
    final now = DateTime.now();
    return RetentionPolicyModel()
      ..autoCleanupEnabled = false
      ..retentionPeriod = 'forever'
      ..deleteRouteDataOnly = false
      ..exportBeforeDelete = false
      ..exportFormat = 'json'
      ..lastCleanupDate = null
      ..lastCleanupDeletedCount = 0
      ..createdAt = now
      ..updatedAt = now;
  }
}
