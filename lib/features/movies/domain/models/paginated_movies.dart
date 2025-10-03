import 'package:movies/features/movies/domain/models/movie.dart';

class PaginatedMovies {
  final int page;
  final List<Movie> moviesList;
  final int totalPages;

  PaginatedMovies({
    required this.page,
    required this.moviesList,
    required this.totalPages,
  });
}
