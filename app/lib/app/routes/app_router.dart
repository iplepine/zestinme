import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/emotion_write/presentation/screens/emotion_write_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../features/auth/presentation/login_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final checkStatus = ref.read(checkOnboardingStatusProvider);
      final isCompleted = await checkStatus.call();

      if (!isCompleted && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      if (isCompleted && state.matchedLocation == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/write',
        builder: (context, state) => const EmotionWriteScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),

      // Legacy Routes (kept for reference if needed, or can be removed)
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/old-home',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
}
