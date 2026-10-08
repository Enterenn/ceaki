import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/result/fortune_banner.dart';

void main() {
  testWidgets('the banner leads with punch and hides detail', (tester) async {
    const banner = FortuneBanner(
      fortuneId: 'fortune.bollore',
      title: 'famille Bolloré',
      punch: 'Acheter ça, c’est mettre des sous dans la poche de la famille Bolloré.',
      detail: 'Grasset y est rattaché. Bolloré SE détient 30,4 % du capital.',
    );

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: FortuneBannerView(banner: banner)),
      ),
    );

    expect(find.text('GRANDE FORTUNE'), findsOneWidget);
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
