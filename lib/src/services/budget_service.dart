import 'dart:collection';
import 'dart:developer';

import 'package:my_accountant/src/api/api_service.dart';
import 'package:my_accountant/src/models/budget_model.dart';

class BudgetService {
  final ApiService _service = ApiService();

  Future<Map<String, dynamic>> getAllUserBudget(int userId) async {
    try {
      log("Getting budget of user with ID $userId...");
      final response = await _service.get('/budgets/', params: {
        "userId": userId,
      });

      List<BudgetModel> budgets = [];
      if (response['data'] != null && response['data']['budgets'] != null) {
        for (var budget in response['data']['budgets']) {
          budgets.add(BudgetModel.fromMap(budget));
        }
      }
      log("Found ${budgets.length} budgets");

      Map<String, dynamic> userBudgets = {
        "budgets": budgets,
        "total_budget": response['data']['total_budget'],
      };

      return userBudgets;
    } catch (e) {
      log("Error encountered while getting user's budgets", error: e);
      throw e.toString();
    }
  }
}
