import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:zestinme/l10n/app_localizations.dart';

class SceneVoid extends StatefulWidget {
  final VoidCallback
  onCleaningComplete; // Renamed from onFishingComplete for Gardening consistency

  const SceneVoid({super.key, required this.onCleaningComplete});

  @override
  State<SceneVoid> createState() => _SceneVoidState();
}

class _SceneVoidState extends State<SceneVoid> {
  // User input points for visual drawing
  final List<Offset> _cleanedPoints = [];

  // Logic: Grid points inside the central area to measure coverage
  final List<Offset> _targetPoints = [];
  final Set<int> _hitIndices = {};

  bool _isCleaned = false;
  double _cleanedRatio = 0.0;

  // Space Dimensions (Circular area)
  final double _radius = 120;

  bool _showIntro = true;
  bool _showSpace = false;

  @override
  void initState() {
    super.initState();
    // Center of SizedBox(300, 400) is (150, 200).
    _generateTargetGrid(const Offset(150, 200));
    _startIntro();
  }

  void _startIntro() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    setState(() {
      _showIntro = false;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _showSpace = true;
    });
  }

  void _generateTargetGrid(Offset center) {
    _targetPoints.clear();
    const double step = 10.0;

    for (double y = center.dy - _radius; y <= center.dy + _radius; y += step) {
      for (
        double x = center.dx - _radius;
        x <= center.dx + _radius;
        x += step
      ) {
        final point = Offset(x, y);
        if ((point - center).distance <= _radius) {
          _targetPoints.add(point);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF101418), // Match Dark Night
      body: Stack(
        children: [
          // 1. Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF1A1F26), Color(0xFF101418)],
                  radius: 1.2,
                  center: Alignment.center,
                ),
              ),
            ),
          ),

          // 2. Central Interaction Area
          if (_showIntro)
            Center(
              child:
                  Text(
                        l10n.onboarding_intro_message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.8,
                          fontWeight: FontWeight.w200,
                          letterSpacing: -0.5,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 1500.ms)
                      .then(delay: 3000.ms)
                      .fadeOut(duration: 1000.ms),
            ),

          if (_showSpace)
            Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. The Ground Space (Underneath)
                    Container(
                      width: _radius * 2,
                      height: _radius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF2D264B).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 2000.ms),

                    // 2. The Fog Layer (On Top)
                    GestureDetector(
                      onPanUpdate: (details) {
                        if (_isCleaned) return;

                        setState(() {
                          _cleanedPoints.add(details.localPosition);

                          const double cleaningRadius = 25.0;
                          for (int i = 0; i < _targetPoints.length; i++) {
                            if (!_hitIndices.contains(i)) {
                              if ((_targetPoints[i] - details.localPosition)
                                      .distance <
                                  cleaningRadius) {
                                _hitIndices.add(i);
                              }
                            }
                          }

                          if (_targetPoints.isNotEmpty) {
                            _cleanedRatio =
                                _hitIndices.length / _targetPoints.length;
                          }
                        });

                        if (_cleanedPoints.length % 5 == 0) {
                          HapticFeedback.selectionClick();
                        }

                        if (_cleanedRatio >= 0.95 && !_isCleaned) {
                          _finishCleaning();
                        }
                      },
                      child: CustomPaint(
                        size: const Size(300, 400),
                        painter: FogPainter(cleanedPoints: _cleanedPoints),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Instructions
          if (!_isCleaned && _showSpace)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    l10n.onboarding_found_pot_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(duration: 1000.ms, delay: 1000.ms),
                  const SizedBox(height: 32),
                  const Icon(
                        Icons.touch_app_outlined,
                        color: Colors.white24,
                        size: 28,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: 10, duration: 1500.ms),
                ],
              ),
            ),

          // Transition Overlay
          if (_isCleaned)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.onboarding_cleaning_complete,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn().scale(),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _finishCleaning() {
    setState(() {
      _isCleaned = true;
    });
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(seconds: 2), () {
      widget.onCleaningComplete();
    });
  }
}

class FogPainter extends CustomPainter {
  final List<Offset> cleanedPoints;

  FogPainter({required this.cleanedPoints});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // 1. Draw full fog layer
    final fogPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
          .withOpacity(0.15) // Subtle gray fog
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 140, fogPaint);

    // 2. Erase (Clarify) the cleaned points
    final eraser = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;

    for (var point in cleanedPoints) {
      canvas.drawCircle(point, 30.0, eraser);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(FogPainter old) =>
      old.cleanedPoints.length != cleanedPoints.length;
}
