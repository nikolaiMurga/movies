abstract class ApiClient {
  Future<dynamic> get({required String endpoint, required Map<String, dynamic> queryParams});
}
