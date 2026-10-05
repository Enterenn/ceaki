import 'package:flutter/services.dart';
import 'package:transparence/domain/library.dart';

Future<Library> loadAssetLibrary() {
  return rootBundle
      .loadString('assets/library/library.json')
      .then(Library.parse);
}
