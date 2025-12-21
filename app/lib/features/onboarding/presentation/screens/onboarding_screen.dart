import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/features/onboarding/presentation/widgets/scene_goal.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zestinme/features/onboarding/presentation/widgets/scene_identity.dart';
import 'package:zestinme/features/onboarding/presentation/widgets/scene_void.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentScene = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        child: _buildScene(),
      ),
    );
  }

  Widget _buildScene() {
    switch (_currentScene) {
      case 0:
        return SceneVoid(
          onCleaningComplete: () {
            setState(() {
              _currentScene = 1;
            });
          },
        );
      case 1:
        return SceneIdentity(
          onNameSubmitted: () {
            setState(() {
              _currentScene = 2; // Move to SceneEncounter (was 3)
            });
          },
        );
      case 2:
        return SceneEncounter(
          onEncounterComplete: () async {
            // Mark as completed in ViewModel + DB
            await ref.read(onboardingViewModelProvider.notifier).complete();

            if (context.mounted) {
              context.go('/'); // Navigate to Home
            }
          },
        );
      default:
        return Container();
    }
  }
}
