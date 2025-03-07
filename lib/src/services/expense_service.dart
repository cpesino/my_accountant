import 'dart:developer';

import 'package:my_accountant/src/api/api_service.dart';
import 'package:my_accountant/src/models/expense_model.dart';

class ExpenseService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getAllUserExpenses(int userId) async {
    try {
      log("Getting expenses of user with ID $userId...");
      final response = await _apiService.get('/expenses/', params: {
        "userId": userId,
      });

      List<ExpenseModel> expenses = [];
      if (response['data'] != null && response['data']['expenses'] != null) {
        for (var expense in response['data']['expenses']) {
          expenses.add(ExpenseModel.fromMap(expense));
        }
      }
      log("Found ${expenses.length} expenses");

      Map<String, dynamic> userExpenses = {
        "expenses": expenses,
        "total_expenses": response['data']['total_amount'],
      };
      return userExpenses;
    } catch (e) {
      log("Error encountered while getting user expenses", error: e);
      throw e.toString();
    }
  }
}
