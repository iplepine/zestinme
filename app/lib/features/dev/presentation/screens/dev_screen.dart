import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../features/caring/presentation/screens/caring_intro_screen.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Menu'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[850], // Dark theme default
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavTile(context, '🌿 Mind Gardener (Home)', '/'),
          _buildNavTile(context, '🌱 Seeding (New Catch)', '/seeding'),
          _buildNavTile(
            context,
            '🌙 Sleep Record (Dreaming)',
            '/sleep',
          ), // Added Sleep Screen
          _buildNavTile(context, '🚀 Onboarding', '/onboarding'),
          _buildNavTile(context, ' Garden Journal (History)', '/history'),
          const Divider(color: Colors.white24),

          ListTile(
            title: const Text(
              '💧 Test Caring Flow (Dummy)',
              style: TextStyle(color: Colors.cyanAccent),
            ),
            trailing: const Icon(Icons.science, color: Colors.cyanAccent),
            onTap: () {
              // Creating a dummy record
              final dummyRecord = EmotionRecord()
                ..timestamp = DateTime.now().subtract(const Duration(hours: 5))
                ..emotionLabel = 'Anxious'
                ..valence = 3.0
                ..arousal = 7.0;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CaringIntroScreen(record: dummyRecord),
                ),
              );
            },
          ),

          const Divider(color: Colors.white24),
          _buildNavTile(context, '⚙️ Settings', '/settings'),
          _buildNavTile(context, '🔒 Login (Legacy)', '/login'),
        ],
      ),
    );
  }

  Widget _buildNavTile(BuildContext context, String title, String route) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onTap: () => context.push(route),
      ),
    );
  }
}
