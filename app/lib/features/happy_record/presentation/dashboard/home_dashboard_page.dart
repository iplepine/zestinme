import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/widgets/insight_tools.dart';
import '../../../home/presentation/widgets/mental_weather_header.dart';
import '../../../home/presentation/widgets/mirror_plant_scene.dart';
import '../../../home/presentation/widgets/check_in_sheet.dart';
import '../../../home/presentation/widgets/let_go_dialog.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  void _onReflection() {
    context.push('/write');
  }

  void _onHistory() {
    context.push('/history');
  }

  void _onCheckIn() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CheckInSheet(),
    );
  }

  void _onLetGo() {
    showDialog(context: context, builder: (context) => const LetGoDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Deep Space / Night Garden
      body: Stack(
        children: [
          // Background Gradient (Dynamic based on Mental Weather)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF2C3E50), // Twilight Blue
                    Color(0xFF111116), // Deep Dark
                  ],
                  radius: 1.5,
                  center: Alignment.topCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. Top Area: Mental Weather (20%)
                const Expanded(flex: 2, child: MentalWeatherHeader()),

                // 2. Center Area: Mirror Plant (60%)
                const Expanded(flex: 6, child: MirrorPlantScene()),

                // 3. Bottom Area: Insight Tools (20%)
                Expanded(
                  flex: 2,
                  child: InsightTools(
                    onCheckIn: _onCheckIn,
                    onReflection: _onReflection,
                    onLetGo: _onLetGo,
                    onHistory: _onHistory,
                  ),
                  // Note: InsightTools handles its own taps internally for now,
                  // or we can pass callbacks if we refactor InsightTools to be stateless/pure.
                  // For this prototype, I'll update InsightTools to use the callbacks
                  // if I decide to make it pure. For now let's leave it as is
                  // and maybe refactor InsightTools to accept callbacks next.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
