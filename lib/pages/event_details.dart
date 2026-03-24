import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:countdown_timer/l10n/app_localizations.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/top_countdown_card.dart';
import '../widgets/middle_config_section.dart';
import '../widgets/bottom_display_units_section.dart';

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
              TopCountdownCard(event: _currentEvent),
              const SizedBox(height: 20),
              MiddleConfigSection(
                event: _currentEvent,
                isEditMode: _isEditMode,
                titleController: _titleController,
                onEditModeToggled: () =>
                    setState(() => _isEditMode = !_isEditMode),
                onEventChanged: (e) => setState(() => _currentEvent = e),
              ),
              const SizedBox(height: 20),
              if (_isEditMode)
                BottomDisplayUnitsSection(
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


