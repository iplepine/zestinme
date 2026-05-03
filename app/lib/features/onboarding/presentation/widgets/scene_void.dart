import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/widgets/fullcon_brand.dart';
import 'package:zestinme/l10n/app_localizations.dart';

class SceneVoid extends StatelessWidget {
  final VoidCallback onCleaningComplete;

  const SceneVoid({super.key, required this.onCleaningComplete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.midnightDeep,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF09111F), Color(0xFF101A2D), Color(0xFF09111F)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: _GlowOrb(
                color: AppColors.lanternGlow.withValues(alpha: 0.16),
                size: 220,
              ),
            ),
            Positioned(
              left: -60,
              bottom: 180,
              child: _GlowOrb(
                color: AppColors.spiritTeal.withValues(alpha: 0.12),
                size: 200,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FullConWordmark().animate().fadeIn().moveY(begin: 8, end: 0),
                    const Spacer(),
                    Text(
                      l10n.onboarding_intro_message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                        letterSpacing: -1.1,
                      ),
                    ).animate().fadeIn(delay: 120.ms).moveY(begin: 16, end: 0),
                    const SizedBox(height: 14),
                    Text(
                      l10n.onboarding_found_space_title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 15,
                        height: 1.55,
                      ),
                    ).animate().fadeIn(delay: 220.ms).moveY(begin: 16, end: 0),
                    const SizedBox(height: 28),
                    const _PreviewCardStack()
                        .animate()
                        .fadeIn(delay: 320.ms)
                        .moveY(begin: 20, end: 0),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          onCleaningComplete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lanternGlow,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: Text(
                          l10n.onboarding_launch_cta,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 420.ms).moveY(begin: 12, end: 0),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        l10n.onboarding_launch_caption,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.52),
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ).animate().fadeIn(delay: 520.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCardStack extends StatelessWidget {
  const _PreviewCardStack();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _PreviewCard(
          color: AppColors.signalBlue,
          icon: Icons.bedtime_rounded,
          title: l10n.onboarding_preview_recovery_title,
          body: l10n.onboarding_preview_recovery_body,
        ),
        const SizedBox(height: 12),
        _PreviewCard(
          color: AppColors.spiritTeal,
          icon: Icons.bolt_rounded,
          title: l10n.onboarding_preview_checkin_title,
          body: l10n.onboarding_preview_checkin_body,
        ),
        const SizedBox(height: 12),
        _PreviewCard(
          color: AppColors.lanternGlow,
          icon: Icons.trending_up_rounded,
          title: l10n.onboarding_preview_coaching_title,
          body: l10n.onboarding_preview_coaching_body,
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  const _PreviewCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
