import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/game/esquive_burst.dart';

void main() {
  testWidgets('esquive burst enters with badge and line', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EsquiveBurst(
            line: "Reposé. famille Bolloré n'aura pas celui-ci.",
            rankTitle: 'Première esquive',
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('ESQUIVE'), findsOneWidget);
    expect(
      find.text("Reposé. famille Bolloré n'aura pas celui-ci."),
      findsOneWidget,
    );
    expect(find.text('Première esquive'), findsOneWidget);
  });
}
