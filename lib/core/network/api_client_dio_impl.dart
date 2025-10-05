import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/core/network/endpoints.dart';
import 'package:movies/core/network/params.dart';
import 'package:movies/resources/app_constants.dart';
import 'package:movies/resources/app_strings.dart';

final baseOptions = Provider<BaseOptions>((ref) {
  return BaseOptions(
    baseUrl: Endpoints.baseUrl,
    headers: ref.watch(params).getHeaders(token: dotenv.env[AppStrings.apiToken]),
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    sendTimeout: AppConstants.sendTimeout,
  );
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(ref.watch(baseOptions));
});

final apiClient = Provider<ApiClient>((ref) {
  return ApiClientDioImpl(ref.watch(dioProvider));
});

class ApiClientDioImpl implements ApiClient {
  final Dio dio;

  const ApiClientDioImpl(this.dio);

  ErrorModel _mapDioException(DioException e) {
    ErrorModel badResponseHandle() {
      // from response
      final data = e.response?.data;

      // from response with model
      if (data is Map<String, dynamic>) {
        try {
          return ErrorModel.fromJson(data);
        } catch (_) {
          return ErrorModel(statusMessage: AppStrings.invalidResponse);
        }
      }
      return ErrorModel(statusMessage: AppStrings.invalidResponse);

      //manual
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400:
          return ErrorModel(statusMessage: AppStrings.badRequest);
        case 401:
          return ErrorModel(statusMessage: AppStrings.unauthorized);
        case 403:
          return ErrorModel(statusMessage: AppStrings.forbidden);
        case 404:
          return ErrorModel(statusMessage: AppStrings.notFound);
        case 500:
          return ErrorModel(statusMessage: AppStrings.serverError);
        default:
          return ErrorModel(statusMessage: AppStrings.unknownError);
      }
    }

    switch (e.type) {
      case DioExceptionType.badResponse:
        return badResponseHandle();
      case DioExceptionType.connectionTimeout:
        return ErrorModel(statusMessage: AppStrings.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return ErrorModel(statusMessage: AppStrings.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return ErrorModel(statusMessage: AppStrings.receiveTimeout);
      case DioExceptionType.cancel:
        return ErrorModel(statusMessage: AppStrings.requestCancelled);
      default:
        return ErrorModel(statusMessage: '${AppStrings.unknownError}: ${e.message}');
    }
  }

  Future<Response> _dioExceptionHandle({required Future<dynamic> apiCall}) async {
    try {
      final resp = await apiCall;
      return resp;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // GET
  @override
  Future<Response> get({required String endpoint, Map<String, dynamic>? queryParams}) async {
    return _dioExceptionHandle(apiCall: dio.get(endpoint, queryParameters: queryParams));
  }
}
