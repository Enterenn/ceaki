import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/result/result_page.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  static const codeField = Key('scan-code');

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final _code = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l10n.scannerPlaceholder, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        TextField(
          key: ScannerPage.codeField,
          controller: _code,
          enabled: !_busy,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: l10n.codeHint,
            errorText: _error,
          ),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: _busy ? null : _submit,
          child: Text(_busy ? l10n.searching : l10n.seeAttachment),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final read = readGtin(_code.text);
    switch (read) {
      case GtinRejected(:final reason):
        setState(() => _error = _reject(l10n, reason));
      case GtinAccepted(:final gtin):
        setState(() {
          _busy = true;
          _error = null;
        });
        try {
          final library = await ref.read(capitalLibraryProvider.future);
          final id = await ref.read(scanBookProvider).open(gtin, library);
          if (!mounted) return;
          setState(() => _busy = false);
          await Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => ResultPage(scanId: id)),
          );
        } catch (_) {
          if (!mounted) return;
          setState(() => _error = l10n.offlineProduct);
        } finally {
          if (mounted && _busy) setState(() => _busy = false);
        }
    }
  }

  String _reject(AppLocalizations l10n, GtinReject reason) {
    return switch (reason) {
      GtinReject.empty => l10n.codeEmpty,
      GtinReject.unrecognized => l10n.codeUnrecognized,
      GtinReject.invalidCheck => l10n.codeInvalidCheck,
    };
  }
}
