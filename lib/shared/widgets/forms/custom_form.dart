import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({
    super.key,
    required this.formGroup,
    required this.fields,
    this.padding,
  });

  final FormGroup formGroup;
  final List<Widget> fields;
  final double? padding;

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: Padding(
        padding: EdgeInsets.all(widget.padding ?? 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.fields,
        ),
      ),
    );
  }
}
