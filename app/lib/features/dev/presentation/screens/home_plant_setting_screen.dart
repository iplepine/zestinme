import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/home/presentation/widgets/scenic_background.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';

class HomePlantSettingScreen extends ConsumerStatefulWidget {
  const HomePlantSettingScreen({super.key});

  @override
  ConsumerState<HomePlantSettingScreen> createState() =>
      _HomePlantSettingScreenState();
}

class _HomePlantSettingScreenState
    extends ConsumerState<HomePlantSettingScreen> {
  // Layout Params (Updated Defaults)
  double _globalBottom = 10;
  double _potWidth = 100;
  double _plantBaseSize = 120;
  double _plantBottomInternal = 50;
  double _backgroundOffset = 0;
  double _scaleFactorPerStage = 25.0;
  double _offsetX = 0;

  // Available Background Assets
  final List<String> _backgroundAssets = [
    'assets/images/backgrounds/background_night.png',
  ];

  // Environment Params
  // Environment Params (Locally controlled for preview, but sync with provider)
  double _temperature = 0.5; // 0.0 (Cold) ~ 1.0 (Hot)
  double _humidity = 0.5; // 0.0 (Dry) ~ 1.0 (Wet)

  // Plant Params
  double _growthStage = 0; // 0 ~ 4
  bool _isThirsty = false;
  String _category = 'herb'; // 'herb', 'leaf', 'succ', 'weired'

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    // Current Plant Selection
    final currentPlant = PlantDatabase.species.firstWhere(
      (p) => p.id == 1, // Default to first for metadata
      orElse: () => PlantDatabase.species.first,
    );

    // Lighting Calculation
    final lightingColor = Color.lerp(
      const Color(0xFF667799), // Night
      Colors.white, // Day
      homeState.sunlightLevel.clamp(0.0, 1.0),
    )!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Plant Setting Dev"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Scenic Background
          ScenicBackground(
            sunlight: homeState.sunlightLevel,
            offsetY: _backgroundOffset,
            imagePath: homeState.backgroundImagePath,
          ),

          // 2. Plant Widget (Positioned with _globalBottom)
          Positioned(
            bottom: _globalBottom,
            left: _offsetX,
            right: -_offsetX,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(lightingColor, BlendMode.modulate),
              child: MysteryPlantWidget(
                growthStage: _growthStage.round(),
                isThirsty: _isThirsty,
                plantName: currentPlant.name,
                potWidth: _potWidth,
                plantBaseSize: _plantBaseSize,
                plantBottomOffset: _plantBottomInternal,
                scaleFactorPerStage: _scaleFactorPerStage,
                category: _category,
                onPlantTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Plant Tapped!")),
                  );
                },
                onWaterTap: () {
                  setState(() => _isThirsty = false);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Watered!")));
                },
              ),
            ),
          ),

          // 3. Control Panel (Top Right, Semi-transparent)
          // Replaces DraggableScrollableSheet to avoid obscuring the plant
          Positioned(
            top: kToolbarHeight + 40,
            left: 20,
            right: 20,
            bottom: 300, // Reserve space for plant
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader("Layout Config"),
                    _buildSlider(
                      "Global Bottom",
                      _globalBottom,
                      (v) => setState(() => _globalBottom = v),
                      min: -50,
                      max: 200,
                    ),
                    _buildSlider(
                      "Pot Width",
                      _potWidth,
                      (v) => setState(() => _potWidth = v),
                      min: 50,
                      max: 300,
                    ),
                    _buildSlider(
                      "Plant Size",
                      _plantBaseSize,
                      (v) => setState(() => _plantBaseSize = v),
                      min: 50,
                      max: 300,
                    ),
                    _buildSlider(
                      "Plant Offset",
                      _plantBottomInternal,
                      (v) => setState(() => _plantBottomInternal = v),
                      min: 0,
                      max: 150,
                    ),
                    _buildSlider(
                      "Background Offset",
                      _backgroundOffset,
                      (v) => setState(() => _backgroundOffset = v),
                      min: -200,
                      max: 200,
                    ),
                    _buildSlider(
                      "Scale Per Stage",
                      _scaleFactorPerStage,
                      (v) => setState(() => _scaleFactorPerStage = v),
                      min: 0,
                      max: 100,
                    ),
                    _buildSlider(
                      "Offset X",
                      _offsetX,
                      (v) => setState(() => _offsetX = v),
                      min: -200,
                      max: 200,
                    ),
                    _buildSlider(
                      "Sunlight (Sync)",
                      homeState.sunlightLevel,
                      (v) => homeNotifier.updateSunlight(v),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Background Image",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                      value: homeState.backgroundImagePath,
                      items: _backgroundAssets.map((path) {
                        return DropdownMenuItem(
                          value: path,
                          child: Text(path.split('/').last),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) homeNotifier.updateBackgroundImage(v);
                      },
                    ),
                    const Divider(height: 30, color: Colors.white24),
                    _buildHeader("Environment (Local Preview)"),
                    _buildSlider(
                      "Temperture",
                      _temperature,
                      (v) => setState(() => _temperature = v),
                    ),
                    _buildSlider(
                      "Humidity",
                      _humidity,
                      (v) => setState(() => _humidity = v),
                    ),
                    const Divider(height: 30, color: Colors.white24),
                    _buildHeader("Plant Info"),
                    _buildSlider(
                      "Growth Stage",
                      _growthStage,
                      (v) => setState(() => _growthStage = v),
                      max: 4,
                      divisions: 4,
                    ),
                    SwitchListTile(
                      title: const Text(
                        "Is Thirsty?",
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _isThirsty,
                      onChanged: (v) => setState(() => _isThirsty = v),
                      activeColor: Colors.tealAccent,
                    ),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Select Plant Category",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                      value: _category,
                      items: ['herb', 'leaf', 'succ', 'weired'].map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _category = v);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
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
}
