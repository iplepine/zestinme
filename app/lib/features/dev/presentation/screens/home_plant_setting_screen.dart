import 'package:flutter/material.dart';
import 'package:zestinme/features/home/presentation/widgets/scenic_background.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';

class HomePlantSettingScreen extends StatefulWidget {
  const HomePlantSettingScreen({super.key});

  @override
  State<HomePlantSettingScreen> createState() => _HomePlantSettingScreenState();
}

class _HomePlantSettingScreenState extends State<HomePlantSettingScreen> {
  // Environment Params
  double _sunlight = 0.2; // 0.0 (Night) ~ 1.0 (Day)
  double _temperature = 0.5; // 0.0 (Cold) ~ 1.0 (Hot)
  double _humidity = 0.5; // 0.0 (Dry) ~ 1.0 (Wet)

  // Plant Params
  double _growthStage =
      0; // 0 ~ 4 (Float for smooth slider, but widget takes int)
  bool _isThirsty = false;
  String _plantId = '1'; // Default: Mimosa

  @override
  Widget build(BuildContext context) {
    // Current Plant Selection
    final currentPlant = PlantDatabase.species.firstWhere(
      (p) => p.id == int.tryParse(_plantId),
      orElse: () => PlantDatabase.species.first,
    );

    // Calculate Plant Lighting Tint based on Sunlight
    // Night (0.0): Dark Blue-ish tint (multiply)
    // Day (1.0): Neutral / Slight Warmth
    final lightingColor = Color.lerp(
      const Color(0xFF667799), // Night: Dark Blue-Grey
      Colors.white, // Day: Neutral
      _sunlight.clamp(0.0, 1.0),
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
          // 1. Scenic Background (replaces EnvironmentBackground)
          ScenicBackground(sunlight: _sunlight),

          // 2. Plant Widget with Lighting Mask
          Positioned(
            bottom: 120 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                lightingColor,
                BlendMode.modulate, // Multiplies the color (Darkens at night)
              ),
              child: MysteryPlantWidget(
                growthStage: _growthStage.round(),
                isThirsty: _isThirsty,
                plantName: currentPlant.name,
                onPlantTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Plant Tapped!")),
                  );
                },
                onWaterTap: () {
                  setState(() {
                    _isThirsty = false;
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Watered!")));
                },
              ),
            ),
          ),

          // 3. Control Panel (Bottom Sheet style but fixed)
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                    const Text(
                      "Environment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _buildSlider(
                      "Sunlight (Time)",
                      _sunlight,
                      (v) => setState(() => _sunlight = v),
                    ),
                    _buildSlider(
                      "Temperature",
                      _temperature,
                      (v) => setState(() => _temperature = v),
                    ),
                    _buildSlider(
                      "Humidity",
                      _humidity,
                      (v) => setState(() => _humidity = v),
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Plant",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _buildSlider(
                      "Growth Stage",
                      _growthStage,
                      (v) => setState(() => _growthStage = v),
                      max: 4,
                      divisions: 4,
                    ),
                    SwitchListTile(
                      title: const Text("Is Thirsty?"),
                      value: _isThirsty,
                      onChanged: (v) => setState(() => _isThirsty = v),
                    ),

                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Plant Species",
                      ),
                      value: _plantId,
                      items: PlantDatabase.species.map((p) {
                        return DropdownMenuItem(
                          value: p.id.toString(),
                          child: Text(
                            "${p.id}. ${p.name} (${p.scientificName})",
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _plantId = v);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
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
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value.toStringAsFixed(2))],
        ),
        Slider(
          value: value,
          min: 0.0,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
