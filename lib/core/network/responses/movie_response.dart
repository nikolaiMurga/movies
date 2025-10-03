import 'package:movies/core/network/dto/movie_dto.dart';

class MoviesResponse {
  int? page;
  List<MovieDto>? dtoList;
  int? totalPages;
  int? totalResults;

  MoviesResponse({this.page, this.dtoList, this.totalPages, this.totalResults});

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      page: json['page'],
      dtoList: json['results'] == null ? [] : List<MovieDto>.from(json['results']!.map((j) => MovieDto.fromJson(j))),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}
