import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class SceneVoid extends StatefulWidget {
  final VoidCallback onFishingComplete;

  const SceneVoid({super.key, required this.onFishingComplete});

  @override
  State<SceneVoid> createState() => _SceneVoidState();
}

class _SceneVoidState extends State<SceneVoid> with TickerProviderStateMixin {
  double _dragDistance = 0.0;
  bool _isFishing = false;
  bool _showSplash = false;

  late AnimationController _rodController;
  late Animation<double> _rodAnimation;

  @override
  void initState() {
    super.initState();
    _rodController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rodAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _rodController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _rodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background: Dark Sea
        Container(color: const Color(0xFF0A101C)),

        // Fog Effect
        Positioned.fill(
          child:
              Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(duration: 3000.ms, begin: 0.5, end: 0.8),
        ),

        // Splash Effect
        if (_showSplash)
          Center(
            child:
                Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                    )
                    .animate()
                    .scale(
                      duration: 600.ms,
                      begin: Offset.zero,
                      end: const Offset(2, 2),
                    )
                    .fadeOut(duration: 600.ms),
          ),

        if (_showSplash)
          Center(
            child:
                Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    )
                    .animate()
                    .scale(
                      duration: 400.ms,
                      begin: Offset.zero,
                      end: const Offset(1.5, 1.5),
                    )
                    .fadeOut(duration: 400.ms),
          ),

        // Prompt Text & Visual Cue
        if (!_isFishing)
          Center(
            child:
                Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "안개를 걷어내려면 낚싯대를 아래로 당기세요",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white.withOpacity(0.5),
                              size: 32,
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .moveY(begin: 0, end: 10, duration: 1000.ms)
                            .fade(begin: 0.2, end: 0.8),
                      ],
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(duration: 2000.ms),
          ),

        // Fishing Rod Interaction Area
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (_isFishing) return;
            setState(() {
              _dragDistance += details.delta.dy;
            });
          },
          onVerticalDragEnd: (details) {
            if (_isFishing) return;
            if (_dragDistance > 150) {
              _startFishing();
            } else {
              // Snap back if not pulled enough
              _animateRodBack();
            }
          },
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            child: AnimatedBuilder(
              animation: _rodController,
              builder: (context, child) {
                return CustomPaint(
                  painter: FishingRodPainter(
                    dragDistance: _isFishing
                        ? _rodAnimation.value
                        : _dragDistance,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _animateRodBack() {
    _rodAnimation = Tween<double>(begin: _dragDistance, end: 0).animate(
      CurvedAnimation(parent: _rodController, curve: Curves.elasticOut),
    );

    _rodController.forward(from: 0).then((_) {
      setState(() {
        _dragDistance = 0;
      });
    });
  }

  void _startFishing() async {
    setState(() {
      _isFishing = true;
    });

    // 1. Rod Snaps Back (Cast)
    HapticFeedback.mediumImpact();
    _animateRodBack();

    // 2. Wait for line to hit water
    await Future.delayed(const Duration(milliseconds: 400));

    // 3. Splash Effect
    HapticFeedback.heavyImpact();
    setState(() {
      _showSplash = true;
    });

    // 4. Wait for splash to finish and transition
    await Future.delayed(const Duration(seconds: 2));
    widget.onFishingComplete();
  }
}

class FishingRodPainter extends CustomPainter {
  final double dragDistance;

  FishingRodPainter({required this.dragDistance});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Configuration
    final tension = dragDistance.clamp(0.0, 300.0);
    final maxBend = 100.0; // Maximum pixels the tip bends down
    final bendAmount = (tension / 300.0) * maxBend;

    // Rod properties
    final rodColor = const Color(0xFF8D6E63); // Wood brown

    // 2. Define Points
    // Handle starts off-screen bottom-right
    final handleStart = Offset(size.width * 1.2, size.height * 1.2);
    // Rod base (visible start) - aiming towards center-top
    final defaultTip = Offset(size.width * 0.5, size.height * 0.4);

    // Calculate bent tip position
    // The tip moves down and slightly in as it bends
    final bentTip = Offset(defaultTip.dx, defaultTip.dy + bendAmount);

    // Control point for the rod's curve
    // As tension increases, the control point moves to create a sharper curve
    final controlPoint = Offset(
      size.width * 0.65,
      size.height * 0.6 + (bendAmount * 0.5),
    );

    // 3. Draw Rod (Tapered)
    final rodPaint = Paint()
      ..color = rodColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    final rodPath = Path();
    rodPath.moveTo(handleStart.dx, handleStart.dy);
    rodPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      bentTip.dx,
      bentTip.dy,
    );

    canvas.drawPath(rodPath, rodPaint);

    // 4. Draw Fishing Line
    // Line goes from bentTip to the water (or drag point)
    final lineStart = bentTip;
    final lineEnd = Offset(size.width / 2, size.height);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.0;

    canvas.drawLine(lineStart, lineEnd, linePaint);
  }

  @override
  bool shouldRepaint(covariant FishingRodPainter oldDelegate) {
    return oldDelegate.dragDistance != dragDistance;
  }
}
