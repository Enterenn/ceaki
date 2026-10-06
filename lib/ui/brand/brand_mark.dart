import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparence/data/logos/logo_cache.dart';
import 'package:transparence/domain/library.dart';
import 'package:transparence/ui/theme.dart';

/// Brand visual: local asset, cached https logo, or geometric monogram.
/// Never invents a trademarked logo — monogram is initials only.
class BrandMark extends ConsumerWidget {
  const BrandMark({
    required this.name,
    this.logoAsset,
    this.logoUrl,
    this.size = 48,
    super.key,
  });

  factory BrandMark.forBrand(Brand brand, {Key? key, double size = 48}) {
    return BrandMark(
      key: key,
      name: brand.name,
      logoAsset: brand.logoAsset,
      logoUrl: brand.logoUrl,
      size: size,
    );
  }

  final String name;
  final String? logoAsset;
  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = logoAsset;
    if (asset != null && asset.isNotEmpty) {
      return _Frame(
        size: size,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _Monogram(name: name, size: size),
        ),
      );
    }

    final url = logoUrl;
    if (url != null && url.isNotEmpty) {
      return _CachedLogo(url: url, name: name, size: size);
    }

    return _Frame(size: size, child: _Monogram(name: name, size: size));
  }
}

class _CachedLogo extends ConsumerWidget {
  const _CachedLogo({
    required this.url,
    required this.name,
    required this.size,
  });

  final String url;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<File?>(
      future: ref.watch(logoCacheProvider).fileFor(url),
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file == null) {
          return _Frame(size: size, child: _Monogram(name: name, size: size));
        }
        return _Frame(
          size: size,
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _Monogram(name: name, size: size),
          ),
        );
      },
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(child: child),
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = brandInitials(name);
    final accent = _accentFor(name);
    return ColoredBox(
      color: TransparenceColors.ink,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(width: size * 0.12, color: accent),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: size * 0.1, color: accent),
          ),
          Center(
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: size * (initials.length > 1 ? 0.32 : 0.42),
                height: 1,
                color: TransparenceColors.paper,
                fontVariations: const [FontVariation('wght', 800)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _accentFor(String value) {
    final hash = value.codeUnits.fold<int>(0, (sum, c) => sum + c);
    const accents = [
      TransparenceColors.lime,
      TransparenceColors.coral,
      TransparenceColors.leaf,
    ];
    return accents[hash % accents.length];
  }
}

String brandInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final word = parts.single;
    return word.length == 1 ? word.toUpperCase() : word.substring(0, 1).toUpperCase();
  }
  return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
}
