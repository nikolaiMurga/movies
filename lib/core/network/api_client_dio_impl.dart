import 'package:dio/dio.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/resources/app_strings.dart';

class ApiClientDioImpl implements ApiClient {
  final Dio _dio;

  ApiClientDioImpl(this._dio);

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
    return _dioExceptionHandle(apiCall: _dio.get(endpoint, queryParameters: queryParams));
  }
}
