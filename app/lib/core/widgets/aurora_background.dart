import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui'; // For ImageFilter

class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Deep Night Colors
    const Color bgBase = Color(0xFF0F172A); // Slate 900
    const Color aurora1 = Color(0xFF4C1D95); // Violet 900 (Deep)
    const Color aurora2 = Color(0xFF0F766E); // Teal 700 (Muted)
    const Color aurora3 = Color(0xFF312E81); // Indigo 900

    return Stack(
      children: [
        // 1. Deep Base
        Container(color: bgBase),

        // 2. Moving Orbs (Simulating Mesh Gradient)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            // Introduce subtle chaos
            final wave1 = math.sin(t * 2 * math.pi);
            final wave2 = math.cos(t * 2 * math.pi);

            return Stack(
              children: [
                // Top-Left Aurora (Violet)
                Positioned(
                  top: -100 + (wave1 * 50),
                  left: -50 + (wave2 * 30),
                  child: _buildBlurOrb(aurora1, 300),
                ),
                // Bottom-Right Aurora (Teal)
                Positioned(
                  bottom: -100 - (wave2 * 50),
                  right: -50 + (wave1 * 30),
                  child: _buildBlurOrb(aurora2, 350),
                ),
                // Center-ish Aurora (Indigo)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3 + (wave2 * 80),
                  left: MediaQuery.of(context).size.width * 0.2 - (wave1 * 60),
                  child: _buildBlurOrb(aurora3.withOpacity(0.6), 400),
                ),
              ],
            );
          },
        ),

        // 3. Noise Texture (Optional, simulates film grain)
        // Ignoring for now to keep performance high, can add via Image asset later.

        // 4. Overall Blur (To merge colors)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildBlurOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.0)],
          stops: const [0.2, 1.0],
        ),
      ),
    );
  }
}
