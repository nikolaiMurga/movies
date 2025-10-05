import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/features/movies/presentation/providers/movie_state.dart';

final movieProvider = AsyncNotifierProvider<MovieProvider, MovieState>(() {
  throw UnimplementedError('Must provide FetchMoviesUseCase via constructor');
});

class MovieProvider extends AsyncNotifier<MovieState> {
  final MoviesUseCase _moviesUseCase;

  MovieProvider(this._moviesUseCase);

  @override
  MovieState build() {
    return MovieState(isLoading: false, movies: null, error: null);
  }

  Future<void> fetchMovies(String query, {int page = 1}) async {
    if (page > 1 && state.value != null && !state.value!.hasMore) return;

    // loading
    state = AsyncValue.data(MovieState(
      isLoading: true,
      movies: state.value?.movies ?? [],
      currentPage: page,
      totalPages: state.value?.totalPages ?? 1,
    ));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final request = MoviesRequest(page: page);
      final paginatedMovies = await _moviesUseCase.fetchCurrencies(request: request);
      final currentMovies = state.value?.movies ?? [];

      // data
      state = AsyncValue.data(MovieState(
        isLoading: false,
        movies: [...currentMovies, ...paginatedMovies.moviesList],
        error: null,
        currentPage: paginatedMovies.page,
        totalPages: paginatedMovies.totalPages,
      ));
    } on ErrorModel catch (e) {
      // error
      state = AsyncValue.data(MovieState(
        isLoading: false,
        movies: state.value?.movies ?? [],
        error: e,
        currentPage: page,
        totalPages: state.value?.totalPages ?? 1,
      ));
    }
  }

  void reset() {
    state = AsyncValue.data(MovieState(
      isLoading: false,
      movies: [],
      error: null,
      currentPage: 1,
      totalPages: 1,
    ));
  }
}
