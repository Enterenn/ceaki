import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/library_page.dart';
import 'package:transparence/ui/scanner/scanner_page.dart';
import 'package:transparence/ui/theme.dart';
import 'package:transparence/ui/you/you_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final index = ref.watch(shellTabProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [ScannerPage(), LibraryPage(), YouPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (next) {
          ref.read(shellTabProvider.notifier).select(next);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.document_scanner_outlined),
            selectedIcon: const Icon(
              Icons.document_scanner,
              color: TransparenceColors.ink,
            ),
            label: l10n.navScanner,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(
              Icons.grid_view,
              color: TransparenceColors.ink,
            ),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(
              Icons.person,
              color: TransparenceColors.ink,
            ),
            label: l10n.navYou,
          ),
        ],
      ),
    );
  }
}
