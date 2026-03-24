import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../providers/ticker_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/color_picker.dart';
import '../widgets/event_card.dart'
    show CountdownDisplay; // Reuse the display from event_card

class EventDetails extends ConsumerStatefulWidget {
  final Event event;

  const EventDetails({super.key, required this.event});

  @override
  ConsumerState<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends ConsumerState<EventDetails> {
  late Event _currentEvent;
  late TextEditingController _titleController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
    _titleController = TextEditingController(text: _currentEvent.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    _currentEvent = _currentEvent.copyWith(title: _titleController.text);
    ref.read(eventsProvider.notifier).updateEvent(_currentEvent);
    setState(() {
      _isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopCountdownCard(event: _currentEvent),
              const SizedBox(height: 20),
              _MiddleConfigSection(
                event: _currentEvent,
                isEditMode: _isEditMode,
                titleController: _titleController,
                onEditModeToggled: () =>
                    setState(() => _isEditMode = !_isEditMode),
                onEventChanged: (e) => setState(() => _currentEvent = e),
              ),
              const SizedBox(height: 20),
              if (_isEditMode)
                _BottomDisplayUnitsSection(
                  event: _currentEvent,
                  onEventChanged: (e) => setState(() => _currentEvent = e),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditMode) {
            _saveEvent();
          } else {
            final localeName = Localizations.localeOf(context).languageCode;
            Share.share(
              '\${l10n.anticipating} \${_currentEvent.title} on \${AppHelpers.formatDate(_currentEvent.targetDate, localeName)}!',
            );
          }
        },
        backgroundColor: _isEditMode
            ? AppColors.tealPrimary
            : AppColors.orangePrimary,
        child: Icon(
          _isEditMode ? Icons.check : Icons.share,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TopCountdownCard extends ConsumerWidget {
  final Event event;

  const _TopCountdownCard({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = ref.watch(tickerProvider);
    final gradient = AppColors.getEventGradient(event.category);
    final isDarkTheme = AppColors.isDarkTheme(event.category);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.anticipating,
            style: const TextStyle(
              color: AppColors.textLightGrey,
              letterSpacing: 2,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title.isEmpty ? l10n.newEvent : event.title,
            style: TextStyle(
              color: isDarkTheme ? AppColors.textLight : AppColors.textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          CountdownDisplay(event: event, isDarkTheme: isDarkTheme, now: now),
        ],
      ),
    );
  }
}

class _MiddleConfigSection extends StatelessWidget {
  final Event event;
  final bool isEditMode;
  final TextEditingController titleController;
  final VoidCallback onEditModeToggled;
  final ValueChanged<Event> onEventChanged;

  const _MiddleConfigSection({
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
              const Expanded(
                child: Text(
                  'Event Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        l10n.editMode,
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

class _BottomDisplayUnitsSection extends StatelessWidget {
  final Event event;
  final ValueChanged<Event> onEventChanged;

  const _BottomDisplayUnitsSection({
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
