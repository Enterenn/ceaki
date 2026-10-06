import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/archive.dart';

final archiveBrandsProvider = Provider<AsyncValue<List<ArchiveEntry>>>((ref) {
  final library = ref.watch(capitalLibraryProvider);
  final scans = ref.watch(_scansProvider);
  if (library.isLoading || scans.isLoading) {
    return const AsyncLoading();
  }
  if (library.hasError) {
    return AsyncError(library.error!, library.stackTrace!);
  }
  if (scans.hasError) {
    return AsyncError(scans.error!, scans.stackTrace!);
  }
  final entries = buildArchive(
    library: library.requireValue,
    scans: [
      for (final scan in scans.requireValue)
        ScanBrandInput(
          scannedAt: scan.scannedAt,
          brandNames: splitFields(scan.brandNames),
          chosenBrandIds: decodeChoices(scan.chosenBrandIds),
        ),
    ],
  );
  return AsyncData(entries);
});

final _scansProvider = StreamProvider((ref) {
  return ref.watch(appDatabaseProvider).watchScans();
});
