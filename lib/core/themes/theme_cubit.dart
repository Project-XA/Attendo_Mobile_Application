import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/// Manages the app's [ThemeMode] and persists the preference in Hive.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({required Box<bool> themeBox})
      : _themeBox = themeBox,
        super(
          (themeBox.get('isDark', defaultValue: false) ?? false)
              ? ThemeMode.dark
              : ThemeMode.light,
        );

  final Box<bool> _themeBox;

  bool get isDark => state == ThemeMode.dark;

  void toggleTheme() {
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    _themeBox.put('isDark', newMode == ThemeMode.dark);
    emit(newMode);
  }

  void setTheme(ThemeMode mode) {
    _themeBox.put('isDark', mode == ThemeMode.dark);
    emit(mode);
  }
}