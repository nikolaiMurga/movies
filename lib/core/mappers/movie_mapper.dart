import 'package:movies/core/network/dto/movie_dto.dart';
import 'package:movies/features/movies/domain/movie.dart';

class MovieMapper {
  Movie fromDto(MovieDto dto) {
    return Movie(
      id: dto.id ?? 0,
      title: dto.title ?? 'title',
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage ?? 0.0,
    );
  }

  Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      voteAverage: json['voteAverage'],
    );
  }

  Map<String, dynamic> toJson(Movie model) {
    return {
      'id': model.id,
      'title': model.title,
      'posterPath': model.posterPath,
      'voteAverage': model.voteAverage,
    };
  }
}
