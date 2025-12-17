import 'package:flutter/material.dart';
import 'package:zestinme/core/widgets/interactive_prop.dart';

class WindChimeWidget extends StatelessWidget {
  final VoidCallback onTap;

  const WindChimeWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InteractiveProp(
      onTap: onTap,
      animationType: PropAnimationType.swing,
      intensity: 0.5,
      child: Container(
        width: 60,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wind_power, color: Colors.white70),
            SizedBox(height: 4),
            Text("Wind", style: TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
