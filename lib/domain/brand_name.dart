const _legalForms = {'sa', 'sas', 'sarl', 'se', 'sasu', 'ltd', 'inc', 'gmbh'};

const _editorialPrefixes = {'editions', 'edition', 'ed'};

const _folded = <int, String>{
  0x00E0: 'a',
  0x00E1: 'a',
  0x00E2: 'a',
  0x00E3: 'a',
  0x00E4: 'a',
  0x00E5: 'a',
  0x00E7: 'c',
  0x00E8: 'e',
  0x00E9: 'e',
  0x00EA: 'e',
  0x00EB: 'e',
  0x00EC: 'i',
  0x00ED: 'i',
  0x00EE: 'i',
  0x00EF: 'i',
  0x00F1: 'n',
  0x00F2: 'o',
  0x00F3: 'o',
  0x00F4: 'o',
  0x00F5: 'o',
  0x00F6: 'o',
  0x00F9: 'u',
  0x00FA: 'u',
  0x00FB: 'u',
  0x00FC: 'u',
  0x00FD: 'y',
  0x00FF: 'y',
  0x0153: 'oe',
  0x00E6: 'ae',
};

/// Removes catalogue parentheticals for display: "Gallimard Jeunesse (Paris)" → "Gallimard Jeunesse".
String displayBrandName(String value) {
  return value
      .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String normalizeBrandName(String value) {
  final cleaned = displayBrandName(value);
  final folded = StringBuffer();
  for (final rune in cleaned.toLowerCase().runes) {
    final mapped = _folded[rune];
    if (mapped != null) {
      folded.write(mapped);
    } else if (rune < 0x0300 || rune > 0x036F) {
      folded.writeCharCode(rune);
    }
  }

  final tokens = folded
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList();

  while (tokens.isNotEmpty &&
      (_legalForms.contains(tokens.first) ||
          _legalForms.contains(tokens.last))) {
    if (_legalForms.contains(tokens.first)) tokens.removeAt(0);
    if (tokens.isNotEmpty && _legalForms.contains(tokens.last)) {
      tokens.removeLast();
    }
  }
  while (tokens.isNotEmpty && _editorialPrefixes.contains(tokens.first)) {
    tokens.removeAt(0);
  }
  return tokens.join(' ');
}
