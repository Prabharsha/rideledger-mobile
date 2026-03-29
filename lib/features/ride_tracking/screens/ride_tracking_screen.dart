import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/sample_data.dart';

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
    bg:         Color(0xFF0E0F14),
    surface:    Color(0xFF181A22),
    text:       Color(0xFFEDEAE4),
    textSec:    Color(0xFF9A9892),
    textMut:    Color(0xFF65625F),
    accent:     Color(0xFFC9964A),
    accentSurf: Color(0xFF1E150A),
    border:     Color(0xFF252A38),
    warnSurf:   Color(0xFF291F10),
    error:      Color(0xFFBF5A50),
    errorSurf:  Color(0xFF271210),
  );

  static const day = _Palette(
    bg:         Color(0xFFECE9E1),
    surface:    Color(0xFFDAD7CF),
    text:       Color(0xFF191B24),
    textSec:    Color(0xFF4A4845),
    textMut:    Color(0xFF7A7772),
    accent:     Color(0xFFB8852A),
    accentSurf: Color(0xFFF5EAD5),
    border:     Color(0xFFCAC7BF),
    warnSurf:   Color(0xFFF5E5C4),
    error:      Color(0xFFBF5A50),
    errorSurf:  Color(0xFFFFDDDA),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// TW200 constants
// RPM limits per break-in stage (on a 9 000 RPM scale)
// Speed limits per stage (km/h)
// Gear ratio chain: primary × gear × final drive — wheel circumference 2.76 m
// (130/80-18 rear tyre, π × 0.879 m diameter)
// ════════════════════════════════════════════════════════════════════════════

const _kMaxRpm       = 9000;
const _kWheelCircM   = 2.76;  // metres

// Stage 1–4 data (index 0–3)
const _kStageRpmLimits  = [4000, 5000, 6000, 7500];
const _kStageSpdLimits  = [30.0, 40.0, 50.0, 60.0];

// TW200 overall gear ratios (primary × gear × final)
const _kGearRatios = [29.6, 17.4, 13.1, 10.5, 8.7]; // gears 1–5

// ════════════════════════════════════════════════════════════════════════════
// RideTrackingScreen
// ════════════════════════════════════════════════════════════════════════════

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingState();
}

class _RideTrackingState extends State<RideTrackingScreen> {
  // ── Ride state ─────────────────────────────────────────────────────────────
  bool     _isRiding    = false;
  Duration _elapsed     = Duration.zero;
  Timer?   _rideTimer;

  // Live sensor values — updated by GPS stream while riding
  double _speedKmh    = 0;
  int    _gear        = 0;
  double _distanceKm  = 0;

  // GPS
  StreamSubscription<Position>? _gpsSub;
  Position? _lastPos;
  bool _gpsReady = false;
  bool _gpsError = false;

  // TTS voice alerts
  final FlutterTts _tts = FlutterTts();
  bool _voiceAlertActive = false; // prevents repeated alerts within 30 s

  // ── Day / Night mode ───────────────────────────────────────────────────────
  bool _isDayMode        = true;
  bool _isManualOverride = false;
  Timer? _modeTimer;

  // ── Break-in context (Stage 3 from sample data, index 2) ──────────────────
  int    get _stageIdx       => 2;
  int    get _stageRpmLimit  => _kStageRpmLimits[_stageIdx];
  double get _stageSpdLimit  => _kStageSpdLimits[_stageIdx];
  double get _rpmLimitFrac   => _stageRpmLimit / _kMaxRpm;

  // Derived RPM using TW200 gear ratios
  double get _rpmFrac {
    if (!_isRiding || _speedKmh < 1) return 900 / _kMaxRpm; // idle
    final speedMs  = _speedKmh / 3.6;
    final wheelRpm = speedMs / _kWheelCircM * 60;
    final ratio    = _kGearRatios[(_gear - 1).clamp(0, 4)];
    return (wheelRpm * ratio).clamp(0.0, _kMaxRpm.toDouble()) / _kMaxRpm;
  }

  bool get _isOverLimit => _isRiding && _speedKmh > _stageSpdLimit;

  // ── Gear estimation from speed ─────────────────────────────────────────────
  int _estimateGear(double kmh) {
    if (kmh <  10) return 1;
    if (kmh <  22) return 2;
    if (kmh <  38) return 3;
    if (kmh <  58) return 4;
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
    if (!serviceOn) { if (mounted) setState(() => _gpsError = true); return; }

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
        accuracy:       LocationAccuracy.high,
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
    final newGear  = _isRiding ? _estimateGear(newSpeed) : 0;

    double added = 0;
    if (_isRiding && _lastPos != null) {
      added = Geolocator.distanceBetween(
        _lastPos!.latitude,  _lastPos!.longitude,
        pos.latitude,        pos.longitude,
      ) / 1000; // m → km
    }
    _lastPos = pos;

    setState(() {
      _speedKmh   = _isRiding ? newSpeed : 0;
      _gear       = newGear;
      _distanceKm += _isRiding ? added : 0;
    });

    // Voice alert — speaks once, then waits 30 s before re-triggering
    if (_isRiding && newSpeed > _stageSpdLimit && !_voiceAlertActive) {
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
    final now  = DateTime.now();
    final doy  = now.difference(DateTime(now.year, 1, 1)).inDays;
    final decl = -23.45 * math.cos(2 * math.pi * (doy + 10) / 365) * math.pi / 180;
    const latRad = 20.0 * math.pi / 180;
    final cosHa  = -math.tan(latRad) * math.tan(decl);
    if (cosHa >= 1)  return false;
    if (cosHa <= -1) return true;
    final ha      = math.acos(cosHa) * 180 / math.pi;
    final localH  = now.hour + now.minute / 60.0;
    return localH >= (12.0 - ha / 15.0) && localH < (12.0 + ha / 15.0);
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _toggleRide() {
    setState(() {
      if (_isRiding) {
        _rideTimer?.cancel();
        _rideTimer = null;
        _isRiding  = false;
        _speedKmh  = 0;
        _gear      = 0;
        _lastPos   = null;
        _voiceAlertActive = false;
        _tts.stop();
      } else {
        _elapsed    = Duration.zero;
        _distanceKm = 0;
        _lastPos    = null;
        _isRiding   = true;
        _gear       = 1;
        // Start GPS stream (requests permission if not yet granted)
        _startGpsStream();
        // Elapsed timer — GPS provides speed, this tracks wall-clock ride time
        _rideTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() => _elapsed += const Duration(seconds: 1));
        });
      }
    });
  }

  void _toggleDayMode() {
    setState(() {
      _isManualOverride = true;
      _isDayMode        = !_isDayMode;
    });
  }

  void _resetToAutoMode() {
    setState(() {
      _isManualOverride = false;
      _isDayMode        = _computeAutoDay();
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

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              isRiding:         _isRiding,
              isDayMode:        _isDayMode,
              isManualOverride: _isManualOverride,
              gpsReady:         _gpsReady,
              gpsError:         _gpsError,
              stageIdx:         _stageIdx,
              stageSpdLimit:    _stageSpdLimit,
              stageRpmLimit:    _stageRpmLimit,
              palette:          p,
              onToggleRide:     _toggleRide,
              onToggleMode:     _toggleDayMode,
              onResetAuto:      _resetToAutoMode,
            ),

            if (_isOverLimit)
              _SpeedWarning(speedLimit: _stageSpdLimit, palette: p),

            Expanded(
              child: _SpeedDisplay(
                speed:       _speedKmh,
                isRiding:    _isRiding,
                isOverLimit: _isOverLimit,
                palette:     p,
              ),
            ),

            _RpmSection(
              rpmFrac:    _isRiding ? _rpmFrac : 900 / _kMaxRpm,
              limitFrac:  _rpmLimitFrac,
              rpmLabel:   _isRiding ? _rpmLabel(_rpmFrac) : 'Idle',
              limitLabel: '$_stageRpmLimit RPM max',
              isDayMode:  _isDayMode,
              palette:    p,
            ),

            const SizedBox(height: RLSpacing.md),

            _MetricsRow(
              isRiding:   _isRiding,
              gear:       _gear,
              distanceKm: _distanceKm,
              elapsed:    _elapsed,
              formatTime: _formatElapsed,
              palette:    p,
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
  final bool isRiding, isDayMode, isManualOverride, gpsReady, gpsError;
  final int stageIdx, stageRpmLimit;
  final double stageSpdLimit;
  final _Palette palette;
  final VoidCallback onToggleRide, onToggleMode, onResetAuto;

  const _TopBar({
    required this.isRiding,
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
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RLSpacing.base, RLSpacing.md, RLSpacing.base, RLSpacing.sm,
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
                      isRiding ? 'RIDING' : 'READY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isRiding ? p.accent : p.textMut,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // GPS indicator dot
                    Container(
                      width: 7, height: 7,
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
                      gpsError ? 'GPS off' : gpsReady ? 'GPS' : 'GPS…',
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
              width: 42, height: 42,
              decoration: BoxDecoration(
                color:        p.surface,
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

          // Start / Stop
          GestureDetector(
            onTap: onToggleRide,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: RLSpacing.md, vertical: 10),
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
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.md, vertical: RLSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.base, vertical: RLSpacing.sm),
      decoration: BoxDecoration(
        color:        p.warnSurf,
        borderRadius: RLRadius.borderMd,
        border:       Border(left: BorderSide(color: p.error, width: 3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 22, color: p.error),
          const SizedBox(width: 10),
          Text(
            'Over limit — slow down below ${speedLimit.toStringAsFixed(0)} km/h',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.text),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Speed display
// ════════════════════════════════════════════════════════════════════════════

class _SpeedDisplay extends StatelessWidget {
  final double speed;
  final bool isRiding, isOverLimit;
  final _Palette palette;

  const _SpeedDisplay({
    required this.speed,
    required this.isRiding,
    required this.isOverLimit,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p     = palette;
    final color = isOverLimit ? p.error : p.text;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isRiding ? speed.toStringAsFixed(0) : '0',
            style: TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.w200,
              color: color,
              letterSpacing: -5,
              height: 1.0,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'km/h',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: p.textSec,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RPM zone section
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RPM ZONE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: p.textMut,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                rpmLabel,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.accent),
              ),
              const SizedBox(width: 6),
              Text(
                '/ $limitLabel',
                style: TextStyle(fontSize: 13, color: p.textMut),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Bar — height increased to 60 for better visibility
          SizedBox(
            height: 60,
            child: CustomPaint(
              painter: _RpmBarPainter(
                rpmFrac:   rpmFrac,
                limitFrac: limitFrac,
                isDay:     isDayMode,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _ZLabel('IDLE',    p.textMut),
              const Spacer(),
              _ZLabel('OPTIMAL', p.textMut),
              const Spacer(),
              _ZLabel('LIMIT',   p.accent),
              const Spacer(),
              _ZLabel('DANGER',  p.error),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZLabel extends StatelessWidget {
  final String t; final Color c;
  const _ZLabel(this.t, this.c);
  @override
  Widget build(BuildContext context) => Text(t,
    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c, letterSpacing: 0.8));
}

// ════════════════════════════════════════════════════════════════════════════
// RPM Bar CustomPainter
// Draws four colour-coded zones + stage-limit marker + current-RPM dot
// ════════════════════════════════════════════════════════════════════════════

class _RpmBarPainter extends CustomPainter {
  final double rpmFrac, limitFrac;
  final bool isDay;

  const _RpmBarPainter({
    required this.rpmFrac,
    required this.limitFrac,
    required this.isDay,
  });

  static const _olive  = Color(0xFF8F9E62);
  static const _amber  = Color(0xFFC9964A);
  static const _amberD = Color(0xFFB8852A);
  static const _orange = Color(0xFFCC6B2A);
  static const _red    = Color(0xFFBF5A50);

  Color get _zA => isDay ? _amberD : _amber;

  // Zone boundaries
  static const _z1 = 0.27; // end of idle
  // z2 = limitFrac           end of optimal
  static const _z3 = 0.88; // end of caution

  @override
  void paint(Canvas canvas, Size size) {
    final w    = size.width;
    final barH = size.height * 0.50; // bar occupies top 50 %; bottom for dot
    const barT = 0.0;
    const r    = Radius.circular(5);

    final bgColor = isDay ? const Color(0xFFBFBCB4) : const Color(0xFF252A38);

    // Background track
    _seg(canvas, w, barT, barH, r, 0, 1, bgColor);

    // Zone overlays — increased opacity for better visibility
    _seg(canvas, w, barT, barH, r, 0,       _z1,       _olive.withValues(alpha: 0.40));
    _seg(canvas, w, barT, barH, r, _z1,     limitFrac, _zA.withValues(alpha: 0.35));
    _seg(canvas, w, barT, barH, r, limitFrac, _z3,     _orange.withValues(alpha: 0.35));
    _seg(canvas, w, barT, barH, r, _z3,     1,         _red.withValues(alpha: 0.40));

    // Filled portion (solid, full opacity)
    if (rpmFrac > 0.02) {
      final fc = rpmFrac <= _z1
          ? _olive
          : rpmFrac <= limitFrac
              ? _zA
              : rpmFrac <= _z3
                  ? _orange
                  : _red;
      _seg(canvas, w, barT, barH, r, 0, rpmFrac.clamp(0.0, 1.0), fc);
    }

    // Stage limit marker — vertical line
    final lx = limitFrac * w;
    final mc  = (isDay ? const Color(0xFF191B24) : const Color(0xFFEDEAE4))
        .withValues(alpha: 0.90);
    canvas.drawLine(
      Offset(lx, barT - 4), Offset(lx, barT + barH + 4),
      Paint()..color = mc ..strokeWidth = 2.5 ..strokeCap = StrokeCap.round,
    );
    // Small amber triangle above the bar pointing to the limit
    final tri = Path()
      ..moveTo(lx, barT - 4)
      ..lineTo(lx - 5, barT - 13)
      ..lineTo(lx + 5, barT - 13)
      ..close();
    canvas.drawPath(tri, Paint()..color = _zA);

    // Current RPM dot below the bar
    final dotX  = (rpmFrac * w).clamp(7.0, w - 7.0);
    final dotY  = barT + barH + (size.height - barH) * 0.58;
    final dotColor = rpmFrac <= _z1
        ? _olive
        : rpmFrac <= limitFrac
            ? _zA
            : rpmFrac <= _z3
                ? _orange
                : _red;
    canvas.drawCircle(Offset(dotX, dotY), 7,  Paint()..color = dotColor);
    canvas.drawCircle(Offset(dotX, dotY), 7,
      Paint()
        ..color       = (isDay ? const Color(0xFFECE9E1) : const Color(0xFF0E0F14))
            .withValues(alpha: 0.35)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  void _seg(Canvas canvas, double w, double t, double h, Radius r,
      double f0, double f1, Color c) {
    final x0 = f0 * w, x1 = f1 * w;
    if (x1 <= x0 + 0.5) return;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x0, t, x1 - x0, h), r),
      Paint()..color = c,
    );
  }

  @override
  bool shouldRepaint(_RpmBarPainter o) =>
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
          Expanded(child: _MetricTile(label: 'GEAR',     value: isRiding ? '$gear' : '—',                        unit: '', valueColor: p.accent, palette: p)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(label: 'DISTANCE', value: isRiding ? distanceKm.toStringAsFixed(1) : '0.0', unit: 'km', valueColor: p.text, palette: p)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(label: 'ELAPSED',  value: formatTime(elapsed),                              unit: '', valueColor: p.text, palette: p)),
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
      padding: const EdgeInsets.symmetric(vertical: RLSpacing.md, horizontal: RLSpacing.sm),
      decoration: BoxDecoration(
        color: p.surface, borderRadius: RLRadius.borderLg, border: Border.all(color: p.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700,
              color: p.textMut, letterSpacing: 1.2,
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
                Text(value,
                  style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w600,
                    color: valueColor, height: 1.0,
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

class _BreakInBar extends StatelessWidget {
  final _Palette palette;
  const _BreakInBar({required this.palette});

  @override
  Widget build(BuildContext context) {
    final p   = palette;
    final bIn = SampleData.breakIn;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: RLSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: RLSpacing.base, vertical: RLSpacing.md),
      decoration: BoxDecoration(
        color: p.surface, borderRadius: RLRadius.borderLg, border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Break-in',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.textSec)),
              const Spacer(),
              Text(
                '${bIn.currentKm.toStringAsFixed(0)} / ${bIn.targetKm.toStringAsFixed(0)} km'
                '  ·  ${bIn.progressPercent}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: RLRadius.borderPill,
            child: Container(
              height: 6, color: p.border,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: bIn.progressFraction,
                child: Container(color: p.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
