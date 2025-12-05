import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/di/injection.dart';
import 'package:zestinme/features/garden/domain/services/plant_service.dart';
import 'package:zestinme/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:zestinme/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:zestinme/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:zestinme/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:zestinme/features/onboarding/domain/usecases/complete_onboarding.dart';

part 'onboarding_provider.g.dart';

@riverpod
OnboardingLocalDataSource onboardingLocalDataSource(
  OnboardingLocalDataSourceRef ref,
) {
  return OnboardingLocalDataSourceImpl(Injection.getIt<LocalDbService>());
}

@riverpod
OnboardingRepositoryImpl onboardingRepository(OnboardingRepositoryRef ref) {
  return OnboardingRepositoryImpl(ref.watch(onboardingLocalDataSourceProvider));
}

@riverpod
CheckOnboardingStatus checkOnboardingStatus(CheckOnboardingStatusRef ref) {
  return CheckOnboardingStatus(ref.watch(onboardingRepositoryProvider));
}

@riverpod
CompleteOnboarding completeOnboarding(CompleteOnboardingRef ref) {
  return CompleteOnboarding(ref.watch(onboardingRepositoryProvider));
}

@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  OnboardingState build() {
    return const OnboardingState(
      nickname: '',
      temperatureLevel: 0.5,
      sunlightLevel: 0.5,
      humidityLevel: 0.5,
      arousalScore: 5,
      valenceScore: 5,
      activeModuleId: '',
    );
  }

  void setNickname(String nickname) {
    state = OnboardingState(
      nickname: nickname,
      temperatureLevel: state.temperatureLevel,
      sunlightLevel: state.sunlightLevel,
      humidityLevel: state.humidityLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: state.activeModuleId,
      assignedPlantId: state.assignedPlantId,
    );
  }

  void updateEnvironment({
    double? temperatureLevel,
    double? sunlightLevel,
    double? humidityLevel,
  }) {
    final newTempLevel = temperatureLevel ?? state.temperatureLevel;
    final newSunlightLevel = sunlightLevel ?? state.sunlightLevel;
    final newHumidityLevel = humidityLevel ?? state.humidityLevel;

    // Map 0.0-1.0 to 1-9
    // Temperature -> Arousal
    // Sunlight -> Valence
    final arousal = (newTempLevel * 8 + 1).round();
    final valence = (newSunlightLevel * 8 + 1).round();

    state = OnboardingState(
      nickname: state.nickname,
      temperatureLevel: newTempLevel,
      sunlightLevel: newSunlightLevel,
      humidityLevel: newHumidityLevel,
      arousalScore: arousal,
      valenceScore: valence,
      activeModuleId: state.activeModuleId,
      assignedPlantId: state.assignedPlantId,
    );
  }

  void selectModule(String moduleId) {
    state = OnboardingState(
      nickname: state.nickname,
      temperatureLevel: state.temperatureLevel,
      sunlightLevel: state.sunlightLevel,
      humidityLevel: state.humidityLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: moduleId,
      assignedPlantId: state.assignedPlantId,
    );
  }

  Future<void> complete() async {
    // 1. Assign Plant based on Environment
    // Sunlight: 0.0-1.0 -> 0-100,000 Lux
    // Temperature: 0.0-1.0 -> 0-40 C
    // Humidity: 0.0-1.0 -> 0-100 %
    final lux = state.sunlightLevel * 100000;
    final temperature = state.temperatureLevel * 40;
    final humidity = state.humidityLevel * 100;

    final assignedPlant = PlantService().assignPlant(
      lux: lux,
      temp: temperature,
      humidity: humidity,
    );

    // 2. Update local state with plant ID
    state = OnboardingState(
      nickname: state.nickname,
      temperatureLevel: state.temperatureLevel,
      sunlightLevel: state.sunlightLevel,
      humidityLevel: state.humidityLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: state.activeModuleId,
      assignedPlantId: assignedPlant.id,
    );

    // 3. Persist to DB
    await ref.read(completeOnboardingProvider).call(state);

    // 4. Mark as completed locally to trigger navigation
    state = OnboardingState(
      nickname: state.nickname,
      temperatureLevel: state.temperatureLevel,
      sunlightLevel: state.sunlightLevel,
      humidityLevel: state.humidityLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: state.activeModuleId,
      assignedPlantId: assignedPlant.id,
      isCompleted: true,
    );
  }
}
