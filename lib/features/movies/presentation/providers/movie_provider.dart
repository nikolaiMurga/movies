import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/resources/app_strings.dart';

final movieProvider = AsyncNotifierProvider<MovieProvider, List<Movie>>(() {
  throw UnimplementedError('Must provide MoviesUseCase via constructor');
});

class MovieProvider extends AsyncNotifier<List<Movie>> {
  final MoviesUseCase _moviesUseCase;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  MovieProvider(this._moviesUseCase);

  @override
  Future<List<Movie>> build() async {
    return [];
  }

  void reset() {
    _currentPage = 1;
    _totalPages = 1;
    _hasMore = true;
    state = const AsyncValue.data([]);
  }

  Future<void> fetchMovies(String query, {int page = 1}) async {
    if (page > 1 && !_hasMore) return;

    if (page == 1) state = const AsyncValue.loading();

    try {
      final request = MoviesRequest(page: page);
      final paginatedMovies = await _moviesUseCase.fetchMovies(request: request);
      final currentMovies = state.value ?? [];

      _currentPage = paginatedMovies.page;
      _totalPages = paginatedMovies.totalPages;
      _hasMore = _currentPage < _totalPages;

      state = AsyncValue.data([...currentMovies, ...paginatedMovies.moviesList]);
    } on ErrorModel catch (e, stackTrace) {
      state = AsyncValue.error(e.statusMessage ?? AppStrings.noErrorMessage, stackTrace);
    }
  }
}
