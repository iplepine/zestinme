import 'package:zestinme/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:zestinme/features/onboarding/data/models/onboarding_data_model.dart';
import 'package:zestinme/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:zestinme/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _dataSource;

  OnboardingRepositoryImpl(this._dataSource);

  @override
  Future<void> completeOnboarding(OnboardingState state) async {
    final model = OnboardingDataModel()
      ..nickname = state.nickname
      ..createdAt = DateTime.now()
      ..temperatureLevel = state.temperatureLevel
      ..sunlightLevel = state.sunlightLevel
      ..humidityLevel = state.humidityLevel
      ..arousalScore = state.arousalScore
      ..valenceScore = state.valenceScore
      ..activeModuleId = state.activeModuleId
      ..assignedPlantId = state.assignedPlantId
      ..tutorialCompleted = true
      ..growthStage = state.growthStage;

    await _dataSource.saveOnboardingData(model);
  }

  @override
  Future<bool> checkOnboardingStatus() async {
    return await _dataSource.isOnboardingCompleted();
  }

  @override
  Future<OnboardingState?> getOnboardingState() async {
    final data = await _dataSource.getOnboardingData();
    if (data == null) return null;

    return OnboardingState(
      nickname: data.nickname,
      temperatureLevel: data.temperatureLevel,
      sunlightLevel: data.sunlightLevel,
      humidityLevel: data.humidityLevel,
      arousalScore: data.arousalScore,
      valenceScore: data.valenceScore,
      activeModuleId: data.activeModuleId,
      assignedPlantId: data.assignedPlantId,
      isCompleted: data.tutorialCompleted,
      growthStage: data.growthStage ?? 0,
    );
  }
}
