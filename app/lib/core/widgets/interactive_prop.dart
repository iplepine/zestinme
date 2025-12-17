import 'package:flutter/material.dart';
import 'dart:math' as math;

enum PropAnimationType {
  none,
  float, // Up/Down (Lantern)
  swing, // Rotation (Wind Chime)
  pulse, // Scale (Plant/Seed)
}

class InteractiveProp extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final PropAnimationType animationType;
  final double intensity; // 0.0 ~ 1.0 (Movement range)

  const InteractiveProp({
    super.key,
    required this.child,
    this.onTap,
    this.animationType = PropAnimationType.none,
    this.intensity = 1.0,
  });

  @override
  State<InteractiveProp> createState() => _InteractivePropState();
}

class _InteractivePropState extends State<InteractiveProp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Idle Animation Controller (Continuous)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Idle Animation (Floating/Swinging)
    Widget content = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value; // 0.0 -> 1.0 -> 0.0

        switch (widget.animationType) {
          case PropAnimationType.float:
            // Move Up/Down by 10px * intensity
            return Transform.translate(
              offset: Offset(
                0,
                math.sin(t * math.pi * 2) * 5 * widget.intensity,
              ),
              child: child,
            );
          case PropAnimationType.swing:
            // Rotate slightly (-5 deg ~ 5 deg)
            return Transform.rotate(
              angle: math.sin(t * math.pi * 2) * 0.05 * widget.intensity,
              alignment: Alignment.topCenter, // Swing from top
              child: child,
            );
          case PropAnimationType.pulse:
            // Scale slightly (0.95 ~ 1.05)
            final scale =
                1.0 + (math.sin(t * math.pi * 2) * 0.05 * widget.intensity);
            return Transform.scale(scale: scale, child: child);
          case PropAnimationType.none:
            return child!;
        }
      },
      child: widget.child,
    );

    // 2. Tap Interaction (Squash/Scale)
    final tapScale = _isPressed ? 0.9 : 1.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: tapScale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutQuad,
        child: content,
      ),
    );
  }
}
