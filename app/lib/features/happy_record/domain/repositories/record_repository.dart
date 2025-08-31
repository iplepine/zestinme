import '../../../../core/models/record.dart';

abstract class RecordRepository {
  List<Record> getRecentRecords({int limit = 5});
  Future<void> addRecord(Record record);

  // 통계 계산을 위한 메서드들
  List<Record> getRecordsByDateRange(DateTime startDate, DateTime endDate);
  List<Record> getRecordsByYearAndMonth(int year, int month);
  List<Record> getRecordsByDate(DateTime date);
}
