import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context, {
  required String content,
  String? title,
}) async {
  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title ?? 'Ups'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
