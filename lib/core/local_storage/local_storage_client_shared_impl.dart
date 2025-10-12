import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/log_service/log_service.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorage = Provider<LocalStorageClient>((ref) {
  return LocalStorageClientSharedImpl(SharedPreferences.getInstance() as SharedPreferences);
});

class LocalStorageClientSharedImpl implements LocalStorageClient {
  final SharedPreferences _pref;

  LocalStorageClientSharedImpl(this._pref);

  // clear storage
  Future<bool> clearStorage() async {
    final isClear = await _pref.clear();
    return isClear;
  }

  //  save favorite movies
  final _favoriteMoviesKey = 'favorite_movies_key';

  @override
  Future<bool> saveFavoriteMovies(List<String> jsonString) async {
    final isSet = await _pref.setStringList(_favoriteMoviesKey, jsonString);
    LogService.addLog('saveFavoriteMovies succeed is $isSet');
    return isSet;
  }

  @override
  List<String> loadFavoriteMovies() {
    final stringList = _pref.getStringList(_favoriteMoviesKey);
    LogService.addLog('saveFavoriteMovies succeed is $stringList');
    return stringList ?? [];
  }

  @override
  Future<bool> removeFavoriteMovies() async {
    final isRemoved = await _pref.remove(_favoriteMoviesKey);
    LogService.addLog('removeFavoriteMovies succeed is $isRemoved');
    return isRemoved;
  }
}
