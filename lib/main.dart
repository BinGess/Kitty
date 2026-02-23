import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bootstrap.dart';
import 'app.dart';
import 'core/providers/current_cat_provider.dart';

void main() async {
  await Bootstrap.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(Bootstrap.sharedPreferences),
      ],
      child: const MeowTalkApp(),
    ),
  );
}
