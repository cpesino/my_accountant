import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/models/user_model.dart';
import 'package:my_accountant/src/services/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<UserModel>();
  RxBool isAuthenticated = false.obs; 
  var token = ''.obs;
  var errorMessage = ''.obs;

  final AuthService _authService = AuthService();

  @override
  void onInit() async {
    super.onInit();
    await _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    isAuthenticated.value = await _authService.isAuthenticated();
    if (isAuthenticated.value) {
      await _initializeAuthProperties();
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> _initializeAuthProperties() async {
    log("Initializing auth properties...");
    user.value = await _loadUser();
    token.value = await _loadToken() ?? '';
    log("User and token initialized");
  }

  Future<UserModel?> _loadUser() async {
    UserModel? storedUser = await _authService.getUser();
    if (storedUser != null) {
      log("Loaded user from storage");
      return storedUser;
    } else {
      log("User not found");
      return null;
    }
  }

  Future<String?> _loadToken() async {
    String? storedToken = await _authService.getToken();
    if (storedToken != null) {
      log("Loaded token from storage");
      return storedToken;
    } else {
      log("Token not found");
      return null;
    }
  }

  void logout() async {
    log("Logging out...");
    await _authService.clearCredentials();
    isAuthenticated.value = false;
    token.value = '';
    errorMessage.value = '';
    Get.offAllNamed('/login');
  }

  Future<void> login(
      {required String username, required String password}) async {
    errorMessage.value = '';

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      bool success =
          await _authService.login(username: username, password: password);
      if (success) {
        user.value = await _loadUser();
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      log("Error!", error: e);
    } finally {
      Get.back();
    }
  }
}
