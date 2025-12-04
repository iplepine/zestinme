import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class SceneVoid extends StatefulWidget {
  final VoidCallback onFishingComplete;

  const SceneVoid({super.key, required this.onFishingComplete});

  @override
  State<SceneVoid> createState() => _SceneVoidState();
}

class _SceneVoidState extends State<SceneVoid> {
  double _dragDistance = 0.0;
  bool _isFishing = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background: Dark Sea
        Container(color: const Color(0xFF0A101C)),

        // Fog Effect (Simplified with Gradient and Opacity)
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

        // Prompt Text
        Center(
          child:
              Text(
                    "안개를 걷어내려면 낚싯대를 당기세요",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
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
              // Threshold to trigger fishing
              _startFishing();
            } else {
              setState(() {
                _dragDistance = 0;
              });
            }
          },
          child: Container(
            color: Colors.transparent, // Hit test area
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: FishingRodPainter(dragDistance: _dragDistance),
            ),
          ),
        ),
      ],
    );
  }

  void _startFishing() async {
    setState(() {
      _isFishing = true;
    });

    HapticFeedback.heavyImpact();

    // Simulate fishing delay
    await Future.delayed(const Duration(seconds: 2));

    widget.onFishingComplete();
  }
}

class FishingRodPainter extends CustomPainter {
  final double dragDistance;

  FishingRodPainter({required this.dragDistance});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final start = Offset(size.width / 2, size.height / 2);
    final end = Offset(
      size.width / 2,
      size.height / 2 + dragDistance.clamp(0, 200),
    );

    // Draw simple line for now
    if (dragDistance > 0) {
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FishingRodPainter oldDelegate) {
    return oldDelegate.dragDistance != dragDistance;
  }
}
