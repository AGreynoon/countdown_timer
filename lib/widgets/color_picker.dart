import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ColorPicker extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const ColorPicker({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  static const List<String> availableCategories = [
    'Orange',
    'Blue',
    'Green',
    'Purple',
    'White'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availableCategories.map((category) {
          final isSelected = selectedCategory.toLowerCase() == category.toLowerCase();
          final color = AppColors.getThemePrimaryColor(category);

          return GestureDetector(
            onTap: () => onSelected(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: category.toLowerCase() == 'white' 
                    ? Border.all(color: Colors.grey.shade300, width: 2) 
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: category.toLowerCase() == 'white' ? Colors.black : Colors.white,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
