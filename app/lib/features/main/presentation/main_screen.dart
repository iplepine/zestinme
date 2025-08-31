import 'package:flutter/material.dart';
import 'package:zestinme/core/constants/app_colors.dart';

import 'main_home_tab_page.dart';
import '../../happy_record/presentation/insight/my_insight_page.dart';
import '../../happy_record/presentation/challenges/challenges_page.dart';
import '../../happy_record/presentation/settings/settings_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainHomeTabPage(),
    const MyInsightPage(),
    const ChallengesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.bar_chart_outlined, 'Insights'),
                _buildNavItem(2, Icons.emoji_events_outlined, 'Challenges'),
                _buildNavItem(3, Icons.settings_outlined, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.mutedForeground,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: AppColors.fontWeightMedium,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
