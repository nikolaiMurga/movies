import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:movies/core/local_storage/local_storage_client_shared_impl.dart';
import 'package:movies/core/mappers/movie_details_mapper.dart';
import 'package:movies/core/mappers/movie_mapper.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/api_client_dio_impl.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/core/network/params.dart';
import 'package:movies/core/router/router.dart';
import 'package:movies/features/movie_details/data/repos/movie_details_network_repo.dart';
import 'package:movies/features/movie_details/domain/use_cases/movies_details_use_case.dart';
import 'package:movies/features/movie_details/presentation/providers/movie_details_provider.dart';
import 'package:movies/features/movies/data/repos/movie_local_repo.dart';
import 'package:movies/features/movies/data/repos/movie_network_repo.dart';
import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/features/movies/presentation/providers/movie_provider.dart';
import 'package:movies/movie_app.dart';
import 'package:movies/resources/app_constants.dart';
import 'package:movies/resources/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // API
  final Params params = Params();
  final BaseOptions baseOptions = BaseOptions(
    baseUrl: Endpoints.baseUrl,
    headers: params.getHeaders(token: dotenv.env[AppStrings.apiToken]),
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    sendTimeout: AppConstants.sendTimeout,
  );
  final Dio dio = Dio(baseOptions);
  final ApiClient apiClient = ApiClientDioImpl(dio);

  // LOCAL STORAGE
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final LocalStorageClient localStorageClient = LocalStorageClientSharedImpl(pref);

  // MAPPERS
  final MovieMapper movieMapper = MovieMapper();
  final MovieDetailsMapper movieDetailsMapper = MovieDetailsMapper();

  // NETWORK REPOS
  final movieNetworkRepo = MovieNetworkRepo(apiClient, movieMapper, params);
  final movieDetailsNetworkRepo = MovieDetailsNetworkRepo(apiClient, movieDetailsMapper);

  // LOCAL REPOS
  final movieLocalRepo = MovieLocalRepo(localStorageClient, movieMapper);

  // USE CASES
  final MoviesUseCase moviesUseCase = MoviesUseCase(movieNetworkRepo, movieLocalRepo);
  final MoviesDetailsUseCase moviesDetailsUseCase = MoviesDetailsUseCase(movieDetailsNetworkRepo);

  runApp(
    ProviderScope(
      overrides: [
        movieProvider.overrideWith(() => MovieProvider(moviesUseCase)),
        movieDetailsProvider.overrideWith(() => MovieDetailsProvider(moviesDetailsUseCase)),
      ],
      child: const MovieApp(),
    ),
  );
}
