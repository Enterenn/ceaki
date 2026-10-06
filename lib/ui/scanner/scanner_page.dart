import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/ceaki_mark.dart';
import 'package:transparence/ui/result/result_page.dart';
import 'package:transparence/ui/scanner/camera_scan_page.dart';
import 'package:transparence/ui/theme.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  static const codeField = Key('scan-code');
  static const manualToggle = Key('scan-manual-toggle');
  static const submitButton = Key('scan-submit');

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final _code = TextEditingController();
  String? _error;
  var _busy = false;
  var _manual = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Stack(
      children: [
        const Positioned.fill(child: _HomeBackdrop()),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const CeakiMark(size: 44),
              const SizedBox(height: 12),
              Container(
                width: 72,
                height: 8,
                color: TransparenceColors.lime,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.scannerHeadline,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.scannerSub,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: TransparenceColors.mute,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: TransparenceColors.lime,
                  foregroundColor: TransparenceColors.ink,
                  minimumSize: const Size.fromHeight(64),
                ),
                onPressed: _busy ? null : _openCamera,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 26),
                    const SizedBox(width: 12),
                    Text(
                      l10n.scanCta,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: TransparenceColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: ScannerPage.manualToggle,
                  onPressed: () => setState(() => _manual = !_manual),
                  child: Text(
                    _manual ? l10n.manualHide : l10n.manualShow,
                  ),
                ),
              ),
              if (_manual) ...[
                const SizedBox(height: 8),
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
                  key: ScannerPage.submitButton,
                  onPressed: _busy ? null : _submit,
                  child: Text(_busy ? l10n.searching : l10n.seeAttachment),
                ),
              ],
            ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openCamera() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CameraScanPage()),
    );
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

class _HomeBackdrop extends StatelessWidget {
  const _HomeBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StripePainter());
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = TransparenceColors.paper;
    canvas.drawRect(Offset.zero & size, base);
    final lime = Paint()
      ..color = TransparenceColors.lime.withValues(alpha: 0.35);
    final ink = Paint()..color = TransparenceColors.ink.withValues(alpha: 0.04);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.62, 0, size.width * 0.38, size.height * 0.34),
      lime,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.72, size.width * 0.28, size.height * 0.28),
      ink,
    );
    final line = Paint()
      ..color = TransparenceColors.ink.withValues(alpha: 0.08)
      ..strokeWidth = 1.5;
    for (var i = 0; i < 8; i++) {
      final y = size.height * 0.4 + i * 18.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 40), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
