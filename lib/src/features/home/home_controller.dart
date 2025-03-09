import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/controllers/budget_controller.dart';
import 'package:my_accountant/src/controllers/expense_controller.dart';
import 'package:my_accountant/src/models/budget_model.dart';
import 'package:my_accountant/src/models/expense_model.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final ExpenseController _expenseController =
      Get.put(ExpenseController(), permanent: true);
  final BudgetController _budgetController =
      Get.put(BudgetController(), permanent: true);

  RxBool isLoading = false.obs;
  RxString name = ''.obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxList<BudgetModel> budgets = <BudgetModel>[].obs;
  var totalBudget = Rxn<Decimal>();
  var totalExpenses = Rxn<Decimal>();
  var selectedMOP = 'Cash'.obs;
  RxString errorMessage = ''.obs;
  RxString selectedCategory = 'Select below'.obs;
  RxList<String> userBudgetCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    totalBudget.value = Decimal.parse('0.00');
    totalExpenses.value = Decimal.parse('0.00');
  }

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      name.value = _authController.user.value!.name;
      Map<String, dynamic> userExpenses =
          await _expenseController.getAllUserExpenses();
      expenses.assignAll(userExpenses['expenses']);
      totalExpenses.value =
          Decimal.parse(userExpenses['total_expenses'].toString());

      Map<String, dynamic> userBudgets =
          await _budgetController.getAllUserBudgets();
      budgets.assignAll(userBudgets['budgets']);
      totalBudget.value =
          Decimal.parse(userBudgets['total_budget'].toString());

      Future.delayed(const Duration(seconds: 5), () {
        isLoading.value = false;
      });
    } catch (e) {
      errorMessage.value = e.toString();
      log("Error!", error: e);
    }
  }

  void logout() {
    _authController.logout();
  }
}
