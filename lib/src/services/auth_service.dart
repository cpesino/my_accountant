import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_accountant/src/api/api_service.dart';
import 'package:my_accountant/src/models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // login
  Future<bool> login(
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
        UserModel user = UserModel.fromMap(response['data']['user']);
        await saveUser(user);
        await saveToken(token);
        return true;
      }
    } catch (e) {
      log("Unable to authenticate", error: e);
      throw e.toString();
    }
    return false;
  }

  // register
  // logout
  Future<void> clearCredentials() async {
    log("Deleting credentials from storage...");
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user');
    log("Data erased from storage");
  }

  // refreshToken
  // saveUser
  Future<void> saveUser(UserModel user) async {
    log("Saving user...");
    await _storage.write(key: "user", value: user.toJson());
    log("User successfully saved");
  }

  // getUser
  Future<UserModel?> getUser() async {
    log("Getting user...");
    String? userStr = await _storage.read(key: "user");
    if (userStr == null) {
      log("Unable to find user");
      return null;
    }
    log("User found");
    return UserModel.fromJson(userStr);
  }

  // saveToken
  Future<void> saveToken(String token) async {
    log("Saving token...");
    await _storage.write(key: "jwt_token", value: token);
    log("Token successfully saved");
  }

  // getToken
  Future<String?> getToken() async {
    try {
      log("Getting token...");
      String? token = await _storage.read(key: "jwt_token");
      if (token == null) {
        log("Token not found");
        return null;
      }
      log("Token found");
      return token;
    } catch (e) {
      throw e.toString();
    }
  }

  // isAuthenticated
  Future<bool> isAuthenticated() async {
    try {
      final response = await _apiService.get('/auth/check');
      bool isAuthenticated = response['data']['isAuthenticated'];
      log("Authenticated: $isAuthenticated");
      return isAuthenticated;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
