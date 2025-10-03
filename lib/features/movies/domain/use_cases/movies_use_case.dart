import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/features/movies/data/repos/local_repo.dart';
import 'package:movies/features/movies/data/repos/network_repo.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/models/paginated_movies.dart';

class MoviesUseCase {
  final NetworkRepo _networkRepo;
  final LocalRepo _localRepo;

  MoviesUseCase(this._networkRepo, this._localRepo);

  Future<PaginatedMovies> fetchCurrencies({required MoviesRequest request}) async {
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
