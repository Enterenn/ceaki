enum ScanChoice { putBack, bought }

final class ScanEntry {
  const ScanEntry({required this.choice, required this.signaledFortuneIds});

  final ScanChoice? choice;
  final List<String> signaledFortuneIds;
}

Map<String, int> notebookCounts(Iterable<ScanEntry> scans) {
  final counts = <String, int>{};
  for (final scan in scans) {
    if (scan.choice != ScanChoice.putBack) continue;
    for (final id in scan.signaledFortuneIds.toSet()) {
      counts.update(id, (value) => value + 1, ifAbsent: () => 1);
    }
  }
  return counts;
}
