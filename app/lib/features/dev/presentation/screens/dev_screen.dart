import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          _buildNavTile(context, '🌿 Home Dashboard', '/'),
          _buildNavTile(context, '🌱 Seeding (New Catch)', '/seeding'),
          _buildNavTile(context, '🚀 Onboarding', '/onboarding'),
          _buildNavTile(context, '📖 History', '/history'),
          const Divider(color: Colors.white24),
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
