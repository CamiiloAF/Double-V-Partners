import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.formControlName,
    required this.hint,
    required this.items,
  });

  final String formControlName;
  final String hint;
  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField(
      formControlName: formControlName,
      items: items,
      hint: Text(hint),
    );
  }
}
