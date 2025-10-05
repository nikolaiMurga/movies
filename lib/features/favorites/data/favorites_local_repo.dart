import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:movies/core/local_storage/local_storage_client_shared_impl.dart';

final favoritesLocalRepo = Provider<FavoritesLocalRepo>((ref) {
  return FavoritesLocalRepo(ref.watch(localStorage));
});

class FavoritesLocalRepo {
  final LocalStorageClient _localStorageClient;

  FavoritesLocalRepo(this._localStorageClient);

  Future<bool> saveFavoriteMovies({required List<int> list}) async {
    final stringList = list.map((id) => id.toString()).toList();
    return _localStorageClient.saveFavoriteMovies(stringList);
  }

  Set<int> loadFavoriteMovies() {
    final favoritesList = _localStorageClient.loadFavoriteMovies();
    return favoritesList.map((id) => int.parse(id)).toSet();
  }

  Future<bool> removeFavoriteMovies() async {
    return _localStorageClient.removeFavoriteMovies();
  }
}
