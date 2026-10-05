final class BookRecord {
  const BookRecord({
    required this.gtin,
    required this.title,
    required this.creator,
    required this.publishers,
    required this.source,
  });

  final String gtin;
  final String title;
  final String? creator;
  final List<String> publishers;
  final String source;
}
