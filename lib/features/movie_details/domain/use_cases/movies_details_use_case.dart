import 'package:movies/features/movie_details/data/repos/movie_details_network_repo.dart';
import 'package:movies/features/movie_details/domain/models/movie_details.dart';

class MoviesDetailsUseCase {
  final MovieDetailsNetworkRepo _networkRepo;

  MoviesDetailsUseCase(this._networkRepo);

  Future<MovieDetails> fetchMovieDetails({required int movieId}) async {
    return _networkRepo.fetchMovieDetails(movieId: movieId);
  }
}
