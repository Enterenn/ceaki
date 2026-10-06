import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  MobileScannerController? _camera;
  String? _error;
  String? _seen;
  var _busy = false;
  var _readyAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void dispose() {
    _code.dispose();
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final camera = _camera;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l10n.scannerPlaceholder, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        if (camera == null) ...[
          Text(l10n.cameraReason, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _allowCamera,
            child: Text(l10n.cameraAllow),
          ),
        ] else
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                controller: camera,
                onDetect: _onDetect,
                errorBuilder: (context, error) {
                  final denied =
                      error.errorCode ==
                      MobileScannerErrorCode.permissionDenied;
                  return ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          denied ? l10n.cameraDenied : error.errorCode.message,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 16),
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

  void _allowCamera() {
    if (_camera != null) return;
    setState(() {
      _camera = MobileScannerController(
        formats: const [
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
        ],
      );
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy || DateTime.now().isBefore(_readyAt)) return;
    final raw = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .firstOrNull;
    if (raw == null || raw == _seen) return;
    _seen = raw;
    final l10n = AppLocalizations.of(context);
    switch (readGtin(raw)) {
      case GtinRejected(:final reason):
        setState(() => _error = _reject(l10n, reason));
      case GtinAccepted(:final gtin):
        setState(() {
          _busy = true;
          _error = null;
        });
        await HapticFeedback.lightImpact();
        await _camera?.stop();
        try {
          await _open(gtin);
        } finally {
          _seen = null;
          _readyAt = DateTime.now().add(const Duration(milliseconds: 800));
          if (mounted) {
            try {
              await _camera?.start();
            } catch (_) {
              _seen = raw;
            }
          }
        }
    }
  }

  Future<void> _submit() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    switch (readGtin(_code.text)) {
      case GtinRejected(:final reason):
        setState(() => _error = _reject(l10n, reason));
      case GtinAccepted(:final gtin):
        await _open(gtin);
    }
  }

  Future<void> _open(Gtin gtin) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final library = await ref.read(capitalLibraryProvider.future);
      final id = await ref.read(scanBookProvider).open(gtin, library);
      if (!mounted) return;
      setState(() => _busy = false);
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => ResultPage(scanId: id)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.offlineProduct);
    } finally {
      if (mounted && _busy) setState(() => _busy = false);
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
