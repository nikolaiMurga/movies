import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/features/movies/data/request/movies_request.dart';
import 'package:movies/features/movies/domain/models/movie.dart';
import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/resources/app_strings.dart';

final movieProvider = AsyncNotifierProvider<MovieProvider, List<Movie>>(() {
  return MovieProvider();
});

class MovieProvider extends AsyncNotifier<List<Movie>> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  @override
  Future<List<Movie>> build() async {
    return [];
  }

  void reset() {
    _currentPage = 1;
    _totalPages = 1;
    _hasMore = true;
    state.value?.clear();
  }

  Future<void> fetchMovies({required int page}) async {
    if (page > 1 && !_hasMore) return;

    if (page == 1) state = const AsyncValue.loading();

    try {
      final request = MoviesRequest(page: page);
      final movieUseCase = ref.watch(moviesUseCase);
      final paginatedMovies = await movieUseCase.fetchMovies(request: request);
      final currentMovies = state.value ?? [];

      _currentPage = paginatedMovies.page;
      _totalPages = paginatedMovies.totalPages;
      _hasMore = _currentPage < _totalPages;

      state = AsyncValue.data([...currentMovies, ...paginatedMovies.moviesList]);
    } on ErrorModel catch (e, stackTrace) {
      state = AsyncValue.error(e.statusMessage ?? AppStrings.noErrorMessage, stackTrace);
    }
  }

  Future<void> fetchMoviesBySearch({required String query}) async {
    reset();
    state = const AsyncValue.loading();
    try {
      final movieUseCase = ref.watch(moviesUseCase);
      final moviesBySearch = await movieUseCase.fetchMoviesBySearch(query: query);
      state = AsyncValue.data(moviesBySearch);
    } on ErrorModel catch (e, stackTrace) {
      state = AsyncValue.error(e.statusMessage ?? AppStrings.noErrorMessage, stackTrace);
    }
  }
}
