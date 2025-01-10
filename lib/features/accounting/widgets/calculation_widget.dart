// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:money2/money2.dart';

// class CalculationWidget extends StatefulWidget {
//   const CalculationWidget({super.key});

//   @override
//   State<CalculationWidget> createState() => _CalculationWidgetState();
// }

// /*--------------------------------- Controller ---*/
// final TextEditingController quantityController =
//     TextEditingController(); // Eingabe
// final TextEditingController itemController = TextEditingController(); // Eingabe
// final TextEditingController taxPercentController =
//     TextEditingController(); // Eingabe

// final TextEditingController bruttoItemPriceController =
//     TextEditingController(); // Eingabe oder berechnet
// final TextEditingController bruttoQuantityPriceController =
//     TextEditingController(); // Eingabe oder berechnet


// /* Variablen um die Preise zu berechnen - 0260 */
// double quantity = 0.00; // Eingabe
// double quantityPrice = 0.00; // berechnet

// String item = 'Stk'; // Eingabe

// double taxPercent = 19.00; // Eingabe
// double taxOnNettoItemPrice = 0.00; // berechnet
// double taxOnNettoQuantityPrice = 0.00; // berechnet

// double taxOnBruttoItemPrice = 0.00; // berechnet
// double taxOnBruttoQuantityPrice = 0.00; // berechnet

// double nettoItemPrice = 0.00; // Eingabe - später im Update
// double nettoQuantityPrice = 0.00; // berechnet

// double bruttoItemPrice = 0.00; // Eingabe oder berechnet
// double bruttoQuantityPrice = 0.00; // Eingabe oder berechnet

// double taxSum = 0.00; // berechnet
// double totalSum = 0.00; // berechnet

// /*--------------------------------- package money2 ---*/
// void packageMoney2Test() {
//   log("----------------------------------------------------------------------------------------------------------------");
//   /* Eine Währung erstellen, in der 10,00 EUR gespeichert sind.
//    Hinweis: Wir verwenden die kleinere Einheit (z. B. Cent), wenn wir den Wert übergeben. Also sind 10,00 EUR = 1000 Cent. */
//   final moneyTest1 = Money.fromInt(100000000, isoCode: 'EUR');
//   log('0001 - moneyTest1: $moneyTest1');

//   /* Eine [Money]-Instanz aus einem String mit [Currency.parse] erstellen - Währung: € - */
//   final moneyTest2 = CommonCurrencies().euro.parse(r'10,50');
//   log('0002 - moneyTest2: ${moneyTest2.format('0.00 S')}'); //  S = Währungszeichen

//   /* Die [Währung] von moneyTest3 ist USD. */
//   final moneyTest3 = CommonCurrencies().usd.parse(r'$10.51');
//   log('0003 - moneyTest3: ${moneyTest3.format('CCS 0.00')}'); // CC = Land / S = Währungszeichen

//   /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */ // funzt nicht
//   // NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//   // String moneyTest2formatiert = formatter.format(moneyTest2);
//   // log('0004 - moneyTest2 wurde formatiert: $moneyTest2formatiert');
// }





// class _CalculationWidgetState extends State<CalculationWidget> {
//   @override

//   Widget build(BuildContext context) {
//     return Container(); // Replace with your actual widget
//     void getCalculationResult() {
//       packageMoney2Test();
//       /* die einzelnen Positionen berechnen */
//       /* die Ergebnisse sind mit ".toStringAsFixed(2)" auf 2 Stellen nach dem Komma gekürzt */
//       log("----------------------------------------------------------------------------------------------------------------");
//       log('0059 - getCalculationResult - String: ${quantityController.text} ==> Anzahl als double: $quantity');
//       log('0060 - getCalculationResult - String: ${itemController.text} ==> Einheiten als Text: $item');
//       log('0061 - getCalculationResult - String: ${taxPercentController.text} ==> MwSt. als double: $taxPercent');
//       log('0062 - getCalculationResult - String: ${bruttoItemPriceController.text} ==> Brutto-Einzel als double: $bruttoItemPrice €');
//       log('0064 - getCalculationResult - String: ${bruttoQuantityPriceController.text} ==> Brutto-Gesamt als double: $bruttoQuantityPrice €');

//       // Netto-Einzel im Update
//       // Netto-Gesamt im Update

//       // Validator wegen Schreibweise der Zahlenformate

//       //'${bruttoQuantityPrice.toStringAsFixed(2)} €',
//       log("----------------------------------------------------------------------------------------------------------------");
//       /* Anzahl * Brutto-Einzelpreis = Brutto-Gesamtpreis berechnen */
//       bruttoQuantityPrice = bruttoItemPrice * quantity;
//       log('0076 - getCalculationResult - Gesamtpreis berechnet: ${bruttoQuantityPrice.toStringAsFixed(2)} €');
//       /* den Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnen */
//       // nettoItemPrice = bruttoItemPrice / 1.19;
//       log('0079 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPrice - OHNE "NumberFormat"');
//       /* Zahlenformat mit Tausender-Trennzeichen + 2 Dezimalstellen in deutsch-locale */
//       NumberFormat formatter = NumberFormat('#,##0.00', 'de_DE');
//       String bruttoItemPriceX = formatter.format(bruttoItemPrice);
//       log('0083 - getCalculationResult ---> bruttoItemPrice: $bruttoItemPriceX mit - "NumberFormat formatter = NumberFormat("#,##0.00", "de_DE")" - ');
//       log('0084 - getCalculationResult ---> Netto-Einzelpreis aus dem Brutto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
//       log('0085 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "nettoItemPrice": $nettoItemPrice');
//       log('0086 - getCalculationResult ---> Rundungsfehler wegen Rechnungszahl "bruttoItemPrice": $bruttoItemPrice');
//       log('0087 - getCalculationResult ---> Rechnungszahl "bruttoItemPriceX": $bruttoItemPriceX');
//       // nettoItemPrice = bruttoItemPriceX / 1.19;
//       // nettoItemPrice = double.parse(nettoItemPrice as String);
//       //nettoItemPrice = nettoQuantityPrice.toStringAsFixed(2);
//       log("----------------------------------------------------------------------------------------------------------------");
//       /* den Netto-Gesamtpreis berechnen */
//       nettoQuantityPrice = nettoItemPrice * quantity;
//       log('0093 - getCalculationResult - Netto-Gesamtpreis berechnet: ${nettoQuantityPrice.toStringAsFixed(2)} €');

//       /* die MwSt. aus dem Netto-Einzelpreis berechnen */
//       taxOnNettoItemPrice = nettoItemPrice * (taxPercent / 100);
//       log('0097 - getCalculationResult - Mwst. aus dem Netto-Einzelpreis berechnet: ${taxOnNettoItemPrice.toStringAsFixed(2)} €');

//       /* die MwSt. aus dem Netto-Einzelpreis * Anzahl, Gewicht, Stück?  berechnen */
//       taxOnNettoQuantityPrice = nettoItemPrice * quantity * (taxPercent / 100);
//       log('0101 - getCalculationResult - Mwst. aus dem Netto-Gesamtpreis berechnet: ${taxOnNettoQuantityPrice.toStringAsFixed(2)} €');

//       /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
//       taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
//       log('0105 - getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

//       /* die MwSt. aus dem Brutto-Einzelpreis berechnen */
//       taxOnBruttoItemPrice = bruttoItemPrice * (taxPercent / 100);
//       log('0109 - getCalculationResult - Mwst. aus dem Brutto-Einzelpreis berechnet: ${taxOnBruttoItemPrice.toStringAsFixed(2)} €');

//       /* die MwSt. aus dem Brutto-Gesamtpreis berechnen */
//       taxOnBruttoQuantityPrice = bruttoQuantityPrice * (taxPercent / 100);
//       log('0113 - getCalculationResult - Mwst. aus dem Brutto-Gesamtpreis berechnet: ${taxOnBruttoQuantityPrice.toStringAsFixed(2)} €');
//       log("----------------------------------------------------------------------------------------------------------------");

//       // double getInvoiceResult(doublebruttoItemPrice, double quantity) {
//       // double taxPercent = 19;

//       taxSum = bruttoItemPrice * quantity * (taxPercent / 100);
//       totalSum = bruttoItemPrice * quantity + taxSum;
//       nettoItemPrice = bruttoItemPrice / (1 + 0.19);
//       log('0122 - getCalculationResult - Netto-Einzelpreis berechnet: ${nettoItemPrice.toStringAsFixed(2)} €');
//       log("----------------------------------------------------------------------------------------------------------------");
//       log("Netto-Einzelpreis:    ${nettoItemPrice.toStringAsFixed(2)} € pro Einheit");
//       log("Gekaufte Einheiten:   $quantity Stück");
//       log("Mehrwertsteuer:       ${taxSum.toStringAsFixed(2)} €");
//       log("Gesamtsumme           ${totalSum.toStringAsFixed(2)} €");
//       log("----------------------------------------------------------------------------------------------------------------");
//     }
//   }
// }