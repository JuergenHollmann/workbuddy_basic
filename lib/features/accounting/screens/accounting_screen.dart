import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/accounting/widgets/expense_widget.dart';
import 'package:workbuddy/features/accounting/widgets/income_widget.dart';
import 'package:workbuddy/features/accounting/widgets/radio_button_accounting.dart';


class AccountingScreen extends StatefulWidget {
  const AccountingScreen({
    super.key,
    required this.startGroupValue,
  });

  final String startGroupValue;

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  // mit "late" wird eine Variable initialisiert ohne ihr sofort einen Wert zuzuweisen:
  late String groupValue;

  // mit "initState" wird der State aufgerufen wenn ein StatefulWidget erstellt wird:
  @override
  void initState() {
    super.initState();
    groupValue = widget.startGroupValue;
  }

  @override
  Widget build(BuildContext context) {
    log("0035 - AccountingScreen - wird angezeigt");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      appBar: AppBar(
        title: const Text(
          'Beleg erfassen',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black, // Schriftfarbe
          ),
        ),
        backgroundColor: wbColorBackgroundBlue, // Hintergrundfarbe
        foregroundColor: Colors.black, // Icon-/Button-/Chevron-Farbe
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
              ),

              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),

              Row(
                children: [
                  RadioButtonAccounting(
                    startGroupValue: groupValue,
                    // Key: _buttonExpenseKey,
                    onChange: (newValue) {
                      groupValue = newValue;
                      setState(() {});
                    },
                  )
                ],
              ),

              // -- Divider ---------------------------------------------
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              if (groupValue == "Einnahme")
                const IncomeWidget()
              else
                const ExpenseWidget(),
              // const RadioButtonAccounting(),
              wbSizedBoxHeight8,
              // -- Divider ---------------------------------------------
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
            ],
          ),
        ),
      ),
    );
  }
}
