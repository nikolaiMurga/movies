import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/features/movies/data/repos/movie_local_repo.dart';
import 'package:movies/features/movies/data/repos/movie_network_repo.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/models/paginated_movies.dart';

class MoviesUseCase {
  final MovieNetworkRepo _networkRepo;
  final MovieLocalRepo _localRepo;

  MoviesUseCase(this._networkRepo, this._localRepo);

  Future<PaginatedMovies> fetchMovies({required MoviesRequest request}) async {
    return _networkRepo.fetchPaginatedMovies(request: request);
  }

  Future<bool> saveFavoriteMovies({required List<Movie> list}) async {
    return _localRepo.saveFavoriteMovies(list: list);
  }

  Future<List<Movie>> loadFavoriteMovies() async {
    return _localRepo.loadFavoriteMovies();
  }

  Future<bool> removeFavoriteMovies() async {
    return _localRepo.removeFavoriteMovies();
  }
}
