import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/environment_provider.dart';

class MentalWeatherHeader extends ConsumerWidget {
  const MentalWeatherHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentState = ref.watch(environmentNotifierProvider);

    final double sunlight = environmentState.sunlight;
    final double temperature = environmentState.temperature;
    final double water = environmentState.water;

    final double scale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(1.0, 1.4);

    return GestureDetector(
      onTap: () => _showGuideDialog(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0 * scale,
          vertical: 16.0 * scale,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildWeatherGauge(
                context,
                '☀️',
                sunlight,
                AppLocalizations.of(context).sunlight,
              ),
            ),
            Expanded(
              child: _buildWeatherGauge(
                context,
                '🌡️',
                temperature,
                AppLocalizations.of(context).temperature,
              ),
            ),
            Expanded(
              child: _buildWeatherGauge(
                context,
                '💧',
                water,
                AppLocalizations.of(context).water,
              ),
            ),
            // Help Icon
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.help_outline,
                color: Colors.white.withOpacity(0.3),
                size: 20 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.glassSurface.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
          ),
          title: Text(
            "마음의 날씨 (Mental Weather)",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGuideItem(
                '☀️',
                "일조량 (Sunlight)",
                "당신의 기분이 얼마나 밝은지를 나타냅니다.\n(긍정적일수록 높음)",
              ),
              const SizedBox(height: 16),
              _buildGuideItem(
                '🌡️',
                "온도 (Temperature)",
                "감정의 에너지가 얼마나 뜨거운지를 나타냅니다.\n(활력/격앙 등)",
              ),
              const SizedBox(height: 16),
              _buildGuideItem(
                '💧',
                "수분 (Humidity)",
                "마음이 얼마나 촉촉하고 깊이 있는지를 나타냅니다.\n(몰입/공감 등)",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("알겠어요", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuideItem(String icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherGauge(
    BuildContext context,
    String icon,
    double value,
    String label,
  ) {
    final double scale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(1.0, 1.4);
    final double gaugeHeight = 50.0 * scale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 12,
              height: gaugeHeight,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 12,
              height: gaugeHeight * value,
              decoration: BoxDecoration(
                color: _getGaugeColor(icon, value),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _getGaugeColor(icon, value).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(icon, style: TextStyle(fontSize: 16 * scale)),
      ],
    );
  }

  Color _getGaugeColor(String icon, double value) {
    if (icon == '☀️') return Colors.amber;
    if (icon == '🌡️') {
      if (value > 0.8) return Colors.red;
      if (value < 0.2) return Colors.blue;
      return Colors.green;
    }
    if (icon == '💧') return Colors.lightBlueAccent;
    return Colors.white;
  }
}
