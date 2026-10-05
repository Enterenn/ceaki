enum GtinReject { empty, unrecognized, invalidCheck }

enum CodeCategory { livre, autre, inconnue }

final class Gtin {
  const Gtin(this.value, this.codeCategory);

  final String value;
  final CodeCategory codeCategory;
}

sealed class GtinRead {
  const GtinRead();
}

final class GtinAccepted extends GtinRead {
  const GtinAccepted(this.gtin);

  final Gtin gtin;
}

final class GtinRejected extends GtinRead {
  const GtinRejected(this.reason);

  final GtinReject reason;
}

CodeCategory categoryOf(String gtin) {
  if (gtin.length != 13) return CodeCategory.inconnue;
  if (gtin.startsWith('978')) return CodeCategory.livre;
  if (gtin.startsWith('9790')) return CodeCategory.autre;
  if (gtin.startsWith('979')) return CodeCategory.livre;
  return CodeCategory.inconnue;
}

GtinRead readGtin(String input) {
  final withoutLabel = input.trim().replaceFirst(
    RegExp(r'^isbn(?:[\s:-]*(?:10|13))?[\s:]*', caseSensitive: false),
    '',
  );
  final compact = withoutLabel.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  if (compact.isEmpty) return const GtinRejected(GtinReject.empty);

  if (RegExp(r'^\d{9}[\dX]$').hasMatch(compact)) {
    if (!_validIsbn10(compact)) {
      return const GtinRejected(GtinReject.invalidCheck);
    }
    final gtin = _isbn10ToGtin13(compact);
    return GtinAccepted(Gtin(gtin, categoryOf(gtin)));
  }

  if (!RegExp(r'^\d+$').hasMatch(compact) ||
      (compact.length != 8 && compact.length != 12 && compact.length != 13)) {
    return const GtinRejected(GtinReject.unrecognized);
  }
  if (!_validGtin(compact)) {
    return const GtinRejected(GtinReject.invalidCheck);
  }
  if (compact.length == 12) {
    final gtin = '0$compact';
    return GtinAccepted(Gtin(gtin, categoryOf(gtin)));
  }
  return GtinAccepted(Gtin(compact, categoryOf(compact)));
}

bool _validIsbn10(String ten) {
  var sum = 0;
  for (var i = 0; i < 10; i++) {
    final char = ten[i];
    final digit = i == 9 && char == 'X' ? 10 : int.tryParse(char);
    if (digit == null) return false;
    sum += digit * (10 - i);
  }
  return sum % 11 == 0;
}

String _isbn10ToGtin13(String ten) {
  final body = '978${ten.substring(0, 9)}';
  return '$body${_checkDigit(body)}';
}

bool _validGtin(String digits) {
  final expected = int.parse(digits[digits.length - 1]);
  return _checkDigit(digits.substring(0, digits.length - 1)) == expected;
}

int _checkDigit(String withoutCheck) {
  var sum = 0;
  var weight = 3;
  for (var i = withoutCheck.length - 1; i >= 0; i--) {
    sum += int.parse(withoutCheck[i]) * weight;
    weight = weight == 3 ? 1 : 3;
  }
  return (10 - (sum % 10)) % 10;
}
