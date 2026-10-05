import 'package:flutter/material.dart';
import 'package:transparence/l10n/app_localizations.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          AppLocalizations.of(context).scannerPlaceholder,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
