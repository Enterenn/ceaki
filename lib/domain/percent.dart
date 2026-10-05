final class Percent {
  const Percent._(this.raw);

  final String raw;

  static Percent parse(Object? value, String path) {
    if (value is! String || !_pattern.hasMatch(value) || !_inRange(value)) {
      throw FormatException(path);
    }
    return Percent._(value);
  }

  String get french => raw.replaceAll('.', ',');

  static final _pattern = RegExp(r'^\d{1,3}(\.\d+)?$');

  static bool _inRange(String value) {
    final parts = value.split('.');
    final whole = int.parse(parts[0]);
    if (whole > 100) return false;
    if (whole < 100 || parts.length == 1) return true;
    return int.parse(parts[1]) == 0;
  }
}
