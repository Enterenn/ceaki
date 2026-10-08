import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/result/fortune_banner.dart';

void main() {
  final library = Library(
    version: '1.0',
    updatedOn: '2024-01-01',
    sectors: [],
    sources: [],
    fortunes: [],
    companies: [],
    brands: [],
    ownerships: [],
  );
  
  testWidgets('the banner leads with punch and hides detail', (tester) async {
    const banner = FortuneBanner(
      fortuneId: 'fortune.bollore',
      title: 'famille Bollore',
      punch: "Acheter ca, c'est mettre des sous dans la poche de la famille Bollore.",
      detail: 'Grasset y est rattache. Bollore SE detient 30,4 % du capital.',
      verdict: 'Sous controle de famille Bollore',
      sources: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: FortuneBannerView(banner: banner, library: library)),
      ),
    );

    expect(find.text('Sous controle de famille Bollore'), findsOneWidget);
    expect(find.text('famille Bolloré'), findsOneWidget);
    expect(
      find.text(
        'Acheter ça, c’est mettre des sous dans la poche de la famille Bolloré.',
      ),
      findsOneWidget,
    );
    expect(find.text('Pourquoi ?'), findsOneWidget);
    expect(find.textContaining('Grasset y est rattaché'), findsNothing);

    await tester.tap(find.text('Pourquoi ?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Grasset y est rattaché'), findsOneWidget);
    expect(find.text('Masquer le détail'), findsOneWidget);
  });
}
