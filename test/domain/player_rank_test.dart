import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/player_rank.dart';

void main() {
  test('paliers are 1, 10 and 50 put-backs with gesture labels', () {
    final zero = playerRank(esquives: 0, scans: 0);
    expect(zero.title, isEmpty);
    expect(zero.nextAt, 1);
    expect(zero.hasMilestone, isFalse);

    expect(playerRank(esquives: 1, scans: 3).title, 'Premier produit reposé');
    expect(playerRank(esquives: 1, scans: 3).nextAt, 10);

    expect(playerRank(esquives: 10, scans: 12).title, 'Dix produits reposés');
    expect(playerRank(esquives: 10, scans: 12).nextAt, 50);

    final max = playerRank(esquives: 50, scans: 60);
    expect(max.title, 'Cinquante produits reposés');
    expect(max.isMax, isTrue);
    expect(max.nextAt, isNull);
  });
}
