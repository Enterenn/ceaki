import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/player_rank.dart';

void main() {
  test('ranks climb with esquives', () {
    expect(playerRank(esquives: 0, scans: 0).title, 'Curieux');
    expect(playerRank(esquives: 1, scans: 2).title, 'Observateur');
    expect(playerRank(esquives: 3, scans: 4).title, 'Attentif');
    expect(playerRank(esquives: 6, scans: 8).level, 3);
    expect(playerRank(esquives: 15, scans: 20).isMax, isTrue);
  });

  test('progress fills toward the next floor', () {
    final rank = playerRank(esquives: 4, scans: 5);
    expect(rank.nextAt, 6);
    expect(rank.xpIntoLevel, 1);
    expect(rank.xpForNext, 3);
    expect(rank.progress, closeTo(1 / 3, 0.001));
  });
}
