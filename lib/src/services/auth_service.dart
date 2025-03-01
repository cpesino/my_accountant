import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_accountant/src/api/api_service.dart';
import 'package:my_accountant/src/models/user.dart';

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
        log("Current user: ${response['data']['user']}");
        User user = User.fromMap(response['data']['user']);
        saveUser(user);
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
  // saveUser
  void saveUser(User user) async {
    log("Saving user...");
    await _storage.write(key: "user", value: user.toJson());
    log("User successfully saved");
  }

  // getUser
  Future<User?> getUser() async {
    log("Getting user...");
    String? userStr = await _storage.read(key: "user");
    if (userStr == null) {
      return null;
    }
    log("User found");
    User user = User.fromJson(userStr);
    return user;
  }

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
    final response = await _apiService.get('/auth/check');
    if (token == null || !response['data']['isAuthenticated']) {
      log("User is not authenticated");
      return false;
    }
    log("User is currently authenticated");
    return true;
  }
}
