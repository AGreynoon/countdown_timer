import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // App Bar
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  // Cards
  static const TextStyle cardTitleLight = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static const TextStyle cardTitleDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle cardSubtitleLight = TextStyle(
    fontSize: 14,
    color: AppColors.textLightGrey,
  );

  static const TextStyle cardSubtitleDark = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
  );

  // Numbers & Units
  static const TextStyle numberStyleWhite = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    height: 1.1,
  );

  static const TextStyle numberStyleBlue = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.numberBlueDark,
    height: 1.1,
  );
  
  static const TextStyle unitLabelWhite = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
    color: AppColors.textLightGrey,
  );

  static const TextStyle unitLabelDark = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
    color: AppColors.textGrey,
  );
}
