import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/mappers/movie_details_mapper.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/api_client_dio_impl.dart';
import 'package:movies/core/network/requests/currencies_request.dart';
import 'package:movies/features/movie_details/data/repos/movie_details_network_repo.dart';
import 'package:movies/features/movie_details/domain/models/movie_details.dart';
import 'package:movies/features/movie_details/domain/use_cases/movies_details_use_case.dart';

import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/resources/app_strings.dart';

final movieDetailsProvider = AsyncNotifierProvider.family<MovieDetailsProvider, MovieDetails, int>(
  () {
    return MovieDetailsProvider(
      MoviesDetailsUseCase(MovieDetailsNetworkRepo(ApiClientDioImpl(Dio()), MovieDetailsMapper())),
    );
  },
);

class MovieDetailsProvider extends FamilyAsyncNotifier<MovieDetails, int> {
  final MoviesDetailsUseCase _moviesDetailsUseCase;

  MovieDetailsProvider(this._moviesDetailsUseCase);

  @override
  Future<MovieDetails> build(int movieId) async {
    state = const AsyncValue.loading();
    try {
      final movieDetails = await _moviesDetailsUseCase.fetchMovieDetails(movieId: movieId);
      state = AsyncValue.data(movieDetails);
      return movieDetails;
    } on ErrorModel catch (e, stackTrace) {
      state = AsyncValue.error(e.statusMessage ?? AppStrings.noErrorMessage, stackTrace);
      rethrow;
    }
  }
}
