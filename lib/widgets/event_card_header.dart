import 'package:flutter/material.dart';
import '../models/event.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../utils/helpers.dart';

class EventCardHeader extends StatelessWidget {
  final Event event;
  final bool isDarkTheme;

  const EventCardHeader({super.key, required this.event, required this.isDarkTheme});

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
