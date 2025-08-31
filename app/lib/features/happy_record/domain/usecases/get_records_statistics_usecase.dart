import '../../../../core/models/record.dart';
import '../repositories/record_repository.dart';

enum StatisticsPeriod { today, thisWeek, thisMonth }

class RecordStatistics {
  final int totalRecords;
  final int goodRecords;
  final int difficultRecords;

  const RecordStatistics({
    required this.totalRecords,
    required this.goodRecords,
    required this.difficultRecords,
  });
}

class GetRecordsStatisticsUseCase {
  final RecordRepository _recordRepository;

  GetRecordsStatisticsUseCase(this._recordRepository);

  RecordStatistics execute(StatisticsPeriod period) {
    final now = DateTime.now();
    List<Record> records;

    switch (period) {
      case StatisticsPeriod.today:
        records = _recordRepository.getRecordsByDate(now);
        break;
      case StatisticsPeriod.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        records = _recordRepository.getRecordsByDateRange(
          startOfWeek,
          endOfWeek,
        );
        break;
      case StatisticsPeriod.thisMonth:
        records = _recordRepository.getRecordsByYearAndMonth(
          now.year,
          now.month,
        );
        break;
    }

    final totalRecords = records.length;
    final goodRecords = records.where((record) => record.intensity >= 4).length;
    final difficultRecords = records
        .where((record) => record.intensity <= 2)
        .length;

    return RecordStatistics(
      totalRecords: totalRecords,
      goodRecords: goodRecords,
      difficultRecords: difficultRecords,
    );
  }
}
