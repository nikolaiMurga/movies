import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:movies/core/local_storage/local_storage_client_shared_impl.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(localStorage));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageClient _localStorage;

  ThemeNotifier(this._localStorage) : super(_getInitialTheme(_localStorage));

  static ThemeMode _getInitialTheme(LocalStorageClient client) {
    final savedTheme = client.loadTheme();
    switch (savedTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    final themeString = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    _localStorage.saveTheme(themeString);
  }
}
