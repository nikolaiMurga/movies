import 'package:movies/common/models/error_model.dart';
import 'package:movies/features/movies/domain/models/movie.dart';

class MovieState {
  final bool isLoading;
  final List<Movie>? movies;
  final ErrorModel? error;
  final int currentPage;
  final int totalPages;

  MovieState({
    this.isLoading = false,
    this.movies,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  bool get hasMore => currentPage < totalPages;

  MovieState copyWith({
    bool? isLoading,
    List<Movie>? movies,
    ErrorModel? error,
    int? currentPage,
    int? totalPages,
  }) {
    return MovieState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
