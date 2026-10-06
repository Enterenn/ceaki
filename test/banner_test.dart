import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/ui/result/fortune_banner.dart';

void main() {
  testWidgets('the banner says grande fortune in text', (tester) async {
    const banner = FortuneBanner(
      fortuneId: 'fortune.bollore',
      title: 'famille Bolloré',
      body: 'Grasset y est rattaché.',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FortuneBannerView(banner: banner)),
      ),
    );

    expect(find.text('GRANDE FORTUNE'), findsOneWidget);
    expect(find.text('famille Bolloré'), findsOneWidget);
    expect(find.text('Grasset y est rattaché.'), findsOneWidget);
  });
}
