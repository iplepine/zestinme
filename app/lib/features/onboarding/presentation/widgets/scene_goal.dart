import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneGoal extends ConsumerWidget {
  final VoidCallback onGoalSelected;

  const SceneGoal({super.key, required this.onGoalSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "어디로 항해를 시작할까요?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().moveY(begin: 20, end: 0),
            const SizedBox(height: 40),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildCard(
                  context,
                  ref,
                  "sleep",
                  "🌙 깊은 잠의 섬",
                  "수면 효율 개선",
                  Colors.indigo,
                ),
                _buildCard(
                  context,
                  ref,
                  "anger",
                  "🔥 식지 않는 화산",
                  "분노 조절",
                  Colors.redAccent,
                ),
                _buildCard(
                  context,
                  ref,
                  "value",
                  "💎 잃어버린 보물",
                  "가치관 탐구",
                  Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
    String subtitle,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(onboardingControllerProvider.notifier).selectModule(id);
        ref.read(onboardingControllerProvider.notifier).complete();
        onGoalSelected();
      },
      child: Container(
        width: 150,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.split(' ')[0], // Icon
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 16),
            Text(
              title.split(' ').sublist(1).join(' '), // Text
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }
}
