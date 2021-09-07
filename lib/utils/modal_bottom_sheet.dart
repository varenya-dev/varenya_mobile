import 'package:flutter/material.dart';

/*
 * Display bottom modal sheet util.
 * @param context Context to display the modal sheet.
 * @body Body for the sheet.
 */
void displayBottomSheet(BuildContext context, Widget body) =>
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return body;
        });
