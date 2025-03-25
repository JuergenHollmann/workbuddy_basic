import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:money2/money2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
//import 'package:workbuddy/config/wb_typeaheadfield.dart';
//import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_0_icon.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget({super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  /*--------------------------------- AudioPlayer ---*/
  late AudioPlayer player = AudioPlayer();

  /*--------------------------------- GlobalKeys ---*/
  final _formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState>();

// /*--------------------------------- Scroll-Controller ---*/
// ScrollController _scrollcontroller = ScrollController();

/*--------------------------------- Controller ---*/
  final shopController = TextEditingController();
  final quantityController = TextEditingController();
  final itemController = TextEditingController();
  final taxPercentController = TextEditingController();

  final bruttoItemPriceController = TextEditingController();
  final bruttoQuantityPriceController = TextEditingController();

  final nettoItemPriceController = TextEditingController();
  final nettoQuantityPriceController = TextEditingController();

  final taxOnBruttoItemPriceController = TextEditingController();
  final taxOnBruttoQuantityPriceController = TextEditingController();

  final controllerBelegnummer = TextEditingController();
  final controllerBelegdatum = TextEditingController();

  final controllerWasGekauft = TextEditingController();
  final controllerZahlungsmittel = TextEditingController();
  final controllerWarengruppe = TextEditingController();
  final controllerEinkaeufer = TextEditingController();
  final controllerNotizen = TextEditingController();

/*--------------------------------- Variablen um die Preise zu berechnen ---*/
  double quantity = 0.00; // Eingabe
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

  /*-------------------------------------------------------------------------------------------------------------------*/
  void getCalculationResult() {
    /* Die einzelnen Positionen berechnen */
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // /* Vor der Berechnung müssen alle Zahlen in das Rechenformat mit Punkt vor den Dezimalzahlen umgestellt werden */
    // /*-------------------------------------------------------------------------------------------------------------------*/
    // dev.log('0078 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> ist keine Währung');
    // /* (1) alle Komma durch "x" ersetzen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[,]'), 'x');
    // dev.log('0082 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> Komma durch x ersetzt');

    // /* (2) alle Punkte entfernen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[.]'), '');
    // dev.log('0087 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> Punkte gelöscht');

    // /* (3) alle "x" durch Punkte ersetzen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[x]'), '.');
    // dev.log('0092 √ getCalculationResult - Anzahl als double:              ${quantityController.text} --> x durch Punkt ersetzt');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0094 √ getCalculationResult - Einheiten als Text:             ${itemController.text} --> wird nicht umgestellt');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0096 √ getCalculationResult - MwSt. als Prozentsatz:          ${taxPercentController.text}');
    // taxPercentController.text =
    //     taxPercentController.text.replaceAll(RegExp(r'[ %,]'), '');
    // dev.log('0095 √ getCalculationResult - MwSt. als double:               ${taxPercentController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0097 - getCalculationResult - Brutto-Einzel als Text:         ${bruttoItemPriceController.text} €');
    // bruttoItemPriceController.text =
    //     bruttoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0078 - getCalculationResult - Brutto-Einzel als double:       ${bruttoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0079 - getCalculationResult - Brutto-Gesamt als Text:         ${bruttoQuantityPriceController.text} €');
    // bruttoQuantityPriceController.text =
    //     bruttoQuantityPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0079 - getCalculationResult - Brutto-Gesamt als double:       ${bruttoQuantityPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0080 - getCalculationResult - Netto-Einzel als Text:          ${nettoItemPriceController.text} €');
    // nettoItemPriceController.text =
    //     nettoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0080 - getCalculationResult - Netto-Einzel als double:        ${nettoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0081 - getCalculationResult - Brutto-Gesamt als Text:         ${nettoQuantityPriceController.text} €');
    // nettoQuantityPriceController.text =
    //     nettoQuantityPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0081 - getCalculationResult - Brutto-Gesamt als double:       ${nettoQuantityPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0082 - getCalculationResult - Brutto-Einzel-MwSt. als Text:   ${taxOnBruttoItemPriceController.text} €');
    // taxOnBruttoItemPriceController.text =
    //     taxOnBruttoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0082 - getCalculationResult - Brutto-Einzel-MwSt. als double: ${taxOnBruttoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0083 - getCalculationResult - Brutto-Gesamt-MwSt. als Text: ${taxOnBruttoQuantityPriceController.text} €');
    // taxOnBruttoQuantityPriceController.text = taxOnBruttoQuantityPriceController
    //     .text
    //     .replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0083 - getCalculationResult - Brutto-Gesamt-MwSt. als double: ${taxOnBruttoQuantityPriceController.text}');
    dev.log(
        '----------------------------------------------------------------------------------------------------------------');
    dev.log(
        '0075 - getCalculationResult - Anzahl als double:              ${quantityController.text}');
    dev.log(
        '0076 - getCalculationResult - Einheiten als Text:             ${itemController.text}');
    dev.log(
        '0077 - getCalculationResult - MwSt. als Prozentsatz:          ${taxPercentController.text}');
    dev.log(
        '0078 - getCalculationResult - Brutto-Einzel als double:       ${bruttoItemPriceController.text} €');
    dev.log(
        '0079 - getCalculationResult - Brutto-Gesamt als double:       ${bruttoQuantityPriceController.text} €');
    dev.log(
        '0080 - getCalculationResult - Netto-Einzel als double:        ${nettoItemPriceController.text} €');
    dev.log(
        '0081 - getCalculationResult - Brutto-Gesamt als double:       ${nettoQuantityPriceController.text} €');
    dev.log(
        '0082 - getCalculationResult - Brutto-Einzel-MwSt. als double: ${taxOnBruttoItemPriceController.text} €');
    dev.log(
        '0083 - getCalculationResult - Brutto-Gesamt-MwSt. als double: ${taxOnBruttoQuantityPriceController.text} €');
    dev.log(
        '----------------------------------------------------------------------------------------------------------------');

    /* Netto-Einzelpreis - Umrechnung in Cent für genauere Berechnungen */
    // final nettoItemPriceInCent = nettoItemPrice * 100;
    // dev.log('0080 - getCalculationResult - double: $nettoItemPriceInCent ==> Cent Netto-Einzelpreis');

    // /* überprüfen ob das Feld "Anzahl" gefüllt ist */
    // if (quantityController.text.isEmpty || quantityController.text == "") {
    //   quantityController.text = "";
    //   showDialog(
    //       context: context,
    //       builder: (context) => const WbDialogAlertUpdateComingSoon(
    //           headlineText: "Zur Berechnung fehlen noch Daten!",
    //           contentText: 'Bitte noch das Feld "Anzahl" ergänzen.',
    //           actionsText: "OK 👍"));
    //   dev.log('0093 --> Eingabe "Angabe" fehlt! <---');

    /*--- Wenn das Feld "Einheiten" leer ist ---*/
    if (itemController.text == "") {
      dev.log(
          '0091 - ExpenseWidget - itemController - Eingabe gelöscht: "${itemController.text}" ---> als String');
      itemController.text = "Stk";
      dev.log(
          '0093 - ExpenseWidget - itemController - umgewandelt in "${itemController.text}" ---> als String');
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
    //   dev.log('0105 --> Eingabe "Brutto-Einzelpreis" fehlt! <---');

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
    //   dev.log('0117 --> Eingabe "Brutto-Gesamtpreis" fehlt! <---');
    // }

    /*--- Anzahl - Umformatierung in double ---*/
    quantity = double.tryParse(quantityController.text) ??
        1.00; // wenn keine Zahl vorhanden ist, dann Zahl = 1.00
    dev.log('0128 -----> Anzahl:           quantity =          $quantity');

    /*--- taxPercent - Umformatierung in double ---*/
    /*--- taxOnNettoItemPrice - Umformatierung in double ---*/
    /*--- taxOnNettoQuantityPrice - Umformatierung in double ---*/

    // taxOnBruttoQuantityPrice =
    //     double.tryParse(taxOnBruttoQuantityPriceController.text) ?? 1.0;
    // dev.log('0136 -----> Anzahl:           quantity =          $taxOnBruttoQuantityPriceController');

    /*--- taxOnBruttoItemPrice - Umformatierung in double ---*/
    /*--- taxOnBruttoQuantityPrice - Umformatierung in double ---*/

    /*--- nettoItemPrice - Umformatierung in double ---*/

    /*--- nettoQuantityPrice - Umformatierung in double ---*/
    // nettoQuantityPrice =
    //     double.tryParse(nettoQuantityPriceController.text) ?? 1.0;

    dev.log(
        "----------------------------------------------------------------------------------------------------------------");

    /* Netto-Einzelpreis - Berechnung + Umrechnung in Cent für genauere Berechnungen*/
    nettoItemPrice = nettoItemPrice * 0.840336134 * 100;
    final nettoItemPriceInCent = nettoItemPrice.roundToDouble();
    dev.log(
        '0143 - getCalculationResult - double: $nettoItemPriceInCent ==> Cent Netto-Einzelpreis');

    /* Netto-Gesamtpreis =  Brutto-Einzelpreis * Anzahl */
    final nettoQuantityPriceInCent = nettoItemPrice.roundToDouble() *
        quantity *
        100; // * 100 = Umrechnung in Cent für genauere Berechnungen
    dev.log(
        '0149 --> Berechnung: [Netto-Gesamtpreis in Cent] $nettoQuantityPriceInCent = [Netto-Einzelpreis] ${nettoItemPrice.roundToDouble()} * [Anzahl] $quantity * 100');
    dev.log(
        '0150 - getCalculationResult - double: $nettoQuantityPriceInCent ==> Cent Netto-Gesamtpreis');
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");

    // /* überprüfen ob das Feld "Brutto-Gesamtpreis" gefüllt ist */
    // if (taxPercentController.text.isEmpty || taxPercentController.text == "") {
    //   showDialog(
    //       context: context,
    //       builder: (context) => const WbDialogAlertUpdateComingSoon(
    //           headlineText: "Zur Berechnung fehlen noch Daten!",
    //           contentText: 'Bitte noch das Feld "Mehrwertsteuersatz" ergänzen.',
    //           actionsText: "OK 👍"));
    //   dev.log('0250 --> Eingabe "Angabe" fehlt! <---');
    // } else {}

    /* Brutto-Einzelpreis = Umformatierung in double */
    bruttoItemPrice = double.tryParse(bruttoItemPriceController.text) ?? 1.0;
    dev.log(
        '0155 -----> Brutto-Einzeln: bruttoItemPrice =     $bruttoItemPrice');

    /* Brutto-Gesamtpreis = Brutto-Einzelpreis * Anzahl */
    final bruttoQuantityPriceInCent = bruttoItemPrice *
        quantity *
        100; // * 100 = Umrechnung in Cent für genauere Berechnungen
    dev.log(
        '0161 --> Berechnung: [Brutto-Gesamtpreis in Cent] $bruttoQuantityPriceInCent = [Brutto-Einzelpreis] $bruttoItemPrice * [Anzahl] $quantity * 100');
    dev.log(
        '0162 - getCalculationResult - double: $bruttoQuantityPriceInCent ==> Cent Brutto-Gesamtpreis');
    bruttoQuantityPrice = bruttoQuantityPriceInCent / 100;
    /*--- bruttoQuantityPrice - Umformatierung in double ---*/
    // bruttoQuantityPrice =
    //     double.tryParse(bruttoQuantityPriceController.text) ?? 1.0;
    bruttoQuantityPriceController.text = bruttoQuantityPrice.toStringAsFixed(2);
    dev.log(
        '0170 -----> Brutto-Gesamt:  bruttoQuantityPrice = ${bruttoQuantityPrice.toStringAsFixed(2)} €');
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");

    /* überprüfen ob das Feld "Mehrwertsteuersatz" gefüllt ist */
    if (taxPercentController.text.isEmpty || taxPercentController.text == "") {
      showDialog(
          context: context,
          builder: (context) => const WbDialogAlertUpdateComingSoon(
              headlineText: "Zur Berechnung fehlen noch Daten!",
              contentText: 'Bitte noch das Feld "Mehrwertsteuersatz" ergänzen.',
              actionsText: "OK 👍"));
      dev.log('0250 --> Eingabe "Angabe" fehlt! <---');
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      /* Mehrwertsteuersatz - Berechnung */
      taxPercentController.text = taxPercentController.text
          .replaceAll(RegExp(r' %'), ''); // das Prozentzeichen entfernen
      dev.log(
          '0174 √ getCalculationResult - Mehrwertsteuersatz: ${taxPercentController.text} %'); //

      taxPercent = double.tryParse(taxPercentController.text) ?? 0.0;
      final taxPercentSet = taxPercent / 100;
      dev.log(
          '0178 √ getCalculationResult - Mehrwertsteuersatz zum Rechnen: $taxPercentSet ==> als double');
    }

    /*----------------------------------------------------------------------------------------------------------------*/
    /* Das sind die Formeln zur Berechnung eines Betrages mit Mehrwertsteuer (MwSt% = 19%)                            
       A.1) Brutto aus dem NETTO berechnen: BRUTTO = Netto + (Netto * MwSt% / 100)
       A.2) Brutto-Zahlenbeispiel bei 100 Euro: BRUTTO = 100€ + (100€ * 19 / 100) = 119,00€ BRUTTO

       B.1) Netto aus dem BRUTTO berechnen: NETTO = Brutto / (1 + (MwSt%/100))
       B.2) Netto-Zahlenbeispiel bei 100 Euro: NETTO = 100€ / (1 + (19/100)) = 84,03€ NETTO

       C.1) MwSt. in Euro aus dem BRUTTO: MwSt€ = Brutto - (Brutto / (1 + (MwSt%/100)))
       C.2) MwSt. in Euro aus 100 EURO: MwSt€ = Brutto - (100€ / (1 + (19/100))) = 15,97€ MwSt€ */
    /*----------------------------------------------------------------------------------------------------------------*/

    /* NETTO-Einzel aus dem BRUTTO-Einzel berechnen: NETTO = BRUTTO / (1 + (MwSt%/100)) */
    nettoItemPrice = bruttoItemPrice / (1 + (taxPercent / 100));
    nettoItemPriceController.text = nettoItemPrice.toStringAsFixed(2);

    /* NETTO-Gesamt aus dem BRUTTO-Gesamt berechnen: NETTO = (BRUTTO / (1 + (MwSt%/100))) * Anzahl */
    nettoQuantityPrice = bruttoQuantityPrice / (1 + (taxPercent / 100));
    nettoQuantityPriceController.text = nettoQuantityPrice.toStringAsFixed(2);

    /* Gesamte Mehrwertsteuer aus dem Brutto-Gesamtpreis berechnen */
    taxOnBruttoItemPrice =
        (bruttoItemPrice - (bruttoItemPrice / (1 + (taxPercent / 100)))) *
            quantity;
    taxOnBruttoItemPriceController.text =
        taxOnBruttoItemPrice.toStringAsFixed(2);
    dev.log(
        '0210 √ getCalculationResult - Mehrwertsteuer für 1 Artikel ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

    // /* Gesamt-Mehrwertsteuer der Einzel-Mwst. * Anzahl berechnen */
    // //taxOnBruttoItemPrice = taxOnBruttoItemPrice * quantity;
    //     taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100) * quantity;
    // dev.log('0214 √ getCalculationResult - Mehrwertsteuer für 1 Artikel gerundet auf double: $taxOnBruttoItemPrice €');

    // //taxOnBruttoQuantityPrice = taxOnBruttoItemPrice * quantity;
    // /* Gesamt-Mehrwertsteuer aus dem Brutto-Gesamtpreis berechnen */
    // // taxOnBruttoQuantityPrice =
    // //     bruttoQuantityPrice - (bruttoQuantityPrice / (1 + (taxPercentSet)));
    // taxOnBruttoQuantityPriceController.text =
    //     taxOnBruttoQuantityPrice.toStringAsFixed(2);
    // dev.log('0220 √ getCalculationResult - Gesamt-Mehrwertsteuer aus dem Brutto-Gesamtpreis ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');
    // dev.log("----------------------------------------------------------------------------------------------------------------");

    // // final taxOnBruttoQuantityPriceInCent =
    // //     bruttoQuantityPriceInCent * (taxPercent / 100);
    // // dev.log('0183 --> Berechnung: [Brutto-Gesamtpreis in Cent] $bruttoQuantityPriceInCent * [MwSt.-Satz] $taxPercent / 100 = [Brutto-Gesamt-MwSt. in Cent] $taxOnBruttoQuantityPriceInCent');
    // // taxOnBruttoQuantityPrice = taxOnBruttoQuantityPriceInCent / 100;
    // // taxOnBruttoQuantityPriceController.text =
    // //     taxOnBruttoQuantityPrice.toStringAsFixed(2);
    // // dev.log('0190 - getCalculationResult - Brutto-Gesamt-MwSt.: ${taxOnBruttoQuantityPriceController.text} €');
    // dev.log("----------------------------------------------------------------------------------------------------------------");

    // /* MwSt. aus dem Brutto-Einzelpreis berechnen (für 1 Artikel) */
    // taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
    // dev.log('235 √ getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

    // /* Mehrwertsteuer auf den Netto-Einzelpreis - Berechnung: (Netto-Einzelpreis / (100 + Mehrwertsteuersatz)) • Mehrwertsteuersatz */
    // final taxOnNettoItemPrice = nettoItemPriceInCent * taxPercentSet;
    // // final taxOnNettoItemPrice =
    // //     (nettoItemPriceInCent / (100 + taxPercentSet)) * taxPercentSet * 100;

    // dev.log('0216 - getCalculationResult - double: $taxOnNettoItemPrice ==> Cent Mehrwertsteuer auf den Netto-Einzelpreis');

    // /* Mehrwertsteuer auf den Netto-Gesamtpreis - Berechnung */
    // final taxOnNettoQuantityPrice = taxOnNettoItemPrice * quantity;
    // dev.log('0220 - getCalculationResult - double: $taxOnNettoQuantityPrice ==> Cent Mehrwertsteuer auf den Netto-Gesamtpreis');

    // /* Netto-Gesamtpreis - Berechnung */
    // final nettoQuantityPrice = nettoItemPrice * quantity;
    // dev.log('0224 - getCalculationResult - double: $nettoQuantityPrice ==> Cent Netto-Gesamtpreis (falsch)');

    /* Brutto-Einzelpreis - Berechnung aus dem Netto-Einzelpreis */

    //     /* den Brutto-Einzelpreis aus dem Netto-Einzelpreis berechnen */
//     // bruttoItemPrice = nettoItemPrice / 1.19;
//     dev.log('0079 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPrice - OHNE "NumberFormat"');

    dev.log(
        "----------------------------------------------------------------------------------------------------------------");

    /*-------------------------------------------------------------------------------*/
    /* Die Ergebnisse umformatieren oder im "Money-Währungsformat" darstellen */
    /*-------------------------------------------------------------------------------*/
    dev.log('---- Anzeigen im Display: ----');
    /*--- Anzahl ---*/
    Money quantityAsFormat =
        Money.fromInt((quantity * 100).toInt(), isoCode: 'EUR');
    quantityController.text = quantityAsFormat.format('###,###.#0');
    dev.log(
        '√ ---> 0336 - ExpenseWidget - Eintrag im Textfeld "Anzahl":        ${quantityAsFormat.format('###,###.#0')}');

    /*--- Brutto-Einzelpreis ---*/
    Money bruttoItemPriceAsMoney =
        Money.fromInt((bruttoItemPrice * 100).toInt(), isoCode: 'EUR');
    bruttoItemPriceController.text =
        bruttoItemPriceAsMoney.format('###,###.#0 S');
    dev.log(
        '√ ---> 0343 - ExpenseWidget - Eintrag "Brutto-Einzelpreis in €":   ${bruttoItemPriceAsMoney.format('###,###.#0 S')}');

    /*--- Brutto-Gesamtpreis ---*/
    bruttoQuantityPrice = bruttoQuantityPriceInCent.roundToDouble();
    Money bruttoQuantityPriceAsMoney =
        Money.fromInt((bruttoQuantityPrice).toInt(), isoCode: 'EUR');
    bruttoQuantityPriceController.text =
        bruttoQuantityPriceAsMoney.format('###,###.#0 S');
    dev.log(
        '√ ---> 0351 - ExpenseWidget - Eintrag "Brutto-Gesamtpreis in €":   ${bruttoQuantityPriceAsMoney.format('###,###.#0 S')}');
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");

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
// //         dev.log('0083 - calculatePrice - $result');
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
//     // dev.log('0078 - getCalculationResult - bruttoQuantityPriceController.text = ${bruttoQuantityPriceController.text}');
//     // dev.log('0079 - getCalculationResult - bruttoQuantityPrice.text = $bruttoQuantityPrice');

// // String bruttoItemPriceController.text =

// // NumberFormat.currency('');

//     /* Anzahl * Brutto-Einzelpreis = Brutto-Gesamtpreis berechnen */
//     // bruttoQuantityPrice = bruttoItemPrice * quantity;
//     // dev.log('0076 - getCalculationResult - Gesamtpreis berechnet: ${bruttoQuantityPrice.toStringAsFixed(2)} €');

//     bruttoQuantityPriceController.text = '101' * 10;
//     dev.log('0076 - getCalculationResult - Gesamtpreis berechnet: $bruttoQuantityPrice €');

//     /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */
//     NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//     String bruttoItemPriceX = formatter.format(bruttoItemPrice);
//     dev.log('0115 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPriceX mit - "NumberFormat formatter = NumberFormat("#,##0.00", "de_DE")" - ');

    dev.log(
        '0277 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
    dev.log(
        '0278 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: $nettoItemPrice €');
    dev.log(
        '0279 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: $taxOnNettoItemPrice €');

//     dev.log('0085 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "nettoItemPrice": $nettoItemPrice');
//     dev.log('0086 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "bruttoItemPrice": $bruttoItemPrice');
//     dev.log('0087 - getCalculationResult ---> Rechnungszahl "bruttoItemPriceX": $bruttoItemPriceX');
//     // nettoItemPrice = bruttoItemPriceX / 1.19;
//     // nettoItemPrice = double.parse(nettoItemPrice as String);
//     //nettoItemPrice = nettoQuantityPrice.toStringAsFixed(2);
//     dev.log("----------------------------------------------------------------------------------------------------------------");

//     /* den Netto-Gesamtpreis berechnen */
//     nettoQuantityPrice = nettoItemPrice * quantity;

    dev.log(
        '0292 - getCalculationResult - Netto-Gesamtpreis berechnet: ${nettoQuantityPrice.toStringAsFixed(2)} €');
    dev.log(
        '0293 - getCalculationResult - Netto-Gesamtpreis berechnet: $nettoQuantityPrice €');
    dev.log(
        '0294 - getCalculationResult - Netto-Gesamtpreis berechnet: $nettoItemPrice€');

//     /* die MwSt. aus dem Netto-Einzelpreis berechnen */
//     taxOnNettoItemPrice = nettoItemPrice * (taxPercent / 100);
//     dev.log('0097 - getCalculationResult - Mwst. aus dem Netto-Einzelpreis berechnet: ${taxOnNettoItemPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Netto-Einzelpreis * Anzahl, Gewicht, Stück?  berechnen */
//     taxOnNettoQuantityPrice = nettoItemPrice * quantity * (taxPercent / 100);
//     dev.log('0101 - getCalculationResult - Mwst. aus dem Netto-Gesamtpreis berechnet: ${taxOnNettoQuantityPrice.toStringAsFixed(2)} €');

//     /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
//     taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
//     dev.log('0109 - getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

    dev.log(
        '0316 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');
    dev.log(
        '0317 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: $taxOnBruttoQuantityPrice €');
    dev.log(
        '0318 - getCalculationResult - Mwst. aus dem Netto-Gesamtpreis berechnet:  ${taxOnBruttoQuantityPriceController.text} €');

    // dev.log("----------------------------------------------------------------------------------------------------------------");

//     taxSum = bruttoItemPrice * quantity * (taxPercent / 100);
//     totalSum = bruttoItemPrice * quantity + taxSum;
//     nettoItemPrice = bruttoItemPrice / (1 + 0.19);
//     dev.log('0122 - getCalculationResult - Netto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");
    dev.log(
        "Netto-Einzelpreis:    ${nettoItemPrice.toStringAsFixed(2)} € pro Einheit");
    dev.log("Gekaufte Einheiten:   $quantity $item");
    // dev.log("Mehrwertsteuer:       ${taxSum.toStringAsFixed(2)} €");
    // dev.log("Gesamtsumme           ${totalSum.toStringAsFixed(2)} €");
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");
    // /* Nach der Berechnung müssen wieder alle Zahlen in das Rechenformat mit Punkt vor den Dezimalzahlen umgestellt werden */
    // /*-------------------------------------------------------------------------------------------------------------------*/
    // dev.log('0078 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> ist keine Währung');
    // /* (1) alle Komma durch "x" ersetzen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[,]'), 'x');
    // dev.log('0082 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> Komma durch x ersetzt');

    // /* (2) alle Punkte entfernen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[.]'), '');
    // dev.log('0087 √ getCalculationResult - Anzahl als Text:                ${quantityController.text} --> Punkte gelöscht');

    // /* (3) alle "x" durch Punkte ersetzen */
    // quantityController.text =
    //     quantityController.text.replaceAll(RegExp(r'[x]'), '.');
    // dev.log('0092 √ getCalculationResult - Anzahl als double:              ${quantityController.text} --> x durch Punkt ersetzt');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0094 √ getCalculationResult - Einheiten als Text:             ${itemController.text} --> wird nicht umgestellt');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0096 √ getCalculationResult - MwSt. als Prozentsatz:          ${taxPercentController.text}');
    // taxPercentController.text =
    //     taxPercentController.text.replaceAll(RegExp(r'[ %,]'), '');
    // dev.log('0095 √ getCalculationResult - MwSt. als double:               ${taxPercentController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0097 - getCalculationResult - Brutto-Einzel als Text:         ${bruttoItemPriceController.text} €');
    // bruttoItemPriceController.text =
    //     bruttoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0078 - getCalculationResult - Brutto-Einzel als double:       ${bruttoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0079 - getCalculationResult - Brutto-Gesamt als Text:         ${bruttoQuantityPriceController.text} €');
    // bruttoQuantityPriceController.text =
    //     bruttoQuantityPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0079 - getCalculationResult - Brutto-Gesamt als double:       ${bruttoQuantityPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0080 - getCalculationResult - Netto-Einzel als Text:          ${nettoItemPriceController.text} €');
    // nettoItemPriceController.text =
    //     nettoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0080 - getCalculationResult - Netto-Einzel als double:        ${nettoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0081 - getCalculationResult - Brutto-Gesamt als Text:         ${nettoQuantityPriceController.text} €');
    // nettoQuantityPriceController.text =
    //     nettoQuantityPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0081 - getCalculationResult - Brutto-Gesamt als double:       ${nettoQuantityPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0082 - getCalculationResult - Brutto-Einzel-MwSt. als Text:   ${taxOnBruttoItemPriceController.text} €');
    // taxOnBruttoItemPriceController.text =
    //     taxOnBruttoItemPriceController.text.replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0082 - getCalculationResult - Brutto-Einzel-MwSt. als double: ${taxOnBruttoItemPriceController.text}');
    // dev.log("----------------------------------------------------------------------------------------------------------------");
    // dev.log('0083 - getCalculationResult - Brutto-Gesamt-MwSt. als Text: ${taxOnBruttoQuantityPriceController.text} €');
    // taxOnBruttoQuantityPriceController.text = taxOnBruttoQuantityPriceController
    //     .text
    //     .replaceAll(RegExp(r'[ €,]'), '');

    // dev.log('0083 - getCalculationResult - Brutto-Gesamt-MwSt. als double: ${taxOnBruttoQuantityPriceController.text}');
    dev.log(
        "----------------------------------------------------------------------------------------------------------------");
    setState(() {}); // Aktualisierung der UI
    // packageMoney2Test();
  }

// /*--------------------------------- package money2 (https://pub.dev/packages/money2) ---*/
//   void packageMoney2Test() {
//     dev.log("----------------------------------------------------------------------------------------------------------------");
//     /* Eine Währung erstellen - der Betrag wur immer als int als Cent-Betrag angegebeen, um Rundungsfehler zu vermeiden */
//     final moneyTest1 = Money.fromInt(10025090, isoCode: 'EUR');
//     dev.log('0001 - moneyTest1: $moneyTest1'); // leider noch ohne Tausender-Separator und Leerzeichen beim Währungssymbol
//     dev.log('0002 - moneyTest2: ${moneyTest1.format('###,###.#0 S')} ---> das ist der küzeste und BESTE Code √');

//     /* Definiere den Tausender-Separator und das Leerzeichen beim Währungssymbol EURO */
//     /* Benutze Kommas ',' für den integer/fractional Separator und Punkte '.' für den Tausender-Separator ---> 1.000,00 */
//     final euro = Currency.create('EUR', 2,
//         symbol: '€',
//         groupSeparator: '.',
//         decimalSeparator: ',',
//         pattern: '#,##0.00 S');
//     final moneyTest3 = Money.fromIntWithCurrency(
//         10025090, euro); // die Zahl ist ein Cent-Betrag!
//     dev.log('0003 - moneyTest3: $moneyTest3'); // Ergebnis: 100.250,90 €

//     /* Eine [Money]-Instanz aus einem String mit [Currency.parse] erstellen - Währung: € - */
//     final moneyTest4 = CommonCurrencies().euro.parse(r'10,50');
//     dev.log('0004 - moneyTest4: ${moneyTest4.format('0.00 S')}'); //  S = Währungszeichen

//     /* Die [Währung] von moneyTest3 ist USD. */
//     final moneyTest5 = CommonCurrencies().usd.parse(r'$10.51');
//     dev.log('0005 - moneyTest3: ${moneyTest5.format('CCS 0.00')}'); // CC = Land / S = Währungszeichen

//     /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */ // funzt HIER nicht
//     // NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//     // String moneyTest2formatiert = formatter.format(moneyTest2);
//     // dev.log('0004 - moneyTest2 wurde formatiert: $moneyTest2formatiert');
//   }

// void formatMoneyAfterCalculation(Money value, Money valueAsMoney) {
//   dev.log("----------------------------------------------------------------------------------------------------------------");
//   //value = bruttoItemPrice;
//   /* Wenn die Berechnung stattgefunden hat, soll sobald das Textfeld verlassen wird, der Wert in eine Währung umgewandelt werden */
//   /* 1) Den Wert * 100 ergibt den Wert in Cent */
//   var valueMultiplied100 = value * 100;
//   dev.log('0001 - formatMoneyAfterCalculation - Wert in Cent: $valueMultiplied100');

//   /* Den Wert von "double" in einen "int" umwandeln mit ".toInt()" ---> schneidet nach dem Kamma einfach alles ab */
//   int valueAsIntInCent = valueMultiplied100.toInt();
//   dev.log('0002 - formatMoneyAfterCalculation - $valueMultiplied100 = $valueAsIntInCent Cent');

//   /* Den Wert als Euro-Wert darstellen */
//   Money valueAsMoney = Money.fromInt(valueAsIntInCent, isoCode: 'EUR');
//   dev.log('0003 - formatMoneyAfterCalculation - Eintrag im Textfeld: $valueAsMoney');
//   dev.log('0004 - formatMoneyAfterCalculation - Eintrag im Textfeld: ${valueAsMoney.format('###,###.#0 S')}');
//   dev.log("----------------------------------------------------------------------------------------------------------------");
// }

  /*--------------------------------- Kontakt-ID generieren ---*/
  Future<String> generateContactID() async {
    dev.log('0599 - ExpenseWidget - ContactID wird generiert');
    var rng = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() +
        rng.nextInt(1000).toString();
  }

  Future<void> insertNewShop(String newShopText, String newContactID) async {
    final database = await openDatabase('JOTHAsoft.FiveStars.db');
    await database.insert(
      'KundenDaten',
      {
        /*--- Die leeren Felder unbedingt mit einem leerem String initialisieren, sonst wird "null" eingetragen! ---*/
        'TKD_Feld_000': '',
        'TKD_Feld_001': '',
        'TKD_Feld_002': '',
        'TKD_Feld_003': '',
        'TKD_Feld_004': '',
        'TKD_Feld_005': '',
        'TKD_Feld_006': '',
        'TKD_Feld_007': '',
        'TKD_Feld_008': '',
        'TKD_Feld_009': '',
        'TKD_Feld_010': '',
        'TKD_Feld_011': '',
        'TKD_Feld_012': '',
        'TKD_Feld_013': '',
        'TKD_Feld_014': newShopText,
        'TKD_Feld_015': '',
        'TKD_Feld_016': '',
        'TKD_Feld_017': '',
        'TKD_Feld_018': '',
        'TKD_Feld_019': '',
        'TKD_Feld_020': '',
        'TKD_Feld_021': '',
        'TKD_Feld_022': '',
        'TKD_Feld_023': '',
        'TKD_Feld_024': '',
        'TKD_Feld_025': '',
        'TKD_Feld_026': '',
        'TKD_Feld_027': '',
        'TKD_Feld_028': '',
        'TKD_Feld_029': '',
        'TKD_Feld_030': newContactID
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _generatePdf() async {
    dev.log('0696 - ExpenseWidget - PDF wird generiert');
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /*--- Überschrift: Ausgabe-Beleg ---*/
              pw.Text(
                'Ausgabe-Beleg',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              /*--- Ausgabe der Firma ---*/
              pw.SizedBox(height: 10),
              pw.Text('Ausgabe der Firma MUSTERMANN'),
              pw.SizedBox(height: 10),

              /*--- Datum des Einkaufs ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Datum des Einkaufs:',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )),
                        pw.Text(
                          '25.03.2025',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Wo eingekauft ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Wo eingekauft:\n'),
                    pw.Container(
                      width: 200,
                      child: pw.Text(
                        shopController.text.replaceAll(RegExp(r'[•]'), ''),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Was eingekauft ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Was eingekauft:\n'),
                    pw.Container(
                      width: 200,
                      child: pw.Text(
                        controllerWasGekauft.text
                            .replaceAll(RegExp(r'[•]'), ''),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Menge und Einheit ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Menge und Einheit:'),
                        pw.Text(
                          '${quantityController.text} ${itemController.text}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Netto-Einzelpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Netto-Einzelpreis: '),
                        pw.Text(
                          '${nettoItemPriceController.text.replaceAll(RegExp(r'[ €.]'), ',')} EUR',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Netto-Gesamtpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Netto-Gesamtpreis: '),
                        pw.Text(
                          '${nettoQuantityPriceController.text.replaceAll(RegExp(r'[ €.]'), ',')} EUR',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Mehrwertsteuersatz ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Mehrwertsteuersatz: '),
                        pw.Text(
                          '${taxPercentController.text} %',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Brutto-Einzelpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Brutto-Einzelpreis:'),
                        pw.Text(
                          '${bruttoItemPriceController.text.replaceAll(RegExp(r'[ €.]'), '')} EUR',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Mehrwertsteuer auf den Brutto-Einzelpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('MwSt. Brutto-Einzeln:'),
                        pw.Text(
                          '${taxOnBruttoItemPriceController.text.replaceAll(RegExp(r'[ €.]'), ',')} EUR',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Brutto-Gesamtpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Brutto-Gesamtpreis:'),
                        pw.Text(
                          '${bruttoQuantityPriceController.text.replaceAll(RegExp(r'[ €.]'), '')} EUR',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Mehrwertsteuer auf den Brutto-Gesamtpreis ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('MwSt. Brutto-Gesamt:',
                            textAlign: pw.TextAlign.left),
                        pw.Text(
                          '${taxPercentController.text.replaceAll(RegExp(r'[ €.]'), ',')} EUR', //taxOnBruttoQuantityPriceController
                          style: pw.TextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Zahlungsmittel ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Zahlungsmittel:'),
                        pw.Text(
                          '${controllerZahlungsmittel.text.replaceAll(RegExp(r'[€]'), '')} ',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Warengruppe ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Warengruppe:'),
                        pw.Text(
                          '${controllerWarengruppe.text.replaceAll(RegExp(r'[€]'), '')} ',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Einkäufer ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Einkäufer:'),
                        pw.Text(
                          '${controllerEinkaeufer.text.replaceAll(RegExp(r'[€]'), '')} ',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              /*--- Notizen ---*/
              pw.Container(
                width: 220,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Notizen:'),
                        pw.Text(
                          '${controllerNotizen.text.replaceAll(RegExp(r'[€]'), '')} ',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    dev.log("0024 - ExpenseWidget - wird benutzt");

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*--------------------------------- Wo wurde eingekauft? 0631 ---*/
          DropdownSearch<String>(
            key: dropDownKey,
            /*--------------------------------- decoratorProps ---*/
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: 'Wo wurde eingekauft?',
                labelStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: wbColorButtonBlue,
                ),

                // hintText: 'Geschäft / Lieferant',
                // hintStyle: TextStyle(
                //   fontSize: 12,
                //   fontWeight: FontWeight.bold,
                //   color: wbColorButtonBlue,
                // ),

                filled: true,
                fillColor: wbColorBackgroundRed,

                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(16),
                //   borderSide: BorderSide(
                //     color: Colors.black,
                //     width: 1,
                //   ),
                // ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),

                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(16),
                //   borderSide: BorderSide(
                //     color: wbColorButtonBlue,
                //     width: 1,
                //   ),
                // ),

                // errorBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(16),
                //   borderSide: BorderSide(
                //     color: wbColorButtonBlue,
                //     width: 1,
                //   ),
                // ),

                // focusedErrorBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(16),
                //   borderSide: BorderSide(
                //     color: wbColorButtonBlue,
                //     width: 1,
                //   ),
                // ),

                /*--------------------------------- Icon im Suchfeld des Auswahlmenüs ---*/
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),

                // /*--------------------------------- IconButton für "Neues Geschäft hinzufügen" im Suchfeld des Auswahlmenüs ---*/
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     Icons.add_circle, //delete_forever,
                //     color: wbColorButtonBlue,
                //     size: 52,
                //     semanticLabel: 'Neues Geschäft hinzufügen',
                //   ),
                //   onPressed: () {
                //     dev.log('0700 - ExpenseWidget - "Wo wurde eingekauft?" - Neues Geschäft hinzufügen');
                //     //shopController.clear();
                //   },
              ),
            ),

            /*--------------------------------- dropdownBuilder ---*/
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? "Bitte ein Geschäft auswählen",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null, // Zeilenumbruch ermöglichen
                // overflow: TextOverflow.ellipsis, // Textüberlauf zeigt "..." an
              );
            },

            /*--------------------------------- selectedItem ---*/
            selectedItem: shopController.text.isEmpty
                ? "Bitte ein Geschäft auswählen"
                : shopController.text,
            items: (filter, loadProps) async {
              /*--------------------------------- Datenbank öffnen ---*/
              final databasePath = await getDatabasesPath();
              dev.log('0809 - ExpenseWidget - Datenbankpfad: $databasePath');
              final database = await openDatabase('JOTHAsoft.FiveStars.db');

              /*--------------------------------- Überprüfen, ob die Tabelle "KundenDaten" vorhanden ist ---*/
              final tableExists = await database.rawQuery(
                  "SELECT name FROM sqlite_master WHERE type='table' AND name='KundenDaten'");

              if (tableExists.isEmpty) {
                dev.log(
                    '0817 - ExpenseWidget - Die Tabelle "KundenDaten" existiert nicht!');
                return [];
              }

              try {
                /*--------------------------------- Datenbankabfrage ---*/
                final results = await database.rawQuery(
                    'SELECT TKD_Feld_014, TKD_Feld_006, TKD_Feld_007, TKD_Feld_005 FROM KundenDaten WHERE TKD_Feld_014 IS NOT NULL AND TRIM(TKD_Feld_014) != ""');

                /*--------------------------------- Ergebnisse übermitteln • ---*/
                return results
                    .map((row) =>
                        '${row['TKD_Feld_014']} • ${row['TKD_Feld_006']} ${row['TKD_Feld_007']} • ${row['TKD_Feld_005']}')
                    .toList();
              } catch (e) {
                dev.log('Fehler beim Abrufen der Daten: $e');
                return [];
              }
            },

            /*--------------------------------- PopupProps ---*/
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              /*--------------------------------- Suchfunktion ---*/
              showSearchBox: true,
              /*--------------------------------- TextFieldProps - ANFANG ---*/
              searchFieldProps: TextFieldProps(
                /*--------------------------------- Auswahlmenü - InputDecoration ---*/
                decoration: InputDecoration(
                  /*--- Hintergrundfarbe des Suchfeldes im Auswahlmenü ---*/
                  filled: true,
                  fillColor: wbColorButtonDarkRed,

                  /*--- Textfarbe des Suchfeldes im Auswahlmenü ---*/
                  labelText: 'Suche ...',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  hintText: 'Geschäft / Lieferant',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),

                  /*--- Icon im Suchfeld des Auswahlmenüs ---*/
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),

                  /*--- IconButton für "Neues Geschäft hinzufügen" im Suchfeld des Auswahlmenüs ---*/
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add_circle, //delete_forever,
                      color: Colors.yellow, size: 52,
                      semanticLabel: 'Neues Geschäft hinzufügen',
                    ),
                    onPressed: () {
                      dev.log(
                          '0700 - ExpenseWidget - "Wo wurde eingekauft?" - Neues Geschäft hinzufügen');
                      // Öffne Dialog zum Eingeben eines neuen Geschäfts
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController newShopController =
                              TextEditingController();
                          return AlertDialog(
                            title: Text('Neues Geschäft hinzufügen'),
                            content: TextField(
                              controller: newShopController,
                              decoration: InputDecoration(
                                  hintText: "Das neue Geschäft eingeben"),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Abbrechen'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Hinzufügen'),
                                onPressed: () {
                                  dev.log(
                                      '0851 - ExpenseWidget - "Wo wurde eingekauft?" - Neues Geschäft hinzugefügt - Eingabe: ${newShopController.text}');
                                  setState(() {
                                    shopController.text =
                                        newShopController.text;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('In Datenbank speichern?'),
                                        content: Text(
                                            'Möchtest Du das NEUE Geschäft auch in der Datenbank speichern?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Nein'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Ja'),
                                            onPressed: () async {
                                              try {
                                                dev.log(
                                                    '0874 - ExpenseWidget - "Wo wurde eingekauft?" - Neues Geschäft wird in Datenbank gespeichert');
                                                String newContactID =
                                                    await generateContactID();
                                                String newShopText =
                                                    newShopController
                                                            .text.isEmpty
                                                        ? ''
                                                        : newShopController
                                                            .text;
                                                await insertNewShop(
                                                    newShopText, newContactID);
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                /*--------------------------------- Sound ---*/
                                                player.play(AssetSource(
                                                    "sound/sound06pling.wav"));

                                                /*--------------------------------- Snackbar / Toast ---*/
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor:
                                                      wbColorButtonGreen,
                                                  content: Text(
                                                    'Das neue Geschäft wurde erfolgreich hinzugefügt. 👍\n\nBei Bedarf kannst du nachträglich im Bereich "Kontakte" die fehlenden Daten ergänzen. 😉',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ));
                                                /*--------------------------------- *** ---*/
                                              } catch (e) {
                                                /*--------------------------------- Navigator ---*/
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                /*--------------------------------- Sound ---*/
                                                player.play(AssetSource(
                                                    "sound/sound03enterprise.wav"));

                                                /*--------------------------------- Snackbar / Toast ---*/
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor:
                                                      wbColorButtonDarkRed,
                                                  content: Text(
                                                    'Es gab einen Fehler beim Hinzufügen des neuen Geschäfts. 😟\n\nBitte versuche es später noch einmal.',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ));
                                                /*--------------------------------- *** ---*/
                                                dev.log(
                                                    '0963 - ExpenseWidget - Fehler beim Hinzufügen des neuen Geschäfts: $e');
                                                /*--------------------------------- *** ---*/
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                /*--- Cursor im Suchfeld des Auswahlmenüs ---*/
                cursorColor: Colors.yellow,
                cursorWidth: 5.0,
                cursorHeight: 30.0,

                /*--- Text im Suchfeld des Auswahlmenüs ---*/
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              /*--------------------------------- TextFieldProps - ENDE ---*/
              menuProps: MenuProps(
                borderRadius: BorderRadius.circular(0),
                backgroundColor: wbColorButtonBlue,

                /*--- Schriftfarbe des Auswahlmenüs ---*/

                /*--- Schatten des Auswahlmenüs ---*/
                shadowColor: Colors.black,
                elevation: 12,

                /*--- Der Seiten-Hintergrund wird eingefärbt, solange das Menü geöffnet ist ---*/
                // barrierColor: wbColorLogoBlue,
                // barrierLabel: 'Suchfeld schließen',
                // semanticLabel: 'Suchfeld schließen',
                // barrierDismissible: true,
                // clipBehavior: Clip.none,
                // borderOnForeground: true,
                // color: Colors.yellow,
                // surfaceTintColor: Colors.yellow,
                // margin: EdgeInsets.all(0),
              ),

              /*--------------------------------- itemBuilder ---*/
              itemBuilder: (context, item, isDisabled, isSelected) => Column(
                children: [
                  ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(color: Colors.white), // Divider hinzugefügt
                ],
              ),
            ),

            /*--------------------------------- onChanged ---*/
            onChanged: (String? newValue) {
              dev.log(
                  '0659 - ExpenseWidget - "Wo wurde eingekauft?" - Ausgewählt: $newValue');
              setState(() {
                shopController.text = newValue ?? '';
              });
            },
          ),

          // /*--------------------------------- Wo wurde eingekauft? 0662 ---*/
          // WbTypeAheadField(
          //   controller: shopController,
          //   labelText: 'Wo wurde eingekauft?',
          //   hintText: 'In welchem Geschäft eingekauft?',
          //   prefixIcon: Icons.house_outlined,
          //   suffixIcon: Icons.delete_forever,
          //   fillColor: wbColorBackgroundRed,
          //   borderColor: wbColorButtonDarkRed,
          //   suggestionsBoxColor: wbColorLogoBlue,
          //   listTileTextColor: Colors.white,
          //   listTileTextStyle: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          //   tableName: 'KundenDaten',
          //   tableColumnName: 'TKD_Feld_014', // Firma
          // ),

          // // /*--------------------------------- Was wurde eingekauft? ---*/
          // TypeAheadField(
          //   suggestionsBoxDecoration: SuggestionsBoxDecoration(
          //     /*--- Hintergrundfarbe des Auswahlmenüs ---*/
          //     color: wbColorLogoBlue,
          //   ),
          //   /*--------------------------------- Wo wurde eingekauft? ---*/
          //   itemBuilder: (context, suggestion) {
          //     /*--------------------------------- ListTile = Auswahl-Liste---*/
          //     return Column(
          //       children: [
          //         ListTile(
          //           title: Text(
          //             suggestion.toString(),
          //             style: TextStyle(
          //               fontSize: 20, // Schriftgröße
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white, // Schriftfarbe
          //             ),
          //           ),
          //         ),
          //         /*--------------------------------- Divider ---*/
          //         Divider(color: Colors.white),
          //       ],
          //     );
          //   },
          //   onSuggestionSelected: (suggestion) {
          //     dev.log('0632 - ExpenseWidget - "Wo wurde eingekauft?" - Ausgewählt: $suggestion');
          //     setState(() {
          //       shopController.text = suggestion.toString();
          //       dev.log('0634 - ExpenseWidget - "Wo wurde eingekauft?" - itemController.text: ${itemController.text}');
          //     });
          //   },
          //   suggestionsCallback: (pattern) async {
          //     /*--- Hier wird die Datenbankabfrage hinzugefügt ---*/
          //     final databaseSuggestions =
          //         await fetchDatabaseSuggestions(pattern);
          //     final staticSuggestions = [
          //       'JOTHAsoft.de • Schwäbisch Gmünd',
          //       'OBI • Schwäbisch Gmünd',
          //       'Kaufland • Schwäbisch Gmünd',
          //       'Toom • Schwäbisch Gmünd',
          //       'ACTION • Schwäbisch Gmünd',
          //       'WOOLWORTH • Schwäbisch Gmünd',
          //       'ARAL-Tankstelle • Schwäbisch Gmünd',
          //     ];

          //     return [
          //       ...staticSuggestions,
          //       ...databaseSuggestions,
          //     ]
          //         .where((item) =>
          //             item.toLowerCase().contains(pattern.toLowerCase()))
          //         .toList();
          //   },

          //   /*--------------------------------- TextFieldConfiguration ---*/
          //   textFieldConfiguration: TextFieldConfiguration(
          //     controller: shopController,
          //     maxLines: null,
          //     style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.w900,
          //         height:
          //             1.1), // Zeilenabstand wenn mehrere Zeilen gezeigt werden.
          //     decoration: InputDecoration(
          //       fillColor: wbColorBackgroundRed,
          //       filled: true,
          //       labelText: 'Wo wurde eingekauft?',
          //       labelStyle:
          //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       hintText: 'In welchem Geschäft eingekauft?',
          //       hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: 8, horizontal: 8), // Innenabstand

          //       /*--------------------------------- prefixIcon - Icon ---*/
          //       prefixIcon: Icon(
          //         Icons.house_outlined, //send_rounded,
          //         color: wbColorButtonDarkRed,
          //         size: 32,
          //       ),

          //       /*--------------------------------- suffixIcon - IconButton ---*/
          //       suffixIcon: IconButton(
          //         icon: Icon(Icons.delete_forever),
          //         iconSize: 32, //cancel_outlined),
          //         onPressed: () {
          //           shopController.clear();
          //         },
          //       ),

          //       /*--------------------------------- Border ---*/
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(16),
          //         borderSide: BorderSide(
          //           color: wbColorButtonDarkRed,
          //           width: 10,
          //           style: BorderStyle.solid,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,

          // /*--------------------------------- Wo eingekauft? ---*/
          // WbDropDownMenu(
          //   /* Hier besser eine Map erstellen - ExpenseWidget - 0033 - todo */
          //   label: "Wo wurde eingekauft?",
          //   dropdownItems: [
          //     "OBI",
          //     "Kaufland",
          //     "Toom",
          //     "ACTION",
          //     "WOOLWORTH",
          //     "Tankstelle",
          //   ],
          //   leadingIconsInMenu: [
          //     Icons.send_rounded,
          //     Icons.cancel_outlined,
          //     Icons.handyman_outlined,
          //     Icons.cable_outlined,
          //     Icons.pending_actions_outlined,
          //     Icons.car_repair_outlined,
          //   ],
          //   leadingIconInTextField: Icons.house_outlined,
          //   backgroundColor: wbColorBackgroundRed,
          //   width: 400,
          // ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Was eingekauft? ---*/
          WbDropDownMenu(
            label: "Was wurde eingekauft?",
            controller: controllerWasGekauft,
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
              wbText: 'Anzahl  •  Einheiten  •  Steuern',
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
                    dev.log(
                        "----------------------------------------------------------------------------------------------------------------");
                    dev.log(
                        '0393 - ExpenseWidget - quantityController - Eingabe: "${quantityController.text}" - als String');
                    /* Wenn bei der Eingabe aus Versehen Buchstaben oder Sonderzeichen verwendet werden */
                    if (quantityController.text.contains(
                        RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                      quantityController.text = "";
                      dev.log(
                          '0398 - ExpenseWidget - quantityController - umgewandelt in "${quantityController.text}" ---> als String');
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
                      /*--------------------------------- Try/catch setState ---*/
                    }
                    try {
                      setState(() {
                        quantityController.text = quantityController.text
                            .replaceAll(RegExp(r','), '.');
                        dev.log(
                            '-------> text neu: ${quantityController.text}');
                        quantity = double.parse(quantityController.text);
                        dev.log(
                            '0749 - ExpenseWidget - quantityController - in setState als double geparst: ${quantityController.text}');
                        dev.log(
                            "0752 - ExpenseWidget - quantityController - setState ausgeführt: $quantity ---> als double <--- ");
                        dev.log(
                            '0755 - ExpenseWidget - quantityController - setState ausgeführt: ${quantityController.text} ---> im TextFormField eingetragen? ---> Ja');
                      });
                      dev.log(
                          "----------------------------------------------------------------------------------------------------------------");
                    } catch (e) {
                      dev.log(
                          '0759 - ExpenseWidget - Fehlermeldung - Eingabe: ${quantityController.text} - als String');
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                                headlineText: "Fehlermeldung!",
                                contentText:
                                    'Entweder ist das Feld "Anzahl" leer oder bei der Eingabe wurde mehr als 1 Dezimalkommastelle eingegeben !\n\nWeiter Hinweis:\nTausender-Trennpunkte werden später nach der Berechnung automatisch angezeigt.',
                                actionsText: "OK 👍",
                              ));
                      quantityController.text = '';
                    }
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
                  //initialSelection: 2, // Index 2 aus "dropdownItems" = "19 %" (soll hier nicht automatisch angezeigt werden)
                  backgroundColor: wbColorBackgroundRed,
                  controller: taxPercentController,
                ),
              ),
            ],
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Divider ---*/
          WbDividerWithTextInCenter(
              wbColor: wbColorButtonDarkRed,
              wbText: 'Brutto-Preise - inclusive MwSt.',
              wbTextColor: wbColorButtonDarkRed,
              wbFontSize12: 18,
              wbHeight3: 3),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Brutto-Einzelpreis in € ---*/
          WbTextFormFieldTEXTOnly(
            labelText: "Brutto-Einzelpreis in €",
            labelFontSize20: 18,
            hintText: "Brutto-Einzelpreis in €",
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
              dev.log(
                  "----------------------------------------------------------------------------------------------------------------");
              dev.log(
                  '0640 - ExpenseWidget - bruttoItemPriceController - Eingabe: "${bruttoItemPriceController.text}" - als String');
              /* wenn beim Eingeben aus Versehen ein falsches Zeichen benutzt wird */
              if (bruttoItemPriceController.text
                  .contains(RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                bruttoItemPriceController.text = "";
                dev.log(
                    '0645 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "${bruttoItemPriceController.text}" ---> als String');
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
                  dev.log(
                      '-------> text neu: ${bruttoItemPriceController.text}');

                  // quantity = double.parse(bruttoItemPriceController.text);

/*--------------------------------- *** ---*/
                  dev.log(
                      "0670 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoItemPrice ---> als double <--- damit darf NICHT gerechnet werden !!!");
/*--------------------------------- *** ---*/

                  dev.log(
                      '0673 - ExpenseWidget - quantityController - setState ausgeführt: ${bruttoItemPriceController.text} ---> im TextFormField eingetragen? ---> Ja');
                  // bruttoItemPriceController.text = quantity.toString();
                });
                // getCalculationResult();
                dev.log(
                    "----------------------------------------------------------------------------------------------------------------");
              } catch (e) {
                dev.log(
                    '0679 - ExpenseWidget - Fehlermeldung - Eingabe: ${bruttoItemPriceController.text} - als String');
                bruttoItemPriceController.text = '';
              }
            },

            // /*--------------------------------- onChanged ---*/
            // controller: bruttoItemPriceController,
            // onChanged: (String value) {
            //   dev.log("----------------------------------------------------------------------------------------------------------------");
            //   dev.log("0506 - ExpenseWidget - bruttoItemPriceController - Eingabe: $bruttoItemPriceController - als String");
            //   dev.log("0507 - ExpenseWidget - bruttoItemPriceController - Eingabe: ${bruttoItemPriceController.text} - als String");

            //   /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
            //   if (bruttoItemPriceController.text == "") {
            //     dev.log('0509 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoItemPriceController" ---> als String');
            //     bruttoItemPriceController.text = "0.00";
            //     dev.log('0512 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoItemPriceController" ---> als String');
            //   }
            //   try {
            //     setState(() {
            //       bruttoItemPrice =
            //           double.parse(bruttoItemPriceController.text);
            //       dev.log("0518 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoItemPrice ---> als double");
            //       dev.log('0519 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: "$bruttoItemPriceController" ---> im TextFormField eingetragen? ---> Ja');
            //     });
            //     getCalculationResult();
            //     // /* Das Ergebnis im "Money-Währungsformat" darstellen*/
            //     // Money valueAsMoney =
            //     //     Money.fromInt((bruttoItemPrice * 100).toInt(), isoCode: 'EUR',);
            //     // dev.log('0521 - ExpenseWidget - Eintrag im Textfeld "Einzelpreis Brutto in €": ${valueAsMoney.format('###,###.#0 S')}');
            //     // bruttoItemPriceController.text =
            //     //     valueAsMoney.format('###,###.#0 S');
            //     dev.log("----------------------------------------------------------------------------------------------------------------");
            //   } catch (e) {
            //     bruttoItemPriceController.text = '0.00';
            //   }
            //   // /* Das Ergebnis im "Money-Währungsformat" darstellen */
            //   // Money valueAsMoney = Money.fromInt(
            //   //   (bruttoItemPrice * 100).toInt(),
            //   //   isoCode: 'EUR',
            //   // );
            //   // dev.log('0521 - ExpenseWidget - Eintrag im Textfeld "Einzelpreis Brutto in €": ${valueAsMoney.format('###,###.#0 S')}');
            //   // bruttoItemPriceController.text =
            //   //     valueAsMoney.format('###,###.#0 S');
            // },
            // // focusNode: FocusNode(),

            /*--------------------------------- *** ---*/
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
          /*--------------------------------- Brutto-Gesamtpreis in € ---*/
          WbTextFormFieldTEXTOnly(
            labelText: "Brutto-Gesamtpreis in €",
            labelFontSize20: 18,
            hintText: "Brutto-Gesamtpreis in €",
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
              dev.log(
                  "----------------------------------------------------------------------------------------------------------------");
              dev.log(
                  '0752 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: "${bruttoQuantityPriceController.text}" - als String');
              /* wenn beim Eingeben aus Versehen ein falsches Zeichen benutzt wird */
              if (bruttoQuantityPriceController.text
                  .contains(RegExp(r'[a-zA-Z!"§$%&/(=?`*_:;><#+´^°@€)]'))) {
                bruttoQuantityPriceController.text = "";
                dev.log(
                    '0757 - ExpenseWidget - bruttoQuantityPriceController - umgewandelt in "${bruttoQuantityPriceController.text}" ---> als String');
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
                  dev.log(
                      '-------> Text neu: ${bruttoQuantityPriceController.text}');

                  // bruttoQuantityPrice = double.parse(bruttoQuantityPriceController.text);

                  dev.log(
                      "0781 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: $bruttoQuantityPrice ---> als double");
                  dev.log(
                      '0782 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: ${bruttoQuantityPriceController.text} ---> im TextFormField eingetragen? ---> Ja');
                  bruttoQuantityPriceController.text =
                      bruttoQuantityPrice.toStringAsFixed(2);
                });
                // getCalculationResult();
                dev.log(
                    "----------------------------------------------------------------------------------------------------------------");
              } catch (e) {
                dev.log(
                    '0788 - ExpenseWidget - Fehlermeldung - Eingabe: ${bruttoQuantityPriceController.text} - als String');
                bruttoQuantityPriceController.text = '';
              }

              setState(() {
                bruttoQuantityPriceController.text =
                    bruttoQuantityPrice.toStringAsFixed(2);
                if (bruttoQuantityPriceController.text == "") {
                  dev.log(
                      '0796 - ExpenseWidget - bruttoQuantityPriceController - Eingabe gelöscht: "$bruttoQuantityPriceController" ---> als String');
                  bruttoQuantityPriceController.text = "";
                  dev.log(
                      '0798 - ExpenseWidget - bruttoQuantityPriceController - umgewandelt in "$bruttoQuantityPriceController" ---> als String');
                }
              });
            },

            // /*--------------------------------- onChanged ---*/
            // controller: bruttoQuantityPriceController,
            // onChanged: (String bruttoQuantityPriceController) {
            //   dev.log("0457 - ExpenseWidget - bruttoQuantityPriceController - Eingabe: $bruttoQuantityPriceController - als String");
            //   /* wenn beim Löschen aus Versehen eine "null" entsehen sollte, muss die Ziffer "0" erscheinen */
            //   if (bruttoQuantityPriceController == "") {
            //     dev.log('0460 - ExpenseWidget - bruttoItemPriceController - Eingabe gelöscht: "$bruttoQuantityPriceController" ---> als String');
            //     bruttoQuantityPriceController = "0.00";
            //     dev.log('0462 - ExpenseWidget - bruttoItemPriceController - umgewandelt in "$bruttoQuantityPriceController" ---> als String');
            //   }

            //   // bruttoQuantityPrice = double.parse(bruttoQuantityPriceController);
            //   // setState(() => bruttoQuantityPrice =
            //   //     double.parse(bruttoQuantityPriceController));
            //   // dev.log("0297 - ExpenseWidget - bruttoItemPriceController - setState ausgeführt: $bruttoQuantityPrice ---> als double");

            //   // setState(() {
            //   //   bruttoQuantityPrice = double.parse(bruttoQuantityPriceController);
            //   //   dev.log('0366 - ExpenseWidget - bruttoQuantityPriceController - setState ausgeführt: "$bruttoQuantityPriceController" ---> im TextFormField eingetragen? ---> NEIN !!! todo');
            //   // });

            //   getCalculationResult();
            // },
            // /*--------------------------------- *** ---*/
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Divider ---*/
          WbDividerWithTextInCenter(
              wbColor: wbColorButtonDarkRed,
              wbText: 'Übersicht',
              wbTextColor: wbColorButtonDarkRed,
              wbFontSize12: 18,
              wbHeight3: 3),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
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
                /*--------------------------------- Container - Netto-Einzeln OHNE MwSt. ---*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        'Netto-Einzeln (ohne MwSt.):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          // '${nettoItemPrice.toStringAsFixed(2)} €',
                          '${nettoItemPriceController.text} €',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                /*--------------------------------- Container - Netto-Gesamt ---*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(
                    children: [
                      Text(
                        // 'Netto-Gesamt für ${quantity.toStringAsFixed(2)} $item:',
                        'Netto-Gesamt für ${quantityController.text} ${itemController.text}:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          // '${nettoQuantityPrice.toStringAsFixed(2)} €',
                          '${nettoQuantityPriceController.text} €',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
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
                /*--------------------------------- Container - Mehrwertsteuer für 1 Artikel ---*/
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Mehrwertsteuer für 1 Artikel:',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       Expanded(
                //         child: Text(
                //           // '${taxOnNettoItemPrice.toStringAsFixed(2)} €',
                //           //'${taxOnNettoItemPrice}Controller 0935',
                //           '${taxOnBruttoItemPriceController.text} €',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //           ),
                //           textAlign: TextAlign.right,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                /*--------------------------------- Container - Mehrwertsteuer für alle Artikel ---*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      Text(
                        //'Gesamt-MwSt. für ${quantity.toStringAsFixed(2)} $item:',
                        // 'Gesamt-MwSt. für ${quantityController.text} ${itemController.text}:',
                        'MwSt. insgesamt (${taxPercentController.text}):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          //'${taxOnNettoQuantityPrice.toStringAsFixed(2)} €'
                          //'${taxOnNettoQuantityPrice}Controller 0960',
                          // '${taxOnBruttoQuantityPriceController.text} €',
                          '${taxOnBruttoItemPriceController.text} €',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
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
                /*--------------------------------- Container - Brutto-Einzeln (incl. MwSt.) ---*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        'Brutto-Einzeln (incl. MwSt.):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          //'${bruttoItemPrice.toStringAsFixed(2)} €'
                          '${bruttoItemPriceController.text} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                /*--------------------------------- Container - Brutto-Gesamt für alle Artikel ---*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(
                    children: [
                      Text(
                        // 'Brutto-Gesamt für ${quantity.toStringAsFixed(2)} $item:',
                        'Brutto-Gesamt für ${quantityController.text} ${itemController.text}:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          // '${bruttoQuantityPrice.toStringAsFixed(2)} €',
                          '${bruttoQuantityPriceController.text} ',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
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
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Divider ---*/
          WbDividerWithTextInCenter(
              wbColor: wbColorButtonDarkRed,
              wbText: 'Netto-Preise - OHNE - MwSt.',
              wbTextColor: wbColorButtonDarkRed,
              wbFontSize12: 18,
              wbHeight3: 3),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Abstand ---*/
          SizedBox(height: 12),
          /*--------------------------------- ElevatedButton - Berechnung ---*/
          Center(
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: wbColorDrawerOrangeLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: wbColorAppBarBlue,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Berechnung durchführen',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onPressed: () {
                  dev.log("------------------------------------------------");
                  dev.log('0714 - ExpenseWidget - ElevatedButton angeklickt');
                  getCalculationResult();
                  dev.log("------------------------------------------------");
                },
              ),
            ),
          ),
          /*--------------------------------- ElevatedButton - PDF erstellen ---*/
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: wbColorDrawerOrangeLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: wbColorAppBarBlue,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: _generatePdf,
                child: Text(
                  'PDF erstellen und ggf. ausdrucken',
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
            controller: controllerWarengruppe,
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
            controller: controllerEinkaeufer,
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

          /*--------------------------------- Zahlungsmittel ---*/
          WbDropDownMenu(
            label: 'Wie wurde bezahlt?',
            dropdownItems: [
              'Barzahlung',
              'EC-Karte',
              'Kreditkarte',
              'Revolut DL',
              'Revolut JH',
              'PayPal',
              'Überweisung JH',
              'Überweisung DL',
              'Sonstiges',
            ],
            controller: controllerZahlungsmittel,
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
            controller: controllerNotizen,

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
                  dev.log(
                      "0139 - ExpenseWidget - Ausgabe SPEICHERN - geklickt");
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
      // TextEditingValue oldValue, TextEditingValue newValue) {
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    int punkte = newValue.text.split('.').length - 1;
    if (punkte > 1) {
      return oldValue; // Verhindert die Eingabe eines weiteren Punktes
    }
    return newValue;
  }
}

// Future<List<String>> fetchDatabaseSuggestions(String pattern) async {
//   /*--- Hier wird die Datenbankabfrage durchgeführt ---*/
//   final database = await openDatabase('JOTHAsoft.FiveStars.db');
//   final results = await database.rawQuery(
//       'SELECT TKD_Feld_014, TKD_Feld_006, TKD_Feld_007, TKD_Feld_005 FROM KundenDaten WHERE TKD_Feld_014 LIKE ?',
//       ['%$pattern%']);

//   return results
//       .where((row) =>
//           row['TKD_Feld_014'] != null &&
//           row['TKD_Feld_014'].toString().trim().isNotEmpty)
//       .map((row) =>
//           '${row['TKD_Feld_014']} • ${row['TKD_Feld_006']} ${row['TKD_Feld_007']} • ${row['TKD_Feld_005']}')
//       .toList();
// }
