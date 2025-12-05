import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneIdentity extends ConsumerStatefulWidget {
  final VoidCallback onNameSubmitted;

  const SceneIdentity({super.key, required this.onNameSubmitted});

  @override
  ConsumerState<SceneIdentity> createState() => _SceneIdentityState();
}

class _SceneIdentityState extends ConsumerState<SceneIdentity> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background (Slightly clearer than Void)
        Container(color: const Color(0xFF0A101C)),

        Center(
          child: SingleChildScrollView(
            child:
                Container(
                      width: 300,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5DC), // Beige/Paper color
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tag Hole Visual
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Color(
                                0xFF0A101C,
                              ), // Background color to simulate hole
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "낡은 명찰을 건져올렸습니다!",
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.brown),
                          const SizedBox(height: 16),
                          const Text(
                            "글씨가 물에 번져 흐릿하네요.\n뭐라고 적혀 있었나요?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _controller,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Serif', // Serif font for old feel
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "이름 입력",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _submitName(value);
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                _submitName(_controller.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("확인"),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeOutBack)
                    .fadeIn(),
          ),
        ),
      ],
    );
  }

  void _submitName(String name) {
    HapticFeedback.selectionClick();
    ref.read(onboardingViewModelProvider.notifier).setNickname(name);
    widget.onNameSubmitted();
  }
}
