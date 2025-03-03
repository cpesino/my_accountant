import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:my_accountant/src/common/widgets/test_widget.dart';
import 'package:my_accountant/src/controller/auth_controller.dart';
import 'package:my_accountant/src/models/user_model.dart';
import 'package:my_accountant/src/util/constants/colors.dart';
import 'package:my_accountant/src/util/constants/expense_category.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthController _authController = Get.find();

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final UserModel? user = _authController.user.value;

    String? selectedValue; // = 'View All';
    var formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    double totalBudget = 100;
    double totalExpenses = 27;
    double balance = totalBudget - totalExpenses;
    double percentage = 0.9 - (balance / totalBudget);

    void dropdownCallBack(String? selectedValue) {}


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user, context),
            // Container(
            //   height: 200,
            //   child:
            // ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Card(
              elevation: 20,
              shadowColor: TColors.lightGrey,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: ClipPath(
                clipper: const ShapeBorderClipper(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
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
                        // decoration: const BoxDecoration(
                        //   gradient: LinearGradient(
                        //     colors: [
                        //       Color(0xff20aee2),
                        //       Color(0xffc766e0),
                        //       Color(0xfffe9372)
                        //     ],
                        //     stops: [0, 0.5, 1],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //   ),
                        // ),
                        child: Column(
                          children: [
                            Text(
                              'Total Balance',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: percentage <= 0.2
                                        ? TColors.lighten(
                                            TColors.primary,
                                            0.3,
                                          )
                                        : TColors.lighten(TColors.primary),
                                  ),
                            ),
                            Text(
                              '₱ ${formatter.format(balance)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: percentage <= 0.35
                                        ? TColors.white
                                        : TColors.lighten(TColors.primary),
                                  ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Budget',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: percentage <= 0.6
                                                ? TColors.lighten(
                                                    TColors.primary,
                                                    0.3,
                                                  )
                                                : TColors.lighten(
                                                    TColors.primary),
                                          ),
                                    ),
                                    Text(
                                      formatter.format(totalBudget),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: percentage < 0.7
                                                ? TColors.white
                                                : TColors.lighten(
                                                    TColors.primary),
                                          ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expenses',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: percentage <= 0.6
                                                ? TColors.lighten(
                                                    TColors.primary,
                                                    0.3,
                                                  )
                                                : TColors.lighten(
                                                    TColors.primary),
                                          ),
                                    ),
                                    Text(
                                      formatter.format(totalExpenses),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: percentage < 0.7
                                                ? TColors.white
                                                : TColors.lighten(
                                                    TColors.primary),
                                          ),
                                    )
                                  ],
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
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
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
          ],
        ),
      ),
    );
  }

  Row _buildHeader(UserModel? user, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${user?.name}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
