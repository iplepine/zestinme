import '../../../../core/models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

/// 특정 기간 동안의 수면 기록 조회 유즈케이스
class GetSleepRecordsUseCase {
  final SleepRecordRepository _repository;

  GetSleepRecordsUseCase(this._repository);

  Future<List<SleepRecord>> call() async {
    return _repository.getAllRecords();
  }
}
