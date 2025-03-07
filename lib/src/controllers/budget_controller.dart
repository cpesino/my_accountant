import 'package:get/get.dart';
import 'package:my_accountant/src/models/budget_model.dart';

class BudgetController extends GetxController {
  RxList<BudgetModel> budgets = <BudgetModel>[].obs;
}
