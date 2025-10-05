import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/movie_details/domain/models/movie_details.dart';
import 'package:movies/features/movie_details/domain/use_cases/movies_details_use_case.dart';

final movieDetailsProvider = FutureProvider.family<MovieDetails, int>((ref, id) async {
  final useCase = ref.watch(moviesDetailsUseCase);
  return useCase.fetchMovieDetails(movieId: id);
});
