import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/mixins/date_format_mixin.dart';
import 'package:movies/core/network/dto/movie_details_dto.dart';
import 'package:movies/features/movie_details/domain/models/movie_details.dart';

final movieDetailsMapper = Provider<MovieDetailsMapper>((ref) => MovieDetailsMapper());

class MovieDetailsMapper with DateFormatMixin {
  MovieDetails fromDto(MovieDetailsDto dto) {
    return MovieDetails(
      id: dto.id ?? 0,
      title: dto.title ?? 'title',
      posterPath: dto.posterPath != null ? 'https://image.tmdb.org/t/p/w500${dto.posterPath}' : '',
      voteAverage: dto.voteAverage ?? 0.0,
      overview: dto.overview ?? 'overview',
      releaseDate: getDateFromString(dto.releaseDate),
    );
  }
}
