import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
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
  int _currentStep = 0; // 0 ~ 2 (Total 3 steps)
  bool _hasUnsavedChanges = false;

  // Plant Params (MVP Default: Olive Tree / 올리브 나무)
  int _speciesId = 31;
  double _growthStage = 0;
  String _category = 'tree';

  // Species-specific Overrides (Preview)
  double _customScale = 1.0;
  double _customOffsetY = 0.0;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final layoutState = ref.watch(plantLayoutProvider);
    final layoutNotifier = ref.read(plantLayoutProvider.notifier);

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
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            "Plant Layout Settings",
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
  static const double anchorYBias = ${layoutState.anchorYBias};
  static const double backgroundOffsetY = ${layoutState.backgroundOffsetY};
  static const double potWidth = ${layoutState.potWidth};
  static const double plantBaseSize = ${layoutState.plantBaseSize};
  static const double plantBottomInternalOffset = ${layoutState.plantBottomInternalOffset};
  static const double scaleFactorPerStage = ${layoutState.scaleFactorPerStage};

  // Species-specific Metadata
  // customScale: $_customScale,
  // customOffsetY: $_customOffsetY,
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
                "Save to Code",
                style: TextStyle(color: Colors.tealAccent, fontSize: 13),
              ),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Scenic Background REMOVED

            // 2. Plant Widget (Responsive Anchoring)
            Align(
              alignment: Alignment(0.0, layoutState.anchorYBias),
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
                onPlantTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Plant Tapped!")),
                  );
                },
                onWaterTap: () {},
              ),
            ),

            // 3. Control Panel (Top Right, Semi-transparent)
            if (_isPanelVisible)
              Positioned(
                top: kToolbarHeight + 40,
                left: 20,
                right: 20,
                bottom: 300, // Reserve space for plant
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isPanelVisible ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: _buildCurrentStepContent(
                                layoutState,
                                layoutNotifier,
                              ),
                            ),
                          ),
                        ),
                        _buildNavigationRow(),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(dynamic layoutState, dynamic layoutNotifier) {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            _buildHeader("Step 1: 식물 정하기 (Species)"),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Select Species (Preview)",
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
                  });
                }
              },
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildHeader("Step 2: 성장 및 리소스 설정 (Stage & Resource)"),
            const SizedBox(height: 10),
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
            const Divider(height: 20, color: Colors.white12),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Select Category",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              value: _category,
              items: ['flytrap', 'herb', 'leaf', 'succulent', 'tree', 'weird']
                  .map((key) {
                    return DropdownMenuItem(
                      value: key,
                      child: Text(key.toUpperCase()),
                    );
                  })
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _category = v;
                    _hasUnsavedChanges = true;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.tealAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                "Target Asset: ${_category}_${_growthStage.round()}",
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildHeader("Step 3: 수치값 미세 조정 (Layout)"),
            const SizedBox(height: 10),
            _buildSlider(
              "Species Scale",
              _customScale,
              (v) {
                setState(() {
                  _customScale = v;
                  _hasUnsavedChanges = true;
                });
              },
              min: 0.5,
              max: 2.0,
            ),
            _buildSlider(
              "Species Offset Y",
              _customOffsetY,
              (v) {
                setState(() {
                  _customOffsetY = v;
                  _hasUnsavedChanges = true;
                });
              },
              min: -0.5,
              max: 0.5,
            ),
            _buildSlider(
              "Global Anchor (Bias)",
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
            _buildSlider(
              "Plant Internal Offset",
              layoutState.plantBottomInternalOffset,
              (v) {
                layoutNotifier.updatePlantBottomInternalOffset(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: 0,
              max: 150,
            ),
            _buildSlider(
              "Background Offset",
              layoutState.backgroundOffsetY,
              (v) {
                layoutNotifier.updateBackgroundOffsetY(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: -200,
              max: 200,
            ),
            _buildSlider(
              "Scale Per Stage",
              layoutState.scaleFactorPerStage,
              (v) {
                layoutNotifier.updateScaleFactorPerStage(v);
                setState(() => _hasUnsavedChanges = true);
              },
              min: 0,
              max: 100,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
        color: Colors.white10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentStep == index
                      ? Colors.tealAccent
                      : Colors.white24,
                ),
              );
            }),
          ),
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _currentStep--),
                  icon: const Icon(Icons.chevron_left, color: Colors.white70),
                  tooltip: "이전",
                ),
              const SizedBox(width: 4),
              if (_currentStep < 2)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _currentStep++),
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.tealAccent,
                  ),
                  tooltip: "다음",
                )
              else
                TextButton.icon(
                  onPressed: () => setState(() => _currentStep = 0),
                  icon: const Icon(
                    Icons.refresh,
                    size: 16,
                    color: Colors.greenAccent,
                  ),
                  label: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
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
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
          activeColor: Colors.tealAccent,
          inactiveColor: Colors.white24,
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
          "수정된 레이아웃 설정이 저장(Save to Code)되지 않았습니다. 정말 나가시겠습니까?",
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
