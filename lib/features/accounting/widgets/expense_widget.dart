import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/config/wb_textfield_currency.dart';
import 'package:workbuddy/config/wb_textfield_notice.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';
import 'package:workbuddy/shared/widgets/wb_drop_down_menu_with_icon.dart';
import 'package:workbuddy/shared/widgets/wb_drop_down_menu_without_icon.dart';
import 'package:workbuddy/shared/widgets/wb_text_fixed_not_writable.dart';

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget({super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    log("0024 - ExpenseWidget - wird benutzt");

    return Column(
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
            backgroundColor: wbColorBackgroundRed
            // leadingIconsInMenu: [
            //   Icons.access_time,
            //   Icons.house_outlined,
            //   Icons.handyman_outlined,
            //   Icons.cable_outlined,
            //   Icons.pending_actions_outlined,
            //   Icons.car_repair_outlined,
            // ],
            ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
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
                dropdownItems: ["Stk", "kg", "gr", "Pkg", "ltr", "mtr"],
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth8,
            /*--------------------------------- MwSt ---*/
            Expanded(
              child: WbDropDownMenuWithoutIcon(
                label: "MwSt %",
                dropdownItems: ["0 %", "7 %", "19 %"],
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- MWSt. berechnet ---*/
        const Row(
          children: [
            Expanded(
              child: WbTextFixedNotWritable(
                headlineText: "MwSt. berechnet:",
                hintText: "********** €",
                wbTextFieldWidth: 200,
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,

            // ------ Endpreis € ------
            Expanded(
              child: WBTextFieldCurrency(
                headlineText: "Endpreis in €",
                hintText: "Endpreis in € eintragen!",
              ),
            ),
          ],
        ),

        // wbSizedBoxHeight16,

        // // ------ Warengruppe ------
        // const WBDropdownMenu(
        //   headlineText: "Warengruppe",
        //   hintText: "Bitte die Warengruppe zuordnen",
        // ),

        // wbSizedBoxHeight16,

        // // ------ Wer hat eingekauft? ------
        // const WBDropdownMenu(
        //   headlineText: "Wer hat eingekauft?",
        //   hintText: "Bitte Einkäufer*in zuordnen",
        // ),

        wbSizedBoxHeight16,

        // ------ Notizen ------
        const WBTextfieldNotice(
          headlineText: "Notizen zum Einkauf",
          hintText: "- Notizen zum Einkauf HIER eingeben -",
        ),

        const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),

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
            },
          ),
        ),
      ],
    );
  }
}
