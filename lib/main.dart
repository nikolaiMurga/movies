import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/local_storage/local_storage_client_shared_impl.dart';
import 'package:movies/core/theme/theme_provider.dart';
import 'package:movies/features/favorites/presentation/favorites_provider.dart';
import 'package:movies/movie_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme') ?? 'system';
  ThemeMode initialTheme;
  switch (savedTheme) {
    case 'light':
      initialTheme = ThemeMode.light;
      break;
    case 'dark':
      initialTheme = ThemeMode.dark;
      break;
    default:
      initialTheme = ThemeMode.system;
  }

  runApp(
    ProviderScope(
      overrides: [
        localStorage.overrideWith((ref) => LocalStorageClientSharedImpl(prefs)),
        themeProvider.overrideWith((ref) => ThemeNotifier(initialTheme, prefs)),
        favoritesProvider.overrideWith((ref) => FavoritesNotifier(prefs)),
      ],
      child: const MovieApp(),
    ),
  );
}
