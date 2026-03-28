import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class LocaleNotifier extends Notifier<Locale> {
  static const _localeKey = 'selected_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedCode = prefs.getString(_localeKey);
    return Locale(savedCode ?? 'ar');
  }

  void toggleLocale() {
    final prefs = ref.read(sharedPreferencesProvider);
    final newLocale = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    prefs.setString(_localeKey, newLocale.languageCode);
    state = newLocale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
