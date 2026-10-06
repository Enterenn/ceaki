import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/library/company_page.dart';
import 'package:transparence/ui/library/fiche_chrome.dart';
import 'package:transparence/ui/library/library_view.dart';
import 'package:transparence/ui/library/link_tile.dart';
import 'package:transparence/ui/theme.dart';

class FortunePage extends ConsumerWidget {
  const FortunePage({required this.fortuneId, super.key});

  final String fortuneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excluded =
        ref.watch(excludedFortuneIdsProvider).asData?.value ?? const {};
    return LibraryView(
      builder: (context, library) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        final fortune = library.fortuneOrNull(fortuneId);
        if (fortune == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.missingEntry)),
          );
        }
        final off = excluded.contains(fortune.id);
        final portfolio = descendFromFortune(library, fortune.id);
        final active = library.holdingsOf(
          OwnerKind.fortune,
          fortune.id,
          LinkStatus.active,
        );
        final historical = library.holdingsOf(
          OwnerKind.fortune,
          fortune.id,
          LinkStatus.historical,
        );
        return Scaffold(
          appBar: AppBar(title: Text(fortune.name)),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 12),
              FichePanel(
                accent: off ? TransparenceColors.mute : TransparenceColors.coral,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (off ? l10n.alertOff : l10n.alertOn).toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.1,
                        color: off
                            ? TransparenceColors.mute
                            : TransparenceColors.coral,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(fortune.summary, style: theme.textTheme.bodyLarge),
                    if (fortune.aliases.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        fortune.aliases.join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: TransparenceColors.mute,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: off
                        ? TransparenceColors.ink
                        : TransparenceColors.coral,
                    side: BorderSide(
                      color: off
                          ? TransparenceColors.ink
                          : TransparenceColors.coral,
                      width: 2,
                    ),
                  ),
                  onPressed: () {
                    final database = ref.read(appDatabaseProvider);
                    if (off) {
                      database.restoreAlert(fortune.id);
                    } else {
                      database.removeAlert(
                        fortuneId: fortune.id,
                        fortuneName: fortune.name,
                        removedAt: DateTime.now(),
                      );
                    }
                  },
                  child: Text(off ? l10n.alertRestore : l10n.alertRemove),
                ),
              ),
              FicheSection(l10n.participations),
              for (final link in active)
                LinkTile(
                  title: library.company(link.ownedCompanyId).name,
                  link: link,
                  source: _source(library, link),
                  onOpen: () => _open(
                    context,
                    CompanyPage(companyId: link.ownedCompanyId),
                  ),
                ),
              FicheSection(l10n.brandsReached),
              for (final brand in portfolio.brands)
                FicheNavRow(
                  title: brand.name,
                  leading: BrandMark.forBrand(brand, size: 40),
                  onTap: () => _open(context, BrandPage(brandId: brand.id)),
                ),
              FicheSection(l10n.history),
              if (historical.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    l10n.noHistory,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: TransparenceColors.mute,
                    ),
                  ),
                )
              else
                for (final link in historical)
                  LinkTile(
                    title: library.company(link.ownedCompanyId).name,
                    link: link,
                    source: _source(library, link),
                  ),
            ],
          ),
        );
      },
    );
  }
}

Source? _source(Library library, Ownership link) {
  final id = link.sourceId;
  if (id == null) return null;
  return library.sourceOrNull(id);
}

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}
