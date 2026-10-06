import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/archive_brands.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/shell_tab.dart';
import 'package:transparence/domain/archive.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/brand_mark.dart';
import 'package:transparence/ui/library/brand_page.dart';
import 'package:transparence/ui/shell/hub_header.dart';
import 'package:transparence/ui/theme.dart';

/// Personal archive of brands already met through scans.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _search = TextEditingController();
  ArchiveTone? _tone;

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
        final visible = filterArchive(
          entries,
          query: _search.text,
          tone: _tone,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HubHeader(
              title: l10n.navLibrary,
              subtitle: l10n.archiveSub,
              trailing: l10n.archiveCount(entries.length),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: l10n.archiveSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (entries.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    _FilterChip(
                      label: l10n.archiveFilterAll,
                      selected: _tone == null,
                      color: TransparenceColors.ink,
                      onTap: () => setState(() => _tone = null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.archiveFilterFortune,
                      selected: _tone == ArchiveTone.fortune,
                      color: TransparenceColors.coral,
                      onTap: () => setState(() => _tone = ArchiveTone.fortune),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.archiveFilterClear,
                      selected: _tone == ArchiveTone.clear,
                      color: TransparenceColors.leaf,
                      onTap: () => setState(() => _tone = ArchiveTone.clear),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.archiveFilterUnknown,
                      selected: _tone == ArchiveTone.unknown,
                      color: TransparenceColors.mute,
                      onTap: () => setState(() => _tone = ArchiveTone.unknown),
                    ),
                  ],
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSelected = color == TransparenceColors.mute
        ? TransparenceColors.paper
        : Colors.white;
    return Material(
      color: selected ? color : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: selected ? onSelected : color,
              fontVariations: const [FontVariation('wght', 700)],
            ),
          ),
        ),
      ),
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
                      if (entry.companyName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          entry.companyName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: TransparenceColors.mute,
                          ),
                        ),
                      ],
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
