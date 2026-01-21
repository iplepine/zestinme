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

  // Multi-stage State
  int _currentStage = 0;
  int _maxDepth = 0; // 0, 1, 2
  String _currentQuestion = '';

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

    // Initialize Logic (Calculations only)
    _maxDepth = CaringService.calculateCoachingDepth(widget.record);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentQuestion.isEmpty) {
      _updateQuestion();
    }
  }

  void _updateQuestion() {
    final l10n = AppLocalizations.of(context);
    // If context is invalid during dispose/init, safe check (though didChange usually safe)
    // But l10n might be null if not found (unlikely in MaterialApp)

    final localizedEmotion = widget.record.emotionLabel != null && l10n != null
        ? l10n.getLocalizedEmotion(widget.record.emotionLabel!)
        : widget.record.emotionLabel;

    _currentQuestion = CaringService.selectCoachingQuestion(
      widget.record,
      _currentStage,
      fallbackContext: localizedEmotion,
    );
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
    if (_answer.isNotEmpty) {
      // TODO: Save intermediate answer to DB or List
      // For now, we just proceed. Ideally we append to coachingAnswer using a delimiter or JSON.
    }

    if (_currentStage < _maxDepth) {
      // Go to Next Stage
      setState(() {
        _currentStage++;
        _currentStage++;
        _updateQuestion();
        _answer = ''; // Reset answer for new question
        // Note: Ideally we should flip the card back to front or animate transition.
        // For MVP, we'll just update the state which updates the card content.
        // A key change on the widget can force rebuild/animation if needed.
      });
    } else {
      // Final Stage -> Value Discovery
      _showValueDiscovery();
    }
  }

  void _showValueDiscovery() {
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
    // Note: We are only saving the *last* question/answer pair in this MVP implementation
    // or we should aggregate them. For now, let's just save the final one or the one that triggered completion.

    if (_answer.isEmpty && _currentStage == 0)
      return; // Prevent empty save if nothing happened

    await ref
        .read(caringProvider.notifier)
        .completeCaring(
          record: widget.record,
          question: _currentQuestion,
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
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              _showCard ? Icons.arrow_back : Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              if (_showCard) {
                setState(() {
                  _showCard = false;
                });
              } else {
                context.pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            // 1. Background Gradient (Atmospheric Resonance)
            Positioned.fill(child: _buildBackground()),

            // 2. Content
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _showCard ? _buildCardView() : _buildIntroContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2), // Slightly above center
                radius: 1.2,
                colors: [
                  Color(0xFF2D264B), // Muted Purple-Deep
                  Color(0xFF101418), // Deep Night
                ],
                stops: [0.0, 0.8],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          key: const ValueKey('Intro'),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Hero Plant (Breathing Visualization)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.05),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 56),
                  // 2. Intro Text (Typography Refined)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        final localizedEmotion =
                            widget.record.emotionLabel != null
                            ? l10n.getLocalizedEmotion(
                                widget.record.emotionLabel!,
                              )
                            : '기록된 감정';

                        return Column(
                          children: [
                            Text(
                              "아까 '$localizedEmotion' 감정이 찾아왔었죠.",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "지금 마음은 어떤가요?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                letterSpacing: -0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 80),
                  // 3. Bottom Button (Premium Styling)
                  FilledButton(
                    onPressed: _onStartCaring,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_outlined, size: 18),
                        SizedBox(width: 12),
                        Text(
                          "마음 들여다보기",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom Padding Adjuster
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardView() {
    final isLastStage = _currentStage >= _maxDepth;
    final buttonLabel = isLastStage ? "가치 발견" : "더 깊이 보기";
    final buttonIcon = isLastStage ? Icons.auto_awesome : Icons.arrow_downward;

    return Padding(
      key: ValueKey('Card_$_currentStage'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(flex: 2),
          if (_maxDepth > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_maxDepth + 1, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentStage ? 20 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: index <= _currentStage
                          ? AppTheme.primaryColor
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  );
                }),
              ),
            ),
          CoachingCard(
            question: _currentQuestion,
            submitLabel: buttonLabel,
            submitIcon: buttonIcon,
            onAnswerChanged: (val) {
              _answer = val;
            },
            onAnswerSubmitted: _onAnswerSubmitted,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
