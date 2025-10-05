import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/core/network/requests/currencies_request.dart';

final params = Provider<Params>((ref) => Params());

class Params {
  // HEADERS
  Map<String, String> getHeaders({String? token, bool? data}) {
    if (token != null) {
      return {
        "Content-Type": "application/json",
        "authorization": "Bearer $token",
      };
    } else if (token != null && data != null) {
      return {
        "Content-Type": "multipart/form-data",
        "authorization": "Bearer $token",
      };
    } else {
      return {
        "Content-Type": "application/json",
      };
    }
  }

  Map<String, dynamic> getMoviesRequestQueryParams({required MoviesRequest request}) {
    final Map<String, String> queryParams = {
      'page': '${request.page}',
    };
    return queryParams;
  }
}
