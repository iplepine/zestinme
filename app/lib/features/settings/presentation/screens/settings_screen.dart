import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/theme_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/providers/session_provider.dart';
import '../../../../core/widgets/fullcon_brand.dart';
import '../../../../core/widgets/zest_glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final session = ref.read(sessionProvider.notifier);
    final isKo = locale.languageCode == 'ko';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1322), Color(0xFF121D32)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Row(
                children: [
                  _HeaderIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isKo ? '설정' : 'Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ZestGlassCard(
                borderRadius: BorderRadius.circular(28),
                padding: const EdgeInsets.all(24),
                color: const Color(0xFF111A2C),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FullConWordmark(fontSize: 10),
                    const SizedBox(height: 10),
                    Text(
                      isKo
                          ? '풀컨은 좋은 컨디션을\n오래 유지하도록 돕는 앱입니다.'
                          : 'FullCon helps you hold a better condition longer.',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isKo
                          ? '언어와 화면 설정을 내 방식에 맞게 조정해보세요.'
                          : 'Adjust language and appearance to fit how you run your days.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _buildSectionHeader(context, isKo ? '화면' : 'Display'),
              ZestGlassCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(isKo ? '다크 모드' : 'Dark mode'),
                      subtitle: Text(
                        isKo ? '집중하기 편한 어두운 화면을 사용합니다.' : 'Use the high-focus dark interface',
                      ),
                      secondary: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: Text(isKo ? '테마 모드' : 'Theme mode'),
                      subtitle: Text(
                        switch (themeMode) {
                          ThemeMode.system => isKo ? '시스템 자동' : 'System',
                          ThemeMode.light => isKo ? '라이트' : 'Light',
                          ThemeMode.dark => isKo ? '다크' : 'Dark',
                        },
                      ),
                      onTap: () => _showThemePicker(context, ref, isKo),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _buildSectionHeader(context, isKo ? '언어' : 'Language'),
              ZestGlassCard(
                child: ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(isKo ? '앱 언어' : 'App language'),
                  subtitle: Text(locale.languageCode == 'ko' ? '한국어' : 'English'),
                  onTap: () => _showLocalePicker(context, ref),
                ),
              ),
              const SizedBox(height: 22),
              _buildSectionHeader(context, isKo ? '앱 소개' : 'About'),
              ZestGlassCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const ConditionArrowMark(
                        direction: ConditionArrowDirection.up,
                        size: 18,
                      ),
                      title: Text(isKo ? '제품 포지션' : 'Product stance'),
                      subtitle: Text(
                        isKo ? '능동형 컨디션 코치' : 'Proactive condition coach',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('Version'),
                      trailing: Text(AppConstants.appVersion),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _buildSectionHeader(context, isKo ? '계정' : 'Session'),
              ZestGlassCard(
                child: ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.fire),
                  title: Text(
                    isKo ? '로그아웃' : 'Log out',
                    style: const TextStyle(color: AppColors.fire),
                  ),
                  subtitle: Text(
                    isKo ? '현재 계정에서 로그아웃합니다.' : 'End the current session.',
                  ),
                  onTap: () async {
                    await session.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.signalBlue,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, bool isKo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121C31),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings_brightness_rounded),
                title: Text(isKo ? '시스템' : 'System'),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_rounded),
                title: Text(isKo ? '라이트' : 'Light'),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: Text(isKo ? '다크' : 'Dark'),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocalePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121C31),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('한국어'),
                onTap: () {
                  ref.read(localeProvider.notifier).setKorean();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  ref.read(localeProvider.notifier).setEnglish();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
