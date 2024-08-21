import 'package:flutter/material.dart';

class CustomTheme {
  final TextTheme textTheme;

  const CustomTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF2e478a), // Logo Blue
      onPrimary: Color(0xFFFFFFFF), // White text on blue background
      primaryContainer: Color(0xFFD1E1FF), // Light Blue
      onPrimaryContainer: Color(0xFF003C77), // Darker Blue
      secondary: Color(0xFFf5180f), // Logo Red
      onSecondary: Color(0xFFFFFFFF), // White text on red background
      secondaryContainer: Color(0xFFFFEBEB), // Light Red
      onSecondaryContainer: Color(0xFFB71C1C), // Darker Red
      surface: Color(0xFFFFFFFF), // White
      onSurface: Color(0xFF212121), // Dark Gray text on white background
      background: Color(0xFFFFFFFF), // White background
      onBackground: Color(0xFF212121), // Dark Gray text
      error: Color(0xFFB00020), // Error Red
      onError: Color(0xFFFFFFFF), // White text on error background
      outline: Color(0xFFBDBDBD), // Light Gray for borders or outlines
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF2e478a), // Logo Blue
      onPrimary: Color(0xFFE0E0E0), // Light Gray text on blue background
      primaryContainer: Color(0xFF003C77), // Dark Blue
      onPrimaryContainer: Color(0xFFD1E1FF), // Light Blue text
      secondary: Color(0xFFf5180f), // Logo Red
      onSecondary: Color(0xFF000000), // Black text on red background
      secondaryContainer: Color(0xFFB71C1C), // Darker Red
      onSecondaryContainer: Color(0xFFFFFFFF), // White text
      surface: Color(0xFF121212), // Dark Surface
      onSurface: Color(0xFFE0E0E0), // Light Gray text on dark surface
      background: Color(0xFF121212), // Dark Background
      onBackground: Color(0xFFE0E0E0), // Light Gray text
      error: Color(0xFFCF6679), // Error Red for dark theme
      onError: Color(0xFF000000), // Black text on error background
      outline: Color(0xFF757575), // Medium Gray for outlines
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}
