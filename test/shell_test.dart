import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/ui/transparence_app.dart';

void main() {
  testWidgets('the shell opens the library on the bollore fiche', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TransparenceApp()));
    await tester.pumpAndSettle();

    expect(find.text('Scanner'), findsWidgets);
    await tester.tap(find.text('Bibliothèque').last);
    await tester.pumpAndSettle();

    expect(find.text('famille Bolloré'), findsOneWidget);
    await tester.tap(find.text('famille Bolloré'));
    await tester.pumpAndSettle();

    expect(find.text('Grasset'), findsOneWidget);
    expect(find.text('Fayard'), findsOneWidget);
    expect(find.text('Editis'), findsNothing);
    expect(find.text('Alerte active'), findsOneWidget);
  });
}
