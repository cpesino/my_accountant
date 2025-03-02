// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_accountant/src/util/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.name,
    this.isPasswordField = false,
    this.hintText,
    this.initialValue,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String name;
  final String? hintText;
  final String? initialValue;
  final bool enabled;
  final bool? isPasswordField;
  final InputDecoration? decoration;
  final FormFieldValidator? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(50, 50, 93, 0.25),
            blurRadius: 60,
            spreadRadius: -12,
            offset: Offset(0, 30),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 36,
            spreadRadius: -18,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: TColors.black, fontWeight: FontWeight.bold),
        decoration: widget.decoration ??
            InputDecoration(
              hintText: widget.hintText,
              labelText: widget.name,
              filled: true,
              fillColor: TColors.lightGrey,
              hoverColor: TColors.white,
              errorStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: TColors.error),
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: TColors.darkGrey),
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: TColors.darkGrey),
              suffixIcon: widget.isPasswordField ?? false
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscured = !obscured;
                        });
                      },
                      icon: Icon(
                        obscured ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                      ),
                    )
                  : null,
            ),
        initialValue: widget.initialValue,
        obscureText: widget.isPasswordField ?? false ? obscured : false,
        enabled: widget.enabled,
      ),
    );
  }
}
