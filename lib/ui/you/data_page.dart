import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/application/scan_history.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/theme.dart';

class DataPage extends ConsumerWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cacheCount = ref.watch(productCacheCountProvider);
    final history = ref.watch(scanHistoryProvider);
    final scanCount = history.asData?.value.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileDataTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          Text(
            l10n.profileDataBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: TransparenceColors.mute,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.scanHistoryTitle.toUpperCase(),
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileScanCount(scanCount),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                await ref.read(appDatabaseProvider).clearScanHistory();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.memoryCleared)),
                );
              },
              child: Text(l10n.clearScanHistory),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.profileCacheLabel.toUpperCase(),
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Text(
            cacheCount.when(
              loading: () => '…',
              error: (_, _) => l10n.productCacheCount(0),
              data: l10n.productCacheCount,
            ),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                await ref.read(appDatabaseProvider).clearProductCache();
                ref.invalidate(productCacheCountProvider);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cacheCleared)),
                );
              },
              child: Text(l10n.clearProductCache),
            ),
          ),
        ],
      ),
    );
  }
}
