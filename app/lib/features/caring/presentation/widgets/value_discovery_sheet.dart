import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/zest_filter_chip.dart';

class ValueDiscoverySheet extends StatefulWidget {
  final List<String> recommendedValues;
  final ValueChanged<List<String>> onValuesSelected;
  final VoidCallback onComplete;

  const ValueDiscoverySheet({
    super.key,
    required this.recommendedValues,
    required this.onValuesSelected,
    required this.onComplete,
  });

  @override
  State<ValueDiscoverySheet> createState() => _ValueDiscoverySheetState();
}

class _ValueDiscoverySheetState extends State<ValueDiscoverySheet> {
  final List<String> _selectedValues = [];

  void _toggleValue(String value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
    });
    widget.onValuesSelected(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark surface
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "이 감정 뒤에 숨겨진 가치는 무엇일까요?",
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: widget.recommendedValues.map((value) {
              final isSelected = _selectedValues.contains(value);
              return ZestFilterChip(
                label: "#$value",
                isSelected: isSelected,
                onSelected: (_) => _toggleValue(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _selectedValues.isNotEmpty ? widget.onComplete : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor, // Yellow/Gold
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
            ),
            child: const Text("물 주기 (완료)"),
          ),
          const SizedBox(height: 16), // Bottom safety margin if needed
        ],
      ),
    );
  }
}
