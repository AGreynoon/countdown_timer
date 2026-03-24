import 'package:flutter/material.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../theme/app_colors.dart';
import '../utils/helpers.dart';
import 'time_unit_widget.dart';

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
