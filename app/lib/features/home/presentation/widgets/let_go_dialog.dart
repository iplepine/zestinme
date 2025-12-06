import 'package:flutter/material.dart';

class LetGoDialog extends StatelessWidget {
  const LetGoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Let Go",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wind_power, size: 48, color: Colors.indigoAccent),
          SizedBox(height: 16),
          Text(
            "Shall we prune the heavy thoughts\nfloating in your mind?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Keep"),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement Logic (e.g., reduce arousal/temperature)
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your mind feels lighter.')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Let Go"),
        ),
      ],
    );
  }
}
