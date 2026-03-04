import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_cat_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../domain/cat_personality_profile.dart';

final currentCatPersonalityProfileProvider = Provider<CatPersonalityProfile?>((
  ref,
) {
  final cat = ref.watch(currentCatProvider);
  if (cat == null) return null;
  final selectedLocale = ref.watch(localeProvider);
  final languageCode =
      selectedLocale?.languageCode ??
      PlatformDispatcher.instance.locale.languageCode;
  return CatPersonalityProfile.fromCat(cat, languageCode: languageCode);
});
