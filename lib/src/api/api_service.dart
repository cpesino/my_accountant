import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:my_accountant/src/util/constants/api_constants.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: API_BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          log("Error: ${e.response?.statusCode} - ${e.message}");
          // return handler.next(e);
        },
      ),
    );
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } catch (e) {
      log("ERROR", error: e);
      // throw Exception("GET request failed: $e");
    }
  }

  // GET request
  Future<dynamic> getWithAuth(String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } catch (e) {
      log("ERROR", error: e);
      // throw Exception("GET request failed: $e");
    }
  }

  // POST request
  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      Response response =
          await _dio.post(endpoint, queryParameters: params, data: body ?? {});
      return response.data;
    } catch (e) {
      log("ERROR", error: e);
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      Response response =
          await _dio.put(endpoint, queryParameters: params, data: body ?? {});
      return response.data;
    } catch (e) {
      log("ERROR", error: e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      Response response = await _dio.delete(endpoint,
          queryParameters: params, data: body ?? {});
      return response.data;
    } catch (e) {
      log("ERROR", error: e);
    }
  }
}
