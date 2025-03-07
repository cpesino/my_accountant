import 'package:get/get.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/controllers/expense_controller.dart';
import 'package:my_accountant/src/models/expense_model.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final ExpenseController _expenseController =
      Get.put(ExpenseController(), permanent: true);

  RxBool isLoading = false.obs;
  RxString name = ''.obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    name.value = _authController.user.value!.name;
    expenses.assignAll(await _expenseController.getUserExpenses());
    Future.delayed(const Duration(seconds: 5), () {
      isLoading.value = false;
    });
  }

  void logout() {
    _authController.logout();
  }
}
