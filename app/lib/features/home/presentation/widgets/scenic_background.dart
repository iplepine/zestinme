import 'dart:ui';
import 'package:flutter/material.dart';

class ScenicBackground extends StatelessWidget {
  final double offsetY; // Vertical shift
  final String imagePath;

  const ScenicBackground({
    super.key,
    this.offsetY = 0,
    this.imagePath = 'assets/images/backgrounds/background_night.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Layer
        Transform.translate(
          offset: Offset(0, offsetY),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
