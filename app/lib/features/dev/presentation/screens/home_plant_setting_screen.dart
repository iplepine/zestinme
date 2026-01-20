import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/home/presentation/providers/time_vibe_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/home/presentation/providers/plant_layout_provider.dart';
import 'dart:developer' as dev;

class HomePlantSettingScreen extends ConsumerStatefulWidget {
  const HomePlantSettingScreen({super.key});

  @override
  ConsumerState<HomePlantSettingScreen> createState() =>
      _HomePlantSettingScreenState();
}

class _HomePlantSettingScreenState
    extends ConsumerState<HomePlantSettingScreen> {
  // UI State
  bool _isPanelVisible = true;
  int _currentStep = 0; // 0 ~ 3
  bool _hasUnsavedChanges = false;

  // Visual Overrides
  TimeVibe? _overrideVibe;
  int _speciesId = 31;
  double _growthStage = 0;
  String _category = 'tree';

  // Species-specific Overrides (Preview)
  double _customScale = 1.0;
  double _customOffsetY = 0.0;

  @override
  Widget build(BuildContext context) {
    final layoutState = ref.watch(plantLayoutProvider);
    final layoutNotifier = ref.read(plantLayoutProvider.notifier);
    final systemVibe = ref.watch(timeVibeNotifierProvider);
    final currentVibe = _overrideVibe ?? systemVibe;

    final selectedSpecies = PlantDatabase.species.firstWhere(
      (p) => p.id == _speciesId,
      orElse: () => PlantDatabase.species.first,
    );

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            "Dev: Visual Settings",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPanelVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () =>
                  setState(() => _isPanelVisible = !_isPanelVisible),
              tooltip: "Toggle Panel",
            ),
            TextButton.icon(
              onPressed: () {
                final code =
                    """
  // Set: ${selectedSpecies.name} (ID: $_speciesId) | Stage: ${_growthStage.round()} | Category: $_category
  static const double anchorYBias = ${layoutState.anchorYBias.toStringAsFixed(4)};
  static const double backgroundOffsetY = ${layoutState.backgroundOffsetY.toStringAsFixed(4)};
  static const double potWidth = ${layoutState.potWidth.toStringAsFixed(4)};
  static const double plantBaseSize = ${layoutState.plantBaseSize.toStringAsFixed(4)};
  static const double plantBottomInternalOffset = ${layoutState.plantBottomInternalOffset.toStringAsFixed(4)};
  static const double scaleFactorPerStage = ${layoutState.scaleFactorPerStage.toStringAsFixed(4)};

  // Species-specific Metadata for ${selectedSpecies.name}
  // customScale: ${_customScale.toStringAsFixed(4)},
  // customOffsetY: ${_customOffsetY.toStringAsFixed(4)},
""";
                dev.log("LAYOUT_CONSTANTS_UPDATE\n$code");
                setState(() => _hasUnsavedChanges = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("설정값이 콘솔에 출력되었습니다."),
                    backgroundColor: Colors.teal,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.code, color: Colors.tealAccent, size: 18),
              label: const Text(
                "Copy Code",
                style: TextStyle(color: Colors.tealAccent, fontSize: 13),
              ),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background (Override or System)
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                currentVibe.backgroundImage,
                key: ValueKey(currentVibe.backgroundImage),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // 2. Plant (Interactive Anchoring)
            Align(
              alignment: Alignment(0.0, layoutState.anchorYBias),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: MysteryPlantWidget(
                    growthStage: _growthStage.round(),
                    isThirsty: false,
                    plantName: selectedSpecies.name,
                    potWidth: layoutState.potWidth,
                    plantBaseSize: layoutState.plantBaseSize * _customScale,
                    plantBottomOffset: layoutState.plantBottomInternalOffset,
                    customOffsetY: _customOffsetY,
                    scaleFactorPerStage: layoutState.scaleFactorPerStage,
                    category: _category,
                    showPot: false,
                    onPlantTap: () {},
                    onWaterTap: () {},
                  ),
                ),
              ),
            ),

            // 3. Floating Control Panel (Glass)
            if (_isPanelVisible)
              Positioned(
                top: kToolbarHeight + 60,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).size.height * 0.4,
                child: _buildGlassPanel(layoutState, layoutNotifier),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassPanel(dynamic layoutState, dynamic layoutNotifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStepContent(layoutState, layoutNotifier),
                ),
              ),
              _buildNavigationRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(dynamic layoutState, dynamic layoutNotifier) {
    switch (_currentStep) {
      case 0: // Vibe & Background
        return Column(
          children: [
            _buildHeader("Step 1: 배경 및 분위기 (Vibe)"),
            const SizedBox(height: 10),
            Row(
              children: [
                _vibeButton(TimeVibe.morning, "아침"),
                const SizedBox(width: 8),
                _vibeButton(TimeVibe.evening, "저녁"),
                const SizedBox(width: 8),
                _vibeButton(TimeVibe.night, "밤"),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _overrideVibe = null),
              child: const Text(
                "시스템 시간 설정 사용",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      case 1: // Species Selection
        return Column(
          children: [
            _buildHeader("Step 2: 식물 정하기 (Species)"),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Select Species",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              value: _speciesId,
              items: PlantDatabase.species.map((p) {
                return DropdownMenuItem(
                  value: p.id,
                  child: Text("${p.id}: ${p.name}"),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _hasUnsavedChanges = true;
                    _speciesId = v;
                    final sp = PlantDatabase.species.firstWhere(
                      (p) => p.id == v,
                    );
                    _customScale = sp.customScale ?? 1.0;
                    _customOffsetY = sp.customOffsetY ?? 0.0;
                    _category = sp.assetKey;
                  });
                }
              },
            ),
          ],
        );
      case 2: // Stage & Category
        return Column(
          children: [
            _buildHeader("Step 3: 성장 및 리소스 (Resource)"),
            _buildSlider(
              "Growth Stage",
              _growthStage,
              (v) {
                setState(() {
                  _growthStage = v;
                  _hasUnsavedChanges = true;
                });
              },
              max: 4,
              divisions: 4,
            ),
            const Divider(height: 32, color: Colors.white12),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Manual Category Override",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              value: _category,
              items: ['rubber', 'herb', 'leaf', 'succulent', 'tree'].map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(key.toUpperCase()),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _category = v;
                    _hasUnsavedChanges = true;
                  });
                }
              },
            ),
          ],
        );
      case 3: // Layout Tuning
        return Column(
          children: [
            _buildHeader("Step 4: 수치 미세 조정 (Layout)"),
            _buildSlider(
              "Species Scale",
              _customScale,
              (v) => setState(() {
                _customScale = v;
                _hasUnsavedChanges = true;
              }),
              min: 0.5,
              max: 2.0,
            ),
            _buildSlider(
              "Global Anchor (Y Bias)",
              layoutState.anchorYBias,
              (v) {
                layoutNotifier.updateAnchorYBias(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: -1.0,
              max: 1.0,
            ),
            _buildSlider(
              "Pot Width",
              layoutState.potWidth,
              (v) {
                layoutNotifier.updatePotWidth(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: 50,
              max: 300,
            ),
            _buildSlider(
              "Plant Base Size",
              layoutState.plantBaseSize,
              (v) {
                layoutNotifier.updatePlantBaseSize(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: 50,
              max: 400,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _vibeButton(TimeVibe vibe, String label) {
    final isSelected = _overrideVibe == vibe;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _overrideVibe = vibe),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.tealAccent.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.tealAccent : Colors.white24,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.tealAccent : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
        color: Colors.black26,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentStep == index
                      ? Colors.tealAccent
                      : Colors.white12,
                ),
              );
            }),
          ),
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  onPressed: () => setState(() => _currentStep--),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              const SizedBox(width: 8),
              if (_currentStep < 3)
                ElevatedButton(
                  onPressed: () => setState(() => _currentStep++),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.withValues(alpha: 0.2),
                    foregroundColor: Colors.tealAccent,
                  ),
                  child: const Text("다음"),
                )
              else
                TextButton(
                  onPressed: () => setState(() => _currentStep = 0),
                  child: const Text(
                    "다시 시작",
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: Colors.tealAccent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged, {
    double max = 1.0,
    double min = 0.0,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: Colors.tealAccent,
          inactiveColor: Colors.white12,
        ),
      ],
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("변경사항 저장 안 됨", style: TextStyle(color: Colors.white)),
        content: const Text(
          "수정된 레이아웃 설정이 저장(Copy Code)되지 않았습니다. 정말 나가시겠습니까?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("취소", style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("나가기", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
