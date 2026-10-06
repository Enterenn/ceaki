import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/app_version.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/ceaki_mark.dart';
import 'package:transparence/ui/theme.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final library = ref.watch(capitalLibraryProvider);

    return Scaffold(
      backgroundColor: TransparenceColors.paper,
      appBar: AppBar(title: Text(l10n.profileAboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        children: [
          const CeakiMark(size: 36),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 48,
              height: 5,
              color: TransparenceColors.lime,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.aboutPurpose,
            style: theme.textTheme.headlineSmall?.copyWith(
              height: 1.25,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: TransparenceColors.coral, width: 4),
              ),
              color: Colors.white,
            ),
            child: Text(
              l10n.aboutLimit,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: TransparenceColors.ink,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            l10n.aboutSourcesLabel.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.1,
              color: TransparenceColors.mute,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.aboutSources,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: TransparenceColors.mute,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 40),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _MetaRow(
            label: l10n.appVersionLabel,
            value: l10n.appVersionValue(publishedAppVersion),
          ),
          const SizedBox(height: 18),
          library.when(
            loading: () => _MetaRow(
              label: l10n.libraryVersionLabel,
              value: '…',
            ),
            error: (_, _) => _MetaRow(
              label: l10n.libraryVersionLabel,
              value: l10n.libraryError,
            ),
            data: (lib) => _MetaRow(
              label: l10n.libraryVersionLabel,
              value: l10n.libraryVersionValue(lib.version, lib.updatedOn),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.0,
            color: TransparenceColors.mute,
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
