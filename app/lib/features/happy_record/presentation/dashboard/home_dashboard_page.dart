import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/core/localization/app_localizations.dart';
import 'widgets/environment_gauge.dart';

import '../../domain/models/challenge_progress.dart';
import '../../domain/models/emotion_record.dart';
import '../../domain/usecases/get_active_challenges_usecase.dart';
import '../../../../di/injection.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  // ignore: unused_field
  List<ChallengeProgress> _challenges = [];
  // ignore: unused_field
  EmotionRecord? _todayEmotion;
  bool _isLoading = true;

  final GetActiveChallengesUseCase _getActiveChallengesUseCase =
      Injection.getIt<GetActiveChallengesUseCase>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    try {
      // 실제 활성 챌린지 데이터를 불러옵니다
      _challenges = _getActiveChallengesUseCase.execute();

      // TODO: 오늘의 감정 기록 불러오기 구현 필요
      _todayEmotion = null;
    } catch (e) {
      // 에러 발생 시 빈 리스트로 설정
      _challenges = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRecordEmotion() {
    context.push('/write');
  }

  void _onAnswerCoachingQuestion() {
    context.push('/write');
  }

  void _onMoreChallenges() {
    context.push('/challenges');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E1E2C), // Dark theme for gardening
        body: const Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF111116)],
                  radius: 1.5,
                  center: Alignment.topCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  // 1. Main Plant Visual Area (Top ~40% of screen)
                  _buildPlantVisualArea(),

                  // 2. Gardening Dashboard (Bottom Sheet style)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Environment Gauges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            EnvironmentGauge(
                              icon: Icons.wb_sunny_rounded,
                              color: Colors.amber,
                              label: l10n.sunlight,
                              value: 0.8, // Todo: Real Data
                              valueLabel: "Good",
                            ),
                            EnvironmentGauge(
                              icon: Icons.water_drop_rounded,
                              color: Colors.blue,
                              label: l10n.water,
                              value: 0.4, // Todo: Real Data
                              valueLabel: "Thirsty",
                            ),
                            EnvironmentGauge(
                              icon: Icons.thermostat_rounded,
                              color: Colors.orange,
                              label: l10n.temperature,
                              value: 0.6, // Todo: Real Data
                              valueLabel: "24°C",
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Main Action: Care (Log Emotion)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _onRecordEmotion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade700,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.water_drop, size: 24),
                            label: Text(
                              l10n.giveWaterButton, // "Give Water"
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Secondary Actions Row
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _onAnswerCoachingQuestion,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                  side: BorderSide(color: Colors.white24),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.content_cut_rounded,
                                  size: 20,
                                ),
                                label: Text(l10n.pruneButton),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _onMoreChallenges,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                  side: BorderSide(color: Colors.white24),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.spa_rounded, size: 20),
                                label: Text("Details"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantVisualArea() {
    return SizedBox(
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aura / Glow
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.1),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          // Pot
          Positioned(
            bottom: 40,
            child: Image.asset(
              'assets/images/pots/pot_1.png',
              width: 240, // Slightly larger than onboarding (200) for presence
              fit: BoxFit.contain,
            ),
          ),

          // Plant (Basil)
          Positioned(
            bottom: 120, // Adjust based on pot size
            child: Image.asset(
              'assets/images/plants/basil_1.png',
              width: 120, // Growing! (Onboarding was 60)
              fit: BoxFit.contain,
            ),
          ),

          // Plant Name Tag
          Positioned(
            top: 60,
            child: Column(
              children: [
                Text(
                  "Baby Basil", // Todo: Dynamic Name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: [BoxShadow(color: Colors.black45, blurRadius: 10)],
                  ),
                ),
                Text(
                  "Day 1",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    letterSpacing: 1.0,
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
