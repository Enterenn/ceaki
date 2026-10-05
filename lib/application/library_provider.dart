import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/data/library/asset_library.dart';
import 'package:transparence/domain/library.dart';

final capitalLibraryProvider = FutureProvider<Library>((ref) {
  return loadAssetLibrary();
});
