import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_accountant/src/common/widgets/shimmer_list.dart';
import 'package:my_accountant/src/features/home/home_controller.dart';
import 'package:my_accountant/src/util/constants/colors.dart';
import 'package:my_accountant/src/util/constants/expense_category.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());
  
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {

    String? selectedValue; // = 'View All';
    var formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: 2,
    );

    double totalBudget = 10000;
    double totalExpenses = 3000;
    double balance = totalBudget - totalExpenses;
    double percentage = 1 - (balance / totalBudget);

    void dropdownCallBack(String? selectedValue) {}

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: TSizes.spaceBtwSections),
            _buildStatsCard(percentage, context, formatter, _controller),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Obx(() {
              return _controller.isLoading.value
                  ? const ShimmerList(itemCount: 4)
                  : _controller.expenses.isNotEmpty
                      ? Column(
                          children: _controller.expenses.map((expense) {
                            int index = _controller.expenses.indexOf(expense);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: TSizes.sm),
                              child: ListTile(
                                tileColor: TColors.white,
                                leading: Obx(
                                  () => Icon(ExpenseCategory.icons[index - 1]),
                                ),
                                title: Text(expense.description),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '-${expense.amount} Php',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: TColors.error,
                                          ),
                                    ),
                                    Text(
                                      DateFormat("MMM d, y")
                                          .format(expense.createdDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  'Cash',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusLg,
                                  ),
                                ),
                                onTap: () => log("Tap tap"),
                              ),
                            );
                          }).toList(),
                        )
                      : SizedBox(
                          height: 300,
                          child: Center(
                            child: Text(
                              'Hooray! No transactions for today.',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddNewExpense(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> showAddNewExpense(BuildContext context) {
    String selectedMOP = 'Cash';

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
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
                Container(
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
                        'Amount',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.headlineLarge,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          prefixIcon: Text(
                            "₱",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: TColors.darkGrey,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          hintText: '0',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
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
                const SizedBox(height: TSizes.sm),
                Container(
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
                      TextField(
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Add description...',
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: TColors.darkGrey,
                                  ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.sm),
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FA),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                  child: Column(
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
                                        _controller.selectedCategory.value =
                                            _controller.budgets[index].name;
                                      },
                                      child: Center(
                                        child: Icon(
                                          ExpenseCategory.icons[_controller
                                                  .budgets[index].categoryId -
                                              1],
                                          size: TSizes.iconSm,
                                          color:
                                              TColors.lighten(Colors.blue, 0.4),
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
                ),
                const SizedBox(height: TSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _controller.selectedCategory.value = 'Select below';
                        _controller.selectedMOP.value = 'Cash';
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildStatsCard(
    double percentage,
    BuildContext context,
    NumberFormat formatter,
    HomeController controller,
  ) {
    return Card(
      elevation: 20,
      shadowColor: TColors.lightGrey,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: ClipPath(
        clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(TSizes.borderRadiusLg),
            ),
          ),
        ),
        child: SizedBox(
          height: 180,
          child: Stack(
            children: [
              WaveWidget(
                size: const Size(double.infinity, double.infinity),
                backgroundColor: Colors.white,
                waveAmplitude: 5,
                waveFrequency: 0.25,
                config: CustomConfig(
                  colors: [
                    TColors.darken(TColors.primary, 0.2),
                    TColors.darken(TColors.primary),
                    TColors.primary,
                  ],
                  durations: [
                    4000,
                    5500,
                    7000,
                  ],
                  heightPercentages: [
                    percentage,
                    percentage,
                    percentage,
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: percentage <= 0.2
                                ? TColors.lighten(
                                    TColors.primary,
                                    0.3,
                                  )
                                : TColors.lighten(TColors.primary),
                          ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            formatter.format(
                              controller.totalBudget.value!.toDouble() -
                                  controller.totalExpenses.value!.toDouble(),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  height: 0.8,
                                  color: percentage <= 0.35
                                      ? TColors.white
                                      : TColors.primary,
                                ),
                          );
                        }),
                        const SizedBox(width: TSizes.xs),
                        Text(
                          'Php',
                          style: TextStyle(
                            height: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: percentage <= 0.35
                                ? TColors.white
                                : TColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBudget(
                          context,
                          percentage,
                          formatter,
                          controller,
                        ),
                        _buildExpenses(
                          context,
                          percentage,
                          formatter,
                          controller,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenses(BuildContext context, double percentage,
      NumberFormat formatter, HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expenses',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: percentage <= 0.6
                    ? TColors.lighten(
                        TColors.primary,
                        0.3,
                      )
                    : TColors.lighten(TColors.primary),
              ),
        ),
        Obx(() {
          return Text(
            formatter.format(controller.totalExpenses.value?.toDouble()),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: percentage < 0.7 ? TColors.white : TColors.primary,
              ),
          );
        }),
        
      ],
    );
  }

  Widget _buildBudget(BuildContext context, double percentage,
      NumberFormat formatter, HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: percentage <= 0.6
                    ? TColors.lighten(
                        TColors.primary,
                        0.3,
                      )
                    : TColors.lighten(TColors.primary),
              ),
        ),
        Obx(() {
          return Text(
            formatter.format(controller.totalBudget.value?.toDouble()),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: percentage < 0.7 ? TColors.white : TColors.primary,
              ),
          );
        }),
        
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Text(
                'Hi ${_controller.name.value}!',
              style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            
            Text(
              'Your money, your control!',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        IconButton(
          onPressed: () => _controller.logout(),
          icon: Icon(
            Icons.notifications,
            color: TColors.lighten(TColors.buttonPrimary, 0.3),
          ),
          style: IconButton.styleFrom(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
            ),
            backgroundColor: TColors.lighten(TColors.buttonPrimary),
          ),
        ),
      ],
    );
  }
}
