import 'package:flutter/material.dart';
import 'theme_transition_overlay.dart';

class ThemeTransitionManager {
  static OverlayEntry? _entry;

  static void show({
    required BuildContext context,
    required bool isDark,
  }) {
    _entry?.remove();

    _entry = OverlayEntry(
      builder: (_) => ThemeTransitionOverlay(
        isDark: isDark,
        onComplete: () {
          _entry?.remove();
          _entry = null;
        },
      ),
    );

    Overlay.of(context).insert(_entry!);
  }
}