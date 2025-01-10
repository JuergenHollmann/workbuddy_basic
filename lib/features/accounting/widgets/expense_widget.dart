import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_0_icon.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget({super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

/* Variablen um die Preise zu berechnen - 0260 */
double quantity = 0.00; // Eingabe
double quantityPrice = 0.00; // berechnet

String item = 'Stk'; // Eingabe

double taxPercent = 19.00; // Eingabe
double taxOnNettoItemPrice = 0.00; // berechnet
double taxOnNettoQuantityPrice = 0.00; // berechnet

double taxOnBruttoItemPrice = 0.00; // berechnet
double taxOnBruttoQuantityPrice = 0.00; // berechnet

double nettoItemPrice = 0.00; // Eingabe - später im Update
double nettoQuantityPrice = 0.00; // berechnet

double bruttoItemPrice = 0.00; // Eingabe oder berechnet
double bruttoQuantityPrice = 0.00; // Eingabe oder berechnet

double taxSum = 0.00; // berechnet
double totalSum = 0.00; // berechnet

/*--------------------------------- Controller ---*/
final TextEditingController quantityController =
    TextEditingController(); // Eingabe
final TextEditingController itemController = TextEditingController(); // Eingabe
final TextEditingController taxPercentController =
    TextEditingController(); // Eingabe

final TextEditingController bruttoItemPriceController =
    TextEditingController(); // Eingabe oder berechnet
final TextEditingController bruttoQuantityPriceController =
    TextEditingController(); // Eingabe oder berechnet

void getCalculationResult() {
  /* die einzelnen Positionen berechnen */
  /* die Ergebnisse sind mit ".toStringAsFixed(2)" auf 2 Stellen nach dem Komma gekürzt */
  log('0059 - getCalculationResult - String: ${quantityController.text} ==> double: $quantity'); // Anzahl
  log('0060 - getCalculationResult - String: ${itemController.text} ==> double: $item'); // Einheiten
  log('0061 - getCalculationResult - String: ${taxPercentController.text} ==> double: $taxPercent'); // Mehrwertsteuer
  log('0062 - getCalculationResult - String: ${bruttoItemPriceController.text} ==> double: $bruttoItemPrice €'); // Brutto-Einzel
  log('0064 - getCalculationResult - String: ${bruttoQuantityPriceController.text} ==> double: $bruttoQuantityPrice €');  // Brutto-Gesamt

  // Netto-Einzel im Update
  // Netto-Gesamt im Update

  // Validator wegen Schreibweise der Zahlenformate

  //'${bruttoQuantityPrice.toStringAsFixed(2)} €',
  log("--------------------------------------------------------------------------");

  /* Anzahl * Brutto-Einzelpreis = Brutto-Gesamtpreis berechnen */
  bruttoQuantityPrice = bruttoItemPrice * quantity;
  log('0684 - ExpenseWidget - Gesamtpreis berechnet: ${bruttoQuantityPrice.toStringAsFixed(2)} €');
  /* den Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnen */
  // nettoItemPrice = bruttoItemPrice / 1.19;
  log('$bruttoItemPrice');
  /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */
  NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
  String bruttoItemPriceX = formatter.format(bruttoItemPrice); // funzt nicht
  log(bruttoItemPriceX);
  log('0688 - ExpenseWidget - Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
  log('---> Rundungsfehler wegen Rechnungszahl $nettoItemPrice');
  log('---> Rechnungszahl $bruttoItemPriceX');
  // nettoItemPrice = bruttoItemPriceX / 1.19;
  // nettoItemPrice = double.parse(nettoItemPrice as String);
  //nettoItemPrice = nettoQuantityPrice.toStringAsFixed(2);
  log("--------------------------------------------------------------------------");
  /* den Netto-Gesamtpreis berechnen */
  nettoQuantityPrice = nettoItemPrice * quantity;
  log('0093 - ExpenseWidget - Netto-Gesamtpreis berechnet: ${nettoQuantityPrice.toStringAsFixed(2)} €');

  /* die MwSt. aus dem Netto-Einzelpreis berechnen */
  taxOnNettoItemPrice = nettoItemPrice * (taxPercent / 100);
  log('0097 - ExpenseWidget - Mwst. aus dem Netto-Einzelpreis berechnet: ${taxOnNettoItemPrice.toStringAsFixed(2)} €');

  /* die MwSt. aus dem Netto-Einzelpreis * Anzahl, Gewicht, Stück?  berechnen */
  taxOnNettoQuantityPrice = nettoItemPrice * quantity * (taxPercent / 100);
  log('0101 - ExpenseWidget - Mwst. aus dem Netto-Gesamtpreis berechnet: ${taxOnNettoQuantityPrice.toStringAsFixed(2)} €');

  /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
  taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
  log('0105 - ExpenseWidget - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

  /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
  taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
  log('0109 - ExpenseWidget - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

  /* die MwSt. aus dem Brutto-Gesamtpreis berechnen */
  taxOnBruttoQuantityPrice = bruttoQuantityPrice * (taxPercent / 100);
  log('0113 - ExpenseWidget - Mwst. aus dem Brutto-Gesamtpreis berechnet: ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');
  log("--------------------------------------------------------------------------");

  // double getInvoiceResult(doublebruttoItemPrice, double quantity) {
  // double taxPercent = 19;

  taxSum = bruttoItemPrice * quantity * (taxPercent / 100);
  totalSum = bruttoItemPrice * quantity + taxSum;
  nettoItemPrice = bruttoItemPrice / (1 + 0.19);
  log('0122 - ExpenseWidget - Netto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
  log("--------------------------------------------------------------------------");
  log("Netto-Einzelpreis:    ${nettoItemPrice.toStringAsFixed(2)} € pro Einheit");
  log("Gekaufte Einheiten:   $quantity Stück");
  log("Mehrwertsteuer:       ${taxSum.toStringAsFixed(2)} €");
  log("Gesamtsumme           ${totalSum.toStringAsFixed(2)} €");
  log("--------------------------------------------------------------------------");
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    log("0024 - ExpenseWidget - wird benutzt");

    return
        // Scaffold(
        //   backgroundColor: const Color.fromARGB(255, 250, 242, 242),
        //   /*--------------------------------- AppBar ---*/
        //   appBar:

        //  AppBar(
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
        // /*--------------------------------- *** ---*/
        // body:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          leadingIconsInMenu: [
            Icons.send_rounded,
            Icons.cancel_outlined,
            Icons.handyman_outlined,
            Icons.cable_outlined,
            Icons.pending_actions_outlined,
            Icons.car_repair_outlined,
          ],
          leadingIconInTextField: Icons.house_outlined,
          backgroundColor: wbColorBackgroundRed,
          width: 400,
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
          leadingIconsInMenu: [
            Icons.toc_outlined,
            Icons.token_outlined,
            Icons.handyman_outlined,
            Icons.cable_outlined,
            Icons.pending_actions_outlined,
            Icons.car_repair_outlined,
          ],
          leadingIconInTextField: Icons.card_travel_outlined,
          width: 400,
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
        /*----------------------------------------------------------------------------*/
        /* Weil die Auflösung der Eingabefelder in einem iPhone anders aussieht und in einem Android-Phone weniger Platz ist, wird dieser Bereich vorläufig auskommentiert und wegen der besseren Darstellung auf beiden Gerätetypen einfach untereinander dargestellt. */
        /*----------------------------------------------------------------------------*/
        // /*--------------------------------- Anzahl ---*/
        // Row(
        //   children: [
        //     SizedBox(
        //       width: 120,
        //       child: WbTextFormFieldTEXTOnly(
        //         labelText: "Anzahl",
        //         labelFontSize20: 18,
        //         hintText: "Anzahl",
        //         inputTextFontSize22: 22,
        //         inputFontWeightW900: FontWeight.w900,
        //         inputFontColor: wbColorLogoBlue,
        //         fillColor: wbColorBackgroundRed,
        //         textInputTypeOnKeyboard: TextInputType.numberWithOptions(
        //           decimal: true,
        //           signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
        //         ),
        //         /*--------------------------------- onChanged ---*/
        //         controller: quantityController,
        //         onChanged: (String quantityController) {
        //           log("0140 - ExpenseWidget - quantityController - Eingabe: $quantityController - als String");
        //           quantity = double.parse(quantityController);
        //           setState(() => quantity = double.parse(quantityController));
        //           log("0144 - ExpenseWidget - quantityController - Eingabe: $quantity - als double");
        //         },
        //         /*--------------------------------- *** ---*/
        //       ),
        //     ),
        //     /*--------------------------------- Abstand ---*/
        //     wbSizedBoxWidth8,
        //     /*--------------------------------- Units/Einheit ---*/
        //     Expanded(
        //       child: WbDropDownMenuWithoutIcon(
        //         label: 'Einheiten',
        //         dropdownItems: ["Stk", "kg", "gr", "Pkg", "Ltr", "Mtr"],
        //         backgroundColor: wbColorBackgroundRed,
        //       ),
        //     ),
        //     /*--------------------------------- Abstand ---*/
        //     wbSizedBoxWidth8,
        //     /*--------------------------------- MwSt ---*/
        //     Expanded(
        //       child: WbDropDownMenuWithoutIcon(
        //         label: "MwSt",
        //         dropdownItems: ["0 %", "7 %", "19 %"],
        //         backgroundColor: wbColorBackgroundRed,
        //       ),
        //     ),
        //   ],
        // ),
        // /*--------------------------------- Abstand ---*/
        // wbSizedBoxHeight16,
        // /*--------------------------------- Einzelpreis Brutto € ---*/
        // Row(
        //   children: [
        //     Expanded(
        //       child: WbTextFormFieldTEXTOnly(
        //         labelText: "Einzelpreis Brutto €",
        //         labelFontSize20: 18,
        //         hintText: "Brutto €",
        //         inputTextFontSize22: 18,
        //         inputFontWeightW900: FontWeight.w900,
        //         inputFontColor: wbColorLogoBlue,
        //         fillColor: wbColorBackgroundRed,
        //         textInputTypeOnKeyboard: TextInputType.numberWithOptions(
        //           decimal: true,
        //           signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
        //         ),
        //         /*--------------------------------- onChanged ---*/
        //         controller:bruttoItemPriceController,
        //         onChanged: (StringbruttoItemPriceController) {
        //           log("0183 - ExpenseWidget -bruttoItemPriceController - Eingabe: $itemPriceController - als String");
        //          bruttoItemPrice = double.parse(itemPriceController);
        //           setState(() =>bruttoItemPrice = double.parse(itemPriceController));
        //           log("0186 - ExpenseWidget -bruttoItemPriceController - Eingabe: $itemPrice - als double");
        //         },
        //         /*--------------------------------- *** ---*/
        //       ),
        //     ),
        //     /*--------------------------------- Abstand ---*/
        //     wbSizedBoxWidth8,
        //     Text(''),
        //     wbSizedBoxWidth8,
        //     /*--------------------------------- Gesamtpreis Brutto € ---*/
        //     Expanded(
        //       child: WbTextFormFieldTEXTOnly(
        //         labelText: "Gesamtpreis Brutto €",
        //         labelFontSize20: 18,
        //         hintText: "Insgesamt €",
        //         inputTextFontSize22: 22,
        //         inputFontWeightW900: FontWeight.w900,
        //         inputFontColor: wbColorLogoBlue,
        //         fillColor: wbColorBackgroundRed,
        //         textInputTypeOnKeyboard: TextInputType.numberWithOptions(
        //           decimal: true,
        //           signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
        //         ),
        //         /*--------------------------------- onChanged ---*/
        //         controller: bruttoQuantityPriceController,
        //         onChanged: (String bruttoQuantityPriceController) {
        //           log("0212 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: $bruttoQuantityPriceController - als String");
        //           nettoQuantityPrice = double.parse(bruttoQuantityPriceController);
        //           setState(() =>
        //               nettoQuantityPrice = double.parse(bruttoQuantityPriceController));
        //           log("0215 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: $nettoQuantityPrice - als double");
        //         },
        //         /*--------------------------------- *** ---*/
        //       ),
        //     ),
        //   ],
        // ),
        /*----------------------------------------------------------------------------*/

        /*--------------------------------- Anzahl ---*/
        Row(
          children: [
            Text(
              'Anzahl der Artikel?         ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,
            /*--------------------------------- Anzahl der Artikel ---*/
            Expanded(
              child: SizedBox(
                width: 180,
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
                    signed:
                        true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                  ),
                  /*--------------------------------- onChanged ---*/
                  controller: quantityController,
                  onChanged: (String quantityController) {
                    log("0287 - ExpenseWidget - quantityController - Eingabe: $quantityController - als String");
                    /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
                    if (quantityController == "") {
                      log('0290 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$quantityController" ---> als String');
                      quantityController = "0.00";
                      log('0293 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$quantityController" ---> als String');
                    }
                    quantity = double.parse(quantityController);
                    setState(() => quantity = double.parse(quantityController));
                    log("0297 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $quantity ---> als double");
                    // setState(() {
                    //  bruttoItemPrice = double.parse(bruttoItemPriceController);
                    //   log('0366 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: "$bruttoItemPriceController" ---> im TextFormField eingetragen? ---> NEIN !!! todo');
                    // });
                    getCalculationResult();
                  },
                  /*--------------------------------- *** ---*/
                ),
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Units/Einheit ---*/
        Row(
          children: [
            Text(
              'Welche Einheiten?          ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,
            /*--------------------------------- *** ---*/
            Expanded(
              child: SizedBox(
                width: 100,
                child: WbDropDownMenuWithoutIcon(
                  width: 20,
                  label: 'Einheiten',
                  dropdownItems: [
                    "Stk",
                    "kg",
                    "gr",
                    "Pkg",
                    "Ltr",
                    "Mtr",
                    "???"
                  ],
                  backgroundColor: wbColorBackgroundRed,
                ),
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- MwSt ---*/
        Row(
          children: [
            Text(
              'Mehrwertsteuer in %:   ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,
            /*--------------------------------- *** ---*/
            Expanded(
              child: WbDropDownMenuWithoutIcon(
                width: 100,
                label: "MwSt",
                dropdownItems: ["0 %", "7 %", "19 %"],
                backgroundColor: wbColorBackgroundRed,
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Einzelpreis Brutto € ---*/
        Row(
          children: [
            Text(
              'Einzelpreis Brutto:   ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,
            /*--------------------------------- *** ---*/
            Expanded(
              child: WbTextFormFieldTEXTOnly(
                labelText: "Einzelpreis €",
                labelFontSize20: 18,
                hintText: "Einzelpreis",
                inputTextFontSize22: 22,
                inputFontWeightW900: FontWeight.w900,
                inputFontColor: wbColorLogoBlue,
                fillColor: wbColorBackgroundRed,
                textInputTypeOnKeyboard: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                ),
                /*--------------------------------- onChanged ---*/
                controller: bruttoItemPriceController,
                onChanged: (String bruttoItemPriceController) {
                  /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
                  if (bruttoItemPriceController == "") {
                    log('0355 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoItemPriceController" ---> als String');
                    bruttoItemPriceController = "0.00";
                    //bruttoItemPrice = double.parse(itemPriceController);
                    log('0357 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoItemPriceController" ---> als String');
                  }
                  bruttoItemPrice = double.parse(bruttoItemPriceController);
                  setState(() => bruttoItemPrice =
                      double.parse(bruttoItemPriceController));
                  log("0368 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoItemPrice ---> als double");
                  //bruttoItemPrice = double.parse(itemPriceController);
                  // setState(() {
                  //  bruttoItemPrice = double.parse(bruttoItemPriceController);
                  //   log('0366 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: "$bruttoItemPriceController" ---> im TextFormField eingetragen? ---> NEIN !!! todo');
                  // });
                  getCalculationResult();
                },
                /*--------------------------------- *** ---*/
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Gesamtpreis Brutto € ---*/
        Row(
          children: [
            Text(
              'Gesamtpreis Brutto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxWidth16,
            /*--------------------------------- *** ---*/
            Expanded(
              child: WbTextFormFieldTEXTOnly(
                labelText: "Gesamtpreis €",
                labelFontSize20: 18,
                hintText: "Gesamtpreis",
                inputTextFontSize22: 22,
                inputFontWeightW900: FontWeight.w900,
                inputFontColor: wbColorLogoBlue,
                fillColor: wbColorBackgroundRed,
                textInputTypeOnKeyboard: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true, // erlaubt ein "+" oder "-" Zeichen vor der Zahl
                ),
                /*--------------------------------- onChanged ---*/
                controller: bruttoQuantityPriceController,
                onChanged: (String bruttoQuantityPriceController) {
                  log("0212 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: $bruttoQuantityPriceController - als String");
                  /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
                  if (bruttoQuantityPriceController == "") {
                    log('0290 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoQuantityPriceController" ---> als String');
                    bruttoQuantityPriceController = "0.00";
                    log('0293 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoQuantityPriceController" ---> als String');
                  }
                  bruttoQuantityPrice =
                      double.parse(bruttoQuantityPriceController);
                  setState(() => bruttoQuantityPrice =
                      double.parse(bruttoQuantityPriceController));
                  log("0297 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoQuantityPrice ---> als double");
                  setState(() {
                   bruttoQuantityPrice = double.parse(bruttoQuantityPriceController);
                    log('0366 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: "$bruttoQuantityPriceController" ---> im TextFormField eingetragen? ---> NEIN !!! todo');
                  });
                  getCalculationResult();
                },
                /*--------------------------------- *** ---*/
              ),
            ),
          ],
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Container - Teil 1 - für Netto-Preise ---*/
        Container(
          width: 400,
          decoration: ShapeDecoration(
            color: wbColorBackgroundRed,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          child: Column(
            children: [
              /*--------------------------------- Netto-Einzelpreis OHNE MwSt. ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    Text(
                      'Netto-Einzelpreis OHNE MwSt.:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${nettoItemPrice.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Netto-Gesamtpreis ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    Text(
                      'Netto-Gesamtpreis für ${quantity.toStringAsFixed(2)} $item:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${nettoQuantityPrice.toStringAsFixed(2)} €',
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
        /*--------------------------------- Container - Teil 2 - für Berechnungen der MwSt. ---*/
        Container(
          width: 400,
          decoration: ShapeDecoration(
            color: wbColorBackgroundRed,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
          ),
          child: Column(
            children: [
              /*--------------------------------- Mehrwertsteuer für 1 Artikel ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    Text(
                      'Mehrwertsteuer für 1 Artikel:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${taxOnNettoItemPrice.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Mehrwertsteuer für alle Artikel ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    Text(
                      'Mehrwertsteuer für ${quantity.toStringAsFixed(2)} $item:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${taxOnNettoQuantityPrice.toStringAsFixed(2)} €',
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
        /*--------------------------------- Container - Teil 3 - für Bruttopreise ---*/
        Container(
          width: 400,
          decoration: ShapeDecoration(
            color: wbColorBackgroundRed,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          child: Column(
            children: [
              /*--------------------------------- Brutto-Einzelpreis (incl. MwSt.) ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    Text(
                      'Brutto-Einzelpreis INCLUSIVE MwSt.:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${bruttoItemPrice.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Brutto-Gesamtpreis für alle Artikel ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    Text(
                      'Brutto-Gesamtpreis für ${quantity.toStringAsFixed(2)} $item:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${bruttoQuantityPrice.toStringAsFixed(2)} €',
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

        //     /*--------------------------------- Im Gesamtpreis enthaltene MwSt. ---*/
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        //       child: Row(
        //         children: [
        //           Text(
        //             'Im Gesamtpreis enthaltene MwSt.:',
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           Expanded(
        //             child: Text(
        //               '${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //               textAlign: TextAlign.right,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        // ),
        /*--------------------------------- Abstand ---*/
        SizedBox(height: 12),
        /*--------------------------------- Abstand ---*/
        Center(
          child: SizedBox(
            width: 400,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 255, 204, 102)),
              ),
              onPressed: () {
                getCalculationResult();
                setState(() {});
              },
              child: Text(
                'Zur Kontrolle nochmals neu berechnen?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
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
          leadingIconsInMenu: [
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
            Icons.radio_button_checked_outlined,
          ],
          backgroundColor: wbColorBackgroundRed,
          width: 400,
        ),
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight16,
        /*--------------------------------- Wer hat eingekauft? ---*/
        WbDropDownMenu(
          label: 'Wer hat eingekauft?',
          dropdownItems: [
            'Jürgen',
            'Doris',
            'Almir',
            'Mario',
            'Jochen',
            'Johanna',
            'Maria',
            'Josef',
            'Gerhard',
            'Klaus',
          ],
          leadingIconInTextField: Icons.person_2_outlined,
          leadingIconsInMenu: [
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
            Icons.person_2_outlined,
          ],
          backgroundColor: wbColorBackgroundRed,
          width: 400,
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
      // ),
    );
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
