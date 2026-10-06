import 'package:flutter/material.dart';

/// A-fun zine tokens — playful sticker energy, not punk tract.
abstract final class TransparenceColors {
  static const ink = Color(0xFF121214);
  static const paper = Color(0xFFF3F1E9);
  static const panel = Color(0xFFFFFDF8);
  static const lime = Color(0xFFC8FF3D);
  static const coral = Color(0xFFFF3D5A);
  static const leaf = Color(0xFF12B886);
  static const mist = Color(0xFFE6E4DA);
  static const mute = Color(0xFF5C5C66);
}

/// Soft square — fun sticker, not pill.
abstract final class TransparenceRadii {
  static const double sm = 2;
  static const BorderRadius all = BorderRadius.all(Radius.circular(sm));
}

/// Flat offset shadow — sticker lift, no soft blur.
abstract final class TransparenceShadows {
  static const List<BoxShadow> stamp = [
    BoxShadow(
      color: Color(0x1A121214),
      offset: Offset(3, 3),
      blurRadius: 0,
    ),
  ];

  static const List<BoxShadow> stampStrong = [
    BoxShadow(
      color: Color(0x28121214),
      offset: Offset(4, 4),
      blurRadius: 0,
    ),
  ];
}

ThemeData transparenceTheme() {
  const seed = ColorScheme(
    brightness: Brightness.light,
    primary: TransparenceColors.ink,
    onPrimary: TransparenceColors.lime,
    secondary: TransparenceColors.lime,
    onSecondary: TransparenceColors.ink,
    error: TransparenceColors.coral,
    onError: Colors.white,
    surface: TransparenceColors.paper,
    onSurface: TransparenceColors.ink,
    surfaceContainerHighest: TransparenceColors.mist,
    onSurfaceVariant: TransparenceColors.mute,
    outline: Color(0xFF2A2A32),
    outlineVariant: Color(0xFFC8C6BC),
  );

  final display = TextStyle(
    fontFamily: 'Syne',
    fontVariations: const [FontVariation('wght', 800)],
    letterSpacing: -0.6,
    height: 1.05,
    color: TransparenceColors.ink,
  );
  final body = TextStyle(
    fontFamily: 'Figtree',
    fontVariations: const [FontVariation('wght', 450)],
    height: 1.35,
    color: TransparenceColors.ink,
  );

  final text = TextTheme(
    displayLarge: display.copyWith(fontSize: 48),
    displayMedium: display.copyWith(fontSize: 36),
    displaySmall: display.copyWith(fontSize: 28),
    headlineLarge: display.copyWith(fontSize: 28),
    headlineMedium: display.copyWith(fontSize: 24),
    headlineSmall: display.copyWith(fontSize: 20),
    titleLarge: display.copyWith(
      fontSize: 20,
      fontVariations: const [FontVariation('wght', 700)],
    ),
    titleMedium: body.copyWith(
      fontSize: 16,
      fontVariations: const [FontVariation('wght', 650)],
    ),
    titleSmall: body.copyWith(
      fontSize: 14,
      fontVariations: const [FontVariation('wght', 650)],
    ),
    bodyLarge: body.copyWith(fontSize: 16),
    bodyMedium: body.copyWith(fontSize: 14),
    bodySmall: body.copyWith(
      fontSize: 12,
      color: TransparenceColors.mute,
    ),
    labelLarge: body.copyWith(
      fontSize: 14,
      fontVariations: const [FontVariation('wght', 700)],
      letterSpacing: 0.2,
    ),
    labelMedium: body.copyWith(
      fontSize: 12,
      fontVariations: const [FontVariation('wght', 650)],
    ),
    labelSmall: body.copyWith(
      fontSize: 11,
      fontVariations: const [FontVariation('wght', 650)],
      letterSpacing: 0.4,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: seed,
    scaffoldBackgroundColor: TransparenceColors.paper,
    cardColor: TransparenceColors.panel,
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: TransparenceColors.paper,
      foregroundColor: TransparenceColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TransparenceColors.ink,
      indicatorColor: TransparenceColors.lime,
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.labelMedium!.copyWith(
          color: selected ? TransparenceColors.lime : TransparenceColors.mist,
          fontVariations: [
            FontVariation('wght', selected ? 700 : 500),
          ],
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? TransparenceColors.ink : TransparenceColors.mist,
          size: 24,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: TransparenceColors.ink,
        foregroundColor: TransparenceColors.lime,
        minimumSize: const Size.fromHeight(56),
        shape: const RoundedRectangleBorder(
          borderRadius: TransparenceRadii.all,
        ),
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: TransparenceColors.ink,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: TransparenceColors.ink, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: TransparenceRadii.all,
        ),
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: TransparenceColors.ink,
        textStyle: text.labelLarge?.copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: TransparenceColors.panel,
      border: const OutlineInputBorder(
        borderRadius: TransparenceRadii.all,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: TransparenceRadii.all,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: TransparenceRadii.all,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: TransparenceRadii.all,
        borderSide: BorderSide(color: TransparenceColors.coral, width: 2),
      ),
      hintStyle: text.bodyMedium?.copyWith(color: TransparenceColors.mute),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: TransparenceColors.mist,
      selectedColor: TransparenceColors.lime,
      disabledColor: TransparenceColors.mist,
      labelStyle: text.labelMedium!,
      secondaryLabelStyle: text.labelMedium!,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: TransparenceRadii.all,
        side: BorderSide(color: TransparenceColors.ink, width: 1.5),
      ),
      side: const BorderSide(color: TransparenceColors.ink, width: 1.5),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: text.titleMedium,
      subtitleTextStyle: text.bodySmall,
      iconColor: TransparenceColors.ink,
    ),
    dividerTheme: const DividerThemeData(
      color: TransparenceColors.ink,
      thickness: 1.5,
      space: 1.5,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: TransparenceColors.ink,
      contentTextStyle: text.bodyMedium?.copyWith(
        color: TransparenceColors.lime,
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: TransparenceRadii.all,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values)
          platform: const FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
