import '../../../../core/models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

class UpdateSleepRecordUseCase {
  final SleepRecordRepository _repository;

  UpdateSleepRecordUseCase(this._repository);

  Future<void> call(SleepRecord record) async {
    return _repository.updateRecord(record);
  }
}
