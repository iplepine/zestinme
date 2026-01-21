import 'package:zestinme/features/garden/domain/entities/mind_plant.dart';

abstract class GardenRepository {
  Future<MindPlant?> getActivePlant();
  Future<void> saveMindPlant(MindPlant plant);
  Future<void> waterPlant(String plantId);
  // Add other methods as needed
}
