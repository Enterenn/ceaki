import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/domain/notebook.dart';
import 'package:transparence/domain/wording.dart';

void main() {
  test('only a put-back of a signaled fortune increments the notebook', () {
    final counts = notebookCounts(const [
      ScanEntry(
        choice: ScanChoice.putBack,
        signaledFortuneIds: ['fortune.bollore'],
      ),
      ScanEntry(
        choice: ScanChoice.bought,
        signaledFortuneIds: ['fortune.bollore'],
      ),
      ScanEntry(choice: null, signaledFortuneIds: ['fortune.bollore']),
      ScanEntry(
        choice: ScanChoice.putBack,
        signaledFortuneIds: ['fortune.other'],
      ),
    ]);

    expect(counts['fortune.bollore'], 1);
    expect(counts['fortune.other'], 1);
  });

  test('the put-back line names the fortune and invents no price', () {
    final line = putBackLine(const ['famille Bolloré']);
    expect(line, 'Reposé. famille Bolloré — celui-ci reste en rayon.');
    expect(line.contains('€'), isFalse);
    expect(line.toLowerCase().contains('euro'), isFalse);
  });
}
