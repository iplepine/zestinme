import 'package:isar/isar.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/features/onboarding/data/models/onboarding_data_model.dart';

abstract class OnboardingLocalDataSource {
  Future<void> saveOnboardingData(OnboardingDataModel data);
  Future<OnboardingDataModel?> getOnboardingData();
  Future<bool> isOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final LocalDbService _localDbService;

  OnboardingLocalDataSourceImpl(this._localDbService);

  @override
  Future<void> saveOnboardingData(OnboardingDataModel data) async {
    final isar = _localDbService.isar;
    await isar.writeTxn(() async {
      await isar.onboardingDataModels.put(data);
    });
  }

  @override
  Future<OnboardingDataModel?> getOnboardingData() async {
    final isar = _localDbService.isar;
    return await isar.onboardingDataModels.where().findFirst();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final data = await getOnboardingData();
    return data?.tutorialCompleted ?? false;
  }
}
