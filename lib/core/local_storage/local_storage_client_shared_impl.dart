import 'package:movies/common/logging_service.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageClientSharedImpl implements LocalStorageClient {
  final SharedPreferences _pref;

  LocalStorageClientSharedImpl(this._pref);

  // clear storage // todo renaming
  Future<bool> clearStorage() async {
    final isClear = await _pref.clear();
    return isClear;
  }

  //  save favorite movies
  final _favoriteMoviesKey = 'favorite_movies_key';

  @override
  Future<bool> saveFavoriteMovies(String jsonString) async {
    final isSet = await _pref.setString(_favoriteMoviesKey, jsonString);
    LogService.addLog('saveFavoriteMovies succeed is $isSet');
    return isSet;
  }

  @override
  Future<String?> loadFavoriteMovies() async {
    final jsonString = _pref.getString(_favoriteMoviesKey);
    LogService.addLog('saveFavoriteMovies succeed is $jsonString');
    return jsonString;
  }

  @override
  Future<bool> removeFavoriteMovies() async {
    final isRemoved = await _pref.remove(_favoriteMoviesKey);
    LogService.addLog('removeFavoriteMovies succeed is $isRemoved');
    return isRemoved;
  }
}
