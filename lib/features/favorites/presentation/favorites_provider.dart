import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/favorites/domain/favorites_use_case.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesUseCase));
});

class FavoritesNotifier extends StateNotifier<Set<int>> {
  final FavoritesUseCase _favoritesUseCase;

  FavoritesNotifier(this._favoritesUseCase) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await _favoritesUseCase.loadFavoriteMovies();
  }

  Future<void> toggleFavorite(int id) async {
    if (state.contains(id)) {
      state = state.where((fid) => fid != id).toSet();
    } else {
      state = {...state, id};
    }
    await _favoritesUseCase.saveFavoriteMovies(list: state);
  }

  bool isFavorite(int id) => state.contains(id);
}
