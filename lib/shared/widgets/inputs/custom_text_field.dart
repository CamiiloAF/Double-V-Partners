import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../theme/theme.dart';

class CustomTextField<T> extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.bottomPadding,
    this.maxLength,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.valueAccessor,
    this.validationMessages,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.controller,
  });

  final String formControlName;
  final double? bottomPadding;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ReactiveFormFieldCallback<T>? onTap;
  final ControlValueAccessor<T, String>? valueAccessor;
  final Map<String, String Function(Object)>? validationMessages;
  final ReactiveFormFieldCallback<T>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    return Padding(
      padding: EdgeInsets.only(top: bottomPadding ?? 0),
      child: ReactiveTextField(
        style: theme.textTheme.bodySmall,
        controller: controller,
        formControlName: formControlName,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        readOnly: readOnly,
        validationMessages: validationMessages,
        onTap: onTap,
        maxLength: maxLength,
        onChanged: onChanged,
        valueAccessor: valueAccessor,
        decoration: InputDecoration(
          label: Text(labelText),
          hint: hintText != null ? Text(hintText!) : null,
          counter: Offstage(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
