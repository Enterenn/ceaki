import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/archive_brands.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/brand_name.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/theme.dart';

/// Personal archive of brands already met through scans.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final archive = ref.watch(archiveBrandsProvider);
    final library = ref.watch(capitalLibraryProvider).asData?.value;
    return archive.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(l10n.libraryError)),
      data: (entries) {
        final query = _search.text.trim();
        final visible = query.isEmpty
            ? entries
            : [
                for (final entry in entries)
                  if (normalizeBrandName(entry.name).contains(
                    normalizeBrandName(query),
                  ))
                    entry,
              ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: TransparenceColors.ink,
              child: SafeArea(
                bottom: false,
                child: _ArchiveHeader(
                  title: l10n.navLibrary,
                  badge: l10n.archiveBadge,
                  subtitle: l10n.archiveSub,
                  countLabel: l10n.archiveCount(entries.length),
                  legendFortune: l10n.archiveLegendFortune,
                  legendClear: l10n.archiveLegendClear,
                  legendUnknown: l10n.archiveLegendUnknown,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: l10n.archiveSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? _EmptyArchive(
                      message: l10n.archiveEmpty,
                      cta: l10n.archiveEmptyCta,
                      onScan: () {
                        ref.read(shellTabProvider.notifier).select(0);
                      },
                    )
                  : visible.isEmpty
                  ? Center(
                      child: Text(
                        l10n.archiveNoMatch,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: TransparenceColors.mute),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final entry = visible[index];
                        return _ArchiveTile(
                          entry: entry,
                          brand: _brandOf(library, entry.brandId),
                          onTap: () => _openEntry(context, entry),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _openEntry(BuildContext context, ArchiveEntry entry) {
    final brandId = entry.brandId;
    if (brandId == null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UnresolvedBrandPage(name: entry.name),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrandPage(brandId: brandId),
      ),
    );
  }
}

Brand? _brandOf(Library? library, String? brandId) {
  if (library == null || brandId == null) return null;
  for (final brand in library.brands) {
    if (brand.id == brandId) return brand;
  }
  return null;
}

class _ArchiveHeader extends StatelessWidget {
  const _ArchiveHeader({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.countLabel,
    required this.legendFortune,
    required this.legendClear,
    required this.legendUnknown,
  });

  final String title;
  final String badge;
  final String subtitle;
  final String countLabel;
  final String legendFortune;
  final String legendClear;
  final String legendUnknown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: TransparenceColors.ink,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: TransparenceColors.paper,
                  ),
                ),
              ),
              Text(
                countLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: TransparenceColors.mist,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(width: 10, height: 10, color: TransparenceColors.lime),
              const SizedBox(width: 8),
              Text(
                badge.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: TransparenceColors.lime,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: TransparenceColors.mist,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _LegendDot(
                color: TransparenceColors.coral,
                label: legendFortune,
              ),
              _LegendDot(
                color: TransparenceColors.leaf,
                label: legendClear,
              ),
              _LegendDot(
                color: TransparenceColors.mute,
                label: legendUnknown,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: TransparenceColors.mist,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _EmptyArchive extends StatelessWidget {
  const _EmptyArchive({
    required this.message,
    required this.cta,
    required this.onScan,
  });

  final String message;
  final String cta;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: TransparenceColors.lime, width: 6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: TransparenceColors.mute,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: TransparenceColors.lime,
                    foregroundColor: TransparenceColors.ink,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: onScan,
                  child: Text(cta),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchiveTile extends StatelessWidget {
  const _ArchiveTile({
    required this.entry,
    required this.brand,
    required this.onTap,
  });

  final ArchiveEntry entry;
  final Brand? brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _toneColor(entry.tone);
    final label = archiveToneLabel(entry.tone);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 6)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(
              children: [
                if (brand != null)
                  BrandMark.forBrand(brand!, size: 52)
                else
                  BrandMark(name: entry.name, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: color.withValues(alpha: 0.14),
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            letterSpacing: 0.2,
                            fontVariations: const [FontVariation('wght', 700)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _toneColor(ArchiveTone tone) {
    return switch (tone) {
      ArchiveTone.fortune => TransparenceColors.coral,
      ArchiveTone.clear => TransparenceColors.leaf,
      ArchiveTone.unknown => TransparenceColors.mute,
    };
  }
}
