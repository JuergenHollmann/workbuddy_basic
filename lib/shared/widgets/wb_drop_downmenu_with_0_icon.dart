import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbDropDownMenuWithoutIcon extends StatelessWidget {
  const WbDropDownMenuWithoutIcon({
    super.key,
    required this.label,
    required this.textFieldWidth,
    required this.dropdownItems,
    this.backgroundColor,
    this.labelBackgroundColor,
    this.controller, this.initialSelection,
  });

  final String label;
  final List<String> dropdownItems;
  final Color? backgroundColor;
  final Color? labelBackgroundColor;
  final double textFieldWidth;
  final TextEditingController? controller;
  final int? initialSelection;

  @override
  Widget build(BuildContext context) {
    log("0020 - WbDropDownMenuWithoutIcon - aktiviert");

    return DropdownMenu(
      controller: controller,
      initialSelection:
          initialSelection, // zeigt standardmäßig beim Aufruf der Seite den Eintrag am Index an
      textAlign: TextAlign.start, // horizontale Textausrichtung im Textfeld
      width: textFieldWidth, // Breite des Textfeldes
      textStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w900, color: wbColorLogoBlue),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: wbColorButtonBlue,
          backgroundColor: labelBackgroundColor,
        ),
      ),
      menuHeight: 320, // ausklappbare Maximalhöhe
      hintText: "Auswahl", // funzt nur mit "FloatingLabelBehavior.always"
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        constraints: BoxConstraints.tightFor(height: 46),
        floatingLabelAlignment:
            FloatingLabelAlignment.start, // Position des Labels oben
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: backgroundColor,

        /*--- border ---*/
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        outlineBorder: BorderSide(
          color: wbColorLogoBlue,
          width: 10,
        ),
      ),
      /*--------------------------------- *** ---*/
      dropdownMenuEntries: List.generate(
        dropdownItems.length,
        (index) => DropdownMenuEntry(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          value: index,
          label: dropdownItems[index],
        ),
      ).toList(),
      /*--------------------------------- *** ---*/
    );
  }
}
