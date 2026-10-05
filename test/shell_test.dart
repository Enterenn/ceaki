import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/ui/transparence_app.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.memory();
  });

  testWidgets('the shell opens the library on the bollore fiche', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWith((ref) => database)],
        child: const TransparenceApp(),
      ),
    );
    try {
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
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
    }
  });
}
