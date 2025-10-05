abstract class ApiClient {
  Future<dynamic> get({required String endpoint, Map<String, dynamic>? queryParams});
}
