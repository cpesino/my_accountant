import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/services/budget_service.dart';

class BudgetController extends GetxController {
  final AuthController _authController = Get.find();
  final BudgetService budgetService = BudgetService();

  Future<Map<String, dynamic>> getAllUserBudgets() async {
    try {
      log("Getting user id...");
      int? userId = _authController.user.value?.id;
      if (userId == null) {
        throw "User not found";
      }
      return await budgetService.getAllUserBudget(userId);
    } catch (e) {
      log("Unable to get user's budgets");
      throw e.toString();
    }
  }
}
