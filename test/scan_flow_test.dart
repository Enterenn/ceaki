import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/products/bnf_catalog.dart';
import 'package:transparence/data/products/book_record.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/scanner/scanner_page.dart';
import 'package:transparence/ui/transparence_app.dart';

final _library = Library.parse(
  File('assets/library/library.json').readAsStringSync(),
);

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.memory();
  });

  testWidgets('a grasset isbn can be put back into the notebook', (
    tester,
  ) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '978-2-246-80723-0');
      await tester.pumpAndSettle();

      expect(find.text('GRANDE FORTUNE'), findsOneWidget);
      expect(find.textContaining('Grasset y est rattaché'), findsOneWidget);
      expect(find.text("La traversée de l'été : roman"), findsOneWidget);

      await tester.tap(find.text('Je le repose'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Reposé.'), findsOneWidget);
      expect(find.text('Je le repose'), findsNothing);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vous').last);
      await tester.pumpAndSettle();

      expect(find.text('Reposés'), findsOneWidget);
      expect(find.text('famille Bolloré — 1'), findsOneWidget);
    } finally {
      await _closeApp(tester, database);
    }
  });

  testWidgets('a bad check digit stays on the scanner', (tester) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '9782246807231');
      await tester.pump();

      expect(find.text('Le chiffre de contrôle est faux.'), findsOneWidget);
      expect(find.text('GRANDE FORTUNE'), findsNothing);
    } finally {
      await _closeApp(tester, database);
    }
  });

  testWidgets('a plon isbn shows the undocumented owner', (tester) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '978-2-259-19540-9');
      await tester.pumpAndSettle();

      expect(find.text('Propriétaire actuel non documenté'), findsOneWidget);
      expect(find.text('Vivendi SE'), findsOneWidget);
      expect(find.text('Plus belle sera la vie : roman'), findsOneWidget);
      expect(find.text('GRANDE FORTUNE'), findsNothing);
      expect(find.text('Je le repose'), findsNothing);
    } finally {
      await _closeApp(tester, database);
    }
  });

  testWidgets('home keeps the camera and code field off until asked', (
    tester,
  ) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pump();
      expect(find.text('Scannez'), findsOneWidget);
      expect(find.text('Code illisible ?'), findsOneWidget);
      expect(find.byKey(ScannerPage.codeField), findsNothing);
      expect(find.text('Autoriser la caméra'), findsNothing);
      expect(find.byType(MobileScanner), findsNothing);
    } finally {
      await _closeApp(tester, database);
    }
  });

  testWidgets('a dobble barcode shows who owns the brand', (tester) async {
    await tester.pumpWidget(_app(database));
    try {
      await tester.pumpAndSettle();
      await _submitCode(tester, '3558380078180');
      await tester.pumpAndSettle();

      expect(find.text('Dobble classique'), findsOneWidget);
      expect(find.text('Jeu de société'), findsOneWidget);
      expect(find.text('Lars Wingefors AB'), findsWidgets);
      expect(find.text('Savvy Gaming Group'), findsWidgets);
      expect(find.textContaining('16,9 % du capital'), findsOneWidget);
      expect(find.text('Aucune grande fortune documentée'), findsOneWidget);
      expect(find.text('GRANDE FORTUNE'), findsNothing);
      expect(find.text('Je le repose'), findsNothing);
    } finally {
      await _closeApp(tester, database);
    }
  });
}

Future<void> _openManual(WidgetTester tester) async {
  final toggle = find.byKey(ScannerPage.manualToggle);
  await tester.ensureVisible(toggle);
  await tester.tap(toggle);
  await tester.pump();
  expect(find.byKey(ScannerPage.codeField), findsOneWidget);
}

Future<void> _submitCode(WidgetTester tester, String code) async {
  await _openManual(tester);
  await tester.enterText(find.byKey(ScannerPage.codeField), code);
  final submit = find.byKey(ScannerPage.submitButton);
  await tester.ensureVisible(submit);
  await tester.tap(submit);
}

Widget _app(AppDatabase database) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      bookCatalogProvider.overrideWith((ref) => _OfflineCatalog()),
      capitalLibraryProvider.overrideWith((ref) async => _library),
    ],
    child: const TransparenceApp(),
  );
}

Future<void> _closeApp(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await database.close();
}

class _OfflineCatalog implements BookCatalog {
  @override
  Future<BookRecord?> find(String gtin) {
    throw StateError('offline');
  }
}
