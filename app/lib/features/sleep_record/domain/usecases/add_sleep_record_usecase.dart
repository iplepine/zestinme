import '../../../../core/errors/failures.dart';
import '../../../../core/models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

class AddSleepRecordUseCase {
  final SleepRecordRepository _repository;

  AddSleepRecordUseCase(this._repository);

  Future<void> call(SleepRecord record) async {
    // 1. 겹치는 시간대의 기록이 있는지 Repository에 요청한다.
    final overlappingRecords = await _repository.getOverlappingRecords(
      record.id.toString(),
      record.inBedTime,
      record.wakeTime,
    );

    // 2. 겹치는 기록이 있다면 예외를 발생시킨다.
    if (overlappingRecords.isNotEmpty) {
      throw SleepTimeOverlapException(overlappingRecords.first);
    }

    // 3. 겹치는 기록이 없으면 기록을 추가한다.
    return _repository.addRecord(record);
  }
}
