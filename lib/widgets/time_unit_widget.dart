import 'package:flutter/material.dart';
import '../utils/helpers.dart';

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
              fontSize: 12,
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
