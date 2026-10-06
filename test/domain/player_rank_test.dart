import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/player_rank.dart';

void main() {
  test('paliers are 1, 10 and 50 put-backs', () {
    expect(playerRank(esquives: 0, scans: 0).title, 'Curieux');
    expect(playerRank(esquives: 0, scans: 0).nextAt, 1);

    expect(playerRank(esquives: 1, scans: 3).title, 'Observateur');
    expect(playerRank(esquives: 1, scans: 3).nextAt, 10);

    expect(playerRank(esquives: 10, scans: 12).title, 'Attentif');
    expect(playerRank(esquives: 10, scans: 12).nextAt, 50);

    final max = playerRank(esquives: 50, scans: 60);
    expect(max.title, 'Fin connaisseur');
    expect(max.isMax, isTrue);
    expect(max.nextAt, isNull);
  });
}
