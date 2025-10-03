import 'package:dio/dio.dart';
import 'package:movies/common/models/error_model.dart';
import 'package:movies/core/network/api_client.dart';
import 'package:movies/resources/app_strings.dart';

class ApiClientDioImpl implements ApiClient {
  final Dio _dio;

  ApiClientDioImpl(this._dio);

  ErrorModel _mapDioException(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        try {
          return ErrorModel.fromJson(data);
        } catch (_) {
          return ErrorModel(error: AppStrings.invalidResponse);
        }
      }

      switch (statusCode) {
        case 400:
          return ErrorModel(error: AppStrings.badRequest);
        case 401:
          return ErrorModel(error: AppStrings.unauthorized);
        case 403:
          return ErrorModel(error: AppStrings.forbidden);
        case 404:
          return ErrorModel(error: AppStrings.notFound);
        case 500:
          return ErrorModel(error: AppStrings.serverError);
        default:
          return ErrorModel(error: AppStrings.unknownError);
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorModel(error: AppStrings.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return ErrorModel(error: AppStrings.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return ErrorModel(error: AppStrings.receiveTimeout);
      case DioExceptionType.cancel:
        return ErrorModel(error: AppStrings.requestCancelled);
      default:
        return ErrorModel(error: '${AppStrings.unknownError}: ${e.message}');
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
  Future<dynamic> get({required String endpoint, required Map<String, dynamic> queryParams}) async {
    final resp = await _dioExceptionHandle(apiCall: _dio.get(endpoint, queryParameters: queryParams));
    return resp.data;
  }
}
