import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/library.dart';

void main() {
  final library = Library.parse(
    File('assets/library/library.json').readAsStringSync(),
  );

  test('grasset is fortune-red even when the scan alert would be muted', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6, 12),
          brandNames: const ['Bernard Grasset (Paris)'],
        ),
      ],
    );

    expect(entries, hasLength(1));
    expect(entries.single.brandId, 'brand.grasset');
    expect(entries.single.tone, ArchiveTone.fortune);
    expect(archiveToneLabel(entries.single.tone), archiveFortuneLabel);
  });

  test('asmodee is clear-green with no documented fortune', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6, 12),
          brandNames: const ['Asmodee'],
        ),
      ],
    );

    expect(entries.single.brandId, 'brand.asmodee');
    expect(entries.single.tone, ArchiveTone.clear);
    expect(archiveToneLabel(entries.single.tone), archiveClearLabel);
  });

  test('plon is fortune-red via kretinsky after the IMI sale', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6, 12),
          brandNames: const ['Plon (Paris)'],
        ),
      ],
    );

    expect(entries.single.brandId, 'brand.plon');
    expect(entries.single.companyName, 'Editis');
    expect(entries.single.tone, ArchiveTone.fortune);
    expect(archiveToneLabel(entries.single.tone), archiveFortuneLabel);
  });

  test('unmatched catalogue names hide the place parenthetical', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6, 12),
          brandNames: const ['Crunchyroll (Paris)', 'Gallimard Jeunesse (Paris)'],
        ),
      ],
    );

    expect(entries.map((entry) => entry.name).toList(), [
      'Crunchyroll',
      'Gallimard Jeunesse',
    ]);
    expect(entries.every((entry) => entry.tone == ArchiveTone.unknown), isTrue);
  });

  test('filterArchive filters by tone and company name', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6),
          brandNames: const ['Grasset', 'Asmodee', 'Crunchyroll'],
        ),
      ],
    );

    expect(filterArchive(entries, tone: ArchiveTone.fortune), hasLength(1));
    expect(filterArchive(entries, tone: ArchiveTone.clear), hasLength(1));
    expect(filterArchive(entries, tone: ArchiveTone.unknown), hasLength(1));
    expect(
      filterArchive(entries, query: 'lagardere').single.brandId,
      'brand.grasset',
    );
  });

  test('brands are deduplicated and ordered by last seen', () {
    final entries = buildArchive(
      library: library,
      scans: [
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 5),
          brandNames: const ['Grasset'],
        ),
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 6),
          brandNames: const ['Asmodee', 'Grasset'],
        ),
        ScanBrandInput(
          scannedAt: DateTime.utc(2026, 10, 4),
          brandNames: const ['Marque inconnue XYZ'],
        ),
      ],
    );

    expect(entries.map((entry) => entry.brandId ?? entry.name).toList(), [
      'brand.asmodee',
      'brand.grasset',
      'Marque inconnue XYZ',
    ]);
    expect(entries[2].tone, ArchiveTone.unknown);
  });
}
