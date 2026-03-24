import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../providers/ticker_provider.dart';
import '../theme/app_colors.dart';
import 'event_card_header.dart';
import 'countdown_display.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});
  
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = AppColors.isDarkTheme(event.category);
    LinearGradient gradient = AppColors.getEventGradient(event.category);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventCardHeader(event: event, isDarkTheme: isDarkTheme),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              final now = ref.watch(tickerProvider);
              return CountdownDisplay(
                event: event,
                isDarkTheme: isDarkTheme,
                now: now,
                compact: true,
              );
            },
          ),
        ],
      ),
    );
  }
}


