import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.label,
    required this.onDateTimeChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onTap: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
    );
  }
}
