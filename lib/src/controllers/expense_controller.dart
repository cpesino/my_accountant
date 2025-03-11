import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/models/expense_model.dart';
import 'package:my_accountant/src/services/expense_service.dart';

class ExpenseController extends GetxController {
  final AuthController _authController = Get.find();
  final ExpenseService _expenseService = ExpenseService();

  @override
  onInit() {
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllUserExpenses() async {
    try {
      log("Getting user id...");
      int? userId = _authController.user.value?.id;
      if (userId == null) {
        throw "User not found";
      }
      return await _expenseService.getAllUserExpenses(userId);
    } catch (e) {
      log("Unable to get user's expenses");
      throw e.toString();
    }
  }

  Future<ExpenseModel> addNewExpense(ExpenseModel expense) async {
    try {
      log("Getting user id...");
      int? userId = _authController.user.value?.id;
      if (userId == null) {
        throw "User not found";
      }
      Map<String, dynamic> newExpense =
          await _expenseService.addNewExpense(userId, expense);
      log("id:${newExpense['id']}");
      log("categoryId:${newExpense['categoryId']}");
      return ExpenseModel.fromMap(newExpense);
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }
}
