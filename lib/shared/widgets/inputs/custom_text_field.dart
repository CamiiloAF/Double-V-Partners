import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../theme/theme.dart';

class CustomTextField<T> extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.formControlName,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.bottomPadding,
    this.maxLength,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.valueAccessor,
    this.validationMessages,
  });

  final String formControlName;
  final double? bottomPadding;
  final String label;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ReactiveFormFieldCallback<T>? onTap;
  final ControlValueAccessor<T, String>? valueAccessor;
  final Map<String, String Function(Object)>? validationMessages;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    return Padding(
      padding: EdgeInsets.only(top: bottomPadding ?? 0),
      child: ReactiveTextField(
        style: theme.textTheme.bodySmall,
        formControlName: formControlName,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        readOnly: readOnly,
        validationMessages: validationMessages,
        onTap: onTap,
        maxLength: maxLength,
        valueAccessor: valueAccessor,
        decoration: InputDecoration(
          label: Text(label),
          counter: Offstage(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
