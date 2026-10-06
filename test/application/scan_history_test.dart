import 'package:flutter_test/flutter_test.dart';
import 'package:transparence/application/scan_history.dart';
import 'package:transparence/data/user/app_database.dart';

void main() {
  test('history search matches title brand and gtin', () {
    final scans = [
      Scan(
        id: 1,
        scannedAt: DateTime.utc(2026, 10, 6),
        gtin: '9782246807230',
        productName: "La traversée de l'été",
        creator: 'Capote',
        category: 'livre',
        brandNames: 'Bernard Grasset',
        signaledFortuneIds: '',
        signaledFortuneNames: '',
        libraryVersion: 'test',
        choice: null,
        issue: 'resolved',
        chosenBrandIds: '',
      ),
      Scan(
        id: 2,
        scannedAt: DateTime.utc(2026, 10, 5),
        gtin: '3017620422003',
        productName: 'Nutella',
        creator: null,
        category: 'alimentaire',
        brandNames: 'Ferrero',
        signaledFortuneIds: '',
        signaledFortuneNames: '',
        libraryVersion: 'test',
        choice: null,
        issue: 'resolved',
        chosenBrandIds: '',
      ),
    ];

    expect(filterScanHistory(scans, 'grasset').single.id, 1);
    expect(filterScanHistory(scans, '30176').single.id, 2);
    expect(filterScanHistory(scans, 'xyz'), isEmpty);
    expect(historyTitle(scans.first), "La traversée de l'été");
  });
}
