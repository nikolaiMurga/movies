import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/movies/data/request/movies_request.dart';
import 'package:movies/features/movies/data/repos/movie_network_repo.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/models/paginated_movies.dart';

final moviesUseCase = Provider<MoviesUseCase>((ref) => MoviesUseCase(ref.watch(movieNetworkRepo)));

class MoviesUseCase {
  final MovieNetworkRepo _networkRepo;

  MoviesUseCase(this._networkRepo);

  Future<PaginatedMovies> fetchMovies({required MoviesRequest request}) async {
    return _networkRepo.fetchPaginatedMovies(request: request);
  }

  Future<List<Movie>> fetchMoviesBySearch({required String query}) async {
    return _networkRepo.fetchPaginatedMoviesBySearch(query: query);
  }
}
