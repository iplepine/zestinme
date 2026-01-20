import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/l10n/app_localizations.dart';
import 'package:zestinme/features/garden/presentation/providers/current_pot_provider.dart';
import 'package:zestinme/features/seeding/presentation/widgets/seeding_content.dart';
import 'package:zestinme/features/seeding/presentation/providers/seeding_provider.dart';

import 'package:zestinme/app/theme/app_theme.dart';
import 'package:zestinme/features/garden/domain/services/plant_service.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneEncounter extends ConsumerStatefulWidget {
  final VoidCallback onEncounterComplete;

  const SceneEncounter({super.key, required this.onEncounterComplete});

  @override
  ConsumerState<SceneEncounter> createState() => _SceneEncounterState();
}

class _SceneEncounterState extends ConsumerState<SceneEncounter> {
  // Steps:
  // 0: Seeding (Emotion Recording) via SeedingContent
  // 1: Sprout Animation & Instruction
  int _step = 0;
  bool _isFinishing = false;
  String _transitionMessage = "";

  void _onSeedingComplete() {
    // 1. Get the seeding state to determine the environment and plant
    final seedingState = ref.read(seedingNotifierProvider);
    final onboardingState = ref.read(onboardingViewModelProvider);

    // Map Seeding valence/arousal (-1 to 1) to Environment variables (0 to 1)
    // Valence maps to Sunlight (brightness)
    // Arousal maps to Temperature (energy)
    final sunlight = (seedingState.valence + 1) / 2;
    final energy = (seedingState.arousal + 1) / 2;
    final humidity =
        0.5; // Neutral default for now, can be randomized or linked to dragging speed

    // 2. Assign a plant based on these values
    final plant = PlantService().assignPlant(
      lux: sunlight * 100000,
      temp: energy * 40,
      humidity: humidity * 100,
    );

    // Determine emotion key for naming and logic
    String emotionKey = 'neutral';
    if (seedingState.arousal > 0) {
      emotionKey = seedingState.valence > 0 ? 'joy' : 'anger';
    } else {
      emotionKey = seedingState.valence > 0 ? 'peace' : 'sadness';
    }

    // 3. Create the First Pot using the assigned plant
    ref
        .read(currentPotNotifierProvider.notifier)
        .plantNewPot(
          emotionKey: emotionKey,
          nickname: onboardingState.nickname.isNotEmpty
              ? '${onboardingState.nickname}\'s Plant'
              : 'My First Plant',
          plantSpeciesId: plant.id,
        );

    // 4. Transition to Animation Step
    setState(() {
      _step = 1;
    });
  }

  void _finish() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isFinishing = true;
      _transitionMessage = l10n.onboarding_transition_planted;
    });

    // 1. "Seed Planted" message
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() {
      _transitionMessage = l10n.onboarding_transition_entering;
    });

    // 2. "Entering Sanctuary" message
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    widget.onEncounterComplete();
  }

  String _getLocalizedTag(AppLocalizations? l10n, String tag) {
    if (l10n == null) return tag;
    switch (tag) {
      // RED (High Energy, Negative)
      case 'Angry':
        return l10n.seeding_mood_angry;
      case 'Anxious':
        return l10n.seeding_mood_anxious;
      case 'Resentful':
        return l10n.seeding_mood_resentful;
      case 'Overwhelmed':
        return l10n.seeding_mood_overwhelmed;
      case 'Jealous':
        return l10n.seeding_mood_jealous;
      case 'Annoyed':
        return l10n.seeding_mood_annoyed;

      // BLUE (Low Energy, Negative)
      case 'Sad':
        return l10n.seeding_mood_sad;
      case 'Disappointed':
        return l10n.seeding_mood_disappointed;
      case 'Bored':
        return l10n.seeding_mood_bored;
      case 'Lonely':
        return l10n.seeding_mood_lonely;
      case 'Guilty':
        return l10n.seeding_mood_guilty;
      case 'Envious':
        return l10n.seeding_mood_envious;

      // YELLOW (High Energy, Positive)
      case 'Excited':
        return l10n.seeding_mood_excited;
      case 'Proud': // Replaces Joyful/Passionate
        return l10n.seeding_mood_proud;
      case 'Inspired':
        return l10n.seeding_mood_inspired;
      case 'Enthusiastic':
        return l10n.seeding_mood_enthusiastic;
      case 'Curious':
        return l10n.seeding_mood_curious;
      case 'Amused':
        return l10n.seeding_mood_amused;

      // GREEN (Low Energy, Positive)
      case 'Relaxed': // Replaces Calm
        return l10n.seeding_mood_relaxed;
      case 'Grateful':
        return l10n.seeding_mood_grateful;
      case 'Content':
        return l10n.seeding_mood_content;
      case 'Serene': // Replaces Peaceful
        return l10n.seeding_mood_serene;
      case 'Trusting':
        return l10n.seeding_mood_trusting;
      case 'Reflective':
        return l10n.seeding_mood_reflective;

      // Center
      case 'Neutral':
        return l10n.seeding_mood_neutral;

      default:
        return tag;
    }
  }

  // Korean Postposition Helper (Optional, if we display emotion name)
  String _getSubjectParticle(String text) {
    if (text.isEmpty) return "";
    int code = text.codeUnits.last;
    if (code < 0xAC00 || code > 0xD7A3) return "";
    return (code - 0xAC00) % 28 > 0 ? "은" : "는";
  }

  @override
  Widget build(BuildContext context) {
    // Force Dark Theme for this scene to match the SeedingScreen aesthetic
    return Theme(
      data: AppTheme.darkTheme,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // 1. Content
          // Use SafeArea for SeedingContent as it usually expects it?
          // Actually SeedingContent uses LayoutBuilder and fills space.
          // It draws a dark background (SoilPainter).
          // If _step == 0, show SeedingContent.
          if (_step == 0 && !_isFinishing)
            SeedingContent(onComplete: _onSeedingComplete),

          // If _step == 1, show Sprout/Instruction
          if (_step == 1 && !_isFinishing)
            // We need a background here since SeedingContent is gone.
            // Reuse Seeding content's background? Or a simple dark one.
            Stack(
              children: [
                Container(
                  color: const Color(0xFF1A1A1A), // Match SoilPainter base
                ),
                Center(
                  child: SingleChildScrollView(
                    child: _buildInstructionStep(context),
                  ),
                ),
              ],
            ),

          // 2. Transition Overlay
          if (_isFinishing)
            Container(
              color: Colors.black.withValues(alpha: 0.9),
              alignment: Alignment.center,
              child:
                  Text(
                        _transitionMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                        ),
                      )
                      .animate(key: ValueKey(_transitionMessage))
                      .fadeIn(duration: 1000.ms)
                      .then(delay: 1500.ms)
                      .fadeOut(duration: 500.ms),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Get latest state for display if needed
    final seedingState = ref.read(seedingNotifierProvider);
    // Determine display name (e.g. "Grateful" or "Joy")
    // Determine display name (e.g. "Grateful" or "Joy")
    final rawTag = seedingState.selectedTags.isNotEmpty
        ? seedingState.selectedTags.first
        : (seedingState.valence > 0 ? "Joy" : "Feeling"); // Fallback

    final emotionName = _getLocalizedTag(l10n, rawTag);
    final particle = _getSubjectParticle(emotionName);

    // Use MysteryPlantWidget instead of manual asset paths
    final currentPot = ref.watch(currentPotNotifierProvider);
    final selectedSpecies = currentPot != null
        ? PlantDatabase.species.firstWhere(
            (p) => p.id == currentPot.plantSpeciesId,
            orElse: () => PlantDatabase.species.first,
          )
        : PlantDatabase.species.first;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Final Visual: The Planted Pot
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                MysteryPlantWidget(
                      growthStage: currentPot?.growthStage ?? 1,
                      isThirsty: false,
                      plantName: selectedSpecies.name,
                      category: selectedSpecies.assetKey,
                      showPot: false,
                      onPlantTap: () {},
                      onWaterTap: () {},
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Text(
            l10n.onboarding_instructionTitle(emotionName, particle),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().moveY(begin: 10, end: 0),

          const SizedBox(height: 20),

          Text(
            l10n.onboarding_instructionSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 50),

          ElevatedButton(
            onPressed: _finish,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: Text(l10n.onboarding_finish),
          ).animate(delay: 2000.ms).fadeIn(),
        ],
      ),
    );
  }
}
