import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbDropDownMenu extends StatelessWidget {
  const WbDropDownMenu({
    super.key,
    required this.label,
    required this.dropdownItems,
    required this.leadingIconsInMenu,
  });

  final String label;
  final List<String> dropdownItems;
  // final IconData leadingIconsInMenu;
    final List<IconData> leadingIconsInMenu;


  @override
  Widget build(BuildContext context) {
    log("0020 - WbDropDownMenu - aktiviert");

    return DropdownMenu(
      width: 400,
      textStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w900, color: wbColorLogoBlue
          //backgroundColor: Colors.white,
          ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: wbColorButtonBlue,
          backgroundColor: wbColorLightYellowGreen,
        ),
      ),
      leadingIcon: Icon( // sichtbar im Statusfeld
        Icons.folder_shared_outlined,
        size: 30,
      ),
      menuHeight: 320, // ausklappbare Maximalhöhe
      hintText: "Bitte auswählen", // funzt nicht?
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        filled: true,
        fillColor: wbColorLightYellowGreen,

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
          leadingIcon: 
          // leadingIconsInMenu[index],
              Icon( // sichtbar im ausgeklappten Auswahlmenü
            Icons.folder_shared_outlined,
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
// \nWorkBuddy • Free-BASIC-Version 0.002
