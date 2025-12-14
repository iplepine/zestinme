import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/di/injection.dart';
import '../../../../core/services/local_db_service.dart';
import '../state/sleep_home_state.dart';

final sleepHomeControllerProvider =
    StateNotifierProvider<SleepHomeController, SleepHomeState>(
      (ref) => SleepHomeController(Injection.getIt<LocalDbService>()),
    );

class SleepHomeController extends StateNotifier<SleepHomeState> {
  final LocalDbService _localDbService;

  SleepHomeController(this._localDbService)
    : super(const SleepHomeState.loading()) {
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    state = const SleepHomeState.loading();
    try {
      final now = DateTime.now();
      // Fetch last 30 days
      final records = await _localDbService.getSleepRecordsByRange(
        now.subtract(const Duration(days: 30)),
        now,
      );

      state = SleepHomeState.data(records);
    } catch (e) {
      state = SleepHomeState.error(e.toString());
    }
  }
}
