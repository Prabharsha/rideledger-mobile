/// RideLedger — Sample / demo data for UI screens
///
/// Plain Dart objects (no Isar dependency) so screens render immediately.
/// Replace with real provider data as features are implemented.
library;

import 'package:flutter/material.dart';

// ── Ride ─────────────────────────────────────────────────────────────────────
class SampleRide {
  final String id;
  final DateTime date;
  final Duration duration;
  final double distanceKm;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final double fuelUsedL;
  final String fromLabel;
  final String toLabel;
  final String rideType; // 'Commute' | 'Leisure' | 'Errand'
  final int warningCount;
  final double? avgFuelEconomy; // km/L

  const SampleRide({
    required this.id,
    required this.date,
    required this.duration,
    required this.distanceKm,
    required this.avgSpeedKmh,
    required this.maxSpeedKmh,
    required this.fuelUsedL,
    required this.fromLabel,
    required this.toLabel,
    required this.rideType,
    this.warningCount = 0,
    this.avgFuelEconomy,
  });

  String get durationLabel {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

// ── Fuel ─────────────────────────────────────────────────────────────────────
class SampleFuelLog {
  final String id;
  final DateTime date;
  final double liters;
  final double pricePerLiter;
  final double odometer;
  final bool isFullTank;

  const SampleFuelLog({
    required this.id,
    required this.date,
    required this.liters,
    required this.pricePerLiter,
    required this.odometer,
    required this.isFullTank,
  });

  double get totalCost => liters * pricePerLiter;
}

// ── Maintenance ───────────────────────────────────────────────────────────────
enum MaintenanceStatus { overdue, due, upcoming, done }

class SampleMaintenance {
  final String id;
  final String title;
  final String subtitle;
  final double? dueAtKm;
  final double? currentKm;
  final DateTime? dueDate;
  final DateTime? lastDoneDate;
  final MaintenanceStatus status;
  final IconData icon;

  const SampleMaintenance({
    required this.id,
    required this.title,
    required this.subtitle,
    this.dueAtKm,
    this.currentKm,
    this.dueDate,
    this.lastDoneDate,
    required this.status,
    required this.icon,
  });

  double get kmRemaining => dueAtKm != null && currentKm != null
      ? (dueAtKm! - currentKm!).clamp(0, double.infinity)
      : 0;
}

// ── Break-in ──────────────────────────────────────────────────────────────────
enum StageStatus { completed, active, pending }

class SampleBreakInStage {
  final int number;
  final String name;
  final String speedRange;
  final String advice;
  final int fromKm;
  final int toKm;
  final StageStatus status;

  const SampleBreakInStage({
    required this.number,
    required this.name,
    required this.speedRange,
    required this.advice,
    required this.fromKm,
    required this.toKm,
    required this.status,
  });
}

class SampleBreakInProgress {
  final double currentKm;
  final double targetKm;
  final List<SampleBreakInStage> stages;

  const SampleBreakInProgress({
    required this.currentKm,
    required this.targetKm,
    required this.stages,
  });

  double get progressFraction => (currentKm / targetKm).clamp(0, 1);
  int get progressPercent => (progressFraction * 100).round();

  SampleBreakInStage get activeStage =>
      stages.firstWhere((s) => s.status == StageStatus.active,
          orElse: () => stages.last);
}

// ── Report types ─────────────────────────────────────────────────────────────
class SampleReportType {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> formats;

  const SampleReportType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.formats,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
// Populated sample data
// ═════════════════════════════════════════════════════════════════════════════

class SampleData {
  SampleData._();

  // ── Rides ─────────────────────────────────────────────────────────────────
  static final List<SampleRide> rides = [
    SampleRide(
      id: 'r1',
      date: DateTime(2026, 3, 28, 8, 12),
      duration: Duration(minutes: 42),
      distanceKm: 23.4,
      avgSpeedKmh: 33.5,
      maxSpeedKmh: 62,
      fuelUsedL: 0.65,
      fromLabel: 'Home',
      toLabel: 'Office',
      rideType: 'Commute',
      warningCount: 1,
      avgFuelEconomy: 36.0,
    ),
    SampleRide(
      id: 'r2',
      date: DateTime(2026, 3, 27, 17, 55),
      duration: Duration(minutes: 38),
      distanceKm: 21.8,
      avgSpeedKmh: 34.4,
      maxSpeedKmh: 58,
      fuelUsedL: 0.60,
      fromLabel: 'Office',
      toLabel: 'Home',
      rideType: 'Commute',
      warningCount: 0,
      avgFuelEconomy: 36.3,
    ),
    SampleRide(
      id: 'r3',
      date: DateTime(2026, 3, 26, 10, 30),
      duration: Duration(minutes: 95),
      distanceKm: 52.7,
      avgSpeedKmh: 33.3,
      maxSpeedKmh: 55,
      fuelUsedL: 1.42,
      fromLabel: 'Home',
      toLabel: 'Highway Route',
      rideType: 'Leisure',
      warningCount: 2,
      avgFuelEconomy: 37.1,
    ),
    SampleRide(
      id: 'r4',
      date: DateTime(2026, 3, 25, 8, 5),
      duration: Duration(minutes: 44),
      distanceKm: 24.1,
      avgSpeedKmh: 32.9,
      maxSpeedKmh: 60,
      fuelUsedL: 0.67,
      fromLabel: 'Home',
      toLabel: 'Office',
      rideType: 'Commute',
      warningCount: 0,
      avgFuelEconomy: 35.9,
    ),
    SampleRide(
      id: 'r5',
      date: DateTime(2026, 3, 24, 14, 20),
      duration: Duration(minutes: 22),
      distanceKm: 11.3,
      avgSpeedKmh: 30.8,
      maxSpeedKmh: 48,
      fuelUsedL: 0.32,
      fromLabel: 'Office',
      toLabel: 'Market',
      rideType: 'Errand',
      warningCount: 0,
      avgFuelEconomy: 35.3,
    ),
  ];

  // ── Fuel logs ────────────────────────────────────────────────────────────
  static final List<SampleFuelLog> fuelLogs = [
    SampleFuelLog(
      id: 'f1',
      date: DateTime(2026, 3, 24),
      liters: 3.2,
      pricePerLiter: 95.50,
      odometer: 480,
      isFullTank: true,
    ),
    SampleFuelLog(
      id: 'f2',
      date: DateTime(2026, 3, 17),
      liters: 2.8,
      pricePerLiter: 95.00,
      odometer: 347,
      isFullTank: true,
    ),
    SampleFuelLog(
      id: 'f3',
      date: DateTime(2026, 3, 10),
      liters: 3.0,
      pricePerLiter: 94.50,
      odometer: 214,
      isFullTank: true,
    ),
  ];

  // ── Weekly fuel quota ─────────────────────────────────────────────────────
  static const double weeklyQuotaLiters = 5.0;
  static const double weekUsedLiters = 3.1;
  static const double tankCapacityLiters = 5.6;
  static const double currentFuelLiters = 2.5; // estimated
  static const double fuelEconomyKmL = 36.1; // rolling average

  // ── Odometer & totals ─────────────────────────────────────────────────────
  static const double currentOdometer = 513.3;
  static const int totalRides = 21;
  static const double totalDistanceKm = 513.3;

  // ── Maintenance ──────────────────────────────────────────────────────────
  static final List<SampleMaintenance> maintenance = [
    SampleMaintenance(
      id: 'm1',
      title: 'Oil Change',
      subtitle: 'Due at 600 km',
      dueAtKm: 600,
      currentKm: 513,
      lastDoneDate: DateTime(2026, 2, 15),
      status: MaintenanceStatus.upcoming,
      icon: Icons.water_drop_outlined,
    ),
    SampleMaintenance(
      id: 'm2',
      title: 'Chain Lubrication',
      subtitle: 'Every 500 km — done 3 days ago',
      dueAtKm: 600,
      currentKm: 513,
      lastDoneDate: DateTime(2026, 3, 25),
      status: MaintenanceStatus.done,
      icon: Icons.settings_outlined,
    ),
    SampleMaintenance(
      id: 'm3',
      title: 'Air Filter Check',
      subtitle: 'Due at 800 km',
      dueAtKm: 800,
      currentKm: 513,
      status: MaintenanceStatus.upcoming,
      icon: Icons.air,
    ),
    SampleMaintenance(
      id: 'm4',
      title: 'Tire Pressure',
      subtitle: 'Check weekly',
      dueDate: DateTime(2026, 4, 4),
      lastDoneDate: DateTime(2026, 3, 27),
      status: MaintenanceStatus.done,
      icon: Icons.circle_outlined,
    ),
    SampleMaintenance(
      id: 'm5',
      title: 'Spark Plug',
      subtitle: 'Due at 1500 km',
      dueAtKm: 1500,
      currentKm: 513,
      status: MaintenanceStatus.upcoming,
      icon: Icons.bolt,
    ),
  ];

  // ── Break-in ──────────────────────────────────────────────────────────────
  static const breakIn = SampleBreakInProgress(
    currentKm: 513,
    targetKm: 800,
    stages: [
      SampleBreakInStage(
        number: 1,
        name: 'First Miles',
        speedRange: '0 – 30 km/h',
        advice: 'Gentle acceleration only. Avoid sustained high RPM.',
        fromKm: 0,
        toKm: 50,
        status: StageStatus.completed,
      ),
      SampleBreakInStage(
        number: 2,
        name: 'Building Up',
        speedRange: '20 – 40 km/h',
        advice: 'Vary speed steadily. Short highway segments OK.',
        fromKm: 50,
        toKm: 200,
        status: StageStatus.completed,
      ),
      SampleBreakInStage(
        number: 3,
        name: 'Expanding Range',
        speedRange: '30 – 50 km/h',
        advice:
            'Mix urban and highway. Vary throttle. Avoid sustained top speed.',
        fromKm: 200,
        toKm: 500,
        status: StageStatus.active,
      ),
      SampleBreakInStage(
        number: 4,
        name: 'Final Stretch',
        speedRange: '40 – 60 km/h',
        advice:
            'Gradual full-range use. Still avoid prolonged max RPM. Near complete.',
        fromKm: 500,
        toKm: 800,
        status: StageStatus.pending,
      ),
    ],
  );

  // ── Report types ──────────────────────────────────────────────────────────
  static final List<SampleReportType> reportTypes = [
    const SampleReportType(
      id: 'rpt1',
      title: 'Ride History',
      subtitle: 'All sessions with distance, speed, and fuel',
      icon: Icons.route_outlined,
      formats: ['PDF', 'CSV'],
    ),
    const SampleReportType(
      id: 'rpt2',
      title: 'Fuel Tracker',
      subtitle: 'Refuel logs and economy trends',
      icon: Icons.local_gas_station_outlined,
      formats: ['PDF', 'CSV'],
    ),
    const SampleReportType(
      id: 'rpt3',
      title: 'Service Records',
      subtitle: 'Maintenance history and upcoming reminders',
      icon: Icons.build_outlined,
      formats: ['PDF'],
    ),
    const SampleReportType(
      id: 'rpt4',
      title: 'Break-In Summary',
      subtitle: 'Stage completion and compliance report',
      icon: Icons.timeline,
      formats: ['PDF'],
    ),
    const SampleReportType(
      id: 'rpt5',
      title: 'Full Export',
      subtitle: 'Complete data export — all categories',
      icon: Icons.download_outlined,
      formats: ['JSON', 'CSV'],
    ),
  ];

  // ── Active ride (simulated live state) ────────────────────────────────────
  static const bool isRideActive = false; // set true to demo ride screen
  static const double liveSpeedKmh = 42;
  static const int liveGear = 3;
  static const double rideDistanceKm = 14.2;
  static const Duration rideElapsed = Duration(minutes: 24, seconds: 18);
}
