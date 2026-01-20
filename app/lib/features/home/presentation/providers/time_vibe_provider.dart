import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_vibe_provider.g.dart';

enum TimeVibe {
  morning,
  evening,
  night;

  String get backgroundImage {
    return switch (this) {
      TimeVibe.morning => 'assets/images/backgrounds/bg_morning.png',
      TimeVibe.evening => 'assets/images/backgrounds/bg_evening.png',
      TimeVibe.night => 'assets/images/backgrounds/bg_night.png',
    };
  }
}

@riverpod
class TimeVibeNotifier extends _$TimeVibeNotifier {
  @override
  TimeVibe build() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour < 17) {
      return TimeVibe.morning;
    } else if (hour >= 17 && hour < 21) {
      return TimeVibe.evening;
    } else {
      return TimeVibe.night;
    }
  }

  void updateVibe() {
    state = build();
  }
}
