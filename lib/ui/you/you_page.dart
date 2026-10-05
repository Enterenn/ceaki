import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/notebook_lines.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/library_view.dart';

class YouPage extends ConsumerWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notebook = ref.watch(notebookProvider);
    final theme = Theme.of(context);
    return LibraryView(
      builder: (context, library) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.notebookTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            notebook.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => Text(l10n.libraryError),
              data: (lines) {
                if (lines.isEmpty) return Text(l10n.notebookEmpty);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final line in lines) Text(line.label)],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.aboutPurpose),
            const SizedBox(height: 12),
            Text(l10n.aboutLimit),
            const SizedBox(height: 24),
            Text(l10n.libraryVersionLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${library.version} · ${library.updatedOn}'),
          ],
        );
      },
    );
  }
}
