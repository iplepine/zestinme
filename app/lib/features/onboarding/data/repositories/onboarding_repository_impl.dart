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
      ..waterLevel = state.waterLevel
      ..sunlightLevel = state.sunlightLevel
      ..arousalScore = state.arousalScore
      ..valenceScore = state.valenceScore
      ..activeModuleId = state.activeModuleId
      ..tutorialCompleted = true;

    await _dataSource.saveOnboardingData(model);
  }

  @override
  Future<bool> checkOnboardingStatus() async {
    return await _dataSource.isOnboardingCompleted();
  }
}
