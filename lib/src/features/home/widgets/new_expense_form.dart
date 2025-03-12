import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/common/widgets/error_box.dart';
import 'package:my_accountant/src/features/home/home_controller.dart';
import 'package:my_accountant/src/models/expense_model.dart';
import 'package:my_accountant/src/util/constants/colors.dart';
import 'package:my_accountant/src/util/constants/expense_category.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';

class NewExpenseForm extends StatelessWidget {
  final HomeController _controller = Get.find<HomeController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  NewExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    addNewExpense() async {
      if (_formKey.currentState!.validate()) {
        _controller.amount.value = amountController.text;
        _controller.description.value = descriptionController.text;
        _controller.addNewExpense();
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          TSizes.lg,
          0,
          TSizes.lg,
          TSizes.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Transaction',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: TColors.darkGrey,
                  ),
            ),
            const SizedBox(height: TSizes.sm),
            _buildAmountAndMOP(context),
            const SizedBox(height: TSizes.sm),
            _buildDescriptionField(context),
            const SizedBox(height: TSizes.sm),
            _buildCategoryPicker(context),
            const SizedBox(height: TSizes.sm),
            Obx(() {
              return _controller.errorMessage.isNotEmpty
                  ? ErrorBox(
                      errorMessage: _controller.errorMessage.value,
                    )
                  : const SizedBox();
            }),
            const SizedBox(height: TSizes.md),
            _buildButtons(context, addNewExpense),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(
      BuildContext context, Future<Null> Function() addNewExpense) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _controller.selectedCategory.value = 'Select below';
            _controller.mode.value = 'Cash';
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            addNewExpense();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    String? descriptionValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Description is required";
      }
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextFormField(
            controller: descriptionController,
            style: Theme.of(context).textTheme.titleLarge,
            validator: descriptionValidator,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Add description...',
              hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.darkGrey,
                  ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountAndMOP(BuildContext context) {
    String? amountValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Amount is required";
      }
      return null;
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              constraints: const BoxConstraints(
                  minWidth: 100, maxWidth: double.infinity),
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: TSizes.xs),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.headlineLarge,
                    validator: amountValidator,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      prefixIcon: Text(
                        "₱",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: TColors.darkGrey,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: '0',
                      hintStyle:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: TColors.darkGrey,
                                fontWeight: FontWeight.normal,
                              ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: TSizes.sm),
          Flexible(
            flex: 1,
            child: Container(
              constraints:
                  const BoxConstraints(minWidth: 80, maxWidth: double.infinity),
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paid via',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: TSizes.xs),
                  DropdownButtonFormField(
                    isDense: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: TColors.black),
                    items:
                        <String>['Cash', 'Card', 'Online'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: _controller.mode.value,
                    onChanged: (String? newValue) =>
                        _controller.mode.value = newValue!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              'Category: ${_controller.selectedCategory.value}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              return Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _controller.budgets.map((item) {
                    int index = _controller.budgets.indexOf(item);
                    return SizedBox(
                      height: 40,
                      width: 40,
                      child: Material(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusMd,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusMd,
                          ),
                          onTap: () {
                            _controller.category.value =
                                _controller.budgets[index].categoryId;
                            _controller.selectedCategory.value =
                                _controller.budgets[index].name;
                          },
                          child: Center(
                            child: Icon(
                              ExpenseCategory.icons[
                                  _controller.budgets[index].categoryId - 1],
                              size: TSizes.iconSm,
                              color: TColors.lighten(Colors.blue, 0.4),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
