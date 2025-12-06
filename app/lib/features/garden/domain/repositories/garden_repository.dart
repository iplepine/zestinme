import 'package:zestinme/features/garden/domain/entities/current_pot.dart';

abstract class GardenRepository {
  Future<CurrentPot?> getCurrentPot();
  Future<void> saveCurrentPot(CurrentPot pot);
  Future<void> waterPot(String potId);
  // Add other methods as needed
}
