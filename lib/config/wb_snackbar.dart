import 'dart:developer';

import 'package:flutter/material.dart';

class WbSnackbar extends StatelessWidget {
  const WbSnackbar(
      {super.key,
      required this.snackbarBackgroundColor,
      required this.snackbarDurationMilliseconds,
      this.snackBarText,
      this.snackBarTextStyle});

  final Color snackbarBackgroundColor;
  final int snackbarDurationMilliseconds;
  final String? snackBarText;
  final TextStyle? snackBarTextStyle;

  @override
  Widget build(BuildContext context) {
    log('0010 - WbSnackbar - gestartet ...');
    /*--------------------------------- Snackbar einblenden ---*/
    // ScaffoldMessenger.of(context).showSnackBar(
    return SnackBar(
      backgroundColor: snackbarBackgroundColor,
      duration: Duration(milliseconds: 1 * snackbarDurationMilliseconds),
      content: Text(
        snackBarText ?? 'Die Aktion wurde NICHT ausgeführt. 😉',
        style: snackBarTextStyle ??
            TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
    /*--------------------------------- *** ---*/
  }
}
