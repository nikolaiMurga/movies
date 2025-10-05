import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
  return FavoritesNotifier(SharedPreferences.getInstance() as SharedPreferences);
});

class FavoritesNotifier extends StateNotifier<Set<int>> {
  final SharedPreferences _pref;

  FavoritesNotifier(this._pref) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesList = _pref.getStringList('favorites') ?? [];
    state = favoritesList.map((id) => int.parse(id)).toSet();
  }

  Future<void> toggleFavorite(int id) async {
    if (state.contains(id)) {
      state = state.where((fid) => fid != id).toSet();
    } else {
      state = {...state, id};
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', state.map((id) => id.toString()).toList());
  }

  bool isFavorite(int id) => state.contains(id);
}
