import 'package:flutter/material.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/shell.dart';

class TransparenceApp extends StatelessWidget {
  const TransparenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transparence',
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B3A4B)),
      ),
      home: const AppShell(),
    );
  }
}
