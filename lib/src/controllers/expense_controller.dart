import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/models/expense_model.dart';
import 'package:my_accountant/src/services/expense_service.dart';

class ExpenseController extends GetxController {
  final AuthController _authController = Get.find();
  final ExpenseService _expenseService = ExpenseService();

  late int? userId;

  @override
  onInit() {
    super.onInit();
    userId = _authController.user.value?.id;
  }

  Future<List<ExpenseModel>> getUserExpenses() async {
    try {
      log("Getting user id...");
      int? userId = _authController.user.value?.id;
      if (userId == null) {
        throw "User not found";
      }
      log("UserId: $userId");
      return await _expenseService.getUserExpenses(userId);
    } catch (e) {
      log("Unable to get user's expenses");
      throw e.toString();
    }
  }
}
