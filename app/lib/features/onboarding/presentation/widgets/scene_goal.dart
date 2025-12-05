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
              "어떤 씨앗을 심을까요?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().moveY(begin: 20, end: 0),
            const SizedBox(height: 16),
            const Text(
              "마음의 정체성에 맞는 씨앗을 골라주세요.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ).animate().fadeIn(delay: 200.ms),
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
                  "🌙 달맞이꽃",
                  "깊은 잠과 휴식",
                  Colors.indigo,
                ),
                _buildCard(
                  context,
                  ref,
                  "anger",
                  "🌵 선인장",
                  "감정의 가시 다듬기",
                  Colors.green,
                ),
                _buildCard(
                  context,
                  ref,
                  "happiness",
                  "🌻 해바라기",
                  "긍정과 가치 찾기",
                  Colors.amber,
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
        ref.read(onboardingViewModelProvider.notifier).selectModule(id);
        ref.read(onboardingViewModelProvider.notifier).complete();
        onGoalSelected();
      },
      child: Container(
        width: 150,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.8), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.split(' ')[0], // Icon
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 20),
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
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }
}
