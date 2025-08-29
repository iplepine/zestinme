import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class EmotionSelectionWidget extends StatelessWidget {
  final int selectedEmotion;
  final Function(int) onEmotionSelected;

  const EmotionSelectionWidget({
    super.key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  // 감정 목록
  static const List<Map<String, dynamic>> _emotions = [
    {'name': '기쁨', 'emoji': '😊'},
    {'name': '행복', 'emoji': '🥰'},
    {'name': '만족', 'emoji': '😌'},
    {'name': '신남', 'emoji': '🥳'},
    {'name': '평온', 'emoji': '😇'},
    {'name': '따뜻함', 'emoji': '🤗'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '감정을 선택해주세요',
          style: TextStyle(
            color: AppColors.foreground,
            fontSize: 16,
            fontWeight: AppColors.fontWeightMedium,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _emotions.length,
          itemBuilder: (context, index) {
            final emotion = _emotions[index];
            final isSelected = selectedEmotion == index;
            return GestureDetector(
              onTap: () {
                onEmotionSelected(isSelected ? -1 : index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emotion['emoji'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emotion['name'],
                      style: TextStyle(
                        color: AppColors.foreground,
                        fontSize: 12,
                        fontWeight: AppColors.fontWeightMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
