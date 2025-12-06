import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/environment_provider.dart';

class CheckInSheet extends ConsumerStatefulWidget {
  const CheckInSheet({super.key});

  @override
  ConsumerState<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends ConsumerState<CheckInSheet> {
  // Simple sliders for Valence (Sunlight) and Arousal (Temperature)
  // Valence: 0 (Unpleasant) -> 1 (Pleasant)
  // Arousal: 0 (Calm/Low Energy) -> 1 (Excited/High Energy)
  double _valence = 0.5;
  double _arousal = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Quick Check-in",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          _buildSlider(
            label: "Sunlight (Mood)",
            value: _valence,
            leadingIcon: Icons.cloud_outlined,
            trailingIcon: Icons.wb_sunny_rounded,
            activeColor: Colors.amber,
            onChanged: (v) => setState(() => _valence = v),
          ),

          const SizedBox(height: 24),

          _buildSlider(
            label: "Temperature (Energy)",
            value: _arousal,
            leadingIcon: Icons.ac_unit_rounded,
            trailingIcon: Icons.whatshot_rounded,
            activeColor: Colors.redAccent,
            onChanged: (v) => setState(() => _arousal = v),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {
              ref
                  .read(environmentNotifierProvider.notifier)
                  .checkIn(_valence, _arousal);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mind Weather Updated')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Update Environment",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required IconData leadingIcon,
    required IconData trailingIcon,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            Icon(leadingIcon, color: Colors.grey),
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
                activeColor: activeColor,
                inactiveColor: Colors.grey.shade200,
              ),
            ),
            Icon(trailingIcon, color: activeColor),
          ],
        ),
      ],
    );
  }
}
