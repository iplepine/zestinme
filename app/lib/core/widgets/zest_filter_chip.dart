import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class ZestFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const ZestFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        onSelected(val);
        HapticFeedback.selectionClick();
      },
      elevation: 0,
      pressElevation: 0,
      showCheckmark: false,
      // Dark Glass: Translucent black for better visibility on dark backgrounds
      backgroundColor: Colors.black.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      selectedColor: AppColors.seedingChipSelected,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.seedingChipTextSelected : Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.2), // Subtle glass border
          width: 1,
        ),
      ),
    );
  }
}
