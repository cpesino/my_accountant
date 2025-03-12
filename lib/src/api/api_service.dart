import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:my_accountant/src/util/constants/api_constants.dart';

class ApiService {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: API_BASE_URL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            handleExpiredToken();
          }
          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      log("Getting token...");
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw "Token not found";
      }
      Response response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['message'] ?? "Request failed. Please try again";
      } else {
        throw "Network error. Please check your connection";
      }
    }
  }

  // POST request
  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      Response response =
          await _dio.post(endpoint, queryParameters: params, data: body ?? {});
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['message'] ?? "Request failed. Please try again";
      } else {
        throw "Network error. Please check your connection";
      }
    }
  }

  // POST request
  Future<dynamic> postWithAuth(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw "Token not found";
      }
      Response response = await _dio.post(
        endpoint,
        queryParameters: params,
        data: body ?? {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != '') {
        throw e.response?.data['message'] ?? "Request failed. Please try again";
      } else {
        throw "Network error. Please check your connection";
      }
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw "Token not found";
      }
      Response response =
          await _dio.put(
        endpoint,
        queryParameters: params,
        data: body ?? {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['message'] ?? "Request failed. Please try again";
      } else {
        throw "Network error. Please check your connection";
      }
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? params, Map<String, dynamic>? body}) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw "Token not found";
      }
      Response response = await _dio.delete(endpoint,
        queryParameters: params,
        data: body ?? {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['message'] ?? "Request failed. Please try again";
      } else {
        throw "Network error. Please check your connection";
      }
    }
  }

  void handleExpiredToken() {
    clearToken();

    Get.defaultDialog(
      title: "Session Expired",
      middleText: "Your session has expired. Please log in again.",
      onConfirm: () {
        Get.offAllNamed('/login');
      },
      textConfirm: "Login",
    );
  }

  void clearToken() async {
    log("Deleting credentials from storage...");
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user');
    log("Data erased from storage");
  }
}
