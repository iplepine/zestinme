import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/di/injection.dart';
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
      waterLevel: 0.5,
      sunlightLevel: 0.5,
      arousalScore: 5,
      valenceScore: 5,
      activeModuleId: '',
    );
  }

  void setNickname(String nickname) {
    state = OnboardingState(
      nickname: nickname,
      waterLevel: state.waterLevel,
      sunlightLevel: state.sunlightLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: state.activeModuleId,
    );
  }

  void updateEnvironment({double? waterLevel, double? sunlightLevel}) {
    final newWaterLevel = waterLevel ?? state.waterLevel;
    final newSunlightLevel = sunlightLevel ?? state.sunlightLevel;

    // Map 0.0-1.0 to 1-9
    final arousal = (newWaterLevel * 8 + 1).round();
    final valence = (newSunlightLevel * 8 + 1).round();

    state = OnboardingState(
      nickname: state.nickname,
      waterLevel: newWaterLevel,
      sunlightLevel: newSunlightLevel,
      arousalScore: arousal,
      valenceScore: valence,
      activeModuleId: state.activeModuleId,
    );
  }

  void selectModule(String moduleId) {
    state = OnboardingState(
      nickname: state.nickname,
      waterLevel: state.waterLevel,
      sunlightLevel: state.sunlightLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: moduleId,
    );
  }

  Future<void> complete() async {
    await ref.read(completeOnboardingProvider).call(state);
    state = OnboardingState(
      nickname: state.nickname,
      waterLevel: state.waterLevel,
      sunlightLevel: state.sunlightLevel,
      arousalScore: state.arousalScore,
      valenceScore: state.valenceScore,
      activeModuleId: state.activeModuleId,
      isCompleted: true,
    );
  }
}
