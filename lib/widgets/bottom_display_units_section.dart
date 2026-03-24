import 'package:flutter/material.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../theme/app_colors.dart';

class BottomDisplayUnitsSection extends StatelessWidget {
  final Event event;
  final ValueChanged<Event> onEventChanged;

  const BottomDisplayUnitsSection({
    super.key,
    required this.event,
    required this.onEventChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              l10n.displayUnits,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...[
            'Years',
            'Months',
            'Weeks',
            'Days',
            'Hours',
            'Minutes',
            'Seconds',
          ].map((unit) {
            String unitLocal = unit;
            if (unit == 'Years') unitLocal = l10n.years;
            if (unit == 'Months') unitLocal = l10n.months;
            if (unit == 'Weeks') unitLocal = l10n.weeks;
            if (unit == 'Days') unitLocal = l10n.days;
            if (unit == 'Hours') unitLocal = l10n.hours;
            if (unit == 'Minutes') unitLocal = l10n.minutes;
            if (unit == 'Seconds') unitLocal = l10n.seconds;

            return SwitchListTile(
              title: Text(unitLocal, style: const TextStyle(fontSize: 14)),
              value: event.displayUnits[unit] ?? false,
              activeThumbColor: AppColors.tealPrimary,
              onChanged: (val) {
                final newUnits = Map<String, bool>.from(event.displayUnits);
                newUnits[unit] = val;
                onEventChanged(event.copyWith(displayUnits: newUnits));
              },
            );
          }),
        ],
      ),
    );
  }
}
