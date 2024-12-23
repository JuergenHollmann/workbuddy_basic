import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';

class ButtonAccounting extends StatelessWidget {
  const ButtonAccounting({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: GestureDetector(
        onTap: () {
          log("0018 - ButtonAccounting - Wechsle zur Seite AccountingMenu");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountingMenu(),
            ),
          );
        },
        child: const Image(
          image: AssetImage("assets/icon_button_buchhaltung.png"),
        ),
      ),
    );
  }
}
