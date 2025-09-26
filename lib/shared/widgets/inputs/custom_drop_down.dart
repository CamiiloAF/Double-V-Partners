import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.formControlName,
    required this.hintText,
    required this.items,
    required this.labelText,
    this.onChanged,
    this.prefixIcon,
    this.errorText,
  });

  final String formControlName;
  final String hintText;
  final String labelText;
  final String? errorText;
  final Widget? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final ReactiveFormFieldCallback<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField(
      formControlName: formControlName,
      items: items,
      hint: Text(hintText),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        errorText: errorText,
      ),
    );
  }
}
