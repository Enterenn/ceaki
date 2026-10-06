import 'package:flutter/material.dart';

/// Ink, paper, acid lime — punchy without the usual AI purple/cream look.
abstract final class TransparenceColors {
  static const ink = Color(0xFF0B0B0F);
  static const paper = Color(0xFFF7F7F2);
  static const lime = Color(0xFFC8FF3D);
  static const coral = Color(0xFFFF3D5A);
  static const leaf = Color(0xFF12B886);
  static const mist = Color(0xFFE8E8E0);
  static const mute = Color(0xFF5C5C66);
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
    outlineVariant: Color(0xFFC8C8BE),
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
          borderRadius: BorderRadius.zero,
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
          borderRadius: BorderRadius.zero,
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
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: TransparenceColors.ink, width: 2.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
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
        borderRadius: BorderRadius.zero,
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );
}
