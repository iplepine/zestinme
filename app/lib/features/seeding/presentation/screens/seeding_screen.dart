import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/routes/app_router.dart';
import '../providers/seeding_provider.dart';
import '../widgets/seeding_content.dart';

class SeedingScreen extends ConsumerStatefulWidget {
  const SeedingScreen({super.key});

  @override
  ConsumerState<SeedingScreen> createState() => _SeedingScreenState();
}

class _SeedingScreenState extends ConsumerState<SeedingScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure state is clean when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(seedingNotifierProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Force Dark Theme for this screen as it has a specific dark aesthetic
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: SeedingContent(
          onComplete: () {
            if (context.mounted) {
              context.go(AppRouter.home);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.seeding_messagePlanted,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
