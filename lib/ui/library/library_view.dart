import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({required this.builder, super.key});

  final Widget Function(BuildContext context, Library library) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(capitalLibraryProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              Center(child: Text(AppLocalizations.of(context).libraryError)),
          data: (library) => builder(context, library),
        );
  }
}
