import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zestinme/core/localization/app_localizations.dart';
import 'package:zestinme/features/garden/presentation/providers/current_pot_provider.dart';

class SceneEncounter extends ConsumerStatefulWidget {
  final VoidCallback onEncounterComplete;

  const SceneEncounter({super.key, required this.onEncounterComplete});

  @override
  ConsumerState<SceneEncounter> createState() => _SceneEncounterState();
}

class _SceneEncounterState extends ConsumerState<SceneEncounter> {
  final TextEditingController _detailController = TextEditingController();

  // Steps:
  // 0: Select Emotion (Buttons)
  // 1: Input Detail (TextField)
  // 2: Planting Animation
  // 3: Instruction
  int _step = 0;
  String _selectedEmotionKey = ""; // e.g. "joy"
  String _detailText = ""; // User input context

  // Core emotion keys matching ARB
  final List<String> _emotionKeys = [
    "joy",
    "sadness",
    "anger",
    "anxiety",
    "peace",
  ];

  void _selectEmotion(String key) {
    setState(() {
      _selectedEmotionKey = key;
      _step = 1;
    });
  }

  void _onDetailSubmitted() async {
    FocusScope.of(context).unfocus();

    // Wait for keyboard to dismiss to prevent jank/crashes
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() {
      _detailText = _detailController.text;
      _step = 2; // Start Animation
    });

    // Sequence
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Plant the pot in state management just before showing the sprout
        ref
            .read(currentPotNotifierProvider.notifier)
            .plantNewPot(emotionKey: _selectedEmotionKey, nickname: 'My Basil');

        setState(() {
          _step = 3; // Show Instruction (Sprout appears)
        });
      }
    });

    // Notify parent to proceed (actually not yet, wait for user confirmation)
    // ref.read(onboardingViewModelProvider.notifier).complete();
  }

  bool _isFinishing = false;
  String _transitionMessage = "";

  void _finish() async {
    final l10n = AppLocalizations.of(context);

    // Pot is already planted at step 3 transition

    setState(() {
      _isFinishing = true;
      _transitionMessage = l10n.onboarding.transitionPlanted;
    });

    // 1. "Seed Planted" message
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() {
      _transitionMessage = l10n.onboarding.transitionEntering;
    });

    // 2. "Entering Sanctuary" message
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    widget.onEncounterComplete();
  }

  // Korean Postposition Helper
  // Returns "은" or "는" for Korean, or empty for others/defaults
  String _getSubjectParticle(String text) {
    if (text.isEmpty) return "";
    int code = text.codeUnits.last;
    if (code < 0xAC00 || code > 0xD7A3) return ""; // Non-Korean: return empty
    return (code - 0xAC00) % 28 > 0 ? "은" : "는";
  }

  String _getLocalizedEmotion(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    // Access nested emotions map manually since it might be generated as a class
    // Assuming standard structure:
    switch (key) {
      case 'joy':
        return l10n.onboarding.emotions.joy;
      case 'sadness':
        return l10n.onboarding.emotions.sadness;
      case 'anger':
        return l10n.onboarding.emotions.anger;
      case 'anxiety':
        return l10n.onboarding.emotions.anxiety;
      case 'peace':
        return l10n.onboarding.emotions.peace;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        // 1. Background (Static)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF000000)],
              radius: 1.5,
              center: Alignment.center,
            ),
          ),
        ),

        // 2. Content
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_step == 0 && !_isFinishing)
                    Center(
                      child: SingleChildScrollView(
                        child: _buildSelectionStep(context),
                      ),
                    ),

                  if (_step == 1 && !_isFinishing)
                    Center(
                      child: SingleChildScrollView(
                        child: _buildDetailInputStep(context),
                      ),
                    ),

                  if (_step == 2 && !_isFinishing)
                    _buildPlantingAnimation(context, constraints.biggest),

                  if (_step == 3 && !_isFinishing)
                    Center(
                      child: SingleChildScrollView(
                        child: _buildInstructionStep(context),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // 3. Transition Overlay
        if (_isFinishing)
          Container(
            color: Colors.black.withOpacity(0.9),
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
                    .then(delay: 1500.ms) // Hold
                    .fadeOut(duration: 500.ms), // Fade out
          ),
      ],
    );
  }

  // ... (REST OF THE FILE) ...

  Widget _buildSelectionStep(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.onboarding.step1Title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
          ).animate().fadeIn().moveY(begin: 10, end: 0),

          const SizedBox(height: 40),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _emotionKeys.map((key) {
              return _buildEmotionButton(context, key);
            }).toList(),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildEmotionButton(BuildContext context, String key) {
    final text = _getLocalizedEmotion(context, key);

    return ElevatedButton(
      onPressed: () => _selectEmotion(key),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailInputStep(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final emotionName = _getLocalizedEmotion(context, _selectedEmotionKey);
    final particle = _getSubjectParticle(emotionName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.onboarding.step2Title(emotionName, particle),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
          ).animate().fadeIn().moveY(begin: 10, end: 0),

          const SizedBox(height: 16),

          Text(
            l10n.onboarding.step2Subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: _detailController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              maxLines: null,
              decoration: InputDecoration(
                hintText: l10n.onboarding.hint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 16,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent),
                ),
              ),
              onSubmitted: (_) => _onDetailSubmitted(),
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: _onDetailSubmitted,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(l10n.onboarding.submit),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildPlantingAnimation(BuildContext context, Size screenSize) {
    final emotionName = _getLocalizedEmotion(context, _selectedEmotionKey);

    return Center(
      child: SizedBox(
        height: 250, // Match Step 3 height
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none, // Allow seed to start from outside if needed
          children: [
            // 2. Pot Area (Target) - Static Position matching Step 3
            Image.asset(
              'assets/images/pots/pot_1.png',
              width: 150,
              fit: BoxFit.contain,
            ).animate(delay: 500.ms).fadeIn(duration: 1000.ms),

            // 1. Text transforming to Seed
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) {
                  final textOpacity = (1.0 - (value / 0.3)).clamp(0.0, 1.0);
                  final seedOpacity = ((value - 0.3) / 0.2).clamp(0.0, 1.0);

                  // Start: Top of the SizedBox (or relatively higher)
                  // End: Center of the pot (approx bottom 90px matching spout)

                  // Using Alignment for interpolation within the SizedBox
                  final startAlign = const Alignment(
                    0.0,
                    -0.8,
                  ); // Start from way above
                  final endAlign = const Alignment(
                    0.0,
                    0.2,
                  ); // Near the pot rim

                  final moveProgress = ((value - 0.5) / 0.5).clamp(0.0, 1.0);
                  final currentAlign = Alignment.lerp(
                    startAlign,
                    endAlign,
                    Curves.easeInOutBack.transform(moveProgress),
                  )!;

                  return Align(
                    alignment: currentAlign,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Text fading out
                        Opacity(
                          opacity: textOpacity.toDouble(),
                          child: Text(
                            emotionName,
                            style: const TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(color: Colors.amber, blurRadius: 20),
                              ],
                            ),
                          ),
                        ),
                        // Seed fading in
                        Opacity(
                          opacity: seedOpacity.toDouble(),
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.8),
                                  blurRadius: 10 + (value * 20),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final emotionName = _getLocalizedEmotion(context, _selectedEmotionKey);
    final particle = _getSubjectParticle(emotionName);

    // Get dynamic asset from provider
    // If null (not planted yet/error), fallback to 'basil_1.png'
    final currentPot = ref.watch(currentPotNotifierProvider);
    final assetPath = currentPot != null
        ? 'assets/images/plants/basil_${currentPot.growthStage}.png'
        : 'assets/images/plants/basil_1.png';

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
                // The Pot with Plant (basil_1 includes the pot)
                Image.asset(
                      assetPath,
                      width: 150, // Full pot size
                      fit: BoxFit.contain,
                    )
                    .animate()
                    .scale(
                      begin: const Offset(
                        0.8,
                        0.8,
                      ), // Start slightly smaller (pop effect)
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
            l10n.onboarding.instructionTitle(emotionName, particle),
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
            l10n.onboarding.instructionSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
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
            child: Text(l10n.onboarding.finish),
          ).animate(delay: 2000.ms).fadeIn(),
        ],
      ),
    );
  }
}
