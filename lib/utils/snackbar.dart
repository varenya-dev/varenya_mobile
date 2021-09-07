import 'package:flutter/material.dart';

/*
 * Display a snackbar util.
 * @param message Message to be displayed.
 * @param context Context for displaying the snackbar.
 */
void displaySnackbar(String message, BuildContext context) {
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
