import 'package:hive/hive.dart';

import '../../../../core/models/sleep_record.dart';
import '../../domain/repositories/sleep_record_repository.dart';
import '../models/sleep_record_dto.dart';

class SleepRecordRepositoryImpl implements SleepRecordRepository {
  final Box<SleepRecordDto> _box;

  SleepRecordRepositoryImpl(this._box);

  @override
  Future<void> addRecord(SleepRecord record) async {
    await _box.put(record.id.toString(), _toDto(record));
  }

  @override
  Future<void> updateRecord(SleepRecord record) async {
    await _box.put(record.id.toString(), _toDto(record));
  }

  @override
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<SleepRecord>> getAllRecords() async {
    return _box.values.map(_fromDto).toList();
  }

  @override
  Future<List<SleepRecord>> getOverlappingRecords(
    String id,
    DateTime start,
    DateTime end,
  ) async {
    final List<SleepRecordDto> overlaps = [];
    for (final dto in _box.values) {
      if (dto.id == id) continue;

      if (start.isBefore(dto.wakeTime) && dto.inBedTime.isBefore(end)) {
        overlaps.add(dto);
      }
    }
    return overlaps.map(_fromDto).toList();
  }

  @override
  Future<List<SleepRecord>> getRecordsBetween(
    DateTime start,
    DateTime end,
  ) async {
    final records = _box.values
        .where(
          (dto) =>
              dto.date.isAfter(start.subtract(const Duration(days: 1))) &&
              dto.date.isBefore(end.add(const Duration(days: 1))),
        )
        .map(_fromDto)
        .toList();

    // 최신순으로 정렬
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  // --- Mappers ---

  SleepRecordDto _toDto(SleepRecord record) {
    return SleepRecordDto(
      id: record.id.toString(),
      inBedTime: record.inBedTime,
      wakeTime: record.wakeTime,
      qualityScore: record.qualityScore,
      selfRefreshmentScore: record.selfRefreshmentScore,
      tags: record.tags,
      memo: record.memo,
      date: record.date,
    );
  }

  SleepRecord _fromDto(SleepRecordDto dto) {
    final record = SleepRecord()
      ..date = dto.date
      ..inBedTime = dto.inBedTime
      ..wakeTime = dto.wakeTime
      ..qualityScore = dto.qualityScore
      ..selfRefreshmentScore = dto.selfRefreshmentScore
      ..tags = dto.tags
      ..memo = dto.memo;

    // id is autoIncrement in Isar, but we might need to set it for Hive compatibility if possible
    // and if the Isar model allows setting it. In Isar, id is usually not final.
    try {
      record.id = int.tryParse(dto.id) ?? 0;
    } catch (_) {}

    return record;
  }
}
