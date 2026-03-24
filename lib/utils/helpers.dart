import 'package:intl/intl.dart';
import '../models/event.dart';

class AppHelpers {
  static String formatDate(DateTime date, String locale) {
    return DateFormat.yMMMMd(locale).format(date);
  }

  static String localizeNumber(int value, String locale) {
    String input = value.toString().padLeft(2, '0');
    if (locale != 'ar') return input;
    
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < englishNumbers.length; i++) {
      input = input.replaceAll(englishNumbers[i], arabicNumbers[i]);
    }
    return input;
  }

  static Map<String, int> calculateRemainingTime(DateTime target, DateTime now, Event event) {
    Duration diff = target.difference(now);
    bool past = diff.isNegative;
    if (past) {
      diff = -diff;
    }

    int totalDays = diff.inDays;
    int years = 0;
    int months = 0;
    int weeks = 0;
    int days = 0;

    if (event.displayUnits['Years'] == true) {
      years = totalDays ~/ 365;
      totalDays = totalDays % 365;
    }
    if (event.displayUnits['Months'] == true) {
      months = totalDays ~/ 30;
      totalDays = totalDays % 30;
    }
    if (event.displayUnits['Weeks'] == true) {
      weeks = totalDays ~/ 7;
      totalDays = totalDays % 7;
    }
    if (event.displayUnits['Days'] == true) {
      days = totalDays;
    }

    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    return {
      'Years': years,
      'Months': months,
      'Weeks': weeks,
      'Days': days,
      'Hours': hours,
      'Minutes': minutes,
      'Seconds': seconds,
    };
  }
}
