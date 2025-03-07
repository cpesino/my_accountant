// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_accountant/src/common/widgets/custom_text_field.dart';
import 'package:my_accountant/src/common/widgets/error_box.dart';
import 'package:my_accountant/src/controllers/auth_controller.dart';
import 'package:my_accountant/src/util/constants/colors.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode loginButtonFocus = FocusNode();

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    void _submitForm() async {
      if (_formKey.currentState!.validate()) {
        String username = usernameController.text;
        String password = passwordController.text;
        await authController.login(username: username, password: password);
        passwordController.text = '';
      }
    }

    String? _usernameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Username is required";
      }
      return null;
    }

    String? _passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Password is required";
      }
      return null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildLoginForm(
                _formKey,
                authController,
                usernameController,
                _usernameValidator,
                passwordController,
                _passwordValidator,
                context,
                loginButtonFocus,
                _submitForm,
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'It\'s good to see you again',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: TColors.darkGrey,
              ),
        ),
      ],
    );
  }

  Form _buildLoginForm(
      GlobalKey<FormState> _formKey,
      AuthController authController,
      TextEditingController usernameController,
      String? Function(String? value) _usernameValidator,
      TextEditingController passwordController,
      String? Function(String? value) _passwordValidator,
      BuildContext context,
      FocusNode loginButtonFocus,
      void Function() _submitForm) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Obx(() {
            return authController.errorMessage.isNotEmpty
                ? ErrorBox(
                    errorMessage: authController.errorMessage.value,
                  )
                : const SizedBox();
          }),
          const SizedBox(height: TSizes.xs),
          CustomTextField(
            controller: usernameController,
            validator: (value) => _usernameValidator(value),
            name: 'Username',
            hintText: 'Enter username',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: TSizes.sm),
          CustomTextField(
            controller: passwordController,
            validator: (value) => _passwordValidator(value),
            name: 'Password',
            hintText: 'Password',
            isPasswordField: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(loginButtonFocus),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                child: Text(
                  'Forgot password?',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextButton(
                focusNode: loginButtonFocus,
                onPressed: _submitForm,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.md,
                  ),
                  backgroundColor: TColors.buttonPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Login',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: TColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
