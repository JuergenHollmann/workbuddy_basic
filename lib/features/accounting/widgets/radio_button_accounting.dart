import 'dart:developer';

import 'package:flutter/material.dart';

class RadioButtonAccounting extends StatefulWidget {
  const RadioButtonAccounting(
      {super.key, required this.onChange, required this.startGroupValue});

  final void Function(String) onChange;
  final String startGroupValue;

  @override
  State<RadioButtonAccounting> createState() => _RadioButtonAccountingState();
}

class _RadioButtonAccountingState extends State<RadioButtonAccounting> {
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
    log("0029 - RadioButtonAccounting - wird benutzt");

    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: groupValue == "Einnahme"
              ? Colors.green.shade200
              : Colors.red.shade200,
          border: Border.all(color: Colors.grey, width: 5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Spacer(flex: 1),
            Radio(
                value: "Einnahme",
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                    widget.onChange(value);
                    log("0061 - RadioButtonAccounting - Radio - Einnahme wurde angeklickt");
                  });
                }),
            const Text(
              "Einnahme",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Radio(
                value: "Ausgabe",
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                    widget.onChange(value);
                    log("0069 - RadioButtonAccounting - Radio - Ausgabe wurde angeklickt");
                  });
                }),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: const Text(
                "Ausgabe",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
