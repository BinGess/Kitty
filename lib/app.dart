import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class MeowTalkApp extends ConsumerWidget {
  const MeowTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'MeowTalk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh'), Locale('en'), Locale('ja')],
      locale: locale,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (locale != null) return locale;
        if (deviceLocale?.languageCode == 'en') return const Locale('en');
        if (deviceLocale?.languageCode == 'ja') return const Locale('ja');
        return const Locale('zh');
      },
    );
  }
}
