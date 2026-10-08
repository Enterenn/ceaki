import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/brand/ceaki_mark.dart';
import 'package:transparence/ui/motion/entrance.dart';
import 'package:transparence/ui/motion/press_scale.dart';
import 'package:transparence/ui/result/result_page.dart';
import 'package:transparence/ui/scanner/camera_scan_page.dart';
import 'package:transparence/ui/theme.dart';

/// Branded Scan home: Z scene — identity, punch title, lime stage CTA.
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
    return ColoredBox(
      color: TransparenceColors.paper,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Entrance(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CeakiMark(size: 48),
                            const SizedBox(width: 14),
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                color: TransparenceColors.lime,
                              ),
                              child: const SizedBox(width: 72, height: 10),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                      Entrance(
                        delay: const Duration(milliseconds: 120),
                        slide: 0.08,
                        child: Text(
                          l10n.scannerHeadline,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 40,
                            height: 1.02,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Entrance(
                        delay: const Duration(milliseconds: 180),
                        child: Text(
                          l10n.scannerSub,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: TransparenceColors.mute,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Entrance(
                        delay: const Duration(milliseconds: 260),
                        slide: 0.1,
                        scaleFrom: 0.94,
                        child: PressScale(
                          enabled: !_busy,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: TransparenceScenes.lime,
                              borderRadius: TransparenceRadii.tile,
                              boxShadow: TransparenceShadows.stampStrong,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: TransparenceColors.ink,
                                  foregroundColor: TransparenceColors.lime,
                                  minimumSize: const Size.fromHeight(64),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: TransparenceRadii.all,
                                  ),
                                ),
                                onPressed: _busy ? null : _openCamera,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.qr_code_scanner,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      l10n.scanCta,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: TransparenceColors.lime,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Entrance(
                        delay: const Duration(milliseconds: 320),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            key: ScannerPage.manualToggle,
                            onPressed: () =>
                                setState(() => _manual = !_manual),
                            child: Text(
                              _manual ? l10n.manualHide : l10n.manualShow,
                            ),
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
                        PressScale(
                          enabled: !_busy,
                          child: FilledButton(
                            key: ScannerPage.submitButton,
                            onPressed: _busy ? null : _submit,
                            child: Text(
                              _busy ? l10n.searching : l10n.seeAttachment,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
