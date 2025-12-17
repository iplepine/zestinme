import 'package:flutter/material.dart';
import 'dart:async';

class ScenicBackground extends StatefulWidget {
  const ScenicBackground({super.key});

  @override
  State<ScenicBackground> createState() => _ScenicBackgroundState();
}

class _ScenicBackgroundState extends State<ScenicBackground> {
  late String _currentAsset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize immediately without setState
    _currentAsset = _getAssetByTime();

    // Check every minute to update background if time crosses threshold
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkAndUpdate(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getAssetByTime() {
    final hour = DateTime.now().hour;
    // 05:00 ~ 17:00 (Daytime) -> Dawn image
    // 17:00 ~ 05:00 (Nighttime) -> Night image
    final isDaytime = hour >= 5 && hour < 17;
    return isDaytime
        ? 'assets/images/backgrounds/home_dawn.png' // jpg -> png checked in find_by_name
        : 'assets/images/backgrounds/home_night.png';
  }

  void _checkAndUpdate() {
    final newAsset = _getAssetByTime();
    if (_currentAsset != newAsset) {
      if (mounted) {
        setState(() {
          _currentAsset = newAsset;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with Crossfade
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Image.asset(
            _currentAsset,
            key: ValueKey(_currentAsset),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Optional Overlay Gradient to ensure text legibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3), // Top darkening
                Colors.transparent,
                Colors.black.withOpacity(0.6), // Bottom darkening for buttons
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
