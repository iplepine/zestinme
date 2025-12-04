import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/features/emotion_write/presentation/providers/emotion_write_provider.dart';
import 'package:zestinme/features/emotion_write/presentation/widgets/step_1_affect_labeling.dart';
import 'package:zestinme/features/emotion_write/presentation/widgets/step_2_context.dart';
import 'package:zestinme/features/emotion_write/presentation/widgets/step_3_body_sensation.dart';
import 'package:zestinme/features/emotion_write/presentation/widgets/step_4_cognition.dart';
import 'package:zestinme/features/emotion_write/presentation/widgets/step_5_action.dart';

class EmotionWriteScreen extends ConsumerStatefulWidget {
  const EmotionWriteScreen({super.key});

  @override
  ConsumerState<EmotionWriteScreen> createState() => _EmotionWriteScreenState();
}

class _EmotionWriteScreenState extends ConsumerState<EmotionWriteScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // TODO: Show confirmation dialog if dirty
            context.pop();
          },
        ),
        title: Text('Step ${_currentStep + 1}/$_totalSteps'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                Step1AffectLabeling(onNext: _nextPage),
                Step2Context(onNext: _nextPage, onPrev: _prevPage),
                Step3BodySensation(onNext: _nextPage, onPrev: _prevPage),
                Step4Cognition(onNext: _nextPage, onPrev: _prevPage),
                Step5Action(onPrev: _prevPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
