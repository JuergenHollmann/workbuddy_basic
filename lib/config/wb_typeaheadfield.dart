import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sqflite/sqflite.dart';

class WbTypeAheadField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Color fillColor;
  final Color borderColor;
  final Color suggestionsBoxColor;
  final TextStyle listTileTextStyle;
  final Color listTileTextColor;
  final String? databaseName;
  final String? tableName;
  final String? tableColumnName;
  final String? fieldPattern;
  final String? fieldResult;

  const WbTypeAheadField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.fillColor,
    required this.borderColor,
    required this.suggestionsBoxColor,
    required this.listTileTextStyle,
    required this.listTileTextColor,
    this.databaseName,
    this.tableName,
    this.tableColumnName,
    this.fieldPattern,
    this.fieldResult,
  });

  @override
  Widget build(BuildContext context) {
    log('0035 - WbTypeAheadField - aktiviert');
    return TypeAheadField(
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        /*--- Hintergrundfarbe des Auswahlmenüs ---*/
        color: suggestionsBoxColor, // Hintergrundfarbe des Auswahlmenüs
      ),
      itemBuilder: (context, suggestion) {
        return Column(
          children: [
            /*--------------------------------- ListTile = Auswahl-Liste---*/
            ListTile(
              title: Text(
                suggestion.toString(),
                style: listTileTextStyle,
              ),
            ),
            /*--------------------------------- Divider ---*/
            Divider(
                color: Colors.white), // Weißer Divider zwischen den Einträgen
          ],
        );
      },
      onSuggestionSelected: (suggestion) {
        log('0058 - WbTypeAheadField - Ausgewählt: $suggestion');
        controller.text = suggestion.toString();
        log('0060 - WbTypeAheadField - itemController.text: ${controller.text}');
      },
      suggestionsCallback: (pattern) async {
        /*--- Hier wird die Datenbankabfrage hinzugefügt ---*/
        final databaseSuggestions = await fetchDatabaseSuggestions(pattern);
        final staticSuggestions = [
          'JOTHAsoft.de • Schwäbisch Gmünd',
          'OBI • Schwäbisch Gmünd',
          'Kaufland • Schwäbisch Gmünd',
          'Toom • Schwäbisch Gmünd',
          'ACTION • Schwäbisch Gmünd',
          'WOOLWORTH • Schwäbisch Gmünd',
          'ARAL-Tankstelle • Schwäbisch Gmünd',
        ];

        return [
          ...staticSuggestions,
          ...databaseSuggestions,
        ]
            .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },

      /*--------------------------------- TextFieldConfiguration ---*/
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        maxLines: null,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.1),
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          contentPadding:
              EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Innenabstand

          /*--------------------------------- prefixIcon - Icon ---*/
          prefixIcon: Icon(
            prefixIcon,
            color: borderColor,
            size: 32,
          ),

          /*--------------------------------- suffixIcon - IconButton ---*/
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            iconSize: 32,
            onPressed: () {
              controller.clear();
            },
          ),

          /*--------------------------------- Border ---*/
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: borderColor,
              width: 10,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchDatabaseSuggestions(String pattern) async {
    /*--- Hier wird die Datenbankabfrage durchgeführt ---*/
    final database = await openDatabase('JOTHAsoft.FiveStars.db');
    final results = await database.rawQuery(
        'SELECT $tableColumnName, TKD_Feld_006, TKD_Feld_007, TKD_Feld_005 FROM $tableName WHERE $tableColumnName LIKE ?',
        ['%$pattern%']);

    return results
        .where((row) =>
            row['$tableColumnName'] != null &&
            row['$tableColumnName'].toString().trim().isNotEmpty)
        .map((row) =>
            '${row['$tableColumnName']} • ${row['TKD_Feld_006']} ${row['TKD_Feld_007']} • ${row['TKD_Feld_005']}')
        .toList();
  }
}
