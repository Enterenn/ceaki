import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/brand_name.dart';

final scanHistoryProvider = StreamProvider.autoDispose<List<Scan>>((ref) {
  return ref.watch(appDatabaseProvider).watchScans();
});

final productCacheCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(appDatabaseProvider).productCacheCount();
});

List<Scan> filterScanHistory(List<Scan> scans, String query) {
  final needle = normalizeBrandName(query);
  if (needle.isEmpty) return scans;
  return [
    for (final scan in scans)
      if (_matches(scan, needle)) scan,
  ];
}

bool _matches(Scan scan, String needle) {
  final haystacks = [
    scan.gtin,
    scan.productName ?? '',
    scan.creator ?? '',
    ...splitFields(scan.brandNames),
  ];
  for (final value in haystacks) {
    if (normalizeBrandName(value).contains(needle)) return true;
  }
  return false;
}

String historyTitle(Scan scan) {
  final title = scan.productName?.trim();
  if (title != null && title.isNotEmpty) return title;
  final brands = splitFields(scan.brandNames).map(displayBrandName).where(
    (name) => name.isNotEmpty,
  );
  if (brands.isNotEmpty) return brands.join(', ');
  return scan.gtin;
}

String? historySubtitle(Scan scan) {
  final brands = splitFields(scan.brandNames).map(displayBrandName).where(
    (name) => name.isNotEmpty,
  );
  final brandLabel = brands.isEmpty ? null : brands.join(', ');
  final title = scan.productName?.trim();
  if (title != null && title.isNotEmpty) return brandLabel;
  return null;
}
