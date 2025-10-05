import 'package:movies/core/mappers/movie_details_mapper.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/dto/movie_details_dto.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/features/movie_details/domain/models/movie_details.dart';

class MovieDetailsNetworkRepo {
  final ApiClient _apiClient;
  final MovieDetailsMapper _movieDetailsMapper;

  MovieDetailsNetworkRepo(this._apiClient, this._movieDetailsMapper);

  Future<MovieDetails> fetchMovieDetails({required int movieId}) async {
    final resp = await _apiClient.get(endpoint: '${Endpoints.movieDetails}$movieId');
    final dto = MovieDetailsDto.fromJson(resp.data);
    final model = _movieDetailsMapper.fromDto(dto);
    return model;
  }
}
