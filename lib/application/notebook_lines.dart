import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/data/user/app_database.dart';
import 'package:transparence/data/user/stored_fields.dart';
import 'package:transparence/domain/notebook.dart';

final class NotebookLine {
  const NotebookLine({
    required this.fortuneId,
    required this.name,
    required this.count,
  });

  final String fortuneId;
  final String name;
  final int count;

  String get label {
    final products = count == 1 ? 'produit reposé' : 'produits reposés';
    return '$name — $count $products';
  }
}

List<NotebookLine> notebookLines(List<Scan> rows) {
  final entries = [
    for (final row in rows)
      if (row.choice == 'put_back')
        ScanEntry(
          choice: ScanChoice.putBack,
          signaledFortuneIds: splitFields(row.signaledFortuneIds),
        ),
  ];
  final counts = notebookCounts(entries);
  final names = <String, String>{};
  for (final row in rows) {
    final ids = splitFields(row.signaledFortuneIds);
    final labels = splitFields(row.signaledFortuneNames);
    for (var i = 0; i < ids.length && i < labels.length; i++) {
      names.putIfAbsent(ids[i], () => labels[i]);
    }
  }
  return [
    for (final entry in counts.entries)
      NotebookLine(
        fortuneId: entry.key,
        name: names[entry.key] ?? entry.key,
        count: entry.value,
      ),
  ]..sort((a, b) => a.name.compareTo(b.name));
}

final notebookProvider = StreamProvider.autoDispose<List<NotebookLine>>((ref) {
  return ref.watch(appDatabaseProvider).watchPutBacks().map(notebookLines);
});
