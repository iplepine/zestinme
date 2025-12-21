import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/widgets/zest_glass_card.dart';
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
    // Force Dark Theme to ensure Input Decoration defaults match our dark design
    return Theme(
      data: AppTheme.darkTheme,
      child: Stack(
        children: [
          // Background (Slightly clearer than Void)
          Container(color: const Color(0xFF0A101C)),

          Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: ZestGlassCard(
                    borderRadius: BorderRadius.circular(24),
                    padding: const EdgeInsets.all(32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                                Icons.psychology,
                                color: Colors.white54,
                                size: 40,
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .moveY(begin: 10, end: 0),
                          const SizedBox(height: 24),
                          const Text(
                            "이 화분의 주인은...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 8),
                          const Text(
                            "누구의 마음인가요?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ).animate().fadeIn(delay: 600.ms),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _controller,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: AppColors.lemonPrimary,
                            decoration: InputDecoration(
                              filled: false,
                              fillColor: Colors.transparent,
                              hintText: "이름 입력",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 24,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.lemonPrimary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(bottom: 12),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _submitName(value);
                              }
                            },
                          ).animate().fadeIn(delay: 800.ms),
                          const SizedBox(height: 40),
                          SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_controller.text.isNotEmpty) {
                                      _submitName(_controller.text);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lemonPrimary,
                                    foregroundColor: AppColors.voidBlack,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    "확인",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 1000.ms)
                              .moveY(begin: 10, end: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeOutBack)
              .fadeIn(),
        ],
      ),
    );
  }

  void _submitName(String name) {
    HapticFeedback.selectionClick();
    ref.read(onboardingViewModelProvider.notifier).setNickname(name);
    widget.onNameSubmitted();
  }
}
