import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../features/sleep_record/data/models/sleep_record_dto.dart';
import '../features/sleep_record/data/repositories/sleep_record_repository_impl.dart';
import '../features/sleep_record/domain/repositories/sleep_record_repository.dart';
import '../features/sleep_record/domain/usecases/add_sleep_record_usecase.dart';
import '../features/sleep_record/domain/usecases/delete_sleep_record_usecase.dart';
import '../features/sleep_record/domain/usecases/get_sleep_records_usecase.dart';
import '../features/sleep_record/domain/usecases/update_sleep_record_usecase.dart';
import '../core/services/firebase_service.dart';
import '../features/anger/data/question_bank_loader.dart';
import '../features/anger/data/coach_repository.dart';
import '../core/services/local_db_service.dart';

/// 의존성 주입 설정
class Injection {
  static final GetIt _getIt = GetIt.instance;

  /// 의존성 초기화
  static Future<void> init() async {
    // Firebase 초기화
    await FirebaseService.instance.initialize();

    // Hive 초기화 및 어댑터 등록
    await Hive.initFlutter();

    // Sleep Record Adapter
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SleepRecordDtoAdapter());
    }

    final sleepRecordBox = await Hive.openBox<SleepRecordDto>('sleep_records');

    // Isar 초기화
    final localDbService = LocalDbService();
    await localDbService.init();
    _getIt.registerSingleton<LocalDbService>(localDbService);

    // Repository 등록
    _getIt.registerSingleton<SleepRecordRepository>(
      SleepRecordRepositoryImpl(sleepRecordBox),
    );

    // UseCase 등록

    _getIt.registerSingleton<AddSleepRecordUseCase>(
      AddSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<GetSleepRecordsUseCase>(
      GetSleepRecordsUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<UpdateSleepRecordUseCase>(
      UpdateSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<DeleteSleepRecordUseCase>(
      DeleteSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );

    // Firebase 서비스 등록
    _getIt.registerSingleton<FirebaseService>(FirebaseService.instance);

    // 코칭 관련 서비스 등록
    _getIt.registerSingleton<QuestionBankLoader>(
      QuestionBankLoader(
        remoteConfig: FirebaseService.instance.remoteConfig,
        firestore: FirebaseService.instance.firestore,
      ),
    );

    _getIt.registerSingleton<CoachRepository>(
      CoachRepository(
        firestore: FirebaseService.instance.firestore,
        userId: 'anonymous_user', // 실제 구현에서는 Firebase Auth에서 가져옴
      ),
    );
  }

  /// GetIt 인스턴스 반환
  static GetIt get getIt => _getIt;
}
