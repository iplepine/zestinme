import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zestinme/app/theme/app_theme.dart';
import 'package:zestinme/core/widgets/fullcon_brand.dart';
import 'package:zestinme/features/garden/domain/services/plant_service.dart';
import 'package:zestinme/features/garden/presentation/providers/mind_plant_provider.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zestinme/features/seeding/presentation/providers/seeding_provider.dart';
import 'package:zestinme/features/seeding/presentation/widgets/seeding_content.dart';
import 'package:zestinme/l10n/app_localizations.dart';

class SceneEncounter extends ConsumerStatefulWidget {
  final VoidCallback onEncounterComplete;

  const SceneEncounter({super.key, required this.onEncounterComplete});

  @override
  ConsumerState<SceneEncounter> createState() => _SceneEncounterState();
}

class _SceneEncounterState extends ConsumerState<SceneEncounter> {
  int _step = 0;
  bool _isFinishing = false;
  String _transitionMessage = '';

  void _onSeedingComplete() {
    final seedingState = ref.read(seedingNotifierProvider);
    final onboardingState = ref.read(onboardingViewModelProvider);

    final sunlight = (seedingState.valence + 1) / 2;
    final energy = (seedingState.arousal + 1) / 2;
    final plant = PlantService().assignPlant(
      lux: sunlight * 100000,
      temp: energy * 40,
      humidity: 50,
    );

    String emotionKey = 'neutral';
    if (seedingState.arousal > 0) {
      emotionKey = seedingState.valence > 0 ? 'joy' : 'anger';
    } else {
      emotionKey = seedingState.valence > 0 ? 'peace' : 'sadness';
    }

    ref.read(mindPlantNotifierProvider.notifier).startGardening(
          emotionKey: emotionKey,
          nickname: onboardingState.nickname.isNotEmpty
              ? onboardingState.nickname
              : 'Starter Profile',
          plantSpeciesId: plant.id,
        );

    setState(() {
      _step = 1;
    });
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isFinishing = true;
      _transitionMessage = l10n.onboarding_transition_planted;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _transitionMessage = l10n.onboarding_transition_entering;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    widget.onEncounterComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_step == 0 && !_isFinishing) SeedingContent(onComplete: _onSeedingComplete),
          if (_step == 1 && !_isFinishing)
            Container(
              color: const Color(0xFF09111F),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: _buildSummaryStep(context),
                ),
              ),
            ),
          if (_isFinishing)
            Container(
              color: Colors.black.withValues(alpha: 0.92),
              alignment: Alignment.center,
              child: Text(
                _transitionMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ).animate(key: ValueKey(_transitionMessage)).fadeIn(duration: 500.ms),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    final seedingState = ref.read(seedingNotifierProvider);
    final nickname = ref.read(onboardingViewModelProvider).nickname;
    final conditionLabel = _conditionTagLabel(isKo, seedingState.primaryTag);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B4A).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: ConditionArrowMark(
                direction: ConditionArrowDirection.up,
                size: 22,
                framed: false,
                color: Color(0xFFFF6B4A),
              ),
            ),
          ).animate().fadeIn().moveY(begin: 12, end: 0),
          const SizedBox(height: 20),
          Text(
            isKo ? '$nickname님, 첫 체크인이 끝났어요.' : '$nickname, your first check-in is done.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 10),
          Text(
            isKo
                ? '이제 홈에서\n오늘 제안을 확인해보세요.'
                : 'You are in.\nCheck today’s guidance on home.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 22),
          _SummaryRow(
            label: isKo ? '지금 상태' : 'Current state',
            value: conditionLabel,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: isKo ? '현재 점수' : 'Score',
            value: '${seedingState.overallConditionScore}/100',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: isKo ? '핵심 신호' : 'Core signals',
            value: isKo
                ? '에너지 ${seedingState.energyScore}/10 · 회복 ${seedingState.recoveryScore}/10'
                : 'Energy ${seedingState.energyScore}/10 · Recovery ${seedingState.recoveryScore}/10',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: isKo ? '다음' : 'Next',
            value: isKo ? '홈에서 오늘 제안 보기' : 'Open home and review today’s guidance',
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finish,
              child: Text(isKo ? '홈으로 가기' : 'Go to home'),
            ),
          ),
        ],
      ),
    );
  }

  String _conditionTagLabel(bool isKo, String tag) {
    const ko = {
      'LockedIn': '몰입됨',
      'Sharp': '선명함',
      'Recovered': '회복됨',
      'Grounded': '단단함',
      'Ready': '준비됨',
      'Steady': '무난함',
      'Drained': '지침',
      'Heavy': '무거움',
      'Foggy': '흐릿함',
      'Flat': '무덤덤함',
      'Slipping': '흐트러짐',
      'NeedsReset': '재정비 필요',
      'Wired': '과긴장',
      'Overloaded': '벅참',
      'Tense': '긴장됨',
      'Restless': '가라앉지 않음',
      'Pressed': '쫓기는 느낌',
      'OnEdge': '예민함',
      'Scattered': '산만함',
      'Unfocused': '집중 안 됨',
      'Calm': '차분함',
      'Balanced': '균형 잡힘',
      'Stable': '안정적',
      'Light': '가벼움',
      'Building': '올라오는 중',
      'Recovering': '회복 중',
    };
    const en = {
      'LockedIn': 'Locked in',
      'Sharp': 'Sharp',
      'Recovered': 'Recovered',
      'Grounded': 'Grounded',
      'Ready': 'Ready',
      'Steady': 'Steady',
      'Drained': 'Drained',
      'Heavy': 'Heavy',
      'Foggy': 'Foggy',
      'Flat': 'Flat',
      'Slipping': 'Slipping',
      'NeedsReset': 'Needs reset',
      'Wired': 'Wired',
      'Overloaded': 'Overloaded',
      'Tense': 'Tense',
      'Restless': 'Restless',
      'Pressed': 'Pressed',
      'OnEdge': 'On edge',
      'Scattered': 'Scattered',
      'Unfocused': 'Unfocused',
      'Calm': 'Calm',
      'Balanced': 'Balanced',
      'Stable': 'Stable',
      'Light': 'Light',
      'Building': 'Building',
      'Recovering': 'Recovering',
    };
    return (isKo ? ko : en)[tag] ?? tag;
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
