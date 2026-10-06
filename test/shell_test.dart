import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/transparence_app.dart';

final _library = Library.parse(
  File('assets/library/library.json').readAsStringSync(),
);

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

      expect(find.text('Scan'), findsWidgets);
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

  testWidgets('the fortune fiche removes and restores the alert', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) => database),
          capitalLibraryProvider.overrideWith((ref) async => _library),
        ],
        child: const TransparenceApp(),
      ),
    );
    try {
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bibliothèque').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('famille Bolloré'));
      await tester.pumpAndSettle();

      expect(find.text('Alerte active'), findsOneWidget);
      await tester.tap(find.text('Retirer l’alerte'));
      await tester.pumpAndSettle();

      expect(find.text('Alerte retirée'), findsOneWidget);
      expect(find.text('Grasset'), findsOneWidget);
      await tester.tap(find.text('Rétablir l’alerte'));
      await tester.pumpAndSettle();
      expect(find.text('Alerte active'), findsOneWidget);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
    }
  });
}
