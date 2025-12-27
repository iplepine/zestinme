import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../garden/presentation/providers/current_pot_provider.dart';

class MirrorPlantScene extends ConsumerStatefulWidget {
  const MirrorPlantScene({super.key});

  @override
  ConsumerState<MirrorPlantScene> createState() => _MirrorPlantSceneState();
}

class _MirrorPlantSceneState extends ConsumerState<MirrorPlantScene> {
  String? _currentQuestion;

  void _showSelfTalk() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      // Simple logic for prototype: Cycle or Random
      // In real implementation, this should be based on Plant/Environment State
      final questions = [
        l10n.homeQuestionDefault,
        l10n.homeQuestionTired,
        l10n.homeQuestionHappy,
      ];
      _currentQuestion = (questions..shuffle()).first;
    });

    // Auto-hide after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentQuestion = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPot = ref.watch(currentPotNotifierProvider);

    return Expanded(
      child: GestureDetector(
        onTap: _showSelfTalk,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Particles (Background)
            // TODO: Add ParticleSystem for 'Gazing' mode

            // The Plant
            if (currentPot != null)
              _buildPlant(
                'assets/images/plants/plant_${currentPot.speciesName}_${currentPot.growthStage}.png',
                'assets/images/plants/plant_${currentPot.speciesName}_1.png',
              )
            else
              const SizedBox(), // Or Empty State
            // Question Bubble (Self-Talk)
            if (_currentQuestion != null)
              Positioned(top: 40, child: _buildBubble(_currentQuestion!)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlant(String assetPath, String fallbackPath) {
    return Image.asset(
          assetPath,
          width: 280,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to stage 1 if the specific growth stage asset is missing
            return Image.asset(fallbackPath, width: 280, fit: BoxFit.contain);
          },
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.02,
          duration: 3000.ms,
          curve: Curves.easeInOutQuad,
        ) // Breathing effect
        .moveY(
          begin: 0,
          end: -5,
          duration: 4000.ms,
          curve: Curves.easeInOutSine,
        ); // Floating/Growing feel
  }

  Widget _buildBubble(String text) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        )
        .animate()
        .fade(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack);
  }
}
