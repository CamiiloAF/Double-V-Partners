import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({
    required this.formGroup, required this.fields, super.key,
  });

  final FormGroup formGroup;
  final List<Widget> fields;

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.fields,
      ),
    );
  }
}
