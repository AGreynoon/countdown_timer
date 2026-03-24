import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/color_picker.dart';

class AddEvent extends ConsumerStatefulWidget {
  const AddEvent({super.key});

  @override
  ConsumerState<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends ConsumerState<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _targetDate = DateTime.now().add(const Duration(days: 1));
  String _selectedCategory = 'Orange';
  Map<String, bool> _displayUnits = {
    "Years": false,
    "Months": false,
    "Weeks": false,
    "Days": true,
    "Hours": true,
    "Minutes": true,
    "Seconds": true,
  };

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createEvent() {
    if (_titleController.text.trim().isEmpty) return;

    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      targetDate: _targetDate,
      category: _selectedCategory,
      displayUnits: _displayUnits,
    );

    ref.read(eventsProvider.notifier).addEvent(newEvent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newEvent)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.eventName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.targetDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _targetDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _targetDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _targetDate.hour,
                            _targetDate.minute,
                          );
                        });
                      }
                    },
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
                              DateFormat.yMd().format(_targetDate),
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_targetDate),
                      );
                      if (time != null) {
                        setState(() {
                          _targetDate = DateTime(
                            _targetDate.year,
                            _targetDate.month,
                            _targetDate.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
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
                              DateFormat.jm().format(_targetDate),
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
                  const SizedBox(height: 20),
                  Text(
                    l10n.themeColor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ColorPicker(
                    selectedCategory: _selectedCategory,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    // Quick localization mapping
                    String unitLocal = unit;
                    if (unit == 'Years') unitLocal = l10n.years;
                    if (unit == 'Months') unitLocal = l10n.months;
                    if (unit == 'Weeks') unitLocal = l10n.weeks;
                    if (unit == 'Days') unitLocal = l10n.days;
                    if (unit == 'Hours') unitLocal = l10n.hours;
                    if (unit == 'Minutes') unitLocal = l10n.minutes;
                    if (unit == 'Seconds') unitLocal = l10n.seconds;

                    return SwitchListTile(
                      title: Text(unitLocal),
                      value: _displayUnits[unit] ?? false,
                      activeThumbColor: AppColors.tealPrimary,
                      onChanged: (val) {
                        setState(() {
                          _displayUnits = Map.from(_displayUnits)..[unit] = val;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEvent,
        backgroundColor: AppColors.tealPrimary,
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
