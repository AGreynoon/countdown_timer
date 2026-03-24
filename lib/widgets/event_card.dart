import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../providers/ticker_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../utils/helpers.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

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
          _EventCardHeader(event: event, isDarkTheme: isDarkTheme),
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

class _EventCardHeader extends StatelessWidget {
  final Event event;
  final bool isDarkTheme;

  const _EventCardHeader({required this.event, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: isDarkTheme
                    ? AppStyles.cardTitleLight
                    : AppStyles.cardTitleDark,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isDarkTheme
                        ? Icons.favorite_border
                        : Icons.calendar_today_outlined,
                    size: 14,
                    color: isDarkTheme
                        ? AppColors.textLightGrey
                        : AppColors.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      AppHelpers.formatDate(event.targetDate, localeName),
                      style: isDarkTheme
                          ? AppStyles.cardSubtitleLight
                          : AppStyles.cardSubtitleDark,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CountdownDisplay extends StatelessWidget {
  final Event event;
  final bool isDarkTheme;
  final DateTime now;
  final bool compact;

  const CountdownDisplay({
    super.key,
    required this.event,
    required this.isDarkTheme,
    required this.now,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timeMap = AppHelpers.calculateRemainingTime(
      event.targetDate,
      now,
      event,
    );
    bool past = event.targetDate.difference(now).isNegative;

    List<Widget> units = [];

    Color darkNumColor = AppColors.textLight;
    Color darkLabelColor = AppColors.textLightGrey;
    Color whiteNumColor = past
        ? AppColors.destructiveRed
        : AppColors.numberBlueDark;
    Color whiteLabelColor = AppColors.textGrey;

    if (event.displayUnits['Years'] == true) {
      units.add(
        TimeUnitWidget(
          value: timeMap['Years']!,
          label: l10n.years,
          numColor: isDarkTheme ? darkNumColor : whiteNumColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Months'] == true) {
      units.add(
        TimeUnitWidget(
          value: timeMap['Months']!,
          label: l10n.months,
          numColor: isDarkTheme ? darkNumColor : whiteNumColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Weeks'] == true) {
      units.add(
        TimeUnitWidget(
          value: timeMap['Weeks']!,
          label: l10n.weeks,
          numColor: isDarkTheme ? darkNumColor : whiteNumColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Days'] == true) {
      units.add(
        TimeUnitWidget(
          value: timeMap['Days']!,
          label: l10n.days,
          numColor: isDarkTheme ? darkNumColor : whiteNumColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Hours'] == true) {
      Color hColor = isDarkTheme ? darkNumColor : AppColors.numberBlueMid;
      if (past && !isDarkTheme) hColor = Colors.red[300]!;
      units.add(
        TimeUnitWidget(
          value: timeMap['Hours']!,
          label: l10n.hours,
          numColor: hColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Minutes'] == true) {
      Color mColor = isDarkTheme ? darkNumColor : AppColors.numberBlueLight;
      if (past && !isDarkTheme) mColor = Colors.red[200]!;
      units.add(
        TimeUnitWidget(
          value: timeMap['Minutes']!,
          label: l10n.minutes,
          numColor: mColor,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }
    if (event.displayUnits['Seconds'] == true) {
      units.add(
        TimeUnitWidget(
          value: timeMap['Seconds']!,
          label: l10n.seconds,
          numColor: isDarkTheme ? darkNumColor : Colors.grey,
          labelColor: isDarkTheme ? darkLabelColor : whiteLabelColor,
          compact: compact,
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: compact ? 6 : 12, children: units);
  }
}

class TimeUnitWidget extends StatelessWidget {
  final int value;
  final String label;
  final Color numColor;
  final Color labelColor;
  final bool compact;

  const TimeUnitWidget({
    super.key,
    required this.value,
    required this.label,
    required this.numColor,
    required this.labelColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: EdgeInsets.only(right: compact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppHelpers.localizeNumber(value, localeName),
            style: TextStyle(
              fontSize: compact ? 32 : 42,
              fontWeight: FontWeight.bold,
              color: numColor,
              height: 1.1,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
