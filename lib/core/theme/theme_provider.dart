import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ThemeMode.system, SharedPreferences.getInstance() as SharedPreferences);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences prefs;

  ThemeNotifier(super.initialTheme, this.prefs);

  void setTheme(ThemeMode mode) {
    state = mode;
    prefs.setString(
        'theme',
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.dark
                ? 'dark'
                : 'system');
  }
}
