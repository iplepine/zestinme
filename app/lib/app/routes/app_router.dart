import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/seeding/presentation/screens/seeding_screen.dart';
import '../../features/dev/presentation/screens/dev_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/happy_record/presentation/dashboard/home_dashboard_page.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../features/auth/presentation/login_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

part 'app_router.g.dart';

class AppRouter {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const history = '/history';
  static const seeding = '/seeding';
  static const dev = '/dev';
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/dev',
    refreshListenable: notifier,
    redirect: (context, state) {
      // Developer Mode: Always allow /dev and debugging routes
      final allowedRoutes = [
        '/dev',
        '/seeding',
        '/history',
        '/login',
        '/old-home',
        '/',
      ];
      if (allowedRoutes.contains(state.matchedLocation)) return null;

      // Read the current state directly
      final onboardingState = ref.read(onboardingViewModelProvider);
      final isCompleted = onboardingState.isCompleted;

      // Logic:
      // If NOT completed and NOT in /onboarding -> Go to /onboarding
      // If completed and IN /onboarding -> Go to /

      if (!isCompleted && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      if (isCompleted && state.matchedLocation == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeDashboardPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/seeding',
        builder: (context, state) => const SeedingScreen(),
      ),
      GoRoute(path: '/dev', builder: (context, state) => const DevScreen()),

      // Legacy Routes (kept for reference if needed, or can be removed)
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/old-home',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(onboardingViewModelProvider, (_, __) => notifyListeners());
  }
}
