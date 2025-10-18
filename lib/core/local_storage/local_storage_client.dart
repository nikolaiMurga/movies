abstract class LocalStorageClient {
  Future<bool> saveFavoriteMovies(List<String> list);

  List<String> loadFavoriteMovies();

  Future<bool> removeFavoriteMovies();

  Future<bool> saveTheme(String themeString);

  String loadTheme();
}
