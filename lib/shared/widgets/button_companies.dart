import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:workbuddy/features/companies/screens/company_screen.dart';


class ButtonCompanies extends StatelessWidget {
  const ButtonCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: GestureDetector(
        onTap: () {
          log("0015 - ButtonCompanies - wechsle zur Seite CompanyScreen");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyScreen(),
            ),
          );
        },
        child: const Image(
          image: AssetImage("assets/icon_button_firmen.png"),
        ),
      ),
    );
  }
}
