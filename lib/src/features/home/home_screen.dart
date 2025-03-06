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
            _buildStatsCard(percentage, context, formatter, balance,
                totalBudget, totalExpenses),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    onChanged: dropdownCallBack,
                    value: selectedValue,
                    dropdownStyleData: DropdownStyleData(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      offset: const Offset(-32, -3),
                    ),
                    customButton: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        child: Text(
                          'View All',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    items: ExpenseCategory.categories
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
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
                            bool isFirst = index == 0;
                            bool isLast =
                                index == _controller.expenses.length - 1;
                            return ListTile(
                              tileColor: TColors.white,
                              leading: const Icon(Icons.local_taxi),
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
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Cash',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: isFirst
                                      ? const Radius.circular(
                                          TSizes.borderRadiusLg)
                                      : Radius.zero,
                                  bottom: isLast
                                      ? const Radius.circular(
                                          TSizes.borderRadiusLg)
                                      : Radius.zero,
                                ),
                              ),
                              onTap: () => log("Tap tap"),
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
            // Obx(() {
            //   return Expanded(
            //     child: ListView.builder(
            //       itemCount: expenseController.expenses.length,
            //       itemBuilder: (_, index) {
            //         ExpenseModel expense = expenseController.expenses[index];
            //         return ListTile(
            //           tileColor: TColors.white,
            //           title: Text(expense.description),
            //           trailing: Text('${expense.amount} Php'),
            //           subtitle: Text(expense.createdDate.toIso8601String()),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: index == 0
            //                 ? const BorderRadius.vertical(
            //                     top: Radius.circular(TSizes.borderRadiusLg))
            //                 : index == expenseController.expenses.length - 1
            //                     ? const BorderRadius.vertical(
            //                         bottom: Radius.circular(
            //                             TSizes.borderRadiusLg))
            //                     : BorderRadius.zero,
            //           ),
            //           onTap: () => log("Tap tap"),
            //         );
            //       },
            //     ),
            //   );
            // }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    double percentage,
    BuildContext context,
    NumberFormat formatter,
    double balance,
    double totalBudget,
    double totalExpenses,
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
                              
                        Text(
                          formatter.format(balance),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                height: 0.8,
                                color: percentage <= 0.35
                                    ? TColors.white
                                    : TColors.primary,
                              ),
                        ),
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
                          totalBudget,
                        ),
                        _buildExpenses(
                          context,
                          percentage,
                          formatter,
                          totalExpenses,
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
      NumberFormat formatter, double totalExpenses) {
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
        Text(
          formatter.format(totalExpenses),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: percentage < 0.7 ? TColors.white : TColors.primary,
              ),
        )
      ],
    );
  }

  Widget _buildBudget(BuildContext context, double percentage,
      NumberFormat formatter, double totalBudget) {
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
        Text(
          formatter.format(totalBudget),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: percentage < 0.7 ? TColors.white : TColors.primary,
              ),
        )
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
          onPressed: () {},
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
