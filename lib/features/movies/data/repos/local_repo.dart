import 'dart:convert';

import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:movies/core/mappers/movie_mapper.dart';
import 'package:movies/features/movies/domain/models/movie.dart';

class LocalRepo {
  final LocalStorageClient _localStorageClient;
  final MovieMapper _movieMapper;

  LocalRepo(this._localStorageClient, this._movieMapper);

  Future<bool> saveFavoriteMovies({required List<Movie> list}) async {
    final json = {'list': list.map((m) => _movieMapper.toJson(m)).toList()};
    final jsonString = jsonEncode(json);
    return _localStorageClient.saveFavoriteMovies(jsonString);
  }

  Future<List<Movie>> loadFavoriteMovies() async {
    final jsonString = await _localStorageClient.loadFavoriteMovies();
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      final list = List<Movie>.from(json['list']!.map((j) => _movieMapper.fromJson(j)));
      return list;
    }
    return [];
  }

  Future<bool> removeFavoriteMovies() async {
    return _localStorageClient.removeFavoriteMovies();
  }
}
