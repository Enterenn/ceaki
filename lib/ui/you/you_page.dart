import 'package:flutter/material.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/library_view.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LibraryView(
      builder: (context, library) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.aboutPurpose),
            const SizedBox(height: 12),
            Text(l10n.aboutLimit),
            const SizedBox(height: 24),
            Text(
              l10n.libraryVersionLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('${library.version} · ${library.updatedOn}'),
          ],
        );
      },
    );
  }
}
