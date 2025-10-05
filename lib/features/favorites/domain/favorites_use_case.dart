import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/favorites/data/favorites_local_repo.dart';

final favoritesUseCase = Provider<FavoritesUseCase>((ref) {
  return FavoritesUseCase(ref.watch(favoritesLocalRepo));
});

class FavoritesUseCase {
  final FavoritesLocalRepo _localRepo;

  FavoritesUseCase( this._localRepo);


  Future<bool> saveFavoriteMovies({required List<int> list}) async {
    return _localRepo.saveFavoriteMovies(list: list);
  }

  Future<Set<int>> loadFavoriteMovies() async {
    return _localRepo.loadFavoriteMovies();
  }

  Future<bool> removeFavoriteMovies() async {
    return _localRepo.removeFavoriteMovies();
  }
}