import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/local_storage/local_storage_client.dart';
import 'package:movies/core/local_storage/local_storage_client_shared_impl.dart';
import 'package:movies/core/mappers/movie_mapper.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/api_client_dio_impl.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/core/network/params.dart';
import 'package:movies/core/router/router.dart';
import 'package:movies/features/movies/data/repos/local_repo.dart';
import 'package:movies/features/movies/data/repos/network_repo.dart';
import 'package:movies/features/movies/domain/use_cases/movies_use_case.dart';
import 'package:movies/features/movies/presentation/providers/movie_provider.dart';
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

  // REPOS
  final networkRepo = NetworkRepo(apiClient, movieMapper, params);
  final LocalRepo localRepo = LocalRepo(localStorageClient, movieMapper);

  final MoviesUseCase moviesUseCase = MoviesUseCase(networkRepo, localRepo);

  runApp(
    ProviderScope(
      overrides: [
        movieProvider.overrideWith(() => MovieProvider(moviesUseCase)),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ),
  );
}
