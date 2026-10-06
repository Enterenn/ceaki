import 'package:flutter/material.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/library_page.dart';
import 'package:transparence/ui/scanner/scanner_page.dart';
import 'package:transparence/ui/theme.dart';
import 'package:transparence/ui/you/you_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hideAppBar = _index == 0;
    return Scaffold(
      appBar: hideAppBar
          ? null
          : AppBar(
              title: Text(
                _index == 1 ? l10n.navLibrary : l10n.navYou,
              ),
            ),
      body: IndexedStack(
        index: _index,
        children: const [ScannerPage(), LibraryPage(), YouPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: l10n.navScanner,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(
              Icons.grid_view,
              color: TransparenceColors.ink,
            ),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(
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
