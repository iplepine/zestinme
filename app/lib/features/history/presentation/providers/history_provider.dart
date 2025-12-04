import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:get_it/get_it.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History {
  @override
  Future<List<EmotionRecord>> build() async {
    final dbService = GetIt.I<LocalDbService>();
    return await dbService.getAllEmotionRecords();
  }
}
