import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zestinme/core/constants/app_colors.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 74,
          decoration: BoxDecoration(
            color: const Color(0xFF10192A).withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home_filled, isKo ? '오늘' : 'Today'),
              _buildNavItem(
                context,
                1,
                Icons.timeline_rounded,
                isKo ? '타임라인' : 'Timeline',
              ),
              _buildNavItem(
                context,
                2,
                Icons.bedtime_rounded,
                isKo ? '회복' : 'Recovery',
              ),
              _buildNavItem(
                context,
                3,
                Icons.tune_rounded,
                isKo ? '설정' : 'Setup',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.lanternGlow : Colors.white38,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.lanternGlow : Colors.white38,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
