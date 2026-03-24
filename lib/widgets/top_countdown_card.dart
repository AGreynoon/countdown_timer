import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../providers/ticker_provider.dart';
import '../theme/app_colors.dart';
import 'countdown_display.dart';

class TopCountdownCard extends ConsumerWidget {
  final Event event;

  const TopCountdownCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = ref.watch(tickerProvider);
    final gradient = AppColors.getEventGradient(event.category);
    final isDarkTheme = AppColors.isDarkTheme(event.category);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.anticipating,
            style: const TextStyle(
              color: AppColors.textLightGrey,
              letterSpacing: 2,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title.isEmpty ? l10n.newEvent : event.title,
            style: TextStyle(
              color: isDarkTheme ? AppColors.textLight : AppColors.textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          CountdownDisplay(event: event, isDarkTheme: isDarkTheme, now: now),
        ],
      ),
    );
  }
}
