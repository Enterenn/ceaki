import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparence/application/library_provider.dart';
import 'package:transparence/application/scan_book.dart';
import 'package:transparence/domain/gtin.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/result/result_page.dart';
import 'package:transparence/ui/theme.dart';

/// Asks for the camera when needed; the OS keeps the grant or refusal.
class CameraScanPage extends ConsumerStatefulWidget {
  const CameraScanPage({super.key});

  @override
  ConsumerState<CameraScanPage> createState() => _CameraScanPageState();
}

enum _Phase { checking, ask, denied, ready }

class _CameraScanPageState extends ConsumerState<CameraScanPage>
    with WidgetsBindingObserver {
  MobileScannerController? _camera;
  var _phase = _Phase.checking;
  var _busy = false;
  var _requesting = false;
  String? _seen;
  var _readyAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        (_phase == _Phase.denied || _phase == _Phase.ask)) {
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    if (_requesting) return;
    final status = await _cameraStatus();
    if (!mounted) return;
    if (status.isGranted) {
      _openCamera();
      return;
    }
    // On Android, status alone can't prove a permanent denial — only request can.
    if (_phase != _Phase.ask) {
      setState(() => _phase = _Phase.ask);
    }
  }

  Future<PermissionStatus> _cameraStatus() async {
    try {
      return await Permission.camera.status.timeout(
        const Duration(milliseconds: 1500),
      );
    } on TimeoutException {
      return PermissionStatus.denied;
    } catch (_) {
      return PermissionStatus.denied;
    }
  }

  Future<void> _allow() async {
    if (_requesting) return;
    _requesting = true;
    try {
      final status = await Permission.camera.request().timeout(
        const Duration(seconds: 60),
      );
      if (!mounted) return;
      if (status.isGranted) {
        _openCamera();
        return;
      }
      // Only a permanent refusal is final; a simple deny can be asked again.
      if (status.isPermanentlyDenied) {
        setState(() => _phase = _Phase.denied);
        return;
      }
      setState(() => _phase = _Phase.ask);
    } on TimeoutException {
      if (!mounted) return;
      // Dialog may still be up; don't brand it as a refusal.
      setState(() => _phase = _Phase.ask);
    } catch (_) {
      if (!mounted) return;
      // If the plugin glitches, let mobile_scanner prompt instead.
      _openCamera();
    } finally {
      _requesting = false;
    }
  }

  void _openCamera() {
    if (_phase == _Phase.ready && _camera != null) return;
    _camera?.dispose();
    setState(() {
      _phase = _Phase.ready;
      _camera = MobileScannerController(
        formats: const [
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TransparenceColors.ink,
      appBar: AppBar(
        backgroundColor: TransparenceColors.ink,
        foregroundColor: TransparenceColors.lime,
        title: Text(
          l10n.scanTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: TransparenceColors.lime,
          ),
        ),
      ),
      body: switch (_phase) {
        _Phase.checking => const Center(
          child: CircularProgressIndicator(color: TransparenceColors.lime),
        ),
        _Phase.ask => _AskBody(onAllow: _allow),
        _Phase.denied => const _DeniedBody(),
        _Phase.ready => _ScannerBody(
          camera: _camera!,
          busy: _busy,
          onDetect: _onDetect,
          onPermissionLost: () {
            if (mounted) setState(() => _phase = _Phase.denied);
          },
        ),
      },
    );
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
      case GtinRejected():
        _seen = null;
        return;
      case GtinAccepted(:final gtin):
        setState(() => _busy = true);
        await HapticFeedback.mediumImpact();
        await _camera?.stop();
        try {
          final library = await ref.read(capitalLibraryProvider.future);
          final id = await ref.read(scanBookProvider).open(gtin, library);
          if (!mounted) return;
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => ResultPage(scanId: id)),
          );
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.offlineProduct)));
          _seen = null;
          _readyAt = DateTime.now().add(const Duration(milliseconds: 800));
          setState(() => _busy = false);
          try {
            await _camera?.start();
          } catch (_) {}
        }
    }
  }
}

class _AskBody extends StatelessWidget {
  const _AskBody({required this.onAllow});

  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            l10n.cameraReason,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: TransparenceColors.paper,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: TransparenceColors.lime,
              foregroundColor: TransparenceColors.ink,
            ),
            onPressed: onAllow,
            child: Text(l10n.cameraAllow),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _DeniedBody extends StatelessWidget {
  const _DeniedBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            l10n.cameraDenied,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: TransparenceColors.paper,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: TransparenceColors.lime,
              side: const BorderSide(
                color: TransparenceColors.lime,
                width: 2,
              ),
            ),
            onPressed: openAppSettings,
            child: Text(l10n.cameraOpenSettings),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _ScannerBody extends StatelessWidget {
  const _ScannerBody({
    required this.camera,
    required this.busy,
    required this.onDetect,
    required this.onPermissionLost,
  });

  final MobileScannerController camera;
  final bool busy;
  final void Function(BarcodeCapture capture) onDetect;
  final VoidCallback onPermissionLost;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: camera,
          onDetect: onDetect,
          errorBuilder: (context, error) {
            final denied =
                error.errorCode == MobileScannerErrorCode.permissionDenied;
            if (denied) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onPermissionLost();
              });
            }
            return ColoredBox(
              color: TransparenceColors.ink,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    denied ? l10n.cameraDenied : error.errorCode.message,
                    style: const TextStyle(color: TransparenceColors.paper),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
        const IgnorePointer(
          child: CustomPaint(painter: _ScanFramePainter()),
        ),
        if (busy)
          const ColoredBox(
            color: Color(0x880B0B0F),
            child: Center(
              child: CircularProgressIndicator(color: TransparenceColors.lime),
            ),
          ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 40,
          child: Text(
            l10n.scanHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: TransparenceColors.lime,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  const _ScanFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TransparenceColors.lime
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final box = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: size.width * 0.72,
      height: size.width * 0.42,
    );
    const arm = 28.0;
    void corner(Offset a, Offset b, Offset c) {
      canvas.drawLine(a, b, paint);
      canvas.drawLine(b, c, paint);
    }

    corner(
      Offset(box.left, box.top + arm),
      box.topLeft,
      Offset(box.left + arm, box.top),
    );
    corner(
      Offset(box.right - arm, box.top),
      box.topRight,
      Offset(box.right, box.top + arm),
    );
    corner(
      Offset(box.left, box.bottom - arm),
      box.bottomLeft,
      Offset(box.left + arm, box.bottom),
    );
    corner(
      Offset(box.right - arm, box.bottom),
      box.bottomRight,
      Offset(box.right, box.bottom - arm),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
