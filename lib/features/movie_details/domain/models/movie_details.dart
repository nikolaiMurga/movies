class MovieDetails {
  final int id;
  final String posterPath;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final String overview;

  MovieDetails({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
  });

  const MovieDetails.empty()
      : id = 0,
        posterPath = '',
        title = '',
        voteAverage = 0.0,
        releaseDate = '',
        overview = '';
}
