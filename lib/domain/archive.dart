import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/resolve.dart';

/// Archive label — independent from scan alert exclusions.
enum ArchiveTone {
  /// Linked to at least one documented fortune (red).
  fortune,

  /// Brand resolved, no fortune on the active chain (green).
  clear,

  /// Unmatched brand or undocumented current owner (neutral).
  unknown,
}

const archiveFortuneLabel = 'Rattaché à une grande fortune';
const archiveClearLabel = 'Aucune grande fortune documentée';
const archiveUnknownLabel = 'Rattachement non documenté';

String archiveToneLabel(ArchiveTone tone) {
  return switch (tone) {
    ArchiveTone.fortune => archiveFortuneLabel,
    ArchiveTone.clear => archiveClearLabel,
    ArchiveTone.unknown => archiveUnknownLabel,
  };
}

/// Minimal scan input for archive building (keeps domain free of Drift).
final class ScanBrandInput {
  const ScanBrandInput({
    required this.scannedAt,
    required this.brandNames,
    this.chosenBrandIds = const {},
  });

  final DateTime scannedAt;
  final List<String> brandNames;
  final Map<String, String> chosenBrandIds;
}

final class ArchiveEntry {
  const ArchiveEntry({
    required this.key,
    required this.name,
    required this.tone,
    required this.lastSeenAt,
    this.brandId,
  });

  /// Stable key: brand id, or `name:<normalized>` for unmatched.
  final String key;
  final String? brandId;
  final String name;
  final ArchiveTone tone;
  final DateTime lastSeenAt;
}

ArchiveTone archiveToneFor(CompanyChain chain) {
  if (chain.fortuneIds.isNotEmpty) return ArchiveTone.fortune;
  if (!chain.hasActiveOwner) return ArchiveTone.unknown;
  return ArchiveTone.clear;
}

/// Builds a deduplicated archive from scans, newest activity first.
List<ArchiveEntry> buildArchive({
  required Library library,
  required Iterable<ScanBrandInput> scans,
}) {
  final byKey = <String, ArchiveEntry>{};

  for (final scan in scans) {
    if (scan.brandNames.isEmpty) {
      continue;
    }
    final resolved = resolveBrandNames(
      library,
      scan.brandNames,
      chosenIds: scan.chosenBrandIds,
    );

    for (final chain in resolved.chains) {
      _put(
        byKey,
        ArchiveEntry(
          key: chain.brand.id,
          brandId: chain.brand.id,
          name: chain.brand.name,
          tone: archiveToneFor(chain.chain),
          lastSeenAt: scan.scannedAt,
        ),
      );
    }

    for (final pending in [...resolved.unmatched, ...resolved.choices]) {
      _put(
        byKey,
        ArchiveEntry(
          key: 'name:${pending.key}',
          name: pending.rawName,
          tone: ArchiveTone.unknown,
          lastSeenAt: scan.scannedAt,
        ),
      );
    }
  }

  final entries = byKey.values.toList()
    ..sort((a, b) {
      final byDate = b.lastSeenAt.compareTo(a.lastSeenAt);
      if (byDate != 0) return byDate;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  return entries;
}

void _put(Map<String, ArchiveEntry> byKey, ArchiveEntry next) {
  final previous = byKey[next.key];
  if (previous == null) {
    byKey[next.key] = next;
    return;
  }
  byKey[next.key] = ArchiveEntry(
    key: next.key,
    brandId: next.brandId ?? previous.brandId,
    name: next.brandId != null ? next.name : previous.name,
    tone: next.tone,
    lastSeenAt: next.lastSeenAt.isAfter(previous.lastSeenAt)
        ? next.lastSeenAt
        : previous.lastSeenAt,
  );
}
