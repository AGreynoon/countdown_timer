import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../theme/app_colors.dart';
import 'color_picker.dart';

class MiddleConfigSection extends StatelessWidget {
  final Event event;
  final bool isEditMode;
  final TextEditingController titleController;
  final VoidCallback onEditModeToggled;
  final ValueChanged<Event> onEventChanged;

  const MiddleConfigSection({
    super.key,
    required this.event,
    required this.isEditMode,
    required this.titleController,
    required this.onEditModeToggled,
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.eventDetails,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEditModeToggled,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isEditMode
                        ? Colors.blue[50]
                        : AppColors.greyBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 14,
                        color: isEditMode ? Colors.blue : AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.edit,
                        style: TextStyle(
                          fontSize: 12,
                          color: isEditMode ? Colors.blue : AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isEditMode) ...[
            const SizedBox(height: 20),
            Text(
              l10n.themeColor,
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 12),
            ColorPicker(
              selectedCategory: event.category,
              onSelected: (val) {
                onEventChanged(event.copyWith(category: val));
              },
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.eventName,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: titleController,
              enabled: isEditMode,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (val) {
                onEventChanged(event.copyWith(title: val));
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.targetDate,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: isEditMode
                ? () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: event.targetDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      onEventChanged(
                        event.copyWith(
                          targetDate: DateTime(
                            date.year,
                            date.month,
                            date.day,
                            event.targetDate.hour,
                            event.targetDate.minute,
                          ),
                        ),
                      );
                    }
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.yMd().format(event.targetDate),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.time,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: isEditMode
                ? () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(event.targetDate),
                    );
                    if (time != null) {
                      onEventChanged(
                        event.copyWith(
                          targetDate: DateTime(
                            event.targetDate.year,
                            event.targetDate.month,
                            event.targetDate.day,
                            time.hour,
                            time.minute,
                          ),
                        ),
                      );
                    }
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.jm().format(event.targetDate),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 20,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
