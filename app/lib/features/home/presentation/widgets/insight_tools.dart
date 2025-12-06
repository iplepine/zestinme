import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class InsightTools extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onReflection;
  final VoidCallback onLetGo;
  final VoidCallback onHistory;

  const InsightTools({
    super.key,
    required this.onCheckIn,
    required this.onReflection,
    required this.onLetGo,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildToolButton(
            context,
            icon: Icons.water_drop_outlined,
            label: l10n.homeCheckIn,
            onTap: onCheckIn,
          ),
          _buildToolButton(
            context,
            icon: Icons.edit_note_outlined,
            label: l10n.homeReflection,
            onTap: onReflection,
            isPrimary: true,
          ),
          _buildToolButton(
            context,
            icon: Icons.cleaning_services_outlined,
            label: l10n.homeLetGo,
            onTap: onLetGo,
          ),
          _buildToolButton(
            context,
            icon: Icons.history_edu_outlined,
            label: l10n.homeHistory,
            onTap: onHistory,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    // Artist Esthetic: Soft rounded buttons
    // Primary button gets a subtle highlight
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isPrimary ? const Color(0xFFE8F5E9) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              border: isPrimary
                  ? Border.all(color: Colors.green.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Icon(
              icon,
              color: isPrimary ? Colors.green[700] : Colors.grey[700],
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
