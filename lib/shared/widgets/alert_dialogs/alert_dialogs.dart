import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

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

void showSuccessUpdateSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Información actualizada correctamente')),
  );
}

void showSnackBarError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColorsTheme.error,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
