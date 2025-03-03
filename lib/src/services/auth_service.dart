import 'dart:developer';

import 'package:dio/dio.dart';
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
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user');
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
      return null;
    }
    log("User found");
    UserModel user = UserModel.fromJson(userStr);
    return user;
  }

  // saveToken
  Future<void> saveToken(String token) async {
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
      return token;
    } else {
      throw "Token not found";
    }
  }

  // isAuthenticated
  Future<bool> isAuthenticated() async {
    try {
      await getToken();
      await _apiService.get('/auth/check');
      log("User is currently authenticated");
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
