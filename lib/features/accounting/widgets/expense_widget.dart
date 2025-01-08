import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';
import 'package:workbuddy/features/companies/screens/company_screen.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_0_icon.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget({super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    log("0024 - ExpenseWidget - wird benutzt");

    return

        // #Scaffold(
        //   backgroundColor: const Color.fromARGB(255, 250, 242, 242),
        //   /*--------------------------------- AppBar ---*/
        //   appBar:

        // return AppBar(
        //   title: const Text(
        //     'Beleg erfassen',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.w900,
        //       color: Colors.white, // Schriftfarbe
        //     ),
        //   ),
        //   backgroundColor: wbColorButtonDarkRed, // Hintergrundfarbe
        //   foregroundColor: Colors.white, // Icon-/Button-/Chevron-Farbe
        // ),
        /*--------------------------------- *** ---*/
        Column(
      children: [
        /*--------------------------------- Abstand ---*/
        // wbSizedBoxHeight8,
        /*--------------------------------- Wo eingekauft? ---*/
        WbDropDownMenu(
          /* Hier besser eine Map erstellen - ExpenseWidget - 0033 - todo */
          label: "Wo wurde eingekauft?",
          dropdownItems: [
            "OBI",
            "Kaufland",
            "Toom",
            "ACTION",
            "WOOLWORTH",
            "Tankstelle",
          ],
          // leadingIconsInMenu: [
          //   Icons.access_time,
          //   Icons.house_outlined,
          //   Icons.handyman_outlined,
          //   Icons.cable_outlined,
          //   Icons.pending_actions_outlined,
          //   Icons.car_repair_outlined,
          // ],
          leadingIconInTextField: Icons.house_outlined,
          backgroundColor: wbColorBackgroundRed,
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Was eingekauft? ---*/
        WbDropDownMenu(
          label: "Was wurde eingekauft?",
          dropdownItems: [
            "Dachlatten",
            "Spax-Schrauben",
            "Werkzeug",
            "Kabel",
            "Zubehör",
            "Tanken",
          ],
          backgroundColor: wbColorBackgroundRed,
          // leadingIconsInMenu: [
          //   Icons.access_time,
          //   Icons.house_outlined,
          //   Icons.handyman_outlined,
          //   Icons.cable_outlined,
          //   Icons.pending_actions_outlined,
          //   Icons.car_repair_outlined,
          // ],
          leadingIconInTextField: Icons.card_travel_outlined,
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight8,
        /*--------------------------------- Divider ---*/
        WbDividerWithTextInCenter(
            wbColor: wbColorButtonDarkRed,
            wbText: 'Einkaufspreis',
            wbTextColor: wbColorButtonDarkRed,
            wbFontSize12: 18,
            wbHeight3: 3),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight8,
        /*--------------------------------- Anzahl ---*/
        Row(
          children: [
            SizedBox(
              width: 120,
              child: WbTextFormFieldTEXTOnly(
                labelText: "Anzahl",
                labelFontSize20: 18,
                hintText: "Anzahl",
                inputTextFontSize22: 22,
                inputFontWeightW900: FontWeight.w900,
                inputFontColor: wbColorLogoBlue,
                fillColor: wbColorBackgroundRed,
                textInputTypeOnKeyboard: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                ),
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth8,
            /*--------------------------------- Units/Einheit ---*/
            Expanded(
              child: WbDropDownMenuWithoutIcon(
                label: 'Units',
                dropdownItems: ["Stk", "kg", "gr", "Pkg", "Ltr", "Mtr"],
                backgroundColor: wbColorBackgroundRed,
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth8,
            /*--------------------------------- MwSt ---*/
            Expanded(
              child: WbDropDownMenuWithoutIcon(
                label: "MwSt",
                dropdownItems: ["0 %", "7 %", "19 %"],
                backgroundColor: wbColorBackgroundRed,
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Einzelpreis € ---*/
        Row(
          children: [
            Expanded(
              child: WbTextFormFieldTEXTOnly(
                labelText: "Einzelpreis €",
                labelFontSize20: 18,
                hintText: "Einzeln €",
                inputTextFontSize22: 22,
                inputFontWeightW900: FontWeight.w900,
                inputFontColor: wbColorLogoBlue,
                fillColor: wbColorBackgroundRed,
                textInputTypeOnKeyboard: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                ),
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth8,
            Text(''),
            wbSizedBoxWidth8,
            /*--------------------------------- Gesamtpreis € ---*/
            Expanded(
              child: WbTextFormFieldTEXTOnly(
                labelText: "Gesamtpreis €",
                labelFontSize20: 18,
                hintText: "Insgesamt €",
                inputTextFontSize22: 22,
                inputFontWeightW900: FontWeight.w900,
                inputFontColor: wbColorLogoBlue,
                fillColor: wbColorBackgroundRed,
                textInputTypeOnKeyboard: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                ),
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- MWSt. berechnet ---*/
        Container(
          width: 400,
          decoration: ShapeDecoration(
            color: wbColorBackgroundRed,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            children: [
              /*--------------------------------- Im Einzelpreis enthaltene MwSt. ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'Im Einzelpreis enthaltene MwSt.:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '0,00 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Im Gesamtpreis enthaltene MwSt. ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text(
                      'Im Gesamtpreis enthaltene MwSt.:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '0,00 €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /*--------------------------------- Divider ---*/
        const Divider(thickness: 3, height: 32, color: wbColorButtonDarkRed),
        /*--------------------------------- Abstand ---*/
        //wbSizedBoxHeight8,
        /*--------------------------------- Warengruppe ---*/
        WbDropDownMenu(
          label: 'Kategorie / Warengruppe',
          dropdownItems: [
            'Werkzeug',
            'Zubehör',
            'Fahrzeug',
            'Büroartikel',
            'Versicherung'
          ],
          leadingIconInTextField: Icons.create_new_folder_outlined,
          backgroundColor: wbColorBackgroundRed,
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Wer hat eingekauft? ---*/
        WbDropDownMenu(
          label: 'Wer hat eingekauft?',
          dropdownItems: ['Jürgen', 'Doris', 'Almir', 'Mario', 'Jochen'],
          leadingIconInTextField: Icons.person_2_outlined,
          backgroundColor: wbColorBackgroundRed,
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Notizen zum Einkauf ---*/
        WbTextFormField(
          labelText: "Notizen zum Einkauf",
          labelFontSize20: 18,
          hintText: "- Notizen zum Einkauf HIER eingeben -",
          hintTextFontSize16: 12,
          inputTextFontSize22: 14,
          prefixIcon: Icons.shopping_basket_outlined,
          prefixIconSize28: 28,
          inputFontWeightW900: FontWeight.w900,
          inputFontColor: wbColorLogoBlue,
          fillColor: wbColorBackgroundRed,
          // suffixIcon: Icons.menu_outlined,
          // suffixIconSize48: 28,
          textInputTypeOnKeyboard: TextInputType.multiline,
        ),
        /*--------------------------------- Divider ---*/
        const Divider(thickness: 3, height: 32, color: wbColorButtonDarkRed),
        /*--------------------------------- *** ---*/
        // Button aus Vorlage verwenden:
        // solange die Pflichtfelder nicht ausgefüllt sind, soll der Button rot sein und beim Anklicken einen Alert ausgeben, sonst Button grün und Daten speichern + Dialog-Bestätigung.
        /*--------------------------------- Ausgabe speichern ---*/
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
          child: WbButtonUniversal2(
              wbColor: wbColorButtonDarkRed,
              wbIcon: Icons.payments_outlined,
              wbIconSize40: 40,
              wbText: 'Ausgabe SPEICHERN',
              wbFontSize24: 19,
              wbWidth155: 398,
              wbHeight60: 60,
              wbOnTap: () {
                log("0139 - ExpenseWidget - Ausgabe SPEICHERN - geklickt");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountingMenu(),
                  ),
                );
              }),
        )
      ],
    );
            //   /*--------------------------------- AppBar ---*/
    //   appBar:

    // return AppBar(
    //   title: const Text(
    //     'Beleg erfassen',
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.w900,
    //       color: Colors.white, // Schriftfarbe
    //     ),
    //   ),
    //   backgroundColor: wbColorButtonDarkRed, // Hintergrundfarbe
    //   foregroundColor: Colors.white, // Icon-/Button-/Chevron-Farbe
    // ),
    /*--------------------------------- *** ---*/

    // /*--------------------------------- WbInfoContainer ---*/
    // bottomSheet: WbInfoContainer(
    //   infoText:
    //       '$inputCompanyName • $inputCompanyVNContactPerson $inputCompanyNNContactPerson\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\nLetzte Änderung: Am 18.12.2024 um 22:51 Uhr', // todo 1030
    //   wbColors: Colors.yellow,
    // );
    /*--------------------------------- ENDE ---*/
    // );
  }
}
