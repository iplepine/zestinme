import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/theme_provider.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/providers/session_provider.dart';
import '../../../../core/widgets/zest_glass_card.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final session = ref.read(sessionProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.voidBlack),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildSectionHeader(context, 'Account'),
              ZestGlassCard(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () async {
                    await session.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader(context, 'Appearance'),
              ZestGlassCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      secondary: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                    ListTile(
                      title: const Text('Theme Selection'),
                      leading: const Icon(Icons.palette_outlined),
                      subtitle: Text(
                        themeMode.toString().split('.').last.toUpperCase(),
                      ),
                      onTap: () => _showThemePicker(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader(context, 'Language'),
              ZestGlassCard(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language Selection'),
                  subtitle: Text(
                    locale.languageCode == 'ko' ? '한국어' : 'English',
                  ),
                  onTap: () => _showLocalePicker(context, ref),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader(context, 'App Information'),
              ZestGlassCard(
                child: const ListTile(
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings_brightness),
                title: const Text('System'),
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light'),
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark'),
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
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
