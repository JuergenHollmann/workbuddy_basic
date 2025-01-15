import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money2/money2.dart';
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

class _ExpenseWidgetState extends State<ExpenseWidget> {
  /*--------------------------------- Scroll-Controller ---*/
  final _formKey = GlobalKey<FormState>();

// /*--------------------------------- Scroll-Controller ---*/
// ScrollController _scrollcontroller = ScrollController();

/*--------------------------------- Controller ---*/
  final TextEditingController quantityController =
      TextEditingController(); // Eingabe
  final TextEditingController itemController =
      TextEditingController(); // Eingabe
  final TextEditingController taxPercentController =
      TextEditingController(); // Eingabe

  final TextEditingController bruttoItemPriceController =
      TextEditingController(); // Eingabe oder berechnet
  final TextEditingController bruttoQuantityPriceController =
      TextEditingController(); // Eingabe oder berechnet

/*--------------------------------- Variablen um die Preise zu berechnen ---*/
  double quantity = 0.00; // Eingabe
  String item = 'Stk'; // Eingabe

  double taxPercent = 0.00; // Eingabe
  double taxOnNettoItemPrice = 0.00; // berechnet
  double taxOnNettoQuantityPrice = 0.00; // berechnet

  double taxOnBruttoItemPrice = 0.00; // berechnet
  double taxOnBruttoQuantityPrice = 0.00; // berechnet

  double nettoItemPrice = 0.00; // Eingabe - später im Update
  double nettoQuantityPrice = 0.00; // berechnet

  double bruttoItemPrice = 0.00; // Eingabe oder berechnet
  double bruttoQuantityPrice = 0.00; // Eingabe oder berechnet

  void getCalculationResult() {
    /* die einzelnen Positionen berechnen */
    log("----------------------------------------------------------------------------------------------------------------");
    log('0059 - getCalculationResult - String: ${quantityController.text} ==> Anzahl als double: $quantity');
    log('0060 - getCalculationResult - String: ${itemController.text} ==> Einheiten als Text: $item');
    log('0061 - getCalculationResult - String: ${taxPercentController.text} ==> MwSt. als double: $taxPercent');
    log('0062 - getCalculationResult - String: ${bruttoItemPriceController.text} ==> Brutto-Einzel als double: $bruttoItemPrice €');
    log('0064 - getCalculationResult - String: ${bruttoQuantityPriceController.text} ==> Brutto-Gesamt als double: $bruttoQuantityPrice €');

    // Netto-Einzel im Update
    // Netto-Gesamt im Update

    // Validator wegen Schreibweise der Zahlenformate

    log("----------------------------------------------------------------------------------------------------------------");
    /* Netto-Einzelpreis - Umrechnung in Cent für genauere Berechnungen */
    // final nettoItemPriceInCent = nettoItemPrice * 100;
    // log('0080 - getCalculationResult - double: $nettoItemPriceInCent ==> Cent Netto-Einzelpreis');

    // /* überprüfen ob das Feld "Anzahl" gefüllt ist */
    // if (quantityController.text.isEmpty || quantityController.text == "") {
    //   quantityController.text = "";
    //   showDialog(
    //       context: context,
    //       builder: (context) => const WbDialogAlertUpdateComingSoon(
    //           headlineText: "Zur Berechnung fehlen noch Daten!",
    //           contentText: 'Bitte noch das Feld "Anzahl" ergänzen.',
    //           actionsText: "OK 👍"));
    //   log('0093 --> Eingabe "Angabe" fehlt! <---');

    /*--- Wenn das Feld "Einheiten" leer ist ---*/
    if (itemController.text == "") {
      log('0091 - ExpenseWidget - itemController - Eingabe gelöscht: "${itemController.text}" ---> als String');
      itemController.text = "Stk";
      log('0093 - ExpenseWidget - itemController - umgewandelt in "${itemController.text}" ---> als String');
    }

    //   /* überprüfen ob das Feld "Brutto-Einzelpreis" gefüllt ist */
    // } else if (bruttoItemPriceController.text.isEmpty ||
    //     bruttoItemPriceController.text == "") {
    //   // bruttoItemPriceController.text = "";
    //   showDialog(
    //       context: context,
    //       builder: (context) => const WbDialogAlertUpdateComingSoon(
    //           headlineText: "Zur Berechnung fehlen noch Daten!",
    //           contentText: 'Bitte noch das Feld "Brutto-Einzelpreis" ergänzen.',
    //           actionsText: "OK 👍"));
    //   log('0105 --> Eingabe "Brutto-Einzelpreis" fehlt! <---');

    //   /* überprüfen ob das Feld "Brutto-Gesamtpreis" gefüllt ist */
    // } else if (bruttoQuantityPriceController.text.isEmpty ||
    //     bruttoQuantityPriceController.text == "") {
    //   // bruttoQuantityPriceController.text = "";
    //   showDialog(
    //       context: context,
    //       builder: (context) => const WbDialogAlertUpdateComingSoon(
    //           headlineText: "Zur Berechnung fehlen noch Daten!",
    //           contentText: 'Bitte noch das Feld "Brutto-Gesamtpreis" ergänzen.',
    //           actionsText: "OK 👍"));
    //   log('0117 --> Eingabe "Brutto-Gesamtpreis" fehlt! <---');
    // }

    /*--- Anzahl - Umformatierung in double ---*/
    quantity = double.tryParse(quantityController.text) ?? 1.0;

    /*--- taxPercent - Umformatierung in double ---*/
    /*--- taxOnNettoItemPrice - Umformatierung in double ---*/
    /*--- taxOnNettoQuantityPrice - Umformatierung in double ---*/

    /*--- taxOnBruttoItemPrice - Umformatierung in double ---*/
    /*--- taxOnBruttoQuantityPrice - Umformatierung in double ---*/

    /*--- nettoItemPrice - Umformatierung in double ---*/
    /*--- nettoQuantityPrice - Umformatierung in double ---*/
    // nettoQuantityPrice =
    //     double.tryParse(nettoQuantityPriceController.text) ?? 1.0;

    /* Brutto-Einzelpreis = Umformatierung in double */
    bruttoItemPrice = double.tryParse(bruttoItemPriceController.text) ?? 1.0;

    /*--- bruttoQuantityPrice - Umformatierung in double ---*/
    bruttoQuantityPrice =
        double.tryParse(bruttoQuantityPriceController.text) ?? 1.0;
    /*----------------------------------------------------------------------------------------------------------------*/

    /* Netto-Einzelpreis - Berechnung + Umrechnung in Cent für genauere Berechnungen*/
    nettoItemPrice = nettoItemPrice * 0.840336134 * 100;
    final nettoItemPriceInCent = nettoItemPrice.roundToDouble();
    log('0124 - getCalculationResult - double: $nettoItemPriceInCent ==> Cent Netto-Einzelpreis');

    /* Netto-Gesamtpreis =  Brutto-Einzelpreis * Anzahl */
    final nettoQuantityPriceInCent = nettoItemPrice.roundToDouble() *
        quantity *
        100; // * 100 = Umrechnung in Cent für genauere Berechnungen
    log('0130 --> Berechnung: [Netto-Gesamtpreis in Cent] $nettoQuantityPriceInCent = [Netto-Einzelpreis] ${nettoItemPrice.roundToDouble()} * [Anzahl] $quantity * 100');
    log('0132 - getCalculationResult - double: $nettoQuantityPriceInCent ==> Cent Netto-Gesamtpreis');
    log("----------------------------------------------------------------------------------------------------------------");
    /* Brutto-Gesamtpreis = Brutto-Einzelpreis * Anzahl */
    final bruttoQuantityPriceInCent = bruttoItemPrice.roundToDouble() *
        quantity *
        100; // * 100 = Umrechnung in Cent für genauere Berechnungen
    log('0137 --> Berechnung: [Brutto-Gesamtpreis in Cent] $bruttoQuantityPriceInCent = [Brutto-Einzelpreis] ${bruttoItemPrice.roundToDouble()} * [Anzahl] $quantity * 100');
    log('0139 - getCalculationResult - double: $bruttoQuantityPriceInCent ==> Cent Brutto-Gesamtpreis');
    bruttoQuantityPrice = bruttoQuantityPriceInCent / 100;
    bruttoQuantityPriceController.text = bruttoQuantityPrice.toString();
    log("----------------------------------------------------------------------------------------------------------------");
    /*-------------------------------------------------------------------------------*/
    /* Die Ergebnisse umformatieren oder im "Money-Währungsformat" darstellen */
    /*-------------------------------------------------------------------------------*/

    /*--- Anzahl ---*/
    Money quantityAsFormat =
        Money.fromInt((quantity * 100).toInt(), isoCode: 'EUR');
    quantityController.text =
        quantityAsFormat.format('###,###.#0');
    log('-----> 0153 - ExpenseWidget - Eintrag im Textfeld "Anzahl": ${quantityAsFormat.format('###,###.#0')}');

    /*--- Brutto-Einzelpreis ---*/
    Money bruttoItemPriceAsMoney = Money.fromInt(
        (bruttoItemPrice * 100).toInt(),
        isoCode: 'EUR');
    bruttoItemPriceController.text =
        bruttoItemPriceAsMoney.format('###,###.#0 S');
    log('-----> 0864 - ExpenseWidget - Eintrag "Brutto-Einzelpreis in €": ${bruttoItemPriceAsMoney.format('###,###.#0 S')}');

    // /*--- Brutto-Gesamtpreis ---*/
    Money bruttoQuantityPriceAsMoney = Money.fromInt(
        (bruttoQuantityPriceInCent).toInt(),
        isoCode: 'EUR');
    bruttoQuantityPriceController.text =
        bruttoQuantityPriceAsMoney.format('###,###.#0 S');
    log("----------------------------------------------------------------------------------------------------------------");

/* Brutto-Einzelpreis - Berechnung aus dem Netto-Einzelpreis */

    //     /* den Brutto-Einzelpreis aus dem Netto-Einzelpreis berechnen */
//     // bruttoItemPrice = nettoItemPrice / 1.19;
//     log('0079 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPrice - OHNE "NumberFormat"');

    /* Mehrwertsteuersatz - Berechnung */
    taxPercentController.text = taxPercentController.text
        .replaceAll(RegExp(r' %'), ''); // das Prozentzeichen entfernen
    log('0097 - getCalculationResult - Mehrwertsteuersatz: ${taxPercentController.text} %'); //

    taxPercent = double.tryParse(taxPercentController.text) ?? 0.0;
    final taxPercentSet = taxPercent / 100;
    log('0088 - getCalculationResult - Mehrwertsteuersatz zum Rechnen: $taxPercentSet ==> als double');

    /* Mehrwertsteuer auf den Netto-Einzelpreis - Berechnung: (Netto-Einzelpreis / (100 + Mehrwertsteuersatz)) • Mehrwertsteuersatz */
    final taxOnNettoItemPrice = nettoItemPriceInCent * taxPercentSet;
    // final taxOnNettoItemPrice =
    //     (nettoItemPriceInCent / (100 + taxPercentSet)) * taxPercentSet * 100;

    log('0091 - getCalculationResult - double: $taxOnNettoItemPrice ==> Cent Mehrwertsteuer auf den Netto-Einzelpreis');

    /* Mehrwertsteuer auf den Netto-Gesamtpreis - Berechnung */
    final taxOnNettoQuantityPrice = taxOnNettoItemPrice * quantity;
    log('0096 - getCalculationResult - double: $taxOnNettoQuantityPrice ==> Cent Mehrwertsteuer auf den Netto-Gesamtpreis');

    /* Netto-Gesamtpreis - Berechnung */
    final nettoQuantityPrice = nettoItemPrice * quantity;
    log('0104 - getCalculationResult - double: $nettoQuantityPrice ==> Cent Netto-Gesamtpreis (falsch)');

    /* Gesamt-Mehrwertsteuer - Berechnung */
    // final taxOnNettoQuantityPriceInCent = taxOnNettoItemPrice * quantity;
    final taxOnNettoQuantityPriceInCent =
        nettoQuantityPriceInCent * quantity * (taxPercent / 100);
    log('0108 - getCalculationResult - double: $taxOnNettoQuantityPriceInCent ==> Cent Gesamt-Mehrwertsteuer (falsch)');
    log("----------------------------------------------------------------------------------------------------------------");

    setState(() {
      nettoItemPrice = nettoItemPriceInCent / 100;
      // nettoQuantityPrice = nettoQuantityPriceInCent / 100;
    });

// // /*--------------------------------- calculatePrice ---*/
// //     double calculatePrice(double? bruttoItemPriceController,
// //         double? bruttoQuantityPriceController, double? quantityController) {
// //       /* Brutto-Gesamtpreis berechnen */
// //       if (bruttoItemPriceController != null &&
// //           quantityController != null &&
// //           bruttoQuantityPriceController == null) {
// //         double result = bruttoItemPriceController * quantityController;
// //         log('0083 - calculatePrice - $result');
// //         return result;
// //       }
// //       return 0.0; // Default return value
// //     }

//     // bruttoQuantityPriceController.text = NumberFormat.currency(
//     //   //name: '€',
//     //   decimalDigits: 2,
//     //   symbol: '  €  ',
//     //   // customPattern: '#.###,## €',
//     // ).format(bruttoQuantityPrice);
//     // log('0078 - getCalculationResult - bruttoQuantityPriceController.text = ${bruttoQuantityPriceController.text}');
//     // log('0079 - getCalculationResult - bruttoQuantityPrice.text = $bruttoQuantityPrice');

// // String bruttoItemPriceController.text =

// // NumberFormat.currency('');

//     /* Anzahl * Brutto-Einzelpreis = Brutto-Gesamtpreis berechnen */
//     // bruttoQuantityPrice = bruttoItemPrice * quantity;
//     // log('0076 - getCalculationResult - Gesamtpreis berechnet: ${bruttoQuantityPrice.toStringAsFixed(2)} €');

//     bruttoQuantityPriceController.text = '101' * 10;
//     log('0076 - getCalculationResult - Gesamtpreis berechnet: $bruttoQuantityPrice €');

//     /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */
//     NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//     String bruttoItemPriceX = formatter.format(bruttoItemPrice);
//     log('0115 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPriceX mit - "NumberFormat formatter = NumberFormat("#,##0.00", "de_DE")" - ');

    log('0169 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
    log('0170 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: $nettoItemPrice €');
    log('0171 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: $taxOnNettoItemPrice €');

//     log('0085 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "nettoItemPrice": $nettoItemPrice');
//     log('0086 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "bruttoItemPrice": $bruttoItemPrice');
//     log('0087 - getCalculationResult ---> Rechnungszahl "bruttoItemPriceX": $bruttoItemPriceX');
//     // nettoItemPrice = bruttoItemPriceX / 1.19;
//     // nettoItemPrice = double.parse(nettoItemPrice as String);
//     //nettoItemPrice = nettoQuantityPrice.toStringAsFixed(2);
//     log("----------------------------------------------------------------------------------------------------------------");

//     /* den Netto-Gesamtpreis berechnen */
//     nettoQuantityPrice = nettoItemPrice * quantity;

    log('0093 - getCalculationResult - Netto-Gesamtpreis berechnet: ${nettoQuantityPrice.toStringAsFixed(2)} €');
    log('0094 - getCalculationResult - Netto-Gesamtpreis berechnet: $nettoQuantityPrice €');
    log('0095 - getCalculationResult - Netto-Gesamtpreis berechnet: $nettoItemPrice€');

//     /* die MwSt. aus dem Netto-Einzelpreis berechnen */
//     taxOnNettoItemPrice = nettoItemPrice * (taxPercent / 100);
//     log('0097 - getCalculationResult - Mwst. aus dem Netto-Einzelpreis berechnet: ${taxOnNettoItemPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Netto-Einzelpreis * Anzahl, Gewicht, Stück?  berechnen */
//     taxOnNettoQuantityPrice = nettoItemPrice * quantity * (taxPercent / 100);
//     log('0101 - getCalculationResult - Mwst. aus dem Netto-Gesamtpreis berechnet: ${taxOnNettoQuantityPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
//     taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
//     log('0105 - getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
//     taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
//     log('0109 - getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Brutto-Gesamtpreis berechnen */
//     taxOnBruttoQuantityPrice = bruttoQuantityPrice * (taxPercent / 100);
//     log('0113 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');

    log('0113 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');
    log('0114 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: $taxOnBruttoQuantityPrice €');
    log('0115 - getCalculationResult - Mwst. aus dem Netto-Gesamtpreis berechnet: $taxOnNettoQuantityPriceInCent €');

    // log("----------------------------------------------------------------------------------------------------------------");

//     taxSum = bruttoItemPrice * quantity * (taxPercent / 100);
//     totalSum = bruttoItemPrice * quantity + taxSum;
//     nettoItemPrice = bruttoItemPrice / (1 + 0.19);
//     log('0122 - getCalculationResult - Netto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
    log("----------------------------------------------------------------------------------------------------------------");
    log("Netto-Einzelpreis:    ${nettoItemPrice.toStringAsFixed(2)} € pro Einheit");
    log("Gekaufte Einheiten:   $quantity $item");
    // log("Mehrwertsteuer:       ${taxSum.toStringAsFixed(2)} €");
    // log("Gesamtsumme           ${totalSum.toStringAsFixed(2)} €");
    log("----------------------------------------------------------------------------------------------------------------");
    // packageMoney2Test();
  }

// /*--------------------------------- package money2 (https://pub.dev/packages/money2) ---*/
//   void packageMoney2Test() {
//     log("----------------------------------------------------------------------------------------------------------------");
//     /* Eine Währung erstellen - der Betrag wur immer als int als Cent-Betrag angegebeen, um Rundungsfehler zu vermeiden */
//     final moneyTest1 = Money.fromInt(10025090, isoCode: 'EUR');
//     log('0001 - moneyTest1: $moneyTest1'); // leider noch ohne Tausender-Separator und Leerzeichen beim Währungssymbol
//     log('0002 - moneyTest2: ${moneyTest1.format('###,###.#0 S')} ---> das ist der küzeste und BESTE Code √');

//     /* Definiere den Tausender-Separator und das Leerzeichen beim Währungssymbol EURO */
//     /* Benutze Kommas ',' für den integer/fractional Separator und Punkte '.' für den Tausender-Separator ---> 1.000,00 */
//     final euro = Currency.create('EUR', 2,
//         symbol: '€',
//         groupSeparator: '.',
//         decimalSeparator: ',',
//         pattern: '#,##0.00 S');
//     final moneyTest3 = Money.fromIntWithCurrency(
//         10025090, euro); // die Zahl ist ein Cent-Betrag!
//     log('0003 - moneyTest3: $moneyTest3'); // Ergebnis: 100.250,90 €

//     /* Eine [Money]-Instanz aus einem String mit [Currency.parse] erstellen - Währung: € - */
//     final moneyTest4 = CommonCurrencies().euro.parse(r'10,50');
//     log('0004 - moneyTest4: ${moneyTest4.format('0.00 S')}'); //  S = Währungszeichen

//     /* Die [Währung] von moneyTest3 ist USD. */
//     final moneyTest5 = CommonCurrencies().usd.parse(r'$10.51');
//     log('0005 - moneyTest3: ${moneyTest5.format('CCS 0.00')}'); // CC = Land / S = Währungszeichen

//     /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */ // funzt HIER nicht
//     // NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//     // String moneyTest2formatiert = formatter.format(moneyTest2);
//     // log('0004 - moneyTest2 wurde formatiert: $moneyTest2formatiert');
//   }

// void formatMoneyAfterCalculation(Money value, Money valueAsMoney) {
//   log("----------------------------------------------------------------------------------------------------------------");
//   //value = bruttoItemPrice;
//   /* Wenn die Berechnung stattgefunden hat, soll sobald das Textfeld verlassen wird, der Wert in eine Währung umgewandelt werden */
//   /* 1) Den Wert * 100 ergibt den Wert in Cent */
//   var valueMultiplied100 = value * 100;
//   log('0001 - formatMoneyAfterCalculation - Wert in Cent: $valueMultiplied100');

//   /* Den Wert von "double" in einen "int" umwandeln mit ".toInt()" ---> schneidet nach dem Kamma einfach alles ab */
//   int valueAsIntInCent = valueMultiplied100.toInt();
//   log('0002 - formatMoneyAfterCalculation - $valueMultiplied100 = $valueAsIntInCent Cent');

//   /* Den Wert als Euro-Wert darstellen */
//   Money valueAsMoney = Money.fromInt(valueAsIntInCent, isoCode: 'EUR');
//   log('0003 - formatMoneyAfterCalculation - Eintrag im Textfeld: $valueAsMoney');
//   log('0004 - formatMoneyAfterCalculation - Eintrag im Textfeld: ${valueAsMoney.format('###,###.#0 S')}');
//   log("----------------------------------------------------------------------------------------------------------------");
// }

// class _ExpenseWidgetState extends State<ExpenseWidget> {
  /*--------------------------------- GlobalKey ---*/

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
        Form(
      key: _formKey,
      child: Column(
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
              wbText: 'Brutto-Einkaufspreis in €',
              wbTextColor: wbColorButtonDarkRed,
              wbFontSize12: 18,
              wbHeight3: 3),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Anzahl ---*/
          Row(
            children: [
              SizedBox(
                width: 240,
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
                        false, // "signed" erlaubt ein "+" oder "-" Zeichen vor der Zahl
                  ),
                  /*--------------------------------- onChanged ---*/
                  controller: quantityController,
                  onChanged: (String value) {
                    //value
                    log("----------------------------------------------------------------------------------------------------------------");
                    log('0393 - ExpenseWidget - quantityController - Eingabe: "${quantityController.text}" - als String');
                    /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss das double "1.00" erscheinen */

                    // bool validateInput(String value) {
                    //   value = quantityController.text;
                    //   log('');
                    //   if (validateInput == true) {
                    //     log('');
                    //   }

                    //   return value.contains(RegExp(r'[a-zA-z]')) ? false : true;
                    // }

                    // if (quantityController.text == "") {
                    //   log('0396 - ExpenseWidget - quantityController - Eingabe gelöscht: "${quantityController.text}" ---> als String');
                    //                         quantityController.text = "";

                    // }else

                    if (quantityController.text.contains(
                        RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                      quantityController.text = "";
                      log('0398 - ExpenseWidget - quantityController - umgewandelt in "${quantityController.text}" ---> als String');
                      /*--------------------------------- Snackbar / Toast ---*/
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: wbColorButtonDarkRed,
                        content: Text(
                          "Hinweis:\nBitte nur Ziffern zur Berechnung eingeben ... 😉\n\n... und zur Berechnung von Nachkommastellen wird anstelle des Kommas automatisch ein Punkt eingefügt.",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ));
                      /*--------------------------------- *** ---*/
                    }
                    try {
                      setState(() {
                        quantityController.text = quantityController.text
                            .replaceAll(RegExp(r','), '.');
                        log('-------> text neu: ${quantityController.text}');

                        // quantity = double.parse(quantityController.text);

/*--------------------------------- *** ---*/
                        log("0478 - ExpenseWidget - quantityController - setState ausgeführt: $quantity ---> als double <--- damit darf NICHT gerechnet werden !!!");
/*--------------------------------- *** ---*/

                        log('0479 - ExpenseWidget - quantityController - setState ausgeführt: ${quantityController.text} ---> im TextFormField eingetragen? ---> Ja');
                        // quantityController.text = quantity.toString();
                      });
                      // getCalculationResult();
                      log("----------------------------------------------------------------------------------------------------------------");
                    } catch (e) {
                      log('0410 - ExpenseWidget - Fehlermeldung - Eingabe: ${quantityController.text} - als String');
                      quantityController.text = '';
                    }

                    // setState(() {
                    //                                           if (quantityController.text == "") {
                    //     log('0323 - ExpenseWidget - quantityController - Eingabe gelöscht: "$quantityController" ---> als String');
                    //     quantityController.text = "1.00";
                    //     log('0325 - ExpenseWidget - quantityController - umgewandelt in "$quantityController" ---> als String');
                    //   }
                    // });
                  },
                  /*--------------------------------- inputFormatters ---*/
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                  //   OnePointLimit(), // limitiert die Eingabe auf maximal 1 Punkt
                  // ],
                ),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxWidth16,
              // Spacer(flex: 1),
              /*--------------------------------- Einheiten ---*/
              Expanded(
                child: WbDropDownMenuWithoutIcon(
                  //width: 200, // hat hier keine Auswirkung!
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
                  initialSelection: 0, // Index 0 aus "dropdownItems" = "Stk"
                  backgroundColor: wbColorBackgroundRed,
                  textFieldWidth: 210,
                  controller: itemController,
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
                '       Mehrwertsteuersatz:  ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxWidth16,
              /*--------------------------------- *** ---*/
              Expanded(
                child: WbDropDownMenuWithoutIcon(
                  textFieldWidth: 140,
                  label: "MwSt",
                  dropdownItems: ["0 %", "7 %", "19 %"],
                  initialSelection: 2, // Index 2 aus "dropdownItems" = "19 %"
                  backgroundColor: wbColorBackgroundRed,
                  controller: taxPercentController,
                ),
              ),
            ],
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
          /*--------------------------------- Einzelpreis Brutto in € ---*/
          WbTextFormFieldTEXTOnly(
            labelText: "Einzelpreis Brutto in €",
            labelFontSize20: 18,
            hintText: "Einzelpreis Brutto in €",
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
            onChanged: (String value) {
              log("----------------------------------------------------------------------------------------------------------------");
              log('0575 - ExpenseWidget - bruttoItemPriceController - Eingabe: "${bruttoItemPriceController.text}" - als String');

              /* wenn beim Eingeben aus Versehen ein falsches Zeichen benutzt wird */
              if (bruttoItemPriceController.text
                  .contains(RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                bruttoItemPriceController.text = "";
                log('0581 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "${bruttoItemPriceController.text}" ---> als String');

                /*--------------------------------- Snackbar / Toast ---*/
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: wbColorButtonDarkRed,
                  content: Text(
                    "Hinweis:\nBitte nur Ziffern zur Berechnung eingeben ... 😉\n\n... und zur Berechnung von Nachkommastellen wird anstelle des Kommas automatisch ein Punkt eingefügt.",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ));
                /*--------------------------------- *** ---*/
              }
              try {
                setState(() {
                  bruttoItemPriceController.text = bruttoItemPriceController
                      .text
                      .replaceAll(RegExp(r','), '.');
                  log('-------> text neu: ${bruttoItemPriceController.text}');

                  // quantity = double.parse(bruttoItemPriceController.text);

                  log("0604 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoItemPrice ---> als double");
                  log('0605 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: ${bruttoItemPriceController.text} ---> im TextFormField eingetragen? ---> Ja');
                  // bruttoItemPriceController.text = quantity.toString();
                });
                // getCalculationResult();
                log("----------------------------------------------------------------------------------------------------------------");
              } catch (e) {
                log('0611 - ExpenseWidget - Fehlermeldung - Eingabe: ${bruttoItemPriceController.text} - als String');
                bruttoItemPriceController.text = '';
              }

              // setState(() {
              //                                           if (bruttoItemPriceController.text == "") {
              //     log('0323 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoItemPriceController" ---> als String');
              //     bruttoItemPriceController.text = "1.00";
              //     log('0325 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoItemPriceController" ---> als String');
              //   }
              // });
            },

            // /*--------------------------------- onChanged ---*/
            // controller: bruttoItemPriceController,
            // onChanged: (String value) {
            //   log("----------------------------------------------------------------------------------------------------------------");
            //   log("0506 - ExpenseWidget - bruttoItemPriceController - Eingabe: $bruttoItemPriceController - als String");
            //   log("0507 - ExpenseWidget - bruttoItemPriceController - Eingabe: ${bruttoItemPriceController.text} - als String");

            //   /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
            //   if (bruttoItemPriceController.text == "") {
            //     log('0509 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoItemPriceController" ---> als String');
            //     bruttoItemPriceController.text = "0.00";
            //     log('0512 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoItemPriceController" ---> als String');
            //   }
            //   try {
            //     setState(() {
            //       bruttoItemPrice =
            //           double.parse(bruttoItemPriceController.text);
            //       log("0518 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoItemPrice ---> als double");
            //       log('0519 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: "$bruttoItemPriceController" ---> im TextFormField eingetragen? ---> Ja');
            //     });
            //     getCalculationResult();
            //     // /* Das Ergebnis im "Money-Währungsformat" darstellen*/
            //     // Money valueAsMoney =
            //     //     Money.fromInt((bruttoItemPrice * 100).toInt(), isoCode: 'EUR',);
            //     // log('0521 - ExpenseWidget - Eintrag im Textfeld "Einzelpreis Brutto in €": ${valueAsMoney.format('###,###.#0 S')}');
            //     // bruttoItemPriceController.text =
            //     //     valueAsMoney.format('###,###.#0 S');
            //     log("----------------------------------------------------------------------------------------------------------------");
            //   } catch (e) {
            //     bruttoItemPriceController.text = '0.00';
            //   }
            //   // /* Das Ergebnis im "Money-Währungsformat" darstellen */
            //   // Money valueAsMoney = Money.fromInt(
            //   //   (bruttoItemPrice * 100).toInt(),
            //   //   isoCode: 'EUR',
            //   // );
            //   // log('0521 - ExpenseWidget - Eintrag im Textfeld "Einzelpreis Brutto in €": ${valueAsMoney.format('###,###.#0 S')}');
            //   // bruttoItemPriceController.text =
            //   //     valueAsMoney.format('###,###.#0 S');
            // },
            // // focusNode: FocusNode(),

            /*--------------------------------- *** ---*/
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
          /*--------------------------------- Gesamtpreis Brutto in € ---*/
          WbTextFormFieldTEXTOnly(
            labelText: "Gesamtpreis Brutto in €",
            labelFontSize20: 18,
            hintText: "Gesamtpreis Brutto in €",
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
            onChanged: (String value) {
              log("----------------------------------------------------------------------------------------------------------------");
              log('0697 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: "${bruttoQuantityPriceController.text}" - als String');

              /* wenn beim Eingeben aus Versehen ein falsches Zeichen benutzt wird */
              if (bruttoQuantityPriceController.text
                  .contains(RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                bruttoQuantityPriceController.text = "";
                log('0703 - ExpenseWidget - bruttoQuantityPriceController - umgewandelt in "${bruttoQuantityPriceController.text}" ---> als String');

                /*--------------------------------- Snackbar / Toast ---*/
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: wbColorButtonDarkRed,
                  content: Text(
                    "Hinweis:\nBitte nur Ziffern zur Berechnung eingeben ... 😉\n\n... und zur Berechnung von Nachkommastellen wird anstelle des Kommas automatisch ein Punkt eingefügt.",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ));
                /*--------------------------------- *** ---*/
              }
              try {
                setState(() {
                  bruttoQuantityPriceController.text =
                      bruttoQuantityPriceController.text
                          .replaceAll(RegExp(r','), '.');
                  log('-------> text neu: ${bruttoQuantityPriceController.text}');

                  // quantity = double.parse(bruttoQuantityPriceController.text);

                  log("0728 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: $bruttoQuantityPrice ---> als double");
                  log('0729 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: ${bruttoQuantityPriceController.text} ---> im TextFormField eingetragen? ---> Ja');
                  // bruttoQuantityPriceController.text = quantity.toString();
                });
                // getCalculationResult();
                log("----------------------------------------------------------------------------------------------------------------");
              } catch (e) {
                log('0735 - ExpenseWidget - Fehlermeldung - Eingabe: ${bruttoQuantityPriceController.text} - als String');
                bruttoQuantityPriceController.text = '';
              }

              // setState(() {
              //                                           if (bruttoQuantityPriceController.text == "") {
              //     log('0323 - ExpenseWidget - bruttoQuantityPriceController - Eingabe gelöscht: "$bruttoQuantityPriceController" ---> als String');
              //     bruttoQuantityPriceController.text = "1.00";
              //     log('0325 - ExpenseWidget - bruttoQuantityPriceController - umgewandelt in "$bruttoQuantityPriceController" ---> als String');
              //   }
              // });
            },

            // /*--------------------------------- onChanged ---*/
            // controller: bruttoQuantityPriceController,
            // onChanged: (String bruttoQuantityPriceController) {
            //   log("0457 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: $bruttoQuantityPriceController - als String");
            //   /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
            //   if (bruttoQuantityPriceController == "") {
            //     log('0460 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoQuantityPriceController" ---> als String');
            //     bruttoQuantityPriceController = "0.00";
            //     log('0462 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoQuantityPriceController" ---> als String');
            //   }

            //   // bruttoQuantityPrice = double.parse(bruttoQuantityPriceController);
            //   // setState(() => bruttoQuantityPrice =
            //   //     double.parse(bruttoQuantityPriceController));
            //   // log("0297 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoQuantityPrice ---> als double");

            //   // setState(() {
            //   //   bruttoQuantityPrice = double.parse(bruttoQuantityPriceController);
            //   //   log('0366 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: "$bruttoQuantityPriceController" ---> im TextFormField eingetragen? ---> NEIN !!! todo');
            //   // });

            //   getCalculationResult();
            // },
            // /*--------------------------------- *** ---*/
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
                        'Brutto-Einzelpreis incl. MwSt.:',
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
                  log("----------------------------------------------------------------------------------------------------------------");
                  log('0714 - ExpenseWidget - ElevatedButton angeklickt');

                  // /*--- Wenn im Textfeld "MwSt." nichts drin steht ---*/
                  // if (taxPercentController.text == "") {
                  //   log('0732 - ExpenseWidget - taxPercentController - Eingabe gelöscht: "${taxPercentController.text}" ---> als String');
                  //   taxPercentController.text = "19 %";
                  //   log('0734 - ExpenseWidget - taxPercentController - umgewandelt in "${taxPercentController.text}" ---> als String');
                  // }

                  getCalculationResult();

                  // setState(() {});
                  log("----------------------------------------------------------------------------------------------------------------");

                  // log("----------------------------------------------------------------------------------------------------------------");
                },
                child: Text(
                  'Zur Kontrolle NEU berechnen?',
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
      ),
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

class OnePointLimit extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int punkte = newValue.text.split('.').length - 1;
    if (punkte > 1) {
      return oldValue; // Verhindert die Eingabe eines weiteren Punktes
    }
    return newValue;
  }
}
