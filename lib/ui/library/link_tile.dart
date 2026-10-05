import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTile extends StatelessWidget {
  const LinkTile({
    required this.title,
    required this.link,
    required this.source,
    this.onOpen,
    super.key,
  });

  final String title;
  final Ownership link;
  final Source? source;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final details = [
      ownershipFigures(link),
      frenchDate(link.factDate),
      if (link.note != null) link.note!,
    ].join('\n');
    return ListTile(
      title: Text(title),
      subtitle: Text(details),
      onTap: onOpen,
      trailing: source == null
          ? null
          : IconButton(
              tooltip: source!.title,
              onPressed: () => openHttps(context, source!.url),
              icon: const Icon(Icons.open_in_new),
            ),
    );
  }
}

Future<void> openHttps(BuildContext context, String url) async {
  final opened = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).sourceOpenError)),
    );
  }
}
