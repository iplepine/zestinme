import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

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

  // Logic: Grid points inside the pot to measure coverage
  final List<Offset> _potTargetPoints = [];
  final Set<int> _hitIndices =
      {}; // Indices of target points that have been cleaned

  bool _isCleaned = false;
  double _cleanedRatio = 0.0;

  // Pot Dimensions (Must match PotPainter)
  final double _wTop = 160;
  final double _wBottom = 120;
  final double _h = 160;

  bool _showIntro = true; // Start with intro
  bool _showPot = false;

  @override
  void initState() {
    super.initState();
    // Center of SizedBox(300, 400) is (150, 200).
    _generatePotGrid(const Offset(150, 200));
    _startIntro();
  }

  void _startIntro() async {
    // 1. Intro Text Duration
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    setState(() {
      _showIntro = false;
    });

    // 2. Fade in Pot
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _showPot = true;
    });
  }

  void _generatePotGrid(Offset center) {
    _potTargetPoints.clear();
    final path = Path();
    path.moveTo(center.dx - _wTop / 2, center.dy - _h / 2);
    path.lineTo(center.dx + _wTop / 2, center.dy - _h / 2);
    path.lineTo(center.dx + _wBottom / 2, center.dy + _h / 2);
    path.lineTo(center.dx - _wBottom / 2, center.dy + _h / 2);
    path.close();

    // Generate grid points bounding box
    // Top-Left: (center.dx - wTop/2, center.dy - h/2)
    // Grid spacing: 10px (dense enough for 95% accuracy)
    const double step = 10.0;

    for (double y = center.dy - _h / 2; y <= center.dy + _h / 2; y += step) {
      for (
        double x = center.dx - _wTop / 2;
        x <= center.dx + _wTop / 2;
        x += step
      ) {
        final point = Offset(x, y);
        if (path.contains(point)) {
          _potTargetPoints.add(point);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Darker soil/night color
      body: Stack(
        children: [
          // Background - Subtle texture?
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF2C2C3E), Color(0xFF111116)],
                  radius: 1.5,
                  center: Alignment.center,
                ),
              ),
            ),
          ),

          // Central Interaction Area
          if (_showIntro)
            Center(
              child:
                  Text(
                        "당신의 마음 한구석,\n오랫동안 잊고 지낸\n작은 정원이 있습니다.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .then(delay: 2000.ms)
                      .fadeOut(duration: 1000.ms),
            ),

          if (_showPot)
            Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. The Clean Pot (Underneath)
                    Image.asset(
                      'assets/images/pots/pot_1.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ).animate().fadeIn(duration: 1000.ms), // Fade in the pot
                    // ... Dust Layer follows (only if showPot is true, inherently handled by parent visibility but we need to animate it too if needed)
                    // Actually, the dust layer should appear WITH the pot.

                    // 2. The Dust Layer (On Top)
                    GestureDetector(
                      onPanUpdate: (details) {
                        if (_isCleaned) return;
                        // ... (Rest of logic)

                        setState(() {
                          // Add visual point
                          _cleanedPoints.add(details.localPosition);

                          // Check collision with Pot Grid
                          // Cleaning radius = 25.0 (matches DustPainter eraser)
                          const double cleaningRadius = 25.0;

                          for (int i = 0; i < _potTargetPoints.length; i++) {
                            if (!_hitIndices.contains(i)) {
                              if ((_potTargetPoints[i] - details.localPosition)
                                      .distance <
                                  cleaningRadius) {
                                _hitIndices.add(i);
                              }
                            }
                          }

                          // Update Ratio
                          if (_potTargetPoints.isNotEmpty) {
                            _cleanedRatio =
                                _hitIndices.length / _potTargetPoints.length;
                          }
                        });

                        // Haptic density check (Visual only)
                        if (_cleanedPoints.length % 5 == 0) {
                          HapticFeedback.selectionClick();
                        }

                        // Check for completion (98%)
                        if (_cleanedRatio >= 0.98 && !_isCleaned) {
                          _finishCleaning();
                        }
                      },
                      child: CustomPaint(
                        size: const Size(300, 400),
                        painter: DustPainter(cleanedPoints: _cleanedPoints),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Instructions
          if (!_isCleaned)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "오랫동안 방치된 화분을 찾았습니다...\n먼지가 많이 쌓여있네요.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ).animate().fade().moveY(begin: 10, end: 0),
                  const SizedBox(height: 20),
                  Icon(Icons.touch_app, color: Colors.white24, size: 32)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveX(begin: -10, end: 10, duration: 1000.ms),
                ],
              ),
            ),

          // Transition Overlay or Success Message
          if (_isCleaned)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "화분이 깨끗해졌습니다!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(color: Colors.greenAccent),
                  ],
                ),
              ).animate().fade().scale(),
            ),
        ],
      ),
    );
  }

  void _finishCleaning() {
    setState(() {
      _isCleaned = true;
    });
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(seconds: 2), () {
      widget.onCleaningComplete();
    });
  }
}

// -----------------------------------------------------------------------------
// PAINTERS
// -----------------------------------------------------------------------------

class DustPainter extends CustomPainter {
  final List<Offset> cleanedPoints;

  DustPainter({required this.cleanedPoints});

  @override
  void paint(Canvas canvas, Size size) {
    // Save layer to apply composite operation (destination-out for erasing)
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // 1. Draw full dust layer
    final dustPaint = Paint()
      ..color = const Color(0xFFC4BCAF)
          .withOpacity(0.8) // Warm dusty beige
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      ); // Softer edges

    // Organic "Dust" cloud shape covering the pot area
    final rect = Rect.fromLTWH(20, 40, size.width - 40, size.height - 80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(60)),
      dustPaint,
    );

    // 2. Erase the cleaned points
    final eraser = Paint()
      ..blendMode = BlendMode
          .clear // Clear pixels
      ..style = PaintingStyle.fill
      ..strokeWidth = 30.0;

    for (var point in cleanedPoints) {
      canvas.drawCircle(point, 25.0, eraser);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(DustPainter old) =>
      old.cleanedPoints.length != cleanedPoints.length;
}
