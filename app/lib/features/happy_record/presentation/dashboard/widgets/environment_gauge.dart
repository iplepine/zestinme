import 'package:flutter/material.dart';

class EnvironmentGauge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double value; // 0.0 to 1.0
  final String valueLabel; // e.g. "High", "24°C"

  const EnvironmentGauge({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon Circle
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),

        // Label
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),

        // Value Text
        Text(
          valueLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Linear Progress Bar
        SizedBox(
          width: 60,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white10,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
