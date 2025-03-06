import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
