import 'package:movies/core/network/dto/movie_dto.dart';

class MoviesResponse {
  final int page;
  final List<MovieDto> dtoList;
  final int totalPages;
  final int totalResults;

  MoviesResponse({
    required this.page,
    required this.dtoList,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      page: json['page'] ?? 0,
      dtoList: json['results'] == null ? [] : List<MovieDto>.from(json['results']!.map((j) => MovieDto.fromJson(j))),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
