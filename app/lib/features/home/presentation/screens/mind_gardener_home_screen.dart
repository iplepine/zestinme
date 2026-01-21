import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/localization/app_localizations.dart';

import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';
import 'package:zestinme/features/garden/presentation/providers/mind_plant_provider.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/home/presentation/providers/time_vibe_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mindPlant = ref.watch(mindPlantNotifierProvider);

    final timeVibe = ref.watch(timeVibeNotifierProvider);

    return Scaffold(
      extendBody: true,
      body: Builder(
        builder: (context) {
          if (mindPlant == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.spiritTeal),
            );
          }

          final state = mindPlant;
          PlantSpecies? assignedPlant;
          try {
            assignedPlant = PlantDatabase.species.firstWhere(
              (p) => p.id == state.plantSpeciesId,
            );
          } catch (e) {
            // Fallback
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image (Time based)
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  timeVibe.backgroundImage,
                  key: ValueKey(timeVibe.backgroundImage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // 1-1. Tone Down Mask
              Container(color: Colors.black.withValues(alpha: 0.4)),

              // 2. Main Content (New Layout)
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2-1. Header Area (Date & Title)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Small Date + Status (e.g., Thu, Jan 22 · Evening)
                          Text(
                            "${DateFormat('EEE, MMM d').format(DateTime.now())} · ${_getTimeStatus(context)}",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Focus Title ("이번에 살펴보는 것")
                          Text(
                            AppLocalizations.of(context).homeFocusTitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Main Title ("나의 수면 패턴")
                          Text(
                            AppLocalizations.of(context).homeFocusSleepPattern,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32, // Increased size
                              fontWeight: FontWeight.w800, // Increased weight
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sub Title ("4일째 관찰 중")
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.1,
                                    ), // Subtle border
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).homeFocusDayCount,
                                  style: const TextStyle(
                                    color: AppColors.spiritTeal,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // 2-2. Plant Area (Resized & Positioned)
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            // Slightly adjust vertical position if needed
                            top: 20,
                            child: SizedBox(
                              width: 260, // Reduced from 300
                              height: 350, // Reduced from 400
                              child: MysteryPlantWidget(
                                growthStage: state.getDisplayStage(
                                  assignedPlant?.assetKey ?? 'herb',
                                ),
                                plantName: assignedPlant?.name,
                                showPot: false,
                                category: assignedPlant?.assetKey ?? 'herb',
                                onPlantTap: () => context
                                    .push(AppRouter.seeding)
                                    .then(
                                      (_) => ref
                                          .read(homeProvider.notifier)
                                          .refresh(),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2-3. CTA Button (Inviting Style)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () => context.push(AppRouter.seeding).then((_) {
                          ref.read(homeProvider.notifier).refresh();
                        }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.05,
                                ), // Very subtle
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).homeCtaRecordEmotion,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w500, // Reduced weight
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 110), // Bottom Tab Bar Space
                  ],
                ),
              ),

              // 3. Bottom Dock (Glass)
              Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: HomeBottomBar(
                  currentIndex: 0,
                  onTap: (index) {
                    if (index == 0) return;
                    if (index == 1) context.push(AppRouter.history);
                    if (index == 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("발견(인사이트) 준비 중")),
                      );
                    }
                    if (index == 3) {
                      context.push(AppRouter.settings);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getTimeStatus(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return AppLocalizations.of(context).homeStatusMorning;
    } else if (hour >= 12 && hour < 17) {
      return AppLocalizations.of(context).homeStatusAfternoon;
    } else if (hour >= 17 && hour < 21) {
      return AppLocalizations.of(context).homeStatusEvening;
    } else {
      return AppLocalizations.of(context).homeStatusNight;
    }
  }
}
