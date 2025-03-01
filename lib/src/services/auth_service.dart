import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_accountant/src/api/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // login
  Future<void> login(
      {required String username, required String password}) async {
    try {
      log("Authenticating...");
      final response = await _apiService.post(
        '/auth/login',
        body: {
          "username": username,
          "password": password,
        },
      );

      if (response != null && response['data'] != null) {
        String token = response['data']['token'];
        saveToken(token);
      }
    } catch (e) {
      log("Unable to authenticate", error: e);
    }
  }

  // register
  // logout
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // refreshToken
  // getUser
  // saveToken
  void saveToken(String token) async {
    log("Saving token...");
    await _storage.write(key: "jwt_token", value: token);
    log("Token successfully saved");
  }

  // getToken
  Future<String?> getToken() async {
    log("Getting token...");
    String? token = await _storage.read(key: "jwt_token");
    if (token != null) {
      log("Token found");
    } else {
      log("Token not found");
    }
    return token;
  }

  // isAuthenticated
  Future<bool> isAuthenticated() async {
    String? token = await getToken();
    final response = await _apiService.getWithAuth('/auth/check');
    if (token == null || !response['data']['isAuthenticated']) {
      log("User is not authenticated");
      return false;
    }
    log("User is currently authenticated");
    return true;
  }
}
