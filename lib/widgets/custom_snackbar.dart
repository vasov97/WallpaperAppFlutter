import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Text(message),
    ),
  );
}
