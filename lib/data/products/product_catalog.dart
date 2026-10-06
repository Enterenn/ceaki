import 'package:http/http.dart' as http;
import 'package:transparence/data/products/book_record.dart';

const catalogUserAgent =
    'Ceaki/0.5.0 (https://github.com/Enterenn/ceaki)';

const catalogTimeout = Duration(seconds: 8);

/// Looks up a product by GTIN / ISBN in an external catalogue.
abstract class ProductCatalog {
  Future<BookRecord?> find(String gtin);

  void close() {}
}

/// Tries each source in order. Network errors skip to the next source;
/// if every source fails with a network error, the last error is rethrown.
class CascadingCatalog implements ProductCatalog {
  CascadingCatalog(this.sources);

  final List<ProductCatalog> sources;

  @override
  Future<BookRecord?> find(String gtin) async {
    Object? lastError;
    for (final source in sources) {
      try {
        final hit = await source.find(gtin);
        if (hit != null) return hit;
      } catch (error) {
        lastError = error;
      }
    }
    if (lastError != null) throw lastError;
    return null;
  }

  @override
  void close() {
    for (final source in sources) {
      source.close();
    }
  }
}

Map<String, String> catalogHeaders({String accept = 'application/json'}) => {
  'User-Agent': catalogUserAgent,
  'Accept': accept,
};

Future<http.Response> catalogGet(
  http.Client client,
  Uri uri, {
  String accept = 'application/json',
}) {
  return client
      .get(uri, headers: catalogHeaders(accept: accept))
      .timeout(catalogTimeout);
}
