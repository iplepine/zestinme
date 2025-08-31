import 'package:hive/hive.dart';
import '../../domain/repositories/record_repository.dart';
import '../models/record_dto.dart';
import '../../../../core/models/record.dart';

class RecordRepositoryImpl implements RecordRepository {
  final Box<RecordDto> recordBox;
  RecordRepositoryImpl(this.recordBox);

  @override
  List<Record> getRecentRecords({int limit = 5}) {
    final records = recordBox.values
        .map((dto) => dto.toDomain())
        .whereType<Record>()
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records.take(limit).toList();
  }

  @override
  Future<void> addRecord(Record record) async {
    final dto = RecordDto.fromDomain(record);
    await recordBox.add(dto);
  }

  @override
  List<Record> getRecordsByDateRange(DateTime startDate, DateTime endDate) {
    final records = recordBox.values
        .map((dto) => dto.toDomain())
        .whereType<Record>()
        .where(
          (record) =>
              record.createdAt.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              record.createdAt.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  @override
  List<Record> getRecordsByYearAndMonth(int year, int month) {
    final records = recordBox.values
        .map((dto) => dto.toDomain())
        .whereType<Record>()
        .where(
          (record) =>
              record.createdAt.year == year && record.createdAt.month == month,
        )
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  @override
  List<Record> getRecordsByDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    final records = recordBox.values
        .map((dto) => dto.toDomain())
        .whereType<Record>()
        .where((record) {
          final recordDate = DateTime(
            record.createdAt.year,
            record.createdAt.month,
            record.createdAt.day,
          );
          return recordDate.isAtSameMomentAs(targetDate);
        })
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }
}
