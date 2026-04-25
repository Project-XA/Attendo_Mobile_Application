import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

/// Centralised light and dark [ThemeData] for the app.
class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.mainBackgroundWhiteColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.mainSurfaceBlackColor,
      onPrimary: AppColors.onDarkForegroundWhiteColor,
      surface: AppColors.mainBackgroundWhiteColor,
      onSurface: AppColors.mainTextBlackColor,
      surfaceContainerHighest: Color(0xFFF5F5F5),
      outline: AppColors.subTextGreyColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mainBackgroundWhiteColor,
      foregroundColor: AppColors.mainTextBlackColor,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.mainBackgroundWhiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.mainBackgroundWhiteColor,
      selectedItemColor: AppColors.mainTextBlackColor,
      unselectedItemColor: AppColors.subTextGreyColor,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.mainBackgroundWhiteColor,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.mainSurfaceBlackColor.withOpacity(0.2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mainBackgroundWhiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.subTextGreyColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainSurfaceBlackColor,
        foregroundColor: AppColors.onDarkForegroundWhiteColor,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.mainSurfaceBlackColor;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.mainSurfaceBlackColor.withOpacity(0.4);
        }
        return Colors.grey.shade300;
      }),
    ),
  );

  // ─── Dark Theme ───────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.mainBackgroundDarkColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.buttonFilledDarkColor,
      onPrimary: AppColors.onButtonDarkColor,
      surface: AppColors.mainSurfaceDarkColor,
      onSurface: AppColors.mainTextDarkColor,
      surfaceContainerHighest: AppColors.elevatedSurfaceDarkColor,
      outline: AppColors.subTextDarkColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mainBackgroundDarkColor,
      foregroundColor: AppColors.mainTextDarkColor,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.mainSurfaceDarkColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.mainSurfaceDarkColor,
      selectedItemColor: AppColors.mainTextDarkColor,
      unselectedItemColor: AppColors.subTextDarkColor,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.elevatedSurfaceDarkColor,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderDarkColor.withOpacity(0.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mainSurfaceDarkColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderDarkColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonFilledDarkColor,
        foregroundColor: AppColors.onButtonDarkColor,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.buttonFilledDarkColor;
        }
        return Colors.grey.shade600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.buttonFilledDarkColor.withOpacity(0.4);
        }
        return Colors.grey.shade800;
      }),
    ),
  );
}
