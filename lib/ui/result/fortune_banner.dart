import 'package:flutter/material.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/chrome/stamp_tag.dart';
import 'package:transparence/ui/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FortuneBannerView extends StatefulWidget {
  const FortuneBannerView({
    required this.banner,
    required this.library,
    super.key,
  });

  final FortuneBanner banner;
  final Library library;

  @override
  State<FortuneBannerView> createState() => _FortuneBannerViewState();
}

class _FortuneBannerViewState extends State<FortuneBannerView> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final banner = widget.banner;
    final hasDetail = banner.detail.trim().isNotEmpty;

    return Semantics(
      container: true,
      label: '${banner.verdict}. ${banner.title}. ${banner.body}',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: TransparenceScenes.solidCoral,
            borderRadius: TransparenceRadii.tile,
            boxShadow: TransparenceShadows.stampStrong,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StampTag(
                  label: banner.verdict,
                  background: TransparenceColors.ink,
                  foreground: Colors.white,
                  tilt: -0.045,
                ),
                const SizedBox(height: 16),
                Text(
                  banner.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.05,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  banner.punch,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontVariations: const [FontVariation('wght', 700)],
                    height: 1.3,
                  ),
                ),
                if (hasDetail) ...[
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () => setState(() => _open = !_open),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _open ? l10n.whyDetailHide : l10n.whyDetail,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 1.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: _open ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: _open
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  banner.detail,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                ),
                              ),
                              if (banner.sources.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Sources :',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    for (final sourceId in banner.sources)
                                      _SourceLink(
                                        library: widget.library,
                                        sourceId: sourceId,
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SourceLink extends StatelessWidget {
  const _SourceLink({required this.library, required this.sourceId});

  final Library library;
  final String sourceId;

  @override
  Widget build(BuildContext context) {
    final source = library.sourceOrNull(sourceId);
    if (source == null) return const SizedBox();
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _launchUrl(source.url),
      child: Text(
        source.title,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
