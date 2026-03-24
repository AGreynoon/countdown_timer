import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../data/local_event_repository.dart';

final localEventRepositoryProvider = Provider<LocalEventRepository>((ref) {
  return LocalEventRepository();
});

class EventsNotifier extends AsyncNotifier<List<Event>> {
  late LocalEventRepository _repository;

  @override
  Future<List<Event>> build() async {
    _repository = ref.watch(localEventRepositoryProvider);
    return _repository.getEvents();
  }

  Future<void> addEvent(Event event) async {
    final previousState = state;
    state = AsyncValue.data([...previousState.value ?? [], event]);
    try {
      await _repository.insertEvent(event);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateEvent(Event event) async {
    final previousState = state;
    if (previousState.value == null) return;
    
    final updatedList = previousState.value!.map((e) => e.id == event.id ? event : e).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      await _repository.updateEvent(event);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteEvent(String id) async {
    final previousState = state;
    if (previousState.value == null) return;

    final updatedList = previousState.value!.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedList);

    try {
      await _repository.deleteEvent(id);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }
}

final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<Event>>(() {
  return EventsNotifier();
});
