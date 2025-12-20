import '../../../../core/models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

/// 미완성 수면 기록 조회 유즈케이스
class GetUnfinishedSleepRecordUseCase {
  final SleepRecordRepository _repository;

  GetUnfinishedSleepRecordUseCase(this._repository);

  /// 12시간 이내의 미완성 수면 기록을 조회합니다.
  Future<SleepRecord?> call() async {
    final records = await _repository.getAllRecords();

    // 현재 시간 기준으로 12시간 이내의 미완성 기록 찾기
    final now = DateTime.now();
    final unfinishedRecord = records.where((record) {
      final timeDiff = now.difference(record.inBedTime).inHours;
      final isIncomplete =
          record.inBedTime == record.wakeTime; // 잠든 시간과 일어난 시간이 같음
      return timeDiff <= 12 && isIncomplete;
    }).toList();

    return unfinishedRecord.isEmpty ? null : unfinishedRecord.first;
  }
}
