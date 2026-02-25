import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'current_cat_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  static const _key = 'app_locale';

  @override
  Locale? build() {
    final saved = ref.read(sharedPreferencesProvider).getString(_key);
    if (saved == 'zh') return const Locale('zh');
    if (saved == 'en') return const Locale('en');
    return null; // follow system
  }

  void setLocale(Locale? locale) {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      prefs.remove(_key);
    } else {
      prefs.setString(_key, locale.languageCode);
    }
  }
}
