import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/mappers/movie_mapper.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/api_client_dio_impl.dart';
import 'package:movies/core/network/dto/movie_dto.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/core/network/params.dart';
import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/core/network/responses/movie_response.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/models/paginated_movies.dart';

final movieNetworkRepo = Provider<MovieNetworkRepo>((ref) {
  return MovieNetworkRepo(ref.watch(apiClient), ref.watch(movieMapper), ref.watch(params));
});

class MovieNetworkRepo {
  final ApiClient _apiClient;
  final MovieMapper _movieMapper;
  final Params _params;

  MovieNetworkRepo(this._apiClient, this._movieMapper, this._params);

  Future<PaginatedMovies> fetchPaginatedMovies({required MoviesRequest request}) async {
    final queryParams = _params.getMoviesRequestQueryParams(request: request);
    final resp = await _apiClient.get(endpoint: Endpoints.topRatedMovies, queryParams: queryParams);
    final movResp = MoviesResponse.fromJson(resp.data);
    final dtoList = movResp.dtoList;
    final moviesList = <Movie>[];
    if (dtoList.isNotEmpty) {
      for (MovieDto dto in dtoList) {
        moviesList.add(_movieMapper.fromDto(dto));
      }
    }
    return PaginatedMovies(page: movResp.page, moviesList: moviesList, totalPages: movResp.totalPages);
  }
}
