import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../app/theme/app_theme.dart';
import 'dart:ui'; // For ImageFilter
import '../../domain/services/caring_service.dart';
import '../widgets/coaching_card.dart';
import '../widgets/value_discovery_sheet.dart';
import '../providers/caring_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/emotion_localization_utils.dart';

class CaringIntroScreen extends ConsumerStatefulWidget {
  final EmotionRecord record;

  const CaringIntroScreen({super.key, required this.record});

  @override
  ConsumerState<CaringIntroScreen> createState() => _CaringIntroScreenState();
}

class _CaringIntroScreenState extends ConsumerState<CaringIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Flow State
  bool _showCard = false;
  String _answer = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStartCaring() {
    setState(() {
      _showCard = true;
    });
  }

  void _onAnswerSubmitted() {
    // Show Bottom Sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ValueDiscoverySheet(
        // TODO: Get real recommended values based on emotion
        recommendedValues: const ['성장', '연결', '평온', '인정', '자유', '건강'],
        onValuesSelected: (values) {},
        onComplete: () {
          Navigator.pop(context); // Close sheet
          _completeCaring();
        },
      ),
    );
  }

  Future<void> _completeCaring() async {
    // Save via Provider
    final question = CaringService.selectCoachingQuestion(widget.record);

    // Safety check for answer (though UI shouldn't allow empty submit ideally)
    if (_answer.isEmpty) return;

    // Save
    await ref
        .read(caringProvider.notifier)
        .completeCaring(
          record: widget.record,
          question: question,
          answer: _answer,
          valueTags: [], // TODO: Pass values from Sheet
        );

    if (!mounted) return;

    // Show Reward Animation (Simple Snackbar for MVP)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("🌱 씨앗이 자라났습니다! (+20 XP)"),
        backgroundColor: AppTheme.secondaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // Delay pop
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Night Garden Theme Colors
    const backgroundColor = Color(0xFF101418); // Deep Night
    final question = CaringService.selectCoachingQuestion(widget.record);

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            // Dynamic Icon: Arrow Back if Card shown, else Close
            icon: Icon(
              _showCard ? Icons.arrow_back : Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              if (_showCard) {
                // Back to Intro
                setState(() {
                  _showCard = false;
                });
              } else {
                // Close Screen
                context.pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            // 1. Background Gradient (Emotional Resonance)
            _buildBackground(),

            // 2. Content
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _showCard
                    ? _buildCardView(question)
                    : _buildIntroContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    // Use the emotion color for the "Resonance" gradient
    const resonanceColor = Color(0xFF5D3FD3); // Iris

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [resonanceColor.withOpacity(0.15), Colors.transparent],
            stops: const [0.0, 0.7],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildIntroContent() {
    return Stack(
      key: const ValueKey('Intro'),
      fit: StackFit.expand,
      children: [
        // 1. Centered Content (Icon + Text) to match Background
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero Plant (Breathing)
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(
                  Icons.spa, // Placeholder for Plant Asset
                  size: 120,
                  color: Colors.white, // Or emotion specific color
                ),
              ),
              const SizedBox(height: 40),
              // Intro Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      final localizedEmotion =
                          widget.record.emotionLabel != null
                          ? l10n.getLocalizedEmotion(
                              widget.record.emotionLabel!,
                            )
                          : '기록된 감정';

                      return Text(
                        "아까 '$localizedEmotion' 감정이 찾아왔었죠.\n지금 마음은 어떤가요?",
                        style: AppTheme.darkTheme.textTheme.headlineSmall
                            ?.copyWith(color: Colors.white, height: 1.5),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),
              // Visual correction: Shift up slightly to optically balance with text
              const SizedBox(height: 20),
            ],
          ),
        ),

        // 2. Bottom Button
        Positioned(
          left: 0,
          right: 0,
          bottom: 40, // Consistent bottom padding
          child: Center(
            child: FilledButton.icon(
              onPressed: _onStartCaring,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("마음 들여다보기"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardView(String question) {
    return Padding(
      key: const ValueKey('Card'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Spacer flex ratios determine vertical position.
          // Less flex above + More flex below = Shift Upwards
          const Spacer(flex: 2),

          CoachingCard(
            question: question,
            onAnswerChanged: (val) {
              _answer = val;
            },
            onAnswerSubmitted: _onAnswerSubmitted,
          ),

          const Spacer(flex: 3), // More space below pushes it up
        ],
      ),
    );
  }
}
