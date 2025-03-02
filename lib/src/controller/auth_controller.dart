import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/models/user_model.dart';
import 'package:my_accountant/src/services/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<UserModel>();
  var token = ''.obs;
  var errorMessage = ''.obs;

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadToken();
  }

  Future<void> _loadUser() async {
    UserModel? storedUser = await _authService.getUser();
    if (storedUser != null) {
      user.value = storedUser;
      log("Loaded user from storage");
    } else {
      log("User not found");
    }
  }

  Future<void> _loadToken() async {
    String? storedToken = await _authService.getToken();
    if (storedToken != null) {
      token.value = storedToken;
      log("Loaded token from storage");
    } else {
      log("Token not found");
    }
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
        await _loadUser();
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
