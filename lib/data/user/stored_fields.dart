const fieldSep = '\u001f';
const _pairSep = '\u001e';

String joinFields(List<String> values) => values.join(fieldSep);

List<String> splitFields(String value) {
  if (value.isEmpty) return const [];
  return value.split(fieldSep);
}

String encodeChoices(Map<String, String> choices) {
  return [
    for (final entry in choices.entries) '${entry.key}$_pairSep${entry.value}',
  ].join(fieldSep);
}

Map<String, String> decodeChoices(String value) {
  if (value.isEmpty) return const {};
  final choices = <String, String>{};
  for (final part in value.split(fieldSep)) {
    final cut = part.indexOf(_pairSep);
    if (cut <= 0) continue;
    choices[part.substring(0, cut)] = part.substring(cut + 1);
  }
  return choices;
}
