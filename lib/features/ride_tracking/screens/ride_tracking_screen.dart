import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/break_in_stages.dart';
import '../../../data/models/ride_session_model.dart';
import '../../../data/models/route_point_model.dart';
import '../../../data/models/warning_event_model.dart';
import '../../../shared/providers/repositories_provider.dart';
import '../../../shared/providers/rides_provider.dart';
import '../../../shared/providers/bike_profile_provider.dart';
import '../../../shared/providers/break_in_provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// Dashboard Palette — night (dark) and day (light)
// ════════════════════════════════════════════════════════════════════════════

class _Palette {
  final Color bg, surface, text, textSec, textMut;
  final Color accent, accentSurf, border, warnSurf, error, errorSurf;

  const _Palette({
    required this.bg,
    required this.surface,
    required this.text,
    required this.textSec,
    required this.textMut,
    required this.accent,
    required this.accentSurf,
    required this.border,
    required this.warnSurf,
    required this.error,
    required this.errorSurf,
  });

  static const night = _Palette(
    bg: Color(0xFF0E0F14),
    surface: Color(0xFF181A22),
    text: Color(0xFFEDEAE4),
    textSec: Color(0xFF9A9892),
    textMut: Color(0xFF65625F),
    accent: Color(0xFFC9964A),
    accentSurf: Color(0xFF1E150A),
    border: Color(0xFF252A38),
    warnSurf: Color(0xFF291F10),
    error: Color(0xFFBF5A50),
    errorSurf: Color(0xFF271210),
  );

  static const day = _Palette(
    bg: Color(0xFFECE9E1),
    surface: Color(0xFFDAD7CF),
    text: Color(0xFF191B24),
    textSec: Color(0xFF4A4845),
    textMut: Color(0xFF7A7772),
    accent: Color(0xFFB8852A),
    accentSurf: Color(0xFFF5EAD5),
    border: Color(0xFFCAC7BF),
    warnSurf: Color(0xFFF5E5C4),
    error: Color(0xFFBF5A50),
    errorSurf: Color(0xFFFFDDDA),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// TW200 constants
// ── TW200-specific drivetrain constants ──────────────────────────────────────
// Source: tw200_break_in_plan_with_gears_5665.pdf, Section 4 & 5
//
// Primary reduction: 3.318
// Gear ratios: 1st 2.833 / 2nd 1.789 / 3rd 1.318 / 4th 1.040 / 5th 0.821
// Final drive: 50/14 = 3.571
// Rear tyre: 180/80-14 → theoretical diameter 643.6 mm → circ. = π × 0.6436 m
// Overall ratio (gear i) = primary × gear_i × final
// ════════════════════════════════════════════════════════════════════════════

const _kMaxRpm = 9000;
const _kWheelCircM = 2.022; // π × 0.6436 m (180/80-14 tyre)

// Stage 1–4 RPM ceilings and practical speed limits (index 0 = Stage 1 … 3 = Stage 4)
// RPM limits per PDF Section 3; speed limits derived from RPM ceiling in 4th gear
const _kStageRpmLimits = [4000, 5000, 6000, 6500]; // rpm
const _kStageSpdLimits = [40.0, 55.0, 65.0, 75.0]; // km/h

// Total drivetrain ratios per gear = primary × gear_ratio × final (rounded 1 dp)
const _kGearRatios = [33.6, 21.2, 15.6, 12.3, 9.7]; // gears 1–5

// ════════════════════════════════════════════════════════════════════════════
// RideTrackingScreen
// ════════════════════════════════════════════════════════════════════════════

class RideTrackingScreen extends ConsumerStatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  ConsumerState<RideTrackingScreen> createState() => _RideTrackingState();
}

class _RideTrackingState extends ConsumerState<RideTrackingScreen> {
  // ── Ride state ─────────────────────────────────────────────────────────────
  bool _isRiding = false;
  bool _isPaused = false;
  Duration _elapsed = Duration.zero;
  Timer? _rideTimer;
  DateTime? _startTime;
  double _maxSpeedKmh = 0;
  int _overspeedCount = 0;
  String _rideType = 'commute';

  // Live sensor values — updated by GPS stream while riding
  double _speedKmh = 0;
  int _gear = 0;
  double _distanceKm = 0;

  // GPS
  StreamSubscription<Position>? _gpsSub;
  Position? _lastPos;
  bool _gpsReady = false;
  bool _gpsError = false;

  // ── Route & warning accumulation ──────────────────────────────────────────
  String _currentSessionId = '';
  final List<RoutePointModel> _routePoints = [];
  final List<WarningEventModel> _warningEvents = [];
  DateTime? _lastRoutePointTime;

  // ── Speed history (last 15 min, for background graph) ─────────────────────
  final List<_SpeedPoint> _speedHistory = [];

  // TTS voice alerts
  final FlutterTts _tts = FlutterTts();
  bool _voiceAlertActive = false; // prevents repeated alerts within 30 s

  // ── Day / Night mode ───────────────────────────────────────────────────────
  bool _isDayMode = true;
  bool _isManualOverride = false;
  Timer? _modeTimer;

  // ── Break-in context (updated live from breakInProgressProvider) ────────────
  // Index 0 = Stage 1 (most conservative) … 3 = Stage 4.
  // Defaults to 0 (Stage 1) until the provider resolves.
  int _stageIdx = 0;
  int get _stageRpmLimit => _kStageRpmLimits[_stageIdx];
  double get _stageSpdLimit => _kStageSpdLimits[_stageIdx];
  double get _rpmLimitFrac => _stageRpmLimit / _kMaxRpm;

  // Derived RPM using TW200 gear ratios
  double get _rpmFrac {
    if (!_isRiding || _speedKmh < 1) return 900 / _kMaxRpm; // idle
    final speedMs = _speedKmh / 3.6;
    final wheelRpm = speedMs / _kWheelCircM * 60;
    final ratio = _kGearRatios[(_gear - 1).clamp(0, 4)];
    return (wheelRpm * ratio).clamp(0.0, _kMaxRpm.toDouble()) / _kMaxRpm;
  }

  bool get _isOverLimit => _isRiding && _speedKmh > _stageSpdLimit;

  // ── Gear estimation from speed ─────────────────────────────────────────────
  int _estimateGear(double kmh) {
    if (kmh < 10) return 1;
    if (kmh < 22) return 2;
    if (kmh < 38) return 3;
    if (kmh < 58) return 4;
    return 5;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _isDayMode = _computeAutoDay();
    _modeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!_isManualOverride && mounted) {
        setState(() => _isDayMode = _computeAutoDay());
      }
    });
    // Defer all platform channel calls (TTS init + GPS permission check) to
    // after the first frame so the UI paints immediately and Android's ANR
    // watchdog is not triggered by platform work during widget construction.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initTts();
        _checkGpsPermission();
      }
    });
  }

  @override
  void dispose() {
    _rideTimer?.cancel();
    _modeTimer?.cancel();
    _gpsSub?.cancel();
    _tts.stop();
    super.dispose();
  }

  // ── GPS ────────────────────────────────────────────────────────────────────

  // Called on init — silent check only, no permission dialog, no stream.
  Future<void> _checkGpsPermission() async {
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      setState(() => _gpsError = true);
      return;
    }
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return; // stays grey dot
    }
    setState(() => _gpsReady = true);
  }

  // Called when the user taps Start — requests permission if needed, then opens stream.
  Future<void> _startGpsStream() async {
    if (_gpsSub != null) return; // already running

    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      if (mounted) setState(() => _gpsError = true);
      return;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      if (mounted) setState(() => _gpsError = true);
      return;
    }

    if (mounted) setState(() => _gpsReady = true);

    _gpsSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen(_onPosition, onError: (_) {
      if (mounted) setState(() => _gpsError = true);
    });
  }

  void _onPosition(Position pos) {
    if (!mounted) return;
    // Speed arrives in m/s from geolocator
    final newSpeed = (pos.speed * 3.6).clamp(0.0, 300.0);
    final newGear = _isRiding ? _estimateGear(newSpeed) : 0;

    double added = 0;
    if (_isRiding && !_isPaused && _lastPos != null) {
      added = Geolocator.distanceBetween(
            _lastPos!.latitude,
            _lastPos!.longitude,
            pos.latitude,
            pos.longitude,
          ) /
          1000; // m → km
    }
    _lastPos = pos;

    setState(() {
      _speedKmh = (_isRiding && !_isPaused) ? newSpeed : 0;
      _gear = newGear;
      _distanceKm += (_isRiding && !_isPaused) ? added : 0;
      if (_isRiding && !_isPaused && newSpeed > _maxSpeedKmh) {
        _maxSpeedKmh = newSpeed;
      }
    });

    // Append to speed history (last 15 minutes, used by background graph)
    if (_isRiding && !_isPaused) {
      final now = DateTime.now();
      _speedHistory.add(_SpeedPoint(now, newSpeed));
      final cutoff = now.subtract(const Duration(minutes: 15));
      while (_speedHistory.isNotEmpty &&
          _speedHistory.first.time.isBefore(cutoff)) {
        _speedHistory.removeAt(0);
      }
    }

    // Record a GPS route point (throttled: 1 point per 5 seconds while riding)
    if (_isRiding && !_isPaused && _currentSessionId.isNotEmpty) {
      final now = DateTime.now();
      if (_lastRoutePointTime == null ||
          now.difference(_lastRoutePointTime!).inSeconds >= 5) {
        _lastRoutePointTime = now;
        _routePoints.add(RoutePointModel()
          ..pointId = const Uuid().v4()
          ..sessionId = _currentSessionId
          ..timestamp = now
          ..latitude = pos.latitude
          ..longitude = pos.longitude
          ..speedKmh = newSpeed
          ..accuracyM = pos.accuracy
          ..altitudeM = pos.altitude);
      }
    }

    // Voice alert — speaks once, then waits 30 s before re-triggering
    if (_isRiding && newSpeed > _stageSpdLimit && !_voiceAlertActive) {
      _overspeedCount++;
      // Record warning event with full context
      _warningEvents.add(WarningEventModel()
        ..warningId = const Uuid().v4()
        ..sessionId = _currentSessionId
        ..timestamp = DateTime.now()
        ..type = 'overspeed'
        ..message =
            'Speed ${newSpeed.toStringAsFixed(0)} km/h exceeded the ${_stageSpdLimit.toStringAsFixed(0)} km/h break-in limit'
        ..speedKmh = newSpeed
        ..breakInStageName = null);
      _voiceAlertActive = true;
      _tts.speak(
        'Speed limit exceeded. '
        'Reduce speed below ${_stageSpdLimit.toStringAsFixed(0)} kilometres per hour.',
      );
      Timer(const Duration(seconds: 30), () => _voiceAlertActive = false);
    }
  }

  // ── TTS ────────────────────────────────────────────────────────────────────

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  // ── Solar auto-day calculation ─────────────────────────────────────────────
  // Simplified formula, accurate ±20 min at ~20 °N (India / SE Asia).
  // Uses device timezone offset; GPS lat/lon would further improve precision.
  bool _computeAutoDay() {
    final now = DateTime.now();
    final doy = now.difference(DateTime(now.year, 1, 1)).inDays;
    final decl =
        -23.45 * math.cos(2 * math.pi * (doy + 10) / 365) * math.pi / 180;
    const latRad = 20.0 * math.pi / 180;
    final cosHa = -math.tan(latRad) * math.tan(decl);
    if (cosHa >= 1) return false;
    if (cosHa <= -1) return true;
    final ha = math.acos(cosHa) * 180 / math.pi;
    final localH = now.hour + now.minute / 60.0;
    return localH >= (12.0 - ha / 15.0) && localH < (12.0 + ha / 15.0);
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _toggleRide() async {
    if (_isRiding) {
      // ── Stop ───────────────────────────────────────────────────────────────
      final endTime = DateTime.now();
      final start = _startTime ?? endTime;
      final dist = _distanceKm;
      final dur = _elapsed.inSeconds;
      final maxSpd = _maxSpeedKmh;
      final overspd = _overspeedCount;

      // Snapshot accumulated data BEFORE resetting state
      final capturedSessionId = _currentSessionId;
      final capturedRoutePoints = List<RoutePointModel>.from(_routePoints);
      final capturedWarnings = List<WarningEventModel>.from(_warningEvents);

      setState(() {
        _rideTimer?.cancel();
        _rideTimer = null;
        _isRiding = false;
        _isPaused = false;
        _speedKmh = 0;
        _gear = 0;
        _lastPos = null;
        _voiceAlertActive = false;
        _maxSpeedKmh = 0;
        _overspeedCount = 0;
        _startTime = null;
        _routePoints.clear();
        _warningEvents.clear();
        _speedHistory.clear();
        _lastRoutePointTime = null;
        _currentSessionId = '';
      });
      _tts.stop();

      // Only save if the ride was more than 10 seconds and moved at all
      if (dur >= 10 && dist > 0) {
        _saveRide(
          sessionId: capturedSessionId,
          startTime: start,
          endTime: endTime,
          distanceKm: dist,
          durationSec: dur,
          maxSpeedKmh: maxSpd,
          overspeedCount: overspd,
          routePoints: capturedRoutePoints,
          warningEvents: capturedWarnings,
        );
      }
    } else {
      // ── Start — pick ride type first ───────────────────────────────────────
      final picked = await _showRideTypeSheet();
      if (!mounted || picked == null) return; // user cancelled
      setState(() => _rideType = picked);

      setState(() {
        _elapsed = Duration.zero;
        _distanceKm = 0;
        _maxSpeedKmh = 0;
        _overspeedCount = 0;
        _lastPos = null;
        _startTime = DateTime.now();
        _isRiding = true;
        _gear = 1;
      });
      // Generate a fresh session ID and reset accumulators for the new ride
      _currentSessionId = const Uuid().v4();
      _routePoints.clear();
      _warningEvents.clear();
      _lastRoutePointTime = null;
      _startGpsStream();
      _rideTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _isPaused) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    }
  }

  void _pauseRide() {
    if (!_isRiding || _isPaused) return;
    setState(() {
      _isPaused = true;
      _speedKmh = 0;
      _gear = 0;
    });
    _tts.stop();
  }

  void _resumeRide() {
    if (!_isRiding || !_isPaused) return;
    setState(() => _isPaused = false);
  }

  Future<String?> _showRideTypeSheet() {
    final p = _isDayMode ? _Palette.day : _Palette.night;
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _RideTypeSheet(palette: p),
    );
  }

  Future<void> _saveRide({
    required String sessionId,
    required DateTime startTime,
    required DateTime endTime,
    required double distanceKm,
    required int durationSec,
    required double maxSpeedKmh,
    required int overspeedCount,
    required List<RoutePointModel> routePoints,
    required List<WarningEventModel> warningEvents,
  }) async {
    final profile = await ref.read(bikeProfileProvider.future);
    final economy = profile?.manualFuelEconomyKmPerLiter ?? 35.0;
    final stage = BreakInStage.getStageFromKm(
      (profile?.rebuildStartOdometerKm ?? 0) +
          await ref.read(totalRiddenKmProvider.future),
    );
    final avgSpeed =
        durationSec > 0 ? distanceKm / (durationSec / 3600.0) : 0.0;
    final fuelUsed = economy > 0 ? distanceKm / economy : 0.0;

    final ride = RideSessionModel()
      ..sessionId = sessionId
      ..date = startTime
      ..startTime = startTime
      ..endTime = endTime
      ..startOdometerKm = 0
      ..endOdometerKm = distanceKm
      ..distanceKm = distanceKm
      ..durationSeconds = durationSec
      ..averageSpeedKmh = avgSpeed
      ..maxSpeedKmh = maxSpeedKmh
      ..breakInStageName = stage.name
      ..overspeedEventCount = overspeedCount
      ..lowSpeedDurationSeconds = 0
      ..stopDurationSeconds = 0
      ..trafficStressLevel = 'Easy'
      ..estimatedFuelUsedLiters = fuelUsed
      ..fuelEconomyUsedKmPerLiter = economy
      ..rideType = _rideType
      ..encodedRoutePolyline = null
      ..notes = null
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    final repo = ref.read(ridesRepositoryProvider);
    await repo.saveRideSession(ride);

    // Persist route points (speed profile + map trace)
    if (routePoints.isNotEmpty) {
      await repo.saveRoutePointsBatch(routePoints);
    }

    // Persist warning events (overspeed alerts with timestamps)
    if (warningEvents.isNotEmpty) {
      await repo.saveWarningEvents(sessionId, warningEvents);
    }

    ref.invalidate(allRideSessionsProvider);
    ref.invalidate(totalRiddenKmProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ride saved — ${distanceKm.toStringAsFixed(1)} km',
          ),
          backgroundColor: const Color(0xFF252A38),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleDayMode() {
    setState(() {
      _isManualOverride = true;
      _isDayMode = !_isDayMode;
    });
  }

  void _resetToAutoMode() {
    setState(() {
      _isManualOverride = false;
      _isDayMode = _computeAutoDay();
    });
  }

  String _formatElapsed(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}:'
          '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
          '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
    return '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}'
        ':${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  // Full number, no "k" abbreviation
  String _rpmLabel(double frac) {
    final rpm = (frac * _kMaxRpm).round();
    return '$rpm RPM';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = _isDayMode ? _Palette.day : _Palette.night;

    // Keep _stageIdx in sync with the real break-in progress.
    // stageNumber 1–4 → index 0–3; stage 5 (complete) → index 3 (least restrictive).
    ref.listen<AsyncValue<BreakInProgress?>>(breakInProgressProvider,
        (_, next) {
      final stageNum = next.valueOrNull?.stageNumber ?? 1;
      final idx = (stageNum - 1).clamp(0, 3);
      if (idx != _stageIdx && mounted) setState(() => _stageIdx = idx);
    });

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              isRiding: _isRiding,
              isPaused: _isPaused,
              isDayMode: _isDayMode,
              isManualOverride: _isManualOverride,
              gpsReady: _gpsReady,
              gpsError: _gpsError,
              stageIdx: _stageIdx,
              stageSpdLimit: _stageSpdLimit,
              stageRpmLimit: _stageRpmLimit,
              palette: p,
              onToggleRide: _toggleRide,
              onToggleMode: _toggleDayMode,
              onResetAuto: _resetToAutoMode,
              onPause: _pauseRide,
              onResume: _resumeRide,
            ),
            if (_isOverLimit)
              _SpeedWarning(speedLimit: _stageSpdLimit, palette: p),
            Expanded(
              child: _SpeedDisplay(
                speed: _speedKmh,
                isRiding: _isRiding,
                isOverLimit: _isOverLimit,
                palette: p,
                speedHistory: _speedHistory,
                stageLimit: _stageSpdLimit,
              ),
            ),
            _RpmSection(
              rpmFrac: _isRiding ? _rpmFrac : 900 / _kMaxRpm,
              limitFrac: _rpmLimitFrac,
              rpmLabel: _isRiding ? _rpmLabel(_rpmFrac) : 'Idle',
              limitLabel: '$_stageRpmLimit RPM max',
              isDayMode: _isDayMode,
              palette: p,
            ),
            const SizedBox(height: RLSpacing.md),
            _MetricsRow(
              isRiding: _isRiding,
              gear: _gear,
              distanceKm: _distanceKm,
              elapsed: _elapsed,
              formatTime: _formatElapsed,
              palette: p,
            ),
            const SizedBox(height: RLSpacing.md),
            _BreakInBar(palette: p),
            const SizedBox(height: RLSpacing.lg),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Top bar
// ════════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final bool isRiding,
      isPaused,
      isDayMode,
      isManualOverride,
      gpsReady,
      gpsError;
  final int stageIdx, stageRpmLimit;
  final double stageSpdLimit;
  final _Palette palette;
  final VoidCallback onToggleRide, onToggleMode, onResetAuto, onPause, onResume;

  const _TopBar({
    required this.isRiding,
    required this.isPaused,
    required this.isDayMode,
    required this.isManualOverride,
    required this.gpsReady,
    required this.gpsError,
    required this.stageIdx,
    required this.stageSpdLimit,
    required this.stageRpmLimit,
    required this.palette,
    required this.onToggleRide,
    required this.onToggleMode,
    required this.onResetAuto,
    required this.onPause,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RLSpacing.base,
        RLSpacing.md,
        RLSpacing.base,
        RLSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stage + GPS status
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isRiding ? (isPaused ? 'PAUSED' : 'RIDING') : 'READY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isRiding
                            ? (isPaused ? p.textMut : p.accent)
                            : p.textMut,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // GPS indicator dot
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gpsError
                            ? p.error
                            : gpsReady
                                ? const Color(0xFF8F9E62)
                                : p.textMut,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      gpsError
                          ? 'GPS off'
                          : gpsReady
                              ? 'GPS'
                              : 'GPS…',
                      style: TextStyle(fontSize: 10, color: p.textMut),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Stage info — two lines so it never overflows narrow screens
                Text(
                  'Stage ${stageIdx + 1}  ·  max ${stageSpdLimit.toStringAsFixed(0)} km/h',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: p.textSec,
                    height: 1.25,
                  ),
                ),
                Text(
                  '$stageRpmLimit RPM limit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: p.accent,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: RLSpacing.md),

          // Day/Night toggle
          GestureDetector(
            onTap: onToggleMode,
            onLongPress: isManualOverride ? onResetAuto : null,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: RLRadius.borderMd,
                border: Border.all(
                  color: isManualOverride ? p.accent : p.border,
                ),
              ),
              child: Icon(
                isDayMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                size: 20,
                color: isManualOverride ? p.accent : p.textSec,
              ),
            ),
          ),

          const SizedBox(width: RLSpacing.sm),

          // Pause / Resume — only visible while riding
          if (isRiding) ...[
            GestureDetector(
              onTap: isPaused ? onResume : onPause,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isPaused ? p.accentSurf : p.surface,
                  borderRadius: RLRadius.borderMd,
                  border: Border.all(
                    color: isPaused ? p.accent : p.border,
                  ),
                ),
                child: Icon(
                  isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 20,
                  color: isPaused ? p.accent : p.textSec,
                ),
              ),
            ),
            const SizedBox(width: RLSpacing.sm),
          ],

          // Start / Stop
          GestureDetector(
            onTap: onToggleRide,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: RLSpacing.md, vertical: 10),
              decoration: BoxDecoration(
                color: isRiding ? p.errorSurf : p.accent,
                borderRadius: RLRadius.borderPill,
                border: isRiding
                    ? Border.all(color: p.error.withValues(alpha: 0.6))
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isRiding ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 20,
                    color: isRiding ? p.error : const Color(0xFFFAF8F3),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isRiding ? 'Stop' : 'Start',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isRiding ? p.error : const Color(0xFFFAF8F3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Speed warning banner
// ════════════════════════════════════════════════════════════════════════════

class _SpeedWarning extends StatelessWidget {
  final double speedLimit;
  final _Palette palette;
  const _SpeedWarning({required this.speedLimit, required this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: RLSpacing.md, vertical: RLSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: RLSpacing.base, vertical: RLSpacing.sm),
      decoration: BoxDecoration(
        color: p.warnSurf,
        borderRadius: RLRadius.borderMd,
        border: Border(left: BorderSide(color: p.error, width: 3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 22, color: p.error),
          const SizedBox(width: 10),
          Text(
            'Over limit — slow down below ${speedLimit.toStringAsFixed(0)} km/h',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: p.text),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Speed display — large bold number + subtle 15-min history graph background
// ════════════════════════════════════════════════════════════════════════════

class _SpeedDisplay extends StatelessWidget {
  final double speed;
  final bool isRiding, isOverLimit;
  final _Palette palette;
  final List<_SpeedPoint> speedHistory;
  final double stageLimit;

  const _SpeedDisplay({
    required this.speed,
    required this.isRiding,
    required this.isOverLimit,
    required this.palette,
    required this.speedHistory,
    required this.stageLimit,
  });

  @override
  Widget build(BuildContext context) {
    final p     = palette;
    final color = isOverLimit ? p.error : p.text;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background speed-history graph ─────────────────────────────────
        if (speedHistory.length >= 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: CustomPaint(
              painter: _SpeedHistoryPainter(
                points:     speedHistory,
                maxSpeed:   100.0,
                limitSpeed: stageLimit,
                lineColor:  isOverLimit ? p.error : p.accent,
                limitColor: p.error,
              ),
            ),
          ),

        // ── Speed number + unit ────────────────────────────────────────────
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isRiding ? speed.toStringAsFixed(0) : '0',
                style: TextStyle(
                  fontSize: 128,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -8,
                  height: 1.0,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'km/h',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: p.textSec,
                  letterSpacing: 5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Speed history CustomPainter
// ════════════════════════════════════════════════════════════════════════════

class _SpeedHistoryPainter extends CustomPainter {
  final List<_SpeedPoint> points;
  final double maxSpeed;
  final double limitSpeed;
  final Color lineColor;
  final Color limitColor;

  const _SpeedHistoryPainter({
    required this.points,
    required this.maxSpeed,
    required this.limitSpeed,
    required this.lineColor,
    required this.limitColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final now      = DateTime.now();
    const windowMs = 15 * 60 * 1000.0;

    // ── Limit line ─────────────────────────────────────────────────────────
    final limitY = size.height * (1 - (limitSpeed / maxSpeed).clamp(0, 1));
    canvas.drawLine(
      Offset(0, limitY),
      Offset(size.width, limitY),
      Paint()
        ..color       = limitColor.withValues(alpha: 0.20)
        ..strokeWidth = 1.0,
    );

    // ── Build speed path ───────────────────────────────────────────────────
    final path = Path();
    double firstX = 0;
    bool started = false;

    for (final pt in points) {
      final elapsedMs =
          now.difference(pt.time).inMilliseconds.toDouble().clamp(0, windowMs);
      final x = size.width * (1.0 - elapsedMs / windowMs);
      final y = size.height * (1.0 - (pt.speed / maxSpeed).clamp(0.0, 1.0));
      if (!started) {
        path.moveTo(x, y);
        firstX = x;
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    // ── Fill under the curve ───────────────────────────────────────────────
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(firstX, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = lineColor.withValues(alpha: 0.07)
        ..style = PaintingStyle.fill,
    );

    // ── Stroke ─────────────────────────────────────────────────────────────
    canvas.drawPath(
      path,
      Paint()
        ..color      = lineColor.withValues(alpha: 0.28)
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap  = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SpeedHistoryPainter o) =>
      o.points != points ||
      o.limitSpeed != limitSpeed ||
      o.lineColor != lineColor;
}

// ── Speed point data holder ────────────────────────────────────────────────
class _SpeedPoint {
  final DateTime time;
  final double speed;
  const _SpeedPoint(this.time, this.speed);
}

// ════════════════════════════════════════════════════════════════════════════
// RPM zone section — modern segmented LED-style indicator
// ════════════════════════════════════════════════════════════════════════════

class _RpmSection extends StatelessWidget {
  final double rpmFrac, limitFrac;
  final String rpmLabel, limitLabel;
  final bool isDayMode;
  final _Palette palette;

  const _RpmSection({
    required this.rpmFrac,
    required this.limitFrac,
    required this.rpmLabel,
    required this.limitLabel,
    required this.isDayMode,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    // Is the current RPM in or past the caution zone?
    final isCautionOrAbove = rpmFrac > limitFrac;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'RPM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: p.textMut,
                  letterSpacing: 2.0,
                ),
              ),
              const Spacer(),
              Text(
                rpmLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isCautionOrAbove ? p.error : p.accent,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'limit ${(limitFrac * _kMaxRpm / 1000).toStringAsFixed(1)}k',
                style: TextStyle(fontSize: 11, color: p.textMut),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Segmented bar
          SizedBox(
            height: 20,
            child: CustomPaint(
              painter: _RpmSegmentPainter(
                rpmFrac: rpmFrac,
                limitFrac: limitFrac,
                isDay: isDayMode,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 6),
          // Zone labels (compact)
          Row(
            children: [
              Text('IDLE', style: TextStyle(fontSize: 9, color: p.textMut, letterSpacing: 0.8)),
              const Spacer(),
              Text('OPTIMAL', style: TextStyle(fontSize: 9, color: p.textMut, letterSpacing: 0.8)),
              const Spacer(),
              Text('▲ LIMIT', style: TextStyle(fontSize: 9, color: p.accent, letterSpacing: 0.8, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('DANGER', style: TextStyle(fontSize: 9, color: p.error, letterSpacing: 0.8)),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Ride Type Picker Sheet
// ════════════════════════════════════════════════════════════════════════════

class _RideTypeSheet extends StatelessWidget {
  final _Palette palette;
  const _RideTypeSheet({required this.palette});

  static const _types = [
    (
      'commute',
      Icons.directions_bus_outlined,
      'Daily Commute',
      'Office / regular route'
    ),
    (
      'leisure',
      Icons.landscape_outlined,
      'Leisure Ride',
      'Weekend, exploration'
    ),
    ('errand', Icons.shopping_bag_outlined, 'Errand', 'Quick trip, shopping'),
    (
      'highway',
      Icons.merge_type_outlined,
      'Highway Run',
      'Long distance, motorway'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What kind of ride?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: p.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose the ride type to log correctly.',
                style: TextStyle(fontSize: 13, color: p.textMut),
              ),
              const SizedBox(height: 16),
              ..._types.map((t) {
                final (value, icon, title, subtitle) = t;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(value),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: p.bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.border),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 22, color: p.accent),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: p.text,
                                ),
                              ),
                              Text(
                                subtitle,
                                style:
                                    TextStyle(fontSize: 12, color: p.textMut),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 18, color: p.textMut),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RPM Segment Painter — 24 LED-style rounded-rect segments
// ════════════════════════════════════════════════════════════════════════════

class _RpmSegmentPainter extends CustomPainter {
  final double rpmFrac, limitFrac;
  final bool isDay;

  const _RpmSegmentPainter({
    required this.rpmFrac,
    required this.limitFrac,
    required this.isDay,
  });

  static const _nSeg = 24;
  static const _gap  = 3.0;
  static const _r    = Radius.circular(3);

  static const _olive  = Color(0xFF8F9E62);
  static const _amber  = Color(0xFFC9964A);
  static const _orange = Color(0xFFCC6B2A);
  static const _red    = Color(0xFFBF5A50);

  // Zone boundaries (must match _RpmBarPainter logic)
  static const _z1 = 0.27;  // idle → optimal
  static const _z3 = 0.88;  // caution → danger

  Color _zoneColor(double frac) {
    if (frac <= _z1)         return _olive;
    if (frac <= limitFrac)   return _amber;
    if (frac <= _z3)         return _orange;
    return _red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w     = size.width;
    final h     = size.height;
    final segW  = (w - (_nSeg - 1) * _gap) / _nSeg;

    for (int i = 0; i < _nSeg; i++) {
      final segFrac  = (i + 0.5) / _nSeg; // midpoint of this segment
      final x        = i * (segW + _gap);
      final rect     = Rect.fromLTWH(x, 0, segW, h);
      final rRect    = RRect.fromRectAndRadius(rect, _r);
      final base     = _zoneColor(segFrac);
      final isActive = segFrac <= rpmFrac;

      // Limit marker gap: tiny dark divider before the first segment past limitFrac
      final isLimitEdge =
          (limitFrac * _nSeg).round() == i && !isActive;

      if (isActive) {
        // Solid filled segment
        canvas.drawRRect(rRect, Paint()..color = base);
        // Subtle glow on the leading (current) segment
        if (rpmFrac - segFrac < 1.5 / _nSeg) {
          canvas.drawRRect(
            rRect,
            Paint()
              ..color = base.withValues(alpha: 0.45)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
          );
        }
      } else {
        // Dim inactive segment
        canvas.drawRRect(
          rRect,
          Paint()..color = base.withValues(alpha: isDay ? 0.18 : 0.13),
        );
        // Limit marker: bright amber hairline before this segment
        if (isLimitEdge) {
          canvas.drawLine(
            Offset(x - _gap / 2, -2),
            Offset(x - _gap / 2, h + 2),
            Paint()
              ..color = _amber.withValues(alpha: 0.85)
              ..strokeWidth = 2.5
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_RpmSegmentPainter o) =>
      o.rpmFrac != rpmFrac || o.limitFrac != limitFrac || o.isDay != isDay;
}

// ════════════════════════════════════════════════════════════════════════════
// Metrics row
// ════════════════════════════════════════════════════════════════════════════

class _MetricsRow extends StatelessWidget {
  final bool isRiding;
  final int gear;
  final double distanceKm;
  final Duration elapsed;
  final String Function(Duration) formatTime;
  final _Palette palette;

  const _MetricsRow({
    required this.isRiding,
    required this.gear,
    required this.distanceKm,
    required this.elapsed,
    required this.formatTime,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.md),
      child: Row(
        children: [
          Expanded(
              child: _MetricTile(
                  label: 'GEAR',
                  value: isRiding ? '$gear' : '—',
                  unit: '',
                  valueColor: p.accent,
                  palette: p)),
          const SizedBox(width: 8),
          Expanded(
              child: _MetricTile(
                  label: 'DISTANCE',
                  value: isRiding ? distanceKm.toStringAsFixed(1) : '0.0',
                  unit: 'km',
                  valueColor: p.text,
                  palette: p)),
          const SizedBox(width: 8),
          Expanded(
              child: _MetricTile(
                  label: 'ELAPSED',
                  value: formatTime(elapsed),
                  unit: '',
                  valueColor: p.text,
                  palette: p)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label, value, unit;
  final Color valueColor;
  final _Palette palette;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.valueColor,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: RLSpacing.md, horizontal: RLSpacing.sm),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: RLRadius.borderLg,
        border: Border.all(color: p.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: p.textMut,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                    height: 1.0,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Text(unit, style: RLText.labelMd.copyWith(color: p.textMut)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Break-in progress bar
// ════════════════════════════════════════════════════════════════════════════

class _BreakInBar extends ConsumerWidget {
  final _Palette palette;
  const _BreakInBar({required this.palette});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = palette;
    final progress = ref.watch(breakInProgressProvider).valueOrNull;

    final currentKm = progress?.currentKm ?? 0;
    final stageEnd = progress?.stageEndKm ?? 1000;
    final stageFrac = stageEnd.isFinite
        ? ((currentKm - (progress?.stageStartKm ?? 0)) /
                (stageEnd - (progress?.stageStartKm ?? 0)))
            .clamp(0.0, 1.0)
        : 1.0;
    final pct = (stageFrac * 100).round();
    final label = progress != null
        ? '${currentKm.toStringAsFixed(0)} / ${stageEnd.isFinite ? stageEnd.toStringAsFixed(0) : '∞'} km  ·  $pct%'
        : '--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.md),
      padding: const EdgeInsets.symmetric(
          horizontal: RLSpacing.base, vertical: RLSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: RLRadius.borderLg,
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                progress != null
                    ? 'Stage ${progress.stageNumber}: ${progress.stageName}'
                    : 'Break-in',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: p.textSec),
              ),
              const Spacer(),
              Text(
                label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: p.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: RLRadius.borderPill,
            child: Container(
              height: 6,
              color: p.border,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: stageFrac,
                child: Container(color: p.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
