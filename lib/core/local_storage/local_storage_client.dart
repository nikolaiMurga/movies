abstract class LocalStorageClient {
  Future<bool> saveFavoriteMovies(String jsonString);

  Future<String?> loadFavoriteMovies();

  Future<bool> removeFavoriteMovies();
}
