import 'package:flutter/material.dart';

/// App color tokens. Names end with **Color** and include the hue (Black, White, Grey, Green, …).
class AppColors {
  AppColors._();

  /// Near-black — primary text and icons on light backgrounds.
  static const Color mainTextBlackColor = Color(0xFF000000);

  /// Same value as [mainTextBlackColor] — dark surfaces, gradients, filled buttons.
  static const Color mainSurfaceBlackColor = Color(0xFF000000);

  /// White — page and card backgrounds, inputs.
  static const Color mainBackgroundWhiteColor = Color(0xFFFFFFFF);

  /// Same value as [mainBackgroundWhiteColor] — text and icons on dark backgrounds.
  static const Color onDarkForegroundWhiteColor = Color(0xFFFFFFFF);

  /// Muted grey — secondary text, hints, borders.
  static const Color subTextGreyColor = Color(0xFF8D8D8D);

  /// Brand / action blue.
  static const Color buttonBlueColor = Color(0xFF4671B7);

  /// Success / positive actions (e.g. toast).
  static const Color buttonGreenColor = Color(0xFF4CAF50);

  /// Light green status background.
  static const Color statusGreenBackgroundColor = Color(0xFFE8F5E9);

  /// Green text on light green status.
  static const Color statusGreenTextColor = Color(0xFF2E7D32);

  /// Darker green for emphasis on status.
  static const Color statusGreenTextDarkColor = Color(0xFF1B5E20);



  // ─── Dark Mode ─────────────────────────────────────────────

/// خلفية الصفحات في الـ dark mode
static const Color mainBackgroundDarkColor = Color(0xFF121212);

/// Cards, inputs, bottom sheets
static const Color mainSurfaceDarkColor = Color(0xFF1E1E1E);

/// Dropdowns, modals — elevated فوق الـ surface
static const Color elevatedSurfaceDarkColor = Color(0xFF2A2A2A);

/// Borders و dividers
static const Color borderDarkColor = Color(0xFF333333);

/// Primary text في الـ dark
static const Color mainTextDarkColor = Color(0xFFFFFFFF);

/// Secondary/hint text في الـ dark
static const Color subTextDarkColor = Color(0xFFAAAAAA);

/// Filled button background في الـ dark (أبيض عكس الـ light)
static const Color buttonFilledDarkColor = Color(0xFFFFFFFF);

/// Text على الـ filled button في الـ dark
static const Color onButtonDarkColor = Color(0xFF121212);

// ─── Status — Dark variants ────────────────────────────────

static const Color statusGreenBackgroundDarkColor = Color(0xFF1B3A1C);
// ignore: constant_identifier_names
static const Color statusGreenTextDarkColor_v2    = Color(0xFF81C784);
static const Color buttonBlueBgDarkColor          = Color(0xFF1A2A3A);
static const Color buttonBlueTextDarkColor        = Color(0xFF7EAEE8);
}