import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Disk cache for remote brand logos — no analytics, no cookies.
final logoCacheProvider = Provider<LogoCache>((ref) => LogoCache());

class LogoCache {
  LogoCache({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final _memory = <String, File>{};

  Future<File?> fileFor(String url) async {
    final cached = _memory[url];
    if (cached != null && await cached.exists()) return cached;

    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return null;
    }

    final dir = Directory(
      '${(await getApplicationSupportDirectory()).path}/logos',
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/${_safeName(url)}');
    if (await file.exists()) {
      _memory[url] = file;
      return file;
    }

    try {
      final response = await _client
          .get(uri, headers: const {'User-Agent': 'Ceaki/0.3 (logo-cache)'})
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      await file.writeAsBytes(response.bodyBytes, flush: true);
      _memory[url] = file;
      return file;
    } catch (_) {
      return null;
    }
  }

  String _safeName(String url) {
    return url.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }
}
