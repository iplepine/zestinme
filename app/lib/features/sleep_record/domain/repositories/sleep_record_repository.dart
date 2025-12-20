import '../../../../core/models/sleep_record.dart';

abstract class SleepRecordRepository {
  Future<void> addRecord(SleepRecord record);
  Future<List<SleepRecord>> getRecordsBetween(DateTime start, DateTime end);
  Future<List<SleepRecord>> getOverlappingRecords(
    String id,
    DateTime start,
    DateTime end,
  );
  Future<List<SleepRecord>> getAllRecords();
  Future<void> updateRecord(SleepRecord record);
  Future<void> deleteRecord(String id);
}
