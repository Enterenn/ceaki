import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/library/library_page.dart';
import 'package:transparence/ui/scanner/scanner_page.dart';
import 'package:transparence/ui/theme.dart';
import 'package:transparence/ui/you/you_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late final PageController _pages;

  @override
  void initState() {
    super.initState();
    _pages = PageController(initialPage: ref.read(shellTabProvider));
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final index = ref.watch(shellTabProvider);

    ref.listen(shellTabProvider, (prev, next) {
      if (prev == next) return;
      if (!_pages.hasClients) return;
      if (_pages.page?.round() == next) return;
      _pages.animateToPage(
        next,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });

    return Scaffold(
      body: PageView(
        controller: _pages,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (next) {
          if (ref.read(shellTabProvider) != next) {
            ref.read(shellTabProvider.notifier).select(next);
          }
        },
        children: const [
          _KeepAlive(child: ScannerPage()),
          _KeepAlive(child: LibraryPage()),
          _KeepAlive(child: YouPage()),
        ],
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

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
