import 'package:flutter/material.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/shell.dart';
import 'package:transparence/ui/theme.dart';

class TransparenceApp extends StatelessWidget {
  const TransparenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Céaki',
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: transparenceTheme(),
      home: const AppShell(),
    );
  }
}
