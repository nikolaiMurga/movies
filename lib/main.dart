import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/api_client_dio_impl.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/core/network/params.dart';
import 'package:movies/resources/app_constants.dart';
import 'package:movies/resources/app_strings.dart';

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
}
