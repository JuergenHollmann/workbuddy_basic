// Dieser Radiobutton soll nur in der Datenbank gespeichert sein.
// Ist der Kontakt ein Interessent oder ein Kunde (hat schon etwas gekauft)?

import 'dart:developer';

import 'package:flutter/material.dart';

class ContactRadioButton1 extends StatefulWidget {
  const ContactRadioButton1({super.key});

  // final void Function(String) onChange;
  // final String startGroupValue;

  @override
  State<ContactRadioButton1> createState() => _ContactRadioButton1State();
}

class _ContactRadioButton1State extends State<ContactRadioButton1> {
  // mit "late" wird eine Variable initialisiert ohne ihr sofort einen Wert zuzuweisen:
  // late String groupValue;

  // mit "initState" wird der State aufgerufen wenn ein StatefulWidget erstellt wird:
  // @override
  // void initState() {
  //   super.initState();
  //   groupValue = widget.startGroupValue;
  // }

  @override
  Widget build(BuildContext context) {
    log("0031 - ContactRadioButton1 - wird benutzt");

    return Column(
      children: [
        Container(
          width: 398,
          height: 60,
          decoration: BoxDecoration(
            // color: groupValue == "Interessent"
            //     ? Colors.green.shade200
            //     : Colors.red.shade200,
            border: Border.all(color: Colors.grey, width: 5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
    //        child: Expanded(
              child: Row(
                children: [
                  Radio(
                      value: "Interessent",
                      groupValue: "Interessent", // vorher: groupValue,
                      onChanged: (value) {
                        setState(() {
                          // groupValue = value!;
                          //widget.onChange(value);

                          log("Interessent wurde angeklickt");
                        });
                      }),
                  const Text(
                    "Interessent",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Radio(
                      value: "Kunde",
                      groupValue: "Interessent", // vorher: groupValue,
                      onChanged: (value) {
                        setState(() {
                          // groupValue = value!;
                          //widget.onChange(value);
                          log("Kunde wurde angeklickt");
                        });
                      }),
                  const Text(
                    "Kunde",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
    //        ),
          ),
        ),
      ],
    );
  }
}
