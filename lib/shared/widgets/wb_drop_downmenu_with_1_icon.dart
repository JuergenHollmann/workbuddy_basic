import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbDropDownMenu extends StatelessWidget {
  const WbDropDownMenu({
    super.key,
    required this.label,
    required this.dropdownItems,
    required this.leadingIconInTextField,
    this.leadingIconsInMenu,
    this.backgroundColor, this.labelBackgroundColor,
  });

  final String label;
  final List<String> dropdownItems;
  final IconData leadingIconInTextField;
  final List<IconData>? leadingIconsInMenu;
  final Color? backgroundColor;
  final Color? labelBackgroundColor;


  @override
  Widget build(BuildContext context) {
    log("0020 - WbDropDownMenu - aktiviert");

    return DropdownMenu(
      width: 400,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: wbColorLogoBlue,
      ),
      label: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), // nur für das Label
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: wbColorButtonBlue,
            backgroundColor: labelBackgroundColor,
          ),
        ),
      ),
      leadingIcon: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: Icon(
          // sichtbar im Statusfeld
          //Icons.folder_shared_outlined,
          leadingIconInTextField,
          size: 30,
        ),
      ),
      menuHeight: 320, // ausklappbare Maximalhöhe
      hintText: "Bitte auswählen", // funzt nicht?

      //decoration: InputDecoration()
      inputDecorationTheme: InputDecorationTheme(
        //contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 8),

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
          leadingIcon: Icon(
            // Icons.pending_actions_outlined,
            leadingIconsInMenu?[index],
            size: 30,
          ),
          value: index,
          label: dropdownItems[index],
        ),
      ).toList(),
      /*--------------------------------- *** ---*/
    );
  }
}
