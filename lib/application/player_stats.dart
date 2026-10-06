import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/player_rank.dart';

final playerRankProvider = StreamProvider.autoDispose<PlayerRank>((ref) {
  return ref.watch(appDatabaseProvider).watchScans().map((rows) {
    final esquives = rows.where((row) => row.choice == 'put_back').length;
    return playerRank(esquives: esquives, scans: rows.length);
  });
});
