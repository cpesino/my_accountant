import 'package:flutter/material.dart';
import 'package:my_accountant/src/util/constants/colors.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';

class ErrorBox extends StatefulWidget {
  const ErrorBox({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  State<ErrorBox> createState() => _ErrorBoxState();
}

class _ErrorBoxState extends State<ErrorBox> {
  bool isRemoved = false;

  _remove() {
    setState(() {
      isRemoved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isRemoved
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Container(
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: TColors.lighten(TColors.error, 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TColors.lighten(TColors.error, 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.errorMessage,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: TColors.textWhite),
                  ),
                  IconButton(
                    onPressed: _remove,
                    icon: const Icon(
                      Icons.close,
                      size: TSizes.md,
                      color: TColors.light,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          );
  }
}
