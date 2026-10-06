import 'package:flutter/material.dart';
import 'package:transparence/domain/wording.dart';
import 'package:transparence/l10n/app_localizations.dart';
import 'package:transparence/ui/theme.dart';

class FortuneBannerView extends StatefulWidget {
  const FortuneBannerView({required this.banner, super.key});

  final FortuneBanner banner;

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
      label: '$grandeFortuneTitle. ${banner.title}. ${banner.body}',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: TransparenceColors.coral,
            borderRadius: TransparenceRadii.all,
            boxShadow: TransparenceShadows.stampStrong,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grandeFortuneTitle.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  banner.punch,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontVariations: const [FontVariation('wght', 700)],
                    height: 1.3,
                  ),
                ),
                if (hasDetail) ...[
                  const SizedBox(height: 12),
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
                        Icon(
                          _open
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  if (_open) ...[
                    const SizedBox(height: 10),
                    Text(
                      banner.detail,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
