import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  String selectedValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.selectedValue,
      items: const [
        DropdownMenuItem(
          value: 'Cash',
          child: Text('Cash'),
        ),
        DropdownMenuItem(
          value: 'Online',
          child: Text('Online'),
        ),
        DropdownMenuItem(
          value: 'Card',
          child: Text('Card'),
        ),
      ],
      onChanged: widget.onChanged,
    );
  }
}
