import 'dart:developer';

import 'package:age_calculator/age_calculator.dart' show AgeCalculator;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_only_date.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/jhs_custom_widgets/jhs_autocomplete.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/database_helper.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class ContactScreen extends StatefulWidget {
  final Map<String, dynamic> contact;
  final bool isNewContact;

  const ContactScreen(
      {super.key, required this.contact, required this.isNewContact});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

/*--------------------------------- Controller ---*/
final scrollController = ScrollController();
final compPersonAge = TextEditingController();
final Map<String, TextEditingController> controllers = {
  for (var i = 1; i <= 50; i++)
    'controllerCS${i.toString().padLeft(3, '0')}': TextEditingController(),
};

/*--------------------------------- Daten speichern 0082 ---*/
Future<void> saveData(BuildContext context) async {
  if (controllers['controllerCS003']!.text.isEmpty &&
      controllers['controllerCS004']!.text.isEmpty &&
      controllers['controllerCS015']!.text.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fehler"),
        content: Text("Vorname und Nachname dürfen nicht leer sein."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK 👍"),
          ),
        ],
      ),
    );
    return;
  }

  var db = await DatabaseHelper.instance.database;

  /*--- Überprüfen, ob ein Datensatz mit der gleichen KontaktID bereits existiert ---*/
  final List<Map<String, dynamic>> result = await db.query(
    'Tabelle01',
    where: 'Tabelle01_001 = ?',
    whereArgs: [controllers['controllerCS001']!.text],
  );

  if (result.isNotEmpty) {
    log('0113 - ContactScreen - Daten mit der KontaktID ${controllers['controllerCS001']!.text} existieren bereits!');
    /*--- Zeige eine SnackBar an, wenn die Daten bereits existieren ---*/
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Ein Datensatz mit der KontaktID ${controllers['controllerCS001']!.text} existiert bereits!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: wbColorButtonDarkRed,
      duration: Duration(milliseconds: 2000),
    ));
    return;
  }

  /*--- Das aktuelle Datum und die Uhrzeit im gewünschten Format vorbereiten ...
  ----> anstatt "DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())" als Original-Datumsformat ---*/
  final now = DateTime.now();
  final formattedDateTime =
      '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} um ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} Uhr';

  /*--- Angelegt von angemeldetem User (mit MA-NR) ---*/
  // ignore: use_build_context_synchronously
  final currentUser = Provider.of<CurrentUserProvider>(context, listen: false);
  log('0148 - ContactScreen - Angelegt von MA-NR: ${currentUser.currentUser}');
  // employeeID = 'JH-01'; // Hier die MA-NR aus den Einstellungen eintragen - CS-0147 currentUser ist die MA-NR

  /*--------------------------------- Hier werden alle Daten der "ContactScreen" gespeichert (INSERT) ---*/
  log('0094 - ContactScreen - Daten werden in die "Tabelle01" gespeichert');
  await db.insert('Tabelle01', {
    for (var i = 1; i <= 50; i++)
      'Tabelle01_${i.toString().padLeft(3, '0')}':
          controllers['controllerCS${i.toString().padLeft(3, '0')}']!.text,

    /*--- Hier werden die Daten gespeichert, die nicht in der "ContactScreen" einzugeben sind ---*/
    'Tabelle01_047': currentUser.currentUser,
    'Tabelle01_048': formattedDateTime,
    'Tabelle01_049': currentUser.currentUser,
    'Tabelle01_050': formattedDateTime,
  });

  log('0099 - ContactScreen - Daten gespeichert von ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
}

/*--------------------------------- Button-Farbe beim Anklicken ändern ---*/
bool isButton01Clicked = false;
bool isButton02Clicked = false;
bool isButton03Clicked = false;
bool isButton04Clicked = false;
bool isButton05Clicked = false;
bool isButton06Clicked = false;
bool isButton07Clicked = false;
bool isButton08Clicked = false;
bool isButton09Clicked = false; // Daten speichern
bool isButton10Clicked = false; // Daten löschen
bool isButton11Clicked = false;

/*--------------------------------- Dynamische SQL-Update-Funktion ---*/
Future<void> updateData(Map<String, dynamic> row) async {
  log('0117 - ContactScreen - Daten für Update: $row'); // Debugging hinzufügen

  var db = await DatabaseHelper.instance.database;

  final filteredRow = row..removeWhere((key, value) => value == null);
  final fields = filteredRow.keys.map((key) => '$key = ?').join(', ');
  final values = filteredRow.values.toList();

  if (fields.isEmpty || !row.containsKey('Tabelle01_001')) {
    log('0126 - ContactScreen - Keine Felder zum Aktualisieren oder Primärschlüssel fehlt.');
    return;
  }

  await db.rawUpdate('UPDATE Tabelle01 SET $fields WHERE Tabelle01_001 = ?', [
    ...values,
    row['Tabelle01_001'],
  ]);

  log('0135 - ContactScreen - Daten aktualisiert: $row');
}

void saveChanges(BuildContext context) async {
  final updatedRow = {
    for (var i = 1; i <= 50; i++)
      'Tabelle01_${i.toString().padLeft(3, '0')}':
          controllers['controllerCS${i.toString().padLeft(3, '0')}']!.text,
  };
  updatedRow['Tabelle01_001'] = controllers['controllerCS001']!.text;

  /*--------------------------------- Angelegt von angemeldetem User (mit MA-NR) ---*/
  final currentUser = Provider.of<CurrentUserProvider>(context, listen: false);
  updatedRow['Tabelle01_047'] = currentUser.currentUser;
  log('0148 - ContactScreen - Angelegt von MA-NR: ${currentUser.currentUser}');
  // employeeID = 'JH-01'; // Hier die MA-NR aus den Einstellungen eintragen - CS-0147 currentUser ist die MA-NR

  /*--------------------------------- Aktualisiert von angemeldetem User (mit MA-NR) ---*/
  updatedRow['Tabelle01_049'] = currentUser.currentUser;
  log('0151 - ContactScreen - Aktualisiert von MA-NR: ${currentUser.currentUser}');

  /*--------------------------------- Update-Datum = aktuelles Datum und Uhrzeit ---*/
  final now = DateTime.now();
  final formattedDateTime =
      '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} um ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} Uhr';
  updatedRow['Tabelle01_050'] = formattedDateTime;

  /*--------------------------------- Update alle Daten von oben nach unten ---*/
  await updateData(updatedRow);
  log('0137 - ContactScreen - All Daten gespeichert bei ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
  /*--------------------------------- *** ---*/
}

/*--------------------------------- Datensatz löschen - CS-0138 ---*/
Future<void> deleteData(Map<String, dynamic> row) async {
  /*--- Die Datenbank öffnen, indem auf die Instanz von DatabaseHelper zugegriffen wird ---*/
  var db = await DatabaseHelper.instance.database;
  log('0140 - ContactScreen - Datenbank geöffnet');

  /*--- Der Name der Tabelle, aus der der Datensatz gelöscht werden soll ---*/
  final String tableName = 'Tabelle01';
  log('0143 - ContactScreen - Datensatz löschen aus Tabelle: $tableName');

  /*--- Die Spalte, welche KontaktID enthält ---*/
  final String columnKontaktID = 'Tabelle01_001';
  log('0146 - ContactScreen - Datensatz löschen aus Spalte mit KontaktID: $columnKontaktID');

  /*--- Die KontaktID, die gelöscht werden soll ---*/
  final String kontaktIDToDelete = controllers['controllerCS001']!.text;
  log('0151 - ContactScreen - KontaktID L-Ö-S-C-H-E-N: $kontaktIDToDelete');

  /*--- Den Löschvorgang durchführen ---*/
  await db.delete(
    tableName, // Name der Tabelle
    where:
        '$columnKontaktID = ?', // WHERE-Bedingung: Löschen, wo die KontaktID gleich dem Wert ist ---*/
    whereArgs: [
      kontaktIDToDelete
    ], // Argument für die WHERE-Bedingung (z.B.: KontaktID 1234) ---*/
  );

  /*--- Bestätigung ausgeben, dass der Datensatz gelöscht wurde ---*/
  log('0167 - ContactScreen - Der Datensatz mit KontaktID $kontaktIDToDelete wurde gelöscht.');
}

/*--------------------------------- State ---*/
class _ContactScreenState extends State<ContactScreen> {
  /*--------------------------------- Controller ---*/
  ////
  // final TextEditingController _controller = TextEditingController();
  ////
  final Map<String, TextEditingController> controllers = {
    for (var i = 1; i <= 50; i++)
      'controllerCS${i.toString().padLeft(3, '0')}': TextEditingController(),
  };

  //final FocusNode _focusNode = FocusNode();

/*---------------------------------------------------------------------------------------------------------------------------------*/
  @override
  void initState() {
    super.initState();
    initializeFilteredItems();
    loadItemsFromDatabase();
  }

  final Map<String, List<String>> filteredItems = {};
  final Map<String, List<String>> allItems = {};

  void initializeFilteredItems() {
    for (var i = 1; i <= 50; i++) {
      final key = 'K${i.toString().padLeft(3, '0')}';
      filteredItems[key] = [];
      allItems[key] = [];
    }
  }

  Future<void> loadItemsFromDatabase() async {
    final db = await DatabaseHelper.instance.database;

    for (var i = 1; i <= 50; i++) {
      final column = 'Tabelle01_${i.toString().padLeft(3, '0')}';
      final results = await db.query(
        'Tabelle01',
        columns: [column],
        distinct: true,
        orderBy: '$column ASC',
      );

      setState(() {
        final key = 'K${i.toString().padLeft(3, '0')}';
        allItems[key] =
            results.map((row) => (row[column] as String?) ?? '').toList();
        filteredItems[key] = allItems[key]!;
      });

      log('0180 - ContactScreen - Alle Items: $allItems');
      log('0181 - ContactScreen - Gefilterte Items: $filteredItems');
      final key = 'K${i.toString().padLeft(3, '0')}';
      log('0182 - ContactScreen - Key: $key');
      log('0183 - ContactScreen - Column: $column');
      log('0184 - ContactScreen - Results: $results');
      log('0185 - ContactScreen - AllItems: ${allItems[key]}');
      log('0186 - ContactScreen - FilteredItems: ${filteredItems[key]}');

//   }
// }

/*---------------------------------------------------------------------------------------------------------------------------------*/

      // void initializeFilteredItems() {
      //   for (var i = 1; i <= 50; i++) {
      //     final key = 'K${i.toString().padLeft(3, '0')}';
      //     filteredItems[key] = [];
      //     allItems[key] = [];
      //   }
      // }

      // List<String> _filteredItems = [];
      // List<String> _filteredItemsK002 = [];
      // List<String> _filteredItemsK003 = [];
      // List<String> _filteredItemsK004 = [];
      // List<String> _filteredItemsK005 = [];
      // List<String> _filteredItemsK006 = [];
      // List<String> _filteredItemsK007 = [];
      // List<String> _filteredItemsK008 = [];
      // List<String> _filteredItemsK009 = [];
      // List<String> _filteredItemsK010 = [];
      // List<String> _filteredItemsK011 = [];
      // List<String> _filteredItemsK012 = [];
      // List<String> _filteredItemsK013 = [];
      // List<String> _filteredItemsK014 = [];
      // List<String> _filteredItemsK015 = [];
      // List<String> _filteredItemsK016 = [];
      // List<String> _filteredItemsK017 = [];
      // List<String> _filteredItemsK018 = [];
      // List<String> _filteredItemsK019 = [];
      // List<String> _filteredItemsK020 = [];
      // List<String> _filteredItemsK021 = [];
      // List<String> _filteredItemsK022 = [];
      // List<String> _filteredItemsK023 = [];
      // List<String> _filteredItemsK024 = [];
      // List<String> _filteredItemsK025 = [];
      // List<String> _filteredItemsK026 = [];
      // List<String> _filteredItemsK027 = [];
      // List<String> _filteredItemsK028 = [];
      // List<String> _filteredItemsK029 = [];
      // List<String> _filteredItemsK030 = [];
      // List<String> _filteredItemsK031 = [];
      // List<String> _filteredItemsK032 = [];
      // List<String> _filteredItemsK033 = [];
      // List<String> _filteredItemsK034 = [];
      // List<String> _filteredItemsK035 = [];
      // List<String> _filteredItemsK036 = [];
      // List<String> _filteredItemsK037 = [];
      // List<String> _filteredItemsK038 = [];
      // List<String> _filteredItemsK039 = [];
      // List<String> _filteredItemsK040 = [];
      // List<String> _filteredItemsK041 = [];
      // List<String> _filteredItemsK042 = [];
      // List<String> _filteredItemsK043 = [];
      // List<String> _filteredItemsK044 = [];
      // List<String> _filteredItemsK045 = [];
      // List<String> _filteredItemsK046 = [];
      // List<String> _filteredItemsK047 = [];
      // List<String> _filteredItemsK048 = [];
      // List<String> _filteredItemsK049 = [];
      // List<String> _filteredItemsK050 = [];

      // List<String> _allItems = [];
      // final List<String> _allItemsK002 = [];
      // List<String> _allItemsK003 = [];
      // List<String> _allItemsK004 = [];
      // final List<String> _allItemsK005 = [];
      // final List<String> _allItemsK006 = [];
      // final List<String> _allItemsK007 = [];
      // final List<String> _allItemsK008 = [];
      // final List<String> _allItemsK009 = [];
      // final List<String> _allItemsK010 = [];
      // final List<String> _allItemsK011 = [];
      // final List<String> _allItemsK012 = [];
      // final List<String> _allItemsK013 = [];
      // final List<String> _allItemsK014 = [];
      // final List<String> _allItemsK015 = [];
      // final List<String> _allItemsK016 = [];
      // final List<String> _allItemsK017 = [];
      // final List<String> _allItemsK018 = [];
      // final List<String> _allItemsK019 = [];
      // final List<String> _allItemsK020 = [];
      // final List<String> _allItemsK021 = [];
      // final List<String> _allItemsK022 = [];
      // final List<String> _allItemsK023 = [];
      // final List<String> _allItemsK024 = [];
      // final List<String> _allItemsK025 = [];
      // final List<String> _allItemsK026 = [];
      // final List<String> _allItemsK027 = [];
      // final List<String> _allItemsK028 = [];
      // final List<String> _allItemsK029 = [];
      // final List<String> _allItemsK030 = [];
      // final List<String> _allItemsK031 = [];
      // final List<String> _allItemsK032 = [];
      // final List<String> _allItemsK033 = [];
      // final List<String> _allItemsK034 = [];
      // final List<String> _allItemsK035 = [];
      // final List<String> _allItemsK036 = [];
      // final List<String> _allItemsK037 = [];
      // final List<String> _allItemsK038 = [];
      // final List<String> _allItemsK039 = [];
      // final List<String> _allItemsK040 = [];
      // final List<String> _allItemsK041 = [];
      // final List<String> _allItemsK042 = [];
      // final List<String> _allItemsK043 = [];
      // final List<String> _allItemsK044 = [];
      // final List<String> _allItemsK045 = [];
      // final List<String> _allItemsK046 = [];
      // final List<String> _allItemsK047 = [];
      // final List<String> _allItemsK048 = [];
      // final List<String> _allItemsK049 = [];
      // final List<String> _allItemsK050 = [];

      /*--------------------------------- Überprüfen, ob sich die Daten geändert haben ---*/
      bool hasDataChanged() {
        for (var i = 1; i <= 50; i++) {
          final key = 'controllerCS${i.toString().padLeft(3, '0')}';
          final fieldKey = 'Tabelle01_${i.toString().padLeft(3, '0')}';
          if (controllers[key]!.text != (widget.contact[fieldKey] ?? '')) {
            return true;
          }
        }
        return false;
      }

      /*--------------------------------- Überprüfen, ob das erste Feld leer ist und dann scrollen ---*/
      void checkAndScrollToEmptyField() {
        if (controllers['controllerCS003']!.text.isEmpty) {
          log('0373 - ContactScreen - Ist controllerCS003 leer? ${controllers['controllerCS003']!.text.isEmpty}');
          // Setze den Fokus auf das erste Feld
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration.zero, () {
            log('0379 - ContactScreen - Fokus auf Feld 002 gesetzt');
            Scrollable.ensureVisible(
              // ignore: use_build_context_synchronously
              context,
              alignment: 0.5, // Scrollt zur Mitte des Bildschirms
              duration: Duration(milliseconds: 500),
            );
            log('0381 - ContactScreen - Scrollt zur Mitte des Bildschirms');
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            log('0384 - ContactScreen - Scrollt nach oben');
          });
        }
      }

      /*--------------------------------- AudioPlayer ---*/
      ////
      // late AudioPlayer player = AudioPlayer();
      ////

      /*--- für die Berechnung des Alters und der Zeitspanne bis zum nächsten Geburtstag ---*/
      ////
      // int ageY = 0, ageM = 0, ageD = 0, nextY = 0, nextM = 0, nextD = 0;
      // DateTime initTime = DateTime.now();
      // DateTime selectedTime = DateTime.now();
      // String today = DateFormat('dd.MM.yyyy').format(DateTime.now());
      ////

      /*--- Automatisch das Alter berechnen mit "age_calculator" 0785 - ContactScreen ---*/
      void calculateAgeFromBirthday() {
        try {
          AgeCalculator();
          String birthday = controllers['controllerCS005']!.text;

          log('0223 - ContactScreen - Geburtstag: $birthday / ${controllers['controllerCS005']!.text}');

          /*--- Den String in Tag, Monat und Jahr aufteilen ---*/
          List<String> dateParts =
              controllers['controllerCS005']!.text.split('.');
          String day = dateParts[0];
          String month = dateParts[1];
          String year = dateParts[2];

          /*--- Einen neuen String im ISO 8601 Format erstellen ---*/
          String isoDateString = "$year-$month-$day";

          /*--- Den String in ein DateTime-Objekt parsen ---*/
          DateTime dateTime = DateTime.parse(isoDateString);

          log('0267 - ContactScreen - $birthday');
          log('0268 - ContactScreen - $dateTime');

          var age = AgeCalculator.age(dateTime);
          log('0297 - ContactScreen - Berechnetes Alter = ${age.years} Jahre + ${age.months} Monate + ${age.days} Tage');

          /*--- Automatisch die Zeit bis zum nächsten Geburtstag berechnen mit "age_calculator" ---*/
          ////
          // DateTime nextBirthday = dateTime;

          // var timeToNextBirthday = AgeCalculator.timeToNextBirthday(
          //   DateTime(
          //     nextBirthday.year,
          //     nextBirthday.month,
          //     nextBirthday.day,
          //   ),
          //   fromDate: DateTime.now(),
          // );
          ////

          /*--- die Daten aktualisieren ---*/
          setState(() {
            /*--- das Alter berechnen aktualisieren ---*/
            ageY = age.years;
            ageM = age.months;
            ageD = age.days;

            /*--- die Zeit bis zum nächsten Geburtstag aktualisieren ---*/
            ////
            // nextY = timeToNextBirthday.years;
            // nextM = timeToNextBirthday.months;
            // nextD = timeToNextBirthday.days;
            ////
          });
        } catch (e) {
          log('0309 - ContactScreen - Fehlermeldung: $e');
        }
      }

      /*--------------------------------- getNextBirthdayText ---*/
      // String getNextBirthdayText() {
      //   log('0500 - ContactScreen - Geburtstag - Abfrage Ergebnis: ${controllers['controllerCS005']!.text}'); // Geburtstag als Datum (oder leer)

      //   /*--- Wenn das Geburtsdatum leer ist, dann ist das Alter und die Zeit bis zum nächsten Geburtstag unbekannt ---*/
      //   ////
      //   if (controllers['controllerCS005']!.text.isEmpty) {
      //     log('0504 - ContactScreen ---> Geburtstag - controllers["controllerCS005"]!.text.isEmpty: ${controllers["controllerCS005"]!.text.isEmpty} <---');
      //     return '---> ist UNBEKANNT!';
      //   }
      //   if (nextD == 0 && nextM == 0) {
      //     log('0508 - ContactScreen - .... ist wieder in 1 Jahr 😃');
      //     return '... ist wieder in 1 Jahr 😃';
      //   }
      //   if (nextD == 1 && nextM == 0) {
      //     log('0512 - ContactScreen - ... ist schon MORGEN 🚀');
      //     return '... ist schon MORGEN 🚀';
      //   }
      //   if (nextD == 2 && nextM == 0) {
      //     log('0516 - ContactScreen - ... ist schon ÜBERMORGEN!');
      //     return '... ist schon ÜBERMORGEN!';
      //   }
      //   if (nextD >= 3 && nextM == 0) {
      //     log('0520 - ContactScreen - .. ist schon in $nextD Tagen!');
      //     return '... ist schon in $nextD Tagen!';
      //   }

      //   List<String> parts = [];
      //   log('0339 - ContactScreen ---> parts: $parts <--- müssten hier leer sein!');
      //   if (nextY > 0) {
      //     parts.add(nextY == 1 ? '... in $nextY Jahr' : '$nextY Jahre');
      //   }
      //   if (nextM > 0) {
      //     parts.add(nextM == 1 ? '... in $nextM Monat' : '$nextM Monate');
      //   }
      //   if (nextD > 0) {
      //     parts.add(nextD == 1 ? '... in $nextD Tag' : '$nextD Tage');
      //   }
      //   if (parts.isEmpty) {
      //     return '---> ist UNBEKANNT!';
      //   }
      //   log('0352 - ContactScreen ---> parts: $parts <--- müssten hier gefüllt sein!');

      //   return parts.join(' + ');
      // }
      ////

      /*--------------------------------- Telefon-Anruf-Funktionen ---*/
      ////
      // bool hasCallSupport = false;
      // late String phone = '';
      // Future<void>? launched;

      // bool isDataChanged = false;
      ////

      /*--------------------------------- Überprüfen, ob sich die Daten geändert haben ---*/
      void onDataChanged(String key, String value) {
        log('0332 - ContactScreen - $key geändert: $value');
        setState(() {
          ////
          // isDataChanged = hasDataChanged();
          ////
        });
      }

      /*--------------------------------- Speichere Listener-Referenzen in einer Map ---*/
      /*--- Diese Map wird verwendet, um die Listener zu speichern, die den Textfeldern zugeordnet sind. ---*/
      /*--- Wenn ein Textfeld geändert wird, wird der entsprechende Listener aufgerufen. ---*/
      final Map<String, VoidCallback> listeners = {};

      void addListeners() {
        try {
          controllers.forEach((key, controller) {
            // Entferne vorherigen Listener, falls vorhanden
            if (listeners.containsKey(key)) {
              controller.removeListener(listeners[key]!);
              listeners.remove(key);
            }

            // Erstelle neuen Listener
            // ignore: prefer_function_declarations_over_variables
            final listener = () => onDataChanged(key, controller.text);

            // Füge Listener hinzu und speichere Referenz
            controller.addListener(listener);
            listeners[key] = listener;
          });
        } catch (e) {
          log('0370 - ContactScreen - Fehler bei _addListeners: $e');
        }
      }
      /*--------------------------------- *** ---*/

      /*--------------------------------- initState ---*/
      // @override
      // void initState() {
      //   super.initState();
      //   log("0344 - ContactScreen - initState - aktiviert");
      // initializeFilteredItems();
      // loadItemsFromDatabase();

      // _filteredItems = _allItems; // Initial alle Items anzeigen 0476
      // _filteredItemsK002 = _allItemsK002;
      // _filteredItemsK003 = _allItemsK003;
      // _filteredItemsK004 = _allItemsK004;
      // _filteredItemsK005 = _allItemsK005;
      // _filteredItemsK006 = _allItemsK006;
      // _filteredItemsK007 = _allItemsK007;
      // _filteredItemsK008 = _allItemsK008;
      // _filteredItemsK009 = _allItemsK009;
      // _filteredItemsK010 = _allItemsK010;
      // _filteredItemsK011 = _allItemsK011;
      // _filteredItemsK012 = _allItemsK012;
      // _filteredItemsK013 = _allItemsK013;
      // _filteredItemsK014 = _allItemsK014;
      // _filteredItemsK015 = _allItemsK015;
      // _filteredItemsK016 = _allItemsK016;
      // _filteredItemsK017 = _allItemsK017;
      // _filteredItemsK018 = _allItemsK018;
      // _filteredItemsK019 = _allItemsK019;
      // _filteredItemsK020 = _allItemsK020;
      // _filteredItemsK021 = _allItemsK021;
      // _filteredItemsK022 = _allItemsK022;
      // _filteredItemsK023 = _allItemsK023;
      // _filteredItemsK024 = _allItemsK024;
      // _filteredItemsK025 = _allItemsK025;
      // _filteredItemsK026 = _allItemsK026;
      // _filteredItemsK027 = _allItemsK027;
      // _filteredItemsK028 = _allItemsK028;
      // _filteredItemsK029 = _allItemsK029;
      // _filteredItemsK030 = _allItemsK030;
      // _filteredItemsK031 = _allItemsK031;
      // _filteredItemsK032 = _allItemsK032;
      // _filteredItemsK033 = _allItemsK033;
      // _filteredItemsK034 = _allItemsK034;
      // _filteredItemsK035 = _allItemsK035;
      // _filteredItemsK036 = _allItemsK036;
      // _filteredItemsK037 = _allItemsK037;
      // _filteredItemsK038 = _allItemsK038;
      // _filteredItemsK039 = _allItemsK039;
      // _filteredItemsK040 = _allItemsK040;
      // _filteredItemsK041 = _allItemsK041;
      // _filteredItemsK042 = _allItemsK042;
      // _filteredItemsK043 = _allItemsK043;
      // _filteredItemsK044 = _allItemsK044;
      // _filteredItemsK045 = _allItemsK045;
      // _filteredItemsK046 = _allItemsK046;
      // _filteredItemsK047 = _allItemsK047;
      // _filteredItemsK048 = _allItemsK048;
      // _filteredItemsK049 = _allItemsK049;
      // _filteredItemsK050 = _allItemsK050;

      /*--------------------------------- *** ---*/
      // Future<void> loadItemsFromDatabase() async {
      //   final db = await DatabaseHelper.instance.database;

      //   for (var i = 1; i <= 50; i++) {
      // final column = 'Tabelle01_${i.toString().padLeft(3, '0')}';
      // final results = await db.query(
      //   'Tabelle01',
      //   columns: [column],
      //   distinct: true,
      //   orderBy: '$column ASC',
      // );

      // setState(() {
      //   final key = 'K${i.toString().padLeft(3, '0')}';
      //   allItems[key] = results.map((row) => (row[column] as String?) ?? '').toList();
      //   filteredItems[key] = allItems[key]!;
      // });
//   }
// }

      // /*--- Hier die Daten aus der SQFlite-Datenbank abfragen ---*/
      // final results = await db.query(
      //   'Tabelle01',
      //   columns: ['Tabelle01_015'],
      //   //where: 'Tabelle01_015 IS NOT NULL',
      //   distinct: true,
      //   orderBy: 'Tabelle01_015 ASC',
      // );

      /*--------------------------------- K003 - Vorname aus der SQFlite-Datenbank abfragen ---*/
      // final resultsK003 = await db.query(
      //   'Tabelle01',
      //   columns: ['Tabelle01_003'],
      //   //where: 'Tabelle01_003 IS NOT NULL',
      //   distinct: true,
      //   orderBy: 'Tabelle01_003 ASC',
      // );

      // /*--------------------------------- K004 - Nachname aus der SQFlite-Datenbank abfragen ---*/
      // final resultsK004 = await db.query(
      //   'Tabelle01',
      //   columns: ['Tabelle01_004'],
      //   //where: 'Tabelle01_004 IS NOT NULL',
      //   distinct: true,
      //   orderBy: 'Tabelle01_004 ASC',
      // );

      // /*--- Hier die Daten in die Variablen speichern ---*/
      // setState(() {
      //   _allItems = results
      //       .map((row) => (row['Tabelle01_015'] as String?) ?? '')
      //       .toList();
      //   _filteredItems = _allItems;
      // });

      // /*--- K003 - Vorname ---*/
      // _allItemsK003 = resultsK003
      //     .map((row) => (row['Tabelle01_003'] as String?) ?? '')
      //     .toList();
      // _filteredItemsK003 = _allItemsK003;

      // /*--- K004 - Nachname ---*/
      // _allItemsK004 = resultsK004
      //     .map((row) => (row['Tabelle01_004'] as String?) ?? '')
      //     .toList();
      // _filteredItemsK004 = _allItemsK004;

      // /*--- Logs ---*/
      // log('0350 - ContactScreen - _allItems: $_allItems');
      // log('0351 - ContactScreen - _allItemsK003: $_allItemsK003');
      // log('0352 - ContactScreen - _filteredItems: $_filteredItems');
      // log('0353 - ContactScreen - _filteredItemsK003: $_filteredItemsK003');
    }

    // loadItemsFromDatabase();

    /*--- Den Zustand (State) erst nach dem Build ändern.
          Diese Methode wird verwendet, um eine Aktion auszuführen, nachdem das Widget vollständig aufgebaut wurde. 
          Die Daten werden direkt nach dem Rendern gespeichert. ---*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('0350 - ContactScreen - WidgetsBinding.instance.addPostFrameCallback - aktiviert');

      /*--- Controller hier initialisieren ---*/
      controllers['controllerCS001']!.text =
          widget.contact['Tabelle01_001'] ?? '';

      setState(() {
        try {
          /*--- Daten aus der SQFlite ---*/
          for (var i = 1; i <= 50; i++) {
            controllers['controllerCS${i.toString().padLeft(3, '0')}']!.text =
                widget.contact['Tabelle01_${i.toString().padLeft(3, '0')}'] ??
                    '';
          }
        } catch (e) {
          log('0271 - ContactScreen - Fehler: $e');
        }
      });

      /*--- Daten direkt nach dem Rendern speichern ---*/
      updateData({});
      saveChanges(context);

      /*--- Hier nochmal das Alter aus dem Geburtstag berechnen ---*/
      calculateAgeFromBirthday();

      /*--- Define the variable isDataChanged ---*/
      ////
      // bool isDataChanged = false;

      // /*--- Überprüfe, ob sich die Daten geändert haben ---*/
      // setState(() {
      //   isDataChanged = _hasDataChanged();
      // });
      ////
    });

    /*--- Überprüfe den Telefon-Anruf-Support ---*/
    ////
    // bool hasCallSupport = false; // Define the variable

    // canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
    //   setState(() {
    //     hasCallSupport = result;
    //   });
    // });
    ////

    _addListeners();
  }

  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  /*--------------------------------- *** ---*/ // 0619 - ContactScreen
  @override
  // Define age variables
  int ageY = 0;
  int ageM = 0;
  int ageD = 0;

  String getNextBirthdayText() {
    // Replace this logic with your actual implementation
    return "Next birthday is on [date]";
  }

  @override
  Widget build(BuildContext context) {
    log("0824 - ContactScreen - aktiviert");

    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
          title: Text(
            widget.isNewContact ? 'Neuer Kontakt' : 'Kontakt bearbeiten',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.yellow,
            ),
          ),
          centerTitle: true,
          backgroundColor: wbColorLogoBlue, // Hintergrundfarbe
          foregroundColor: Colors.white, // Icon-/Button-/Chevron-Farbe
          shadowColor: Colors.black,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainSelectionScreen(),
                  ),
                );
                ////
                // if (isDataChanged) {
                //   log('0435 - ContactScreen - Daten wurden geändert!');
                //   // /*--------------------------------- Sound ---*/
                //   // player.play(AssetSource("sound/sound05xylophon.wav"));
                //   /*--------------------------------- AlertDialog ---*/
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text(
                //             'Deine Datenänderungen bei ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} wurden NICHT aktualisiert!',
                //             style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 color: wbColorLogoBlue)),
                //         content: Text(
                //           "Es gibt ungespeicherte Änderungen!\n\nMöchtest du die Daten aktualisieren, bevor du zurückgehst?",
                //           style: TextStyle(fontSize: 16),
                //         ),
                //         actions: [
                //           TextButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) =>
                //                       const MainSelectionScreen(),
                //                 ),
                //               );
                //             },
                //             child: Text('Die Daten NICHT aktualisieren',
                //                 style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.bold,
                //                     color: wbColorLogoBlue)),
                //           ),
                //           TextButton(
                //             onPressed: () async {
                //               // /*--------------------------------- Sound ---*/
                //               // player
                //               //     .play(AssetSource("sound/sound06pling.wav"));
                //               /*--------------------------------- Snackbar ---*/
                //               ScaffoldMessenger.of(context)
                //                   .showSnackBar(SnackBar(
                //                 backgroundColor: wbColorOrangeDarker,
                //                 content: Text(
                //                   "Die Daten von\n${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • wurden erfolgreich aktualisiert! 😃👍",
                //                   style: TextStyle(
                //                     fontSize: 28,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ));
                //               /*--------------------------------- Snackbar ENDE ---*/
                //               /*--------------------------------- Daten updaten ---*/
                //               Navigator.of(context).pop();
                //               await updateData({});
                //               log('0493 - ContactScreen - Daten "updateData": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                //               // ignore: use_build_context_synchronously
                //               saveChanges(context);
                //               log('0495 - ContactScreen - Daten "saveChanges": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                //               Navigator.push(
                //                 // ignore: use_build_context_synchronously
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) =>
                //                       const MainSelectionScreen(),
                //                 ),
                //               );
                //               /*--------------------------------- Daten updaten - ENDE ---*/
                //             },
                //             child: Text(
                //                 'Die geänderten Daten jetzt AKTUALISIEREN! 😃👍',
                //                 style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.bold,
                //                     color: wbColorLogoBlue)),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const MainSelectionScreen(),
                //     ),
                //   );
                // }
                ////
              })),
      /*--------------------------------- *** ---*/
      body: SingleChildScrollView(
        controller: scrollController,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*--------------------------------- Firmenlogo ---*/
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(3, 3),
                                spreadRadius: 0,
                              ),
                            ],
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: CircleAvatar(
                            backgroundColor: wbColorButtonBlue,
                            backgroundImage: AssetImage(
                              "assets/company_logos/enpower_expert_logo_4_x_4.png",
                            ),
                            radius: 68,
                          ),
                        ),
                        const SizedBox(height: 20),
                        /*--------------------------------- Name der Firma unter dem Logo ---*/
                        SizedBox(
                          width: 160,
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            controllers['controllerCS015']!.text.isEmpty
                                ? "KEINE Firma"
                                : controllers['controllerCS015']!.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    /*--------------------------------- Bild des Ansprechpartners --- */
                    Column(
                      children: [
                        Container(
                          height: 136,
                          width: 136,
                          decoration: ShapeDecoration(
                            shadows: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                              )
                            ],
                            color: wbColorButtonBlue,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/dummy_person_portrait.png",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        /*--------------------------------- Vor- und Nachname des Ansprechpertners unter dem Bild ---*/
                        SizedBox(
                          width: 160,
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            ('${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    wbSizedBoxHeight8,
                    /*--------------------------------- Kontakt-Status auswählen ---*/
                    WbDropDownMenu(
                      controller: controllers['controllerCS019']!,
                      label: "Kontakt-Staus",
                      dropdownItems: [
                        controllers['controllerCS019']!.text,
                        "Kontakt",
                        "Smartphone-Kontakt",
                        "Interessent",
                        "Kunde",
                        "Lieferant",
                        "Lieferant und Kunde",
                        "möglicher Lieferant",
                      ],
                      leadingIconInTextField: Icons.create_new_folder_outlined,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Divider ---*/
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,

                    ////
                    // /*--------------------------------- K002 - Anrede ---*/
                    // Autocomplete<String>(
                    //   optionsBuilder: (TextEditingValue textEditingValue) {
                    //     return _filteredItems.where((item) => item
                    //         .toLowerCase()
                    //         .contains(textEditingValue.text.toLowerCase()));
                    //   },
                    //   onSelected: (String selection) {
                    //     /*--------------------------------- Sound ---*/
                    //     player.play(AssetSource("sound/sound05xylophon.wav"));
                    //     /*--------------------------------- Log ---*/
                    //     log('0769 - ContactScreen - angeklickt - K002 - Anrede - "${controllers['controllerCS002']!.text}"');
                    //     _controller.text = selection;
                    //   },
                    //   fieldViewBuilder:
                    //       (context, controller, focusNode, onFieldSubmitted) {
                    //     return WbTextFormFieldShadowWith2Icons(
                    //       controller: controllers['controllerCS002']!,
                    //       focusNode: focusNode,
                    //       labelText: 'Anrede',
                    //       labelFontSize22: 20,
                    //       hintText: 'Anrede eingeben',
                    //       hintTextFontSize16: 16,
                    //       inputTextFontSize24: 22,
                    //       prefixIcon: Icons.person, //Icons.person_2_outlined,
                    //       prefixIconSize32: 28,
                    //       suffixIcon: Icons.arrow_drop_down,
                    //       /*--------------------------------- *** ---*/
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _filteredItems = _allItems
                    //               .where((item) => item
                    //                   .toLowerCase()
                    //                   .contains(value.toLowerCase()))
                    //               .toList();
                    //         });
                    //       },
                    //       /*--------------------------------- *** ---*/
                    //     );
                    //   },
                    // ),
                    ////

                    /*--------------------------------- Abstand ---*/
                    //wbSizedBoxHeight8,

                    //

                    /*--------------------------------- K003 - Vorname ---*/
                    JHsAutocomplete(
                      keyName: 'Vorname',
                      controller: controllers['controllerCS003']!,
                      items: filteredItems['K003']!,
                    ),

                    ////
                    // /*--------------------------------- K003 - Vorname ---*/
                    // Autocomplete<String>(
                    //   optionsBuilder: (TextEditingValue textEditingValue) {
                    //     if (textEditingValue.text.isEmpty) {
                    //       // Wenn das Feld leer ist, zeige alle Optionen an
                    //       log('0795 - ContactScreen - optionsBuilder - Alle Items anzeigen');
                    //       return _allItemsK003;
                    //     }
                    //     // Filtere die Optionen basierend auf der Eingabe
                    //     log('0799 - ContactScreen - optionsBuilder - Gefilterte Items anzeigen');
                    //     return _allItemsK003.where((item) => item
                    //         .toLowerCase()
                    //         .contains(textEditingValue.text.toLowerCase()));
                    //   },
                    //   onSelected: (String selection) {
                    //     // Speichere die Auswahl im Controller
                    //     controllers['controllerCS003']!.text = selection;
                    //     log('0807 - ContactScreen - Ausgewählter Wert: $selection');
                    //   },
                    //   fieldViewBuilder: (context, autocompleteController,
                    //       focusNode, onFieldSubmitted) {
                    //     // Synchronisiere den Autocomplete-Controller mit dem Hauptcontroller
                    //     autocompleteController.text =
                    //         controllers['controllerCS003']!.text;
                    //     return InkWell(
                    //       /*--- Textfeld ---*/
                    //       child: WbTextFormFieldShadowWith2Icons(
                    //         controller: autocompleteController,
                    //         focusNode: focusNode,
                    //         labelText: 'Vorname',
                    //         labelFontSize22: 20,
                    //         hintText: 'Vorname eingeben',
                    //         hintTextFontSize16: 16,
                    //         inputTextFontSize24: 22,
                    //         prefixIcon: Icons.person,
                    //         prefixIconSize32: 28,
                    //         suffixIcon: Icons.arrow_drop_down,
                    //         onChanged: (value) {
                    //           log('0844 - ContactScreen - onChanged: $value');
                    //           // Aktualisiere den Autocomplete-Controller
                    //           autocompleteController.text = value;
                    //           // Aktualisiere den Hauptcontroller bei jeder Änderung
                    //           controllers['controllerCS003']!.text = value;

                    //           setState(() {
                    //             if (value.isEmpty) {
                    //               log('0852 - ContactScreen - Das Feld ist leer: $value');
                    //               // Wenn das Feld leer ist, zeige alle Optionen an
                    //               _filteredItemsK003 = _allItemsK003;
                    //             } else {
                    //               log('0856 - ContactScreen - Das Feld ist NICHT leer: $value');
                    //               // Filtere die Optionen basierend auf der Eingabe
                    //               _filteredItemsK003 = _allItemsK003
                    //                   .where((item) => item
                    //                       .toLowerCase()
                    //                       .contains(value.toLowerCase()))
                    //                   .toList();
                    //             }
                    //           });
                    //           // Logge den aktuellen Zustand
                    //           log('0866 - ContactScreen - Aktueller Wert: $value');
                    //           log('0867 - ContactScreen - Gefilterte Items: $_filteredItemsK003');
                    //         },
                    //       ),
                    //     );
                    //   },
                    //   /*--------------------------------- Dropdown-Menü ---*/
                    //   optionsViewBuilder: (context, onSelected, options) {
                    //     return Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Material(
                    //         color: Colors.black, // Hintergrundfarbe
                    //         elevation: 10,
                    //         child: SizedBox(
                    //           height: 330,
                    //           width: MediaQuery.of(context).size.width - 24,
                    //           child: ListView.builder(
                    //             padding: EdgeInsets.zero,
                    //             itemCount: options.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               final option = options.elementAt(index);
                    //               return InkWell(
                    //                 onTap: () => onSelected(option),
                    //                 child: Container(
                    //                   padding: const EdgeInsets.fromLTRB(
                    //                       16, 8, 16, 8),
                    //                   alignment: Alignment.centerLeft,
                    //                   decoration: BoxDecoration(
                    //                     border: Border(
                    //                       bottom: BorderSide(
                    //                         color: Colors.grey,
                    //                         width: 2,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   child: Text(
                    //                     option,
                    //                     style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   /*--------------------------------- Dropdown-Menü - ENDE ---*/
                    // ),
                    ////
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,

                    ////
                    // /*--------------------------------- K004 - Nachname ---*/
                    // Autocomplete<String>(
                    //   optionsBuilder: (TextEditingValue textEditingValue) {
                    //     if (textEditingValue.text.isEmpty) {
                    //       // Wenn das Feld leer ist, zeige alle Optionen an
                    //       log('1231 - ContactScreen - optionsBuilder - Alle Items anzeigen');
                    //       return _allItemsK004;
                    //     }
                    //     // Filtere die Optionen basierend auf der Eingabe
                    //     log('1235 - ContactScreen - optionsBuilder - Gefilterte Items anzeigen');
                    //     return _allItemsK004.where((item) => item
                    //         .toLowerCase()
                    //         .contains(textEditingValue.text.toLowerCase()));
                    //   },
                    //   onSelected: (String selection) {
                    //     // Speichere die Auswahl im Controller
                    //     controllers['controllerCS004']!.text = selection;
                    //     log('1243 - ContactScreen - Ausgewählter Wert: $selection');
                    //   },
                    //   fieldViewBuilder: (context, autocompleteController,
                    //       focusNode, onFieldSubmitted) {
                    //     // Synchronisiere den Autocomplete-Controller mit dem Hauptcontroller
                    //     autocompleteController.text =
                    //         controllers['controllerCS004']!.text;
                    //     return InkWell(
                    //       /*--- Textfeld ---*/
                    //       child: WbTextFormFieldShadowWith2Icons(
                    //         controller: autocompleteController,
                    //         focusNode: focusNode,
                    //         labelText: 'Nachname',
                    //         labelFontSize22: 20,
                    //         hintText: 'Nachname eingeben',
                    //         hintTextFontSize16: 16,
                    //         inputTextFontSize24: 22,
                    //         prefixIcon: Icons.person,
                    //         prefixIconSize32: 28,
                    //         suffixIcon: Icons.arrow_drop_down,
                    //         onChanged: (value) {
                    //           log('1264 - ContactScreen - onChanged: $value');
                    //           // Aktualisiere den Autocomplete-Controller
                    //           autocompleteController.text = value;
                    //           // Aktualisiere den Hauptcontroller bei jeder Änderung
                    //           controllers['controllerCS004']!.text = value;

                    //           setState(() {
                    //             if (value.isEmpty) {
                    //               log('1272 - ContactScreen - Das Feld ist leer: $value');
                    //               // Wenn das Feld leer ist, zeige alle Optionen an
                    //               _filteredItemsK004 = _allItemsK004;
                    //             } else {
                    //               log('1276 - ContactScreen - Das Feld ist NICHT leer: $value');
                    //               // Filtere die Optionen basierend auf der Eingabe
                    //               _filteredItemsK004 = _allItemsK004
                    //                   .where((item) => item
                    //                       .toLowerCase()
                    //                       .contains(value.toLowerCase()))
                    //                   .toList();
                    //             }
                    //           });
                    //           // Logge den aktuellen Zustand
                    //           log('1286 - ContactScreen - Aktueller Wert: $value');
                    //           log('1287 - ContactScreen - Gefilterte Items: $_filteredItemsK004');
                    //         },
                    //       ),
                    //     );
                    //   },
                    //   /*--------------------------------- Dropdown-Menü ---*/
                    //   optionsViewBuilder: (context, onSelected, options) {
                    //     return Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Material(
                    //         color: Colors.black, // Hintergrundfarbe
                    //         elevation: 10,
                    //         child: SizedBox(
                    //           height: 330,
                    //           width: MediaQuery.of(context).size.width - 24,
                    //           child: ListView.builder(
                    //             padding: EdgeInsets.zero,
                    //             itemCount: options.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               final option = options.elementAt(index);
                    //               return InkWell(
                    //                 onTap: () => onSelected(option),
                    //                 child: Container(
                    //                   padding: const EdgeInsets.fromLTRB(
                    //                       16, 8, 16, 8),
                    //                   alignment: Alignment.centerLeft,
                    //                   decoration: BoxDecoration(
                    //                     border: Border(
                    //                       bottom: BorderSide(
                    //                         color: Colors.grey,
                    //                         width: 2,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   child: Text(
                    //                     option,
                    //                     style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   /*--------------------------------- Dropdown-Menü - ENDE ---*/
                    // ),
                    ////
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,

                    //

                    //

                    // WbDropDownMenu(
                    //   controller: controllers['controllerCS002']!,
                    //   label: "Anrede",
                    //   dropdownItems: [
                    //     "Firma",
                    //     "Herr",
                    //     "Frau",
                    //     "Divers",
                    //     "Herr Dr.",
                    //     "Frau Dr.",
                    //     "Dr.",
                    //     "Herr Prof.",
                    //     "Frau Prof.",
                    //     "Prof.",
                    //   ],
                    //   leadingIconsInMenu: [
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //     Icons.person_2_outlined,
                    //   ],
                    //   leadingIconInTextField: Icons.person_2_outlined,
                    // // ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    // /*--------------------------------- Vorname ---*/
                    // WbTextFormField(
                    //   labelText: "Vorname",
                    //   labelFontSize20: 20,
                    //   hintText: "Bitte den Vornamen eintragen",
                    //   hintTextFontSize16: 15,
                    //   inputTextFontSize22: 22,
                    //   prefixIcon: Icons.person,
                    //   prefixIconSize28: 24,
                    //   inputFontWeightW900: FontWeight.w900,
                    //   inputFontColor: wbColorLogoBlue,
                    //   fillColor: wbColorLightYellowGreen,
                    //   controller: controllers['controllerCS003']!,
                    // ),
                    // wbSizedBoxHeight16,
                    // /*--------------------------------- Nachname ---*/
                    // WbTextFormField(
                    //   labelText: "Nachname",
                    //   labelFontSize20: 20,
                    //   hintText: "Bitte den Nachnamen eintragen",
                    //   hintTextFontSize16: 15,
                    //   inputTextFontSize22: 22,
                    //   prefixIcon: Icons.person,
                    //   prefixIconSize28: 24,
                    //   inputFontWeightW900: FontWeight.w900,
                    //   inputFontColor: wbColorLogoBlue,
                    //   fillColor: wbColorLightYellowGreen,
                    //   controller: controllers['controllerCS004']!,
                    // ),

                    /*--------------------------------- Container um den Geburtstag herum ---*/
                    Container(
                      width: 400,
                      decoration: ShapeDecoration(
                        color: wbColorLightYellowGreen,
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    log('0752 - ContactScreen - das Alter mit "${controllers['controllerCS005']!.text}" berechnen');
                                    calculateAgeFromBirthday();
                                  },
                                  child: Text(
                                    'Geburtstag',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                wbSizedBoxWidth16,
                                /*--------------------------------- Geburtstag-Feld ---*/
                                Expanded(
                                  child: WbTextFormFieldOnlyDATE(
                                      controller:
                                          controllers['controllerCS005']!,
                                      prefixIcon: Icons.cake_outlined,
                                      labelText: 'Geburtstag',
                                      labelFontSize20: 20,
                                      hintText: 'Geburtstag',
                                      inputTextFontSize22: 22,
                                      inputFontWeightW900: FontWeight.w900,
                                      inputFontColor: wbColorButtonDarkRed,
                                      fillColor: Colors.yellow,
                                      onEditingComplete: () {
                                        log('0890 - ContactScreen - das Alter mit "${controllers['controllerCS005']!.text}" berechnen');
                                        calculateAgeFromBirthday();
                                      }),
                                ),
                              ],
                            ),
                          ),
                          /*--------------------------------- Alter anzeigen ---*/
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Aktuelles Alter:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    (ageY != 0 && ageM == 0 && ageD == 0)
                                        ? 'Heute genau $ageY Jahre alt 😃'
                                        : (ageY == 0 && ageM == 0 && ageD == 0)
                                            ? '---> ist UNBEKANNT!'
                                            : '$ageY Jahre + $ageM Monate + $ageD Tage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*--------------------------------- nächster Geburtstag ---*/
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Row(
                              children: [
                                Text(
                                  'Nächster Geburtstag:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    getNextBirthdayText(),
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
                    wbSizedBoxHeight8,

                    /*--------------------------------- Divider ---*/
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    /*--------------------------------- *** ---*/

                    /*--------------------------------- Private Adressdaten ---*/
                    ExpansionTile(
                      /*--------------------------------- Farben eingeklappt/ausgeklappt ---*/
                      textColor:
                          Colors.white, // Textfarbe im ausgeklappten Zustand
                      backgroundColor: Colors
                          .blue, // Hintergrundfarbe im ausgeklappten Zustand
                      iconColor:
                          Colors.white, // Iconfarbe im ausgeklappten Zustand
                      collapsedTextColor:
                          wbColorLogoBlue, // Textfarbe im eingeklappten Zustand
                      collapsedIconColor:
                          wbColorLogoBlue, // Iconfarbe im eingeklappten Zustand
                      /*--------------------------------- Titel ---*/
                      title: Container(
                        width: double.infinity, // Volle Breite
                        height: 40, // Feste Höhe
                        padding: EdgeInsets.only(
                            left: 12), // Linker Abstand für Icon
                        decoration: BoxDecoration(
                          color: wbColorButtonBlue, // Hintergrundfarbe
                          borderRadius: BorderRadius.circular(
                              0), // Optional: Abgerundete Ecken
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon links
                            Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.home_work_outlined, size: 28),
                            ),
                            // Linksbündiger Text
                            Expanded(
                              child: Text(
                                'Private Adressdaten',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign:
                                    TextAlign.left, // Explizit linksbündig
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*--------------------------------- Inhalt ---*/
                      children: [
                        ////
                        // /*--------------------------------- K006 - Privat: Straße + Nr ---*/
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        //   child: Column(
                        //     children: [
                        //       Autocomplete<String>(
                        //         optionsBuilder:
                        //             (TextEditingValue textEditingValue) {
                        //           return _filteredItems.where((item) => item
                        //               .toLowerCase()
                        //               .contains(
                        //                   textEditingValue.text.toLowerCase()));
                        //         },
                        //         onSelected: (String selection) {
                        //           /*--------------------------------- Sound ---*/
                        //           player.play(
                        //               AssetSource("sound/sound05xylophon.wav"));
                        //           /*--------------------------------- Log ---*/
                        //           log('1096 - ContactScreen - angeklickt - K006 - Privat Straße + Nr - "${controllers['controllerCS006']!.text}"');
                        //           _controller.text = selection;
                        //         },
                        //         fieldViewBuilder: (context, controller,
                        //             focusNode, onFieldSubmitted) {
                        //           return WbTextFormFieldShadowWith2Icons(
                        //             controller: controllers['controllerCS006']!,
                        //             focusNode: focusNode,
                        //             labelText: 'Privat: Straße + Nr.',
                        //             labelFontSize22: 20,
                        //             hintText: 'Straße mit Nr. eingeben',
                        //             hintTextFontSize16: 16,
                        //             inputTextFontSize24: 22,
                        //             prefixIcon: Icons.location_on_outlined,
                        //             prefixIconSize32: 24,
                        //             suffixIcon: Icons.arrow_drop_down,
                        //             /*--------------------------------- *** ---*/
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _filteredItems = _allItems
                        //                     .where((item) => item
                        //                         .toLowerCase()
                        //                         .contains(value.toLowerCase()))
                        //                     .toList();
                        //               });
                        //             },
                        //             /*--------------------------------- *** ---*/
                        //           );
                        //         },
                        //       ),
                        //       /*--------------------------------- Abstand ---*/
                        //       wbSizedBoxHeight16,
                        //       /*--------------------------------- K007 - Privat: Zusatzinfo zur Adresse ---*/
                        //       Autocomplete<String>(
                        //         optionsBuilder:
                        //             (TextEditingValue textEditingValue) {
                        //           return _filteredItems.where((item) => item
                        //               .toLowerCase()
                        //               .contains(
                        //                   textEditingValue.text.toLowerCase()));
                        //         },
                        //         onSelected: (String selection) {
                        //           /*--------------------------------- Sound ---*/
                        //           player.play(
                        //               AssetSource("sound/sound05xylophon.wav"));
                        //           /*--------------------------------- Log ---*/
                        //           log('1119 - ContactScreen - angeklickt - K007 - Zusatzinfo zur Adresse - "${controllers['controllerCS007']!.text}"');
                        //           _controller.text = selection;
                        //         },
                        //         fieldViewBuilder: (context, controller,
                        //             focusNode, onFieldSubmitted) {
                        //           return WbTextFormFieldShadowWith2Icons(
                        //             controller: controllers['controllerCS007']!,
                        //             focusNode: focusNode,
                        //             labelText: 'Zusatzinfo',
                        //             labelFontSize22: 20,
                        //             hintText: 'Zusatzinfo eingeben',
                        //             hintTextFontSize16: 16,
                        //             inputTextFontSize24: 22,
                        //             prefixIcon: Icons.location_on_outlined,
                        //             prefixIconSize32: 24,
                        //             suffixIcon: Icons.arrow_drop_down,
                        //             /*--------------------------------- *** ---*/
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _filteredItems = _allItems
                        //                     .where((item) => item
                        //                         .toLowerCase()
                        //                         .contains(value.toLowerCase()))
                        //                     .toList();
                        //               });
                        //             },
                        //             /*--------------------------------- *** ---*/
                        //           );
                        //         },
                        //       ),
                        //       /*--------------------------------- Abstand ---*/
                        //       wbSizedBoxHeight16,
                        //       /*--------------------------------- K008 - Privat: PLZ ---*/
                        //       Autocomplete<String>(
                        //         optionsBuilder:
                        //             (TextEditingValue textEditingValue) {
                        //           return _filteredItems.where((item) => item
                        //               .toLowerCase()
                        //               .contains(
                        //                   textEditingValue.text.toLowerCase()));
                        //         },
                        //         onSelected: (String selection) {
                        //           _controller.text = selection;
                        //           /*--------------------------------- Sound ---*/
                        //           player.play(
                        //               AssetSource("sound/sound05xylophon.wav"));
                        //           /*--------------------------------- Log ---*/
                        //           log('1162 - ContactScreen - angeklickt - K008 - Privat PLZ - "${controllers['controllerCS008']!.text}"');
                        //         },
                        //         fieldViewBuilder: (context, controller,
                        //             focusNode, onFieldSubmitted) {
                        //           return WbTextFormFieldShadowWith2Icons(
                        //             controller: controllers['controllerCS008']!,
                        //             focusNode: focusNode,
                        //             labelText: 'Privat: PLZ',
                        //             labelFontSize22: 20,
                        //             hintText: 'PLZ eingeben',
                        //             hintTextFontSize16: 16,
                        //             inputTextFontSize24: 22,
                        //             prefixIcon: Icons.looks_5_outlined,
                        //             prefixIconSize32: 24,
                        //             suffixIcon: Icons.arrow_drop_down,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _filteredItems = _allItems
                        //                     .where((item) => item
                        //                         .toLowerCase()
                        //                         .contains(value.toLowerCase()))
                        //                     .toList();
                        //               });
                        //             },
                        //           );
                        //         },
                        //       ),
                        //       /*--------------------------------- Abstand ---*/
                        //       wbSizedBoxHeight16,
                        //       /*---------------------------------- K009 - Privat: Ort ---*/
                        //       Autocomplete<String>(
                        //         optionsBuilder:
                        //             (TextEditingValue textEditingValue) {
                        //           return _filteredItems.where((item) => item
                        //               .toLowerCase()
                        //               .contains(
                        //                   textEditingValue.text.toLowerCase()));
                        //         },
                        //         onSelected: (String selection) {
                        //           /*--------------------------------- Sound ---*/
                        //           player.play(
                        //               AssetSource("sound/sound05xylophon.wav"));
                        //           /*--------------------------------- Log ---*/
                        //           log('1205 - ContactScreen - angeklickt - K009 - Privat Ort - "${controllers['controllerCS009']!.text}"');
                        //           _controller.text = selection;
                        //         },
                        //         fieldViewBuilder: (context, controller,
                        //             focusNode, onFieldSubmitted) {
                        //           return WbTextFormFieldShadowWith2Icons(
                        //             controller: controllers['controllerCS009']!,
                        //             focusNode: focusNode,
                        //             labelText: 'Privat: Ort',
                        //             labelFontSize22: 20,
                        //             hintText: 'Ort eingeben',
                        //             hintTextFontSize16: 16,
                        //             inputTextFontSize24: 22,
                        //             prefixIcon: Icons.home_work_outlined,
                        //             prefixIconSize32: 24,
                        //             suffixIcon: Icons.arrow_drop_down,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _filteredItems = _allItems
                        //                     .where((item) => item
                        //                         .toLowerCase()
                        //                         .contains(value.toLowerCase()))
                        //                     .toList();
                        //               });
                        //             },
                        //           );
                        //         },
                        //       ),
                        //       /*--------------------------------- Abstand ---*/
                        //       wbSizedBoxHeight16,
                        //       /*--------------------------------- K010 - Privat: Land ---*/
                        //       Autocomplete<String>(
                        //         optionsBuilder:
                        //             (TextEditingValue textEditingValue) {
                        //           return _filteredItems.where((item) => item
                        //               .toLowerCase()
                        //               .contains(
                        //                   textEditingValue.text.toLowerCase()));
                        //         },
                        //         onSelected: (String selection) {
                        //           /*--------------------------------- Sound ---*/
                        //           player.play(
                        //               AssetSource("sound/sound05xylophon.wav"));
                        //           /*--------------------------------- Log ---*/
                        //           log('1249 - ContactScreen - angeklickt - K010 - Privat Land - "${controllers['controllerCS010']!.text}"');
                        //           _controller.text = selection;
                        //         },
                        //         fieldViewBuilder: (context, controller,
                        //             focusNode, onFieldSubmitted) {
                        //           return WbTextFormFieldShadowWith2Icons(
                        //             controller: controllers['controllerCS010']!,
                        //             focusNode: focusNode,
                        //             labelText: 'Privat: Land',
                        //             labelFontSize22: 20,
                        //             hintText: 'Land eingeben',
                        //             hintTextFontSize16: 16,
                        //             inputTextFontSize24: 22,
                        //             prefixIcon: Icons.flag_outlined,
                        //             prefixIconSize32: 24,
                        //             suffixIcon: Icons.arrow_drop_down,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _filteredItems = _allItems
                        //                     .where((item) => item
                        //                         .toLowerCase()
                        //                         .contains(value.toLowerCase()))
                        //                     .toList();
                        //               });
                        //             },
                        //           );
                        //         },
                        //       ),
                        //       /*--------------------------------- Abstand ---*/
                        //       wbSizedBoxHeight16,
                        //       /*--------------------------------- *** ---*/
                        //     ],
                        //   ),
                        // ),
                        ////
                      ],
                    ),
                    /*--------------------------------- Abstand ---*/

                    /*--------------------------------- Divider mit Text ---*/
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Daten der Firma',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    wbSizedBoxHeight8,

                    /*--------------------------------- Firmenbezeichnung ---*/
                    WbTextFormField(
                      labelText: "Firmenbezeichnung",
                      labelFontSize20: 20,
                      hintText: "Wie heißt die Firma?",
                      hintTextFontSize16: 16,
                      inputTextFontSize22: 22,
                      prefixIcon: Icons.source_outlined,
                      prefixIconSize28: 28,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      controller: controllers['controllerCS015']!,
                    ),
                    wbSizedBoxHeight16,
                    /*--------------------------------- Branchenzuordnung ---*/
                    WbTextFormField(
                      controller: controllers['controllerCS016']!,
                      labelText: "Branchenzuordnung",
                      labelFontSize20: 20,
                      hintText: "Welcher Branche zugeordnet?",
                      hintTextFontSize16: 16,
                      inputTextFontSize22: 22,
                      prefixIcon: Icons.comment_bank_outlined,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                    ),
                    wbSizedBoxHeight16,
                    /*--------------------------------- Notizen zu Warengruppen ---*/
                    WbTextFormField(
                      controller: controllers['controllerCS017']!,
                      labelText: "Notizen zu Warengruppen",
                      labelFontSize20: 20,
                      hintText:
                          "Welche Waren sind für die Suchfunktion in der App relevant? Beispiele: Schrauben, Werkzeug, etc.?",
                      hintTextFontSize16: 12,
                      contentPadding: const EdgeInsets.fromLTRB(0, 40, 4, 0),
                      inputTextFontSize22: 15,
                      prefixIcon: Icons.shopping_basket_outlined,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      textInputTypeOnKeyboard: TextInputType.multiline,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    // /*--------------------------------- Divider mit Text ---*/
                    // WbDividerWithTextInCenter(
                    //   wbColor: wbColorLogoBlue,
                    //   wbText: 'Private Adressdaten',
                    //   wbTextColor: wbColorLogoBlue,
                    //   wbFontSize12: 18,
                    //   wbHeight3: 3,
                    // ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,

                    //

                    //

                    // /*--------------------------------- Straße + Nummer ---*/
                    // WbTextFormField(
                    //   controller: controllers['controllerCS006']!,
                    //   labelText: "Straße und Hausnummer",
                    //   labelFontSize20: 20,
                    //   hintText: "Bitte Straße + Hausnr. eintragen",
                    //   hintTextFontSize16: 15,
                    //   inputTextFontSize22: 22,
                    //   prefixIcon: Icons.location_on_outlined,
                    //   prefixIconSize28: 24,
                    //   inputFontWeightW900: FontWeight.w900,
                    //   inputFontColor: wbColorLogoBlue,
                    //   fillColor: wbColorLightYellowGreen,
                    //   textInputTypeOnKeyboard: TextInputType.streetAddress,
                    // ),
                    // wbSizedBoxHeight16,
                    // /*--------------------------------- Zusatzinformation ---*/
                    // WbTextFormField(
                    //   controller: controllers['controllerCS007']!,
                    //   labelText: "Zusatzinfo zur Adresse",
                    //   labelFontSize20: 20,
                    //   hintText: "c/o-Adresse? | Hinterhaus? | EG?",
                    //   hintTextFontSize16: 15,
                    //   inputTextFontSize22: 15,
                    //   prefixIcon: Icons.location_on_outlined,
                    //   prefixIconSize28: 24,
                    //   inputFontWeightW900: FontWeight.w900,
                    //   inputFontColor: wbColorLogoBlue,
                    //   fillColor: wbColorLightYellowGreen,
                    // ),
                    // wbSizedBoxHeight16,
                    // /*--------------------------------- PLZ ---*/
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 120,
                    //       child: WbTextFormFieldTEXTOnly(
                    //         controller: controllers['controllerCS008']!,
                    //         labelText: "PLZ",
                    //         labelFontSize20: 20,
                    //         hintText: "PLZ",
                    //         inputTextFontSize22: 22,
                    //         inputFontWeightW900: FontWeight.w900,
                    //         inputFontColor: wbColorLogoBlue,
                    //         fillColor: wbColorLightYellowGreen,
                    //         textInputTypeOnKeyboard:
                    //             TextInputType.numberWithOptions(
                    //           decimal: false,
                    //           signed: true,
                    //         ),
                    //       ),
                    //     ),
                    //     wbSizedBoxWidth8,
                    //     /*--------------------------------- Firmensitz | Ort ---*/
                    //     Expanded(
                    //       child: WbTextFormField(
                    //         controller: controllers['controllerCS009']!,
                    //         labelText: "Firmensitz | Ort",
                    //         labelFontSize20: 20,
                    //         hintText: "Bitte den Ort eintragen",
                    //         hintTextFontSize16: 15,
                    //         inputTextFontSize22: 22,
                    //         prefixIcon: Icons.home_work_outlined,
                    //         prefixIconSize28: 24,
                    //         inputFontWeightW900: FontWeight.w900,
                    //         inputFontColor: wbColorLogoBlue,
                    //         fillColor: wbColorLightYellowGreen,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // /*--------------------------------- Abstand ---*/
                    // wbSizedBoxHeight16,
                    // /*--------------------------------- Land ---*/
                    // WbTextFormField(
                    //   controller: controllers['controllerCS010']!,
                    //   labelText: "Land",
                    //   labelFontSize20: 20,
                    //   hintText: "Bitte das Land eintragen",
                    //   hintTextFontSize16: 15,
                    //   inputTextFontSize22: 22,
                    //   prefixIcon: Icons.location_on_outlined,
                    //   prefixIconSize28: 24,
                    //   inputFontWeightW900: FontWeight.w900,
                    //   inputFontColor: wbColorLogoBlue,
                    //   fillColor: wbColorLightYellowGreen,
                    //   textInputTypeOnKeyboard: TextInputType.streetAddress,
                    // ),
                    /*--------------------------------- Abstand ---*/
                    //wbSizedBoxHeight16,
                    /*--------------------------------- Divider mit Text ---*/
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Notizen zum Ansprechpartner',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Notizen zum Ansprechpartner ---*/
                    WbTextFormField(
                      controller: controllers['controllerCS018']!,
                      labelText: "Notizen zum Ansprechpartner",
                      labelFontSize20: 20,
                      hintText:
                          "Beispiele: Hobbys, Lieblingswein, Verein, etc.",
                      hintTextFontSize16: 12,
                      contentPadding: const EdgeInsets.fromLTRB(0, 40, 4, 0),
                      inputTextFontSize22: 14,
                      prefixIcon: Icons.shopping_basket_outlined,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      textInputTypeOnKeyboard: TextInputType.multiline,
                    ),
                    wbSizedBoxHeight8,
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Kommunikation',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Telefon 1 - Tabelle01_008 ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 400,
                            child: WbTextFormField(
                              controller: controllers['controllerCS011']!,
                              labelText: "Telefon 1 - Mobil",
                              labelFontSize20: 20,
                              hintText: "Bitte die Mobilnummer eintragen",
                              hintTextFontSize16: 13,
                              inputTextFontSize22: 22,
                              prefixIcon: Icons.phone_android_outlined,
                              prefixIconSize28: 24,
                              inputFontWeightW900: FontWeight.w900,
                              inputFontColor: wbColorLogoBlue,
                              fillColor: wbColorLightYellowGreen,
                              textInputTypeOnKeyboard: TextInputType.phone,
                              ////
                              // onChanged: (String text) => _phone = text,
                              ////
                            ),
                          ),
                        ),
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            ////
                            // onTap: () async {
                            //   log("0767 - ContactScreen - Anruf starten");
                            //   hasCallSupport
                            //       ? () => setState(() {
                            //             _launched = _makePhoneCall(_phone);
                            //           })
                            //       : null;
                            //   log('0785 - ContactScreen - Anruf wird supportet, $hasCallSupport wenn result = "$_launched" | Telefonnummer: $_phone');
                            //   final call = Uri.parse(_phone);
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //     log('0793 - ContactScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                            //   } else {
                            //     log('0795 - ContactScreen - Anruf wird NICHT supportet');
                            //   }

                            //   FutureBuilder<void>(
                            //     future: _launched,
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasError) {
                            //         return Text('Error: ${snapshot.error}');
                            //       } else {
                            //         return const Text('');
                            //       }
                            //     },
                            //   );
                            // },
                            ////
                            child: Image(
                              image: AssetImage(
                                  "assets/iconbuttons/icon_button_telefon_blau.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    wbSizedBoxHeight16,
                    /*--------------------------------- Telefon 2 ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllers['controllerCS012']!,
                              labelText: "Telefon 2",
                              labelFontSize20: 20,
                              hintText: "Bitte ggf. die 2. Nummer eintragen",
                              hintTextFontSize16: 13,
                              inputTextFontSize22: 22,
                              prefixIcon: Icons.phone_callback,
                              prefixIconSize28: 24,
                              inputFontWeightW900: FontWeight.w900,
                              inputFontColor: wbColorLogoBlue,
                              fillColor: wbColorLightYellowGreen,
                              textInputTypeOnKeyboard: TextInputType.phone,
                            ),
                          ),
                        ),
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              log("0661 - company_screen - Einen Anruf starten");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Einen Anruf starten",
                                  contentText:
                                      "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\nanrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-661",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            child: Image(
                              image: AssetImage(
                                  "assets/iconbuttons/icon_button_telefon_blau.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    wbSizedBoxHeight16,
                    /*--------------------------------- E-Mail 1 ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllers['controllerCS013']!,
                              labelText: "E-Mail 1",
                              labelFontSize20: 20,
                              hintText: "Bitte E-Mail-Adresse eintragen",
                              hintTextFontSize16: 13,
                              inputTextFontSize22: 22,
                              prefixIcon: Icons.mail_outline_outlined,
                              prefixIconSize28: 24,
                              inputFontWeightW900: FontWeight.w900,
                              inputFontColor: wbColorLogoBlue,
                              fillColor: wbColorLightYellowGreen,
                              textInputTypeOnKeyboard:
                                  TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              log("0727 - company_screen - Eine E-Mail versenden");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\n${controllers['controllerCS013']!.text}\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0727",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            child: Image(
                              image: AssetImage(
                                "assets/iconbuttons/icon_button_email.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    wbSizedBoxHeight16,
                    /*--------------------------------- Webseite ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllers['controllerCS014']!,
                              labelText: "Webseite der Firma",
                              labelFontSize20: 20,
                              hintText: "Bitte Webseite der Firma eintragen",
                              hintTextFontSize16: 13,
                              inputTextFontSize22: 22,
                              prefixIcon: Icons.language_outlined,
                              prefixIconSize28: 24,
                              inputFontWeightW900: FontWeight.w900,
                              inputFontColor: wbColorLogoBlue,
                              fillColor: wbColorLightYellowGreen,
                              textInputTypeOnKeyboard:
                                  TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () {
                              log("0872 - company_screen - Webseite verlinken");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    WbDialogAlertUpdateComingSoon(
                                  headlineText: "Direkt zur Webseite gehen",
                                  contentText:
                                      'Willst Du jetzt direkt auf die Webseite "${controllers['controllerCS014']!.text}" gehen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0872',
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            child: Image(
                              image: AssetImage(
                                "assets/iconbuttons/icon_button_quadrat_blau_leer.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Divider ---*/
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    /*--------------------------------- Abstand ---*/
                    // wbSizedBoxHeight8,
                  ],
                ),
              ),
              /*--------------------------------- ExpansionPanelList mit Text ---*/
              /*--------------------------------- Adressdaten der Firma ---*/
              ExpansionTile(
                /*--------------------------------- Farben eingeklappt/ausgeklappt ---*/
                textColor: Colors.white, // Textfarbe im ausgeklappten Zustand
                backgroundColor:
                    Colors.blue, // Hintergrundfarbe im ausgeklappten Zustand
                iconColor: Colors.white, // Iconfarbe im ausgeklappten Zustand
                collapsedTextColor:
                    wbColorLogoBlue, // Textfarbe im eingeklappten Zustand
                collapsedIconColor:
                    wbColorLogoBlue, // Iconfarbe im eingeklappten Zustand
                /*--------------------------------- Titel ---*/
                title: Container(
                  width: double.infinity, // Volle Breite
                  height: 40, // Feste Höhe
                  padding: EdgeInsets.only(left: 12), // Linker Abstand für Icon
                  decoration: BoxDecoration(
                    color: wbColorButtonBlue, // Hintergrundfarbe
                    borderRadius:
                        BorderRadius.circular(0), // Optional: Abgerundete Ecken
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon links
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.home_work_outlined, size: 28),
                      ),
                      // Linksbündiger Text
                      Expanded(
                        child: Text(
                          'Adressdaten der Firma',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left, // Explizit linksbündig
                        ),
                      ),
                    ],
                  ),
                ),
                /*--------------------------------- Inhalt ---*/
                children: [
                  ////
                  // /*--------------------------------- K021 - Firma: Straße + Nr ---*/
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                  //   child: Column(
                  //     children: [
                  //       Autocomplete<String>(
                  //         optionsBuilder: (TextEditingValue textEditingValue) {
                  //           return _filteredItems.where((item) => item
                  //               .toLowerCase()
                  //               .contains(textEditingValue.text.toLowerCase()));
                  //         },
                  //         onSelected: (String selection) {
                  //           /*--------------------------------- Sound ---*/
                  //           player
                  //               .play(AssetSource("sound/sound05xylophon.wav"));
                  //           /*--------------------------------- Log ---*/
                  //           log('1403 - ContactScreen - angeklickt - K021 - Firma: Straße + Nr - "${controllers['controllerCS021']!.text}"');
                  //           _controller.text = selection;
                  //         },
                  //         fieldViewBuilder: (context, controller, focusNode,
                  //             onFieldSubmitted) {
                  //           return WbTextFormFieldShadowWith2Icons(
                  //             controller: controllers['controllerCS021']!,
                  //             focusNode: focusNode,
                  //             labelText: 'Firma: Straße + Nr.',
                  //             labelFontSize22: 20,
                  //             hintText: 'Straße mit Nr. eingeben',
                  //             hintTextFontSize16: 16,
                  //             inputTextFontSize24: 22,
                  //             prefixIcon: Icons.location_on_outlined,
                  //             prefixIconSize32: 24,
                  //             suffixIcon: Icons.arrow_drop_down,
                  //             /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
                  //             onTap: () {
                  //               log('1422 - ContactScreen - Widget OBEN positionieren nach onTap auf das Textfeld');
                  //               final renderBox =
                  //                   context.findRenderObject() as RenderBox;
                  //               final position =
                  //                   renderBox.localToGlobal(Offset.zero);
                  //               /*--- Abstand von 116 Punkten unter der AppBar ---*/
                  //               final offset =
                  //                   position.dy - kToolbarHeight - 116;
                  //               scrollController.animateTo(
                  //                 scrollController.offset + offset,
                  //                 duration: const Duration(milliseconds: 300),
                  //                 curve: Curves.easeInOut,
                  //               );
                  //             },
                  //             /*--------------------------------- *** ---*/
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 _filteredItems = _allItems
                  //                     .where((item) => item
                  //                         .toLowerCase()
                  //                         .contains(value.toLowerCase()))
                  //                     .toList();
                  //               });
                  //             },
                  //           );
                  //         },
                  //       ),
                  //       /*--------------------------------- Abstand ---*/
                  //       wbSizedBoxHeight16,
                  //       /*--------------------------------- K022 - Firma: PLZ ---*/
                  //       Autocomplete<String>(
                  //         optionsBuilder: (TextEditingValue textEditingValue) {
                  //           return _filteredItems.where((item) => item
                  //               .toLowerCase()
                  //               .contains(textEditingValue.text.toLowerCase()));
                  //         },
                  //         onSelected: (String selection) {
                  //           _controller.text = selection;
                  //         },
                  //         fieldViewBuilder: (context, controller, focusNode,
                  //             onFieldSubmitted) {
                  //           return WbTextFormFieldShadowWith2Icons(
                  //             // /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
                  //             // onTap: () {
                  //             //   log('1467 - ContactScreen - Widget OBEN positionieren nach onTap auf das Textfeld');
                  //             //   final renderBox =
                  //             //       context.findRenderObject() as RenderBox;
                  //             //   final position =
                  //             //       renderBox.localToGlobal(Offset.zero);
                  //             //   /*--- Abstand von 136 Punkte = 1 Feld oben sichtbar oder 68 Punkte  = direkt unter der AppBar ---*/
                  //             //   final offset =
                  //             //       position.dy - kToolbarHeight - 136;
                  //             //   scrollController.animateTo(
                  //             //     scrollController.offset + offset,
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },
                  //             // /*--------------------------------- *** ---*/
                  //             controller: controllers['controllerCS022']!,
                  //             focusNode: focusNode,
                  //             labelText: 'Firma: PLZ',
                  //             labelFontSize22: 20,
                  //             hintText: 'PLZ eingeben',
                  //             hintTextFontSize16: 16,
                  //             inputTextFontSize24: 22,
                  //             prefixIcon: Icons.looks_5_outlined,
                  //             prefixIconSize32: 24,
                  //             suffixIcon: Icons.arrow_drop_down,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 _filteredItems = _allItems
                  //                     .where((item) => item
                  //                         .toLowerCase()
                  //                         .contains(value.toLowerCase()))
                  //                     .toList();
                  //               });
                  //             },
                  //           );
                  //         },
                  //       ),
                  //       /*--------------------------------- Abstand ---*/
                  //       wbSizedBoxHeight16,
                  //       /*--------------------------------- K023 - Firma: Ort ---*/
                  //       Autocomplete<String>(
                  //         optionsBuilder: (TextEditingValue textEditingValue) {
                  //           return _filteredItems.where((item) => item
                  //               .toLowerCase()
                  //               .contains(textEditingValue.text.toLowerCase()));
                  //         },
                  //         onSelected: (String selection) {
                  //           _controller.text = selection;
                  //         },
                  //         fieldViewBuilder: (context, controller, focusNode,
                  //             onFieldSubmitted) {
                  //           /*--- Scrollen mit "ensureVisible" um das Textfeld unter die AppBar zu bringen ---*/
                  //           return InkWell(
                  //             onTap: () {
                  //               // Setze den Fokus auf das erste Feld
                  //               FocusScope.of(context)
                  //                   .requestFocus(FocusNode());
                  //               Future.delayed(Duration.zero, () {
                  //                 log('1491 - ContactScreen - Fokus auf Feld 002 gesetzt');
                  //                 Scrollable.ensureVisible(
                  //                   // ignore: use_build_context_synchronously
                  //                   context,
                  //                   alignment:
                  //                       0.5, // Scrollt zur Mitte des Bildschirms
                  //                   duration: Duration(milliseconds: 500),
                  //                 );
                  //                 log('1499 - ContactScreen - Scrollt zur Mitte des Bildschirms');
                  //                 scrollController.animateTo(0,
                  //                     duration: Duration(milliseconds: 500),
                  //                     curve: Curves.easeIn);
                  //                 log('0384 - ContactScreen - Scrollt nach oben');
                  //               });
                  //             },

                  //             // onTap: () {
                  //             //   log('1487 - ContactScreen - K023 - Firma: Ort - onTap ausgelöst');
                  //             //   FocusScope.of(context).requestFocus(focusNode);

                  //             //   final renderBox =
                  //             //       context.findRenderObject() as RenderBox;
                  //             //   final position =
                  //             //       renderBox.localToGlobal(Offset.zero);
                  //             //   final offset = position.dy - kToolbarHeight - 8;

                  //             //   scrollController.animateTo(
                  //             //     scrollController.offset + offset,
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },

                  //             // onTap: () {
                  //             //   log('1487 - ContactScreen - K024 - Firma: Land - InkWell onTap ausgelöst');
                  //             //   // Scrollen, um das Feld unter die AppBar zu bringen
                  //             //   final renderBox =
                  //             //       context.findRenderObject() as RenderBox;
                  //             //   final position =
                  //             //       renderBox.localToGlobal(Offset.zero);
                  //             //   final offset = position.dy - kToolbarHeight - 8;

                  //             //   scrollController.animateTo(
                  //             //     scrollController.offset + offset,
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },

                  //             child: WbTextFormFieldShadowWith2Icons(
                  //               controller: controllers['controllerCS023']!,
                  //               focusNode: focusNode,
                  //               labelText: 'Firma: Ort',
                  //               labelFontSize22: 20,
                  //               hintText: 'Ort eingeben',
                  //               hintTextFontSize16: 16,
                  //               inputTextFontSize24: 22,
                  //               prefixIcon: Icons.home_work_outlined,
                  //               prefixIconSize32: 24,
                  //               suffixIcon: Icons.arrow_drop_down,
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   _filteredItems = _allItems
                  //                       .where((item) => item
                  //                           .toLowerCase()
                  //                           .contains(value.toLowerCase()))
                  //                       .toList();
                  //                 });
                  //               },
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       /*--------------------------------- Abstand ---*/
                  //       wbSizedBoxHeight16,
                  //       /*--------------------------------- K024 - Firma: Land ---*/
                  //       Autocomplete<String>(
                  //         optionsBuilder: (TextEditingValue textEditingValue) {
                  //           if (textEditingValue.text.isEmpty) {
                  //             // Wenn das Feld leer ist, zeige alle Optionen an
                  //             log('1512 - ContactScreen - K024 - Firma: Land - optionsBuilder - Alle Items anzeigen');
                  //             return _allItems;
                  //           }
                  //           // Filtere die Optionen basierend auf der Eingabe
                  //           log('1513 - ContactScreen - K024 - Firma: Land - optionsBuilder - Gefilterte Items anzeigen');
                  //           return _allItems.where((item) => item
                  //               .toLowerCase()
                  //               .contains(textEditingValue.text.toLowerCase()));
                  //         },
                  //         onSelected: (String selection) {
                  //           // Speichere die Auswahl im Controller
                  //           controllers['controllerCS024']!.text = selection;
                  //           log('1519 - ContactScreen - Ausgewählter Wert: $selection');
                  //         },
                  //         fieldViewBuilder: (context, autocompleteController,
                  //             focusNode, onFieldSubmitted) {
                  //           // Synchronisiere den Autocomplete-Controller mit dem Hauptcontroller
                  //           autocompleteController.text =
                  //               controllers['controllerCS024']!.text;

                  //           return InkWell(
                  //             // onTap: () {
                  //             //   log('1593 - ContactScreen - K024 - Firma: Land - InkWell onTap ausgelöst');
                  //             //   // Scrollen, um das Feld unter die AppBar zu bringen
                  //             //   final renderBox =
                  //             //       context.findRenderObject() as RenderBox;
                  //             //   final position =
                  //             //       renderBox.localToGlobal(Offset.zero);
                  //             //   final offset = position.dy - kToolbarHeight - 8;

                  //             //   scrollController.animateTo(
                  //             //     scrollController.offset + offset,
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },

                  //             // GestureDetector(
                  //             // /*--- Scrollen mit "ensureVisible" um das Textfeld unter die AppBar zu bringen ---*/
                  //             // onTap: () {
                  //             //   log('1537 - ContactScreen - K024 - Firma: Land - Tap auf das Textfeld');
                  //             //   Scrollable.ensureVisible(
                  //             //     context,
                  //             //     alignment:
                  //             //         0.1, // Positioniere das Widget etwas unterhalb der AppBar
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },

                  //             // /*--- Optional: Scrollen mit "animateTo" um das Textfeld unter die AppBar zu bringen ---*/
                  //             // onTap: () {
                  //             //   // Scrollen, um das Feld unter die AppBar zu bringen
                  //             //   final renderBox =
                  //             //       context.findRenderObject() as RenderBox;
                  //             //       log('1535 - ContactScreen - K024 - Firma: Land - renderBox: $renderBox');
                  //             //   final position =
                  //             //       renderBox.localToGlobal(Offset.zero);
                  //             //       log('1541 - ContactScreen - K024 - Die Position zeigen: $position');
                  //             //       // Abstand von 8 Punkten unter der AppBar
                  //             //   final offset = position.dy -
                  //             //       kToolbarHeight -
                  //             //       8;

                  //             //   scrollController.animateTo(
                  //             //     scrollController.offset + offset,
                  //             //     duration: const Duration(milliseconds: 300),
                  //             //     curve: Curves.easeInOut,
                  //             //   );
                  //             // },
                  //             /*--- Textfeld ---*/
                  //             child: WbTextFormFieldShadowWith2Icons(
                  //               controller: autocompleteController,
                  //               focusNode: focusNode,
                  //               labelText: 'Firma: Land',
                  //               labelFontSize22: 20,
                  //               hintText: 'Land eingeben',
                  //               hintTextFontSize16: 16,
                  //               inputTextFontSize24: 22,
                  //               prefixIcon: Icons.flag_outlined,
                  //               prefixIconSize32: 24,
                  //               suffixIcon: Icons.arrow_drop_down,
                  //               onTap: () {
                  //                 log('1654 - ContactScreen - Widget OBEN positionieren nach onTap auf das Textfeld');
                  //                 // Scrollen, um das Feld unter die AppBar zu bringen
                  //                 final renderBox =
                  //                     context.findRenderObject() as RenderBox;
                  //                 final position =
                  //                     renderBox.localToGlobal(Offset.zero);
                  //                 final offset =
                  //                     position.dy - kToolbarHeight - 50;
                  //                 scrollController.animateTo(
                  //                   scrollController.offset + offset,
                  //                   duration: const Duration(milliseconds: 300),
                  //                   curve: Curves.easeInOut,
                  //                 );

                  //                 // Scrollable.ensureVisible(
                  //                 //   context,
                  //                 //   alignment:
                  //                 //       0.1, // Positioniere das Widget etwas unterhalb der AppBar
                  //                 //   duration: const Duration(milliseconds: 300),
                  //                 //   curve: Curves.easeInOut,

                  //                 // );
                  //               },
                  //               onChanged: (value) {
                  //                 log('1664 - ContactScreen - K024 - Firma: Land - onChanged: $value');
                  //                 // Aktualisiere den Autocomplete-Controller
                  //                 autocompleteController.text = value;
                  //                 // Aktualisiere den Hauptcontroller bei jeder Änderung
                  //                 controllers['controllerCS024']!.text = value;

                  //                 setState(() {
                  //                   if (value.isEmpty) {
                  //                     log('1543 - ContactScreen - K024 - Firma: Land - Das Feld ist leer: $value');
                  //                     // Wenn das Feld leer ist, zeige alle Optionen an
                  //                     _filteredItems = _allItems;
                  //                   } else {
                  //                     log('1547 - ContactScreen - K024 - Firma: Land - Das Feld ist NICHT leer: $value');
                  //                     // Filtere die Optionen basierend auf der Eingabe
                  //                     _filteredItems = _allItems
                  //                         .where((item) => item
                  //                             .toLowerCase()
                  //                             .contains(value.toLowerCase()))
                  //                         .toList();
                  //                   }
                  //                 });
                  //                 // Logge den aktuellen Zustand
                  //                 log('1560 - ContactScreen - Aktueller Wert: $value');
                  //                 log('1561 - ContactScreen - Gefilterte Items: $_filteredItems');
                  //               },
                  //             ),
                  //           );
                  //         },
                  //         /*--------------------------------- Dropdown-Menü ---*/
                  //         optionsViewBuilder: (context, onSelected, options) {
                  //           return Align(
                  //             alignment: Alignment.topLeft,
                  //             child: Material(
                  //               color: Colors.black, // Hintergrundfarbe
                  //               elevation: 10,
                  //               child: SizedBox(
                  //                 height: 330,
                  //                 width: MediaQuery.of(context).size.width - 24,
                  //                 child: ListView.builder(
                  //                   padding: EdgeInsets.zero,
                  //                   itemCount: options.length,
                  //                   itemBuilder:
                  //                       (BuildContext context, int index) {
                  //                     final option = options.elementAt(index);
                  //                     return InkWell(
                  //                       onTap: () => onSelected(option),
                  //                       child: Container(
                  //                         padding: const EdgeInsets.fromLTRB(
                  //                             16, 8, 16, 8),
                  //                         alignment: Alignment.centerLeft,
                  //                         decoration: BoxDecoration(
                  //                           border: Border(
                  //                             bottom: BorderSide(
                  //                               color: Colors.grey,
                  //                               width: 2,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         child: Text(
                  //                           option,
                  //                           style: TextStyle(
                  //                             color: Colors.white,
                  //                             fontSize: 20,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //         //   /*--------------------------------- Dropdown-Menü - ENDE ---*/
                  //       ),
                  //       /*--------------------------------- *** ---*/
                  //     ],
                  //   ),
                  // ),
                  ////
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                ],
              ),
              /*--------------------------------- Abstand ---*/
              // wbSizedBoxHeight8,
              /*--------------------------------- Divider ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: const Divider(thickness: 3, color: wbColorLogoBlue),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxHeight8,
              /*--------------------------------- Alle Daten im Überblick ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: ExpansionTile(
                  //                   /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
                  // log('1810 - ContactScreen - Widget OBEN positionieren nach onTap auf ExpansionTile');
                  // final renderBox = context.findRenderObject() as RenderBox;
                  // final position = renderBox.localToGlobal(Offset.zero);
                  // /*--- Abstand von 136 Punkte = 1 Feld oben sichtbar oder 68 Punkte  = direkt unter der AppBar ---*/
                  // final offset = position.dy - kToolbarHeight - 136;
                  // scrollController.animateTo(
                  //   scrollController.offset + offset,
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                  // /*--------------------------------- *** ---*/

                  title: Text('Alle Kontaktdaten im Überblick'),
                  subtitle: Text(
                      'Hier siehst Du alle Daten, die im Kontaktbereich gespeichert wurden.'),
                  // iconColor: wbColorLogoBlue,
                  // collapsedIconColor: wbColorLogoBlue,
                  // collapsedTextColor: wbColorLogoBlue,
                  textColor: wbColorLogoBlue,
                  backgroundColor: Colors.blueGrey[50],
                  collapsedBackgroundColor: Colors.blueGrey[50],

                  // /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
                  // onExpansionChanged: (isExpanded) {
                  //   if (isExpanded) {
                  //     // log('1810 - ContactScreen - Widget OBEN positionieren nach onTap auf ExpansionTile');
                  //     Future.delayed(Duration(milliseconds: 100), () {
                  //       final renderBox =
                  //           // ignore: use_build_context_synchronously
                  //           context.findRenderObject() as RenderBox;
                  //       final position = renderBox.localToGlobal(Offset.zero);
                  //       final offset = position.dy - kToolbarHeight - 68;
                  //       scrollController.animateTo(
                  //         scrollController.offset + offset,
                  //         duration: const Duration(milliseconds: 300),
                  //         curve: Curves.easeInOut,
                  //       );
                  //     });
                  //   }
                  // },
                  /*--------------------------------- Inhalt ---*/
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K001 - Kontakt-ID: ${controllers['controllerCS001']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K002 - Anrede: ${controllers['controllerCS002']!.text}'),
                          Text(
                              'K003 - Vorname: ${controllers['controllerCS003']!.text}'),
                          Text(
                              'K004 - Nachname: ${controllers['controllerCS004']!.text}'),
                          Text(
                              'K005 - Geburtstag: ${controllers['controllerCS005']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K006 - Straße + Nr: ${controllers['controllerCS006']!.text}'),
                          Text(
                              'K007 - Zusatzinfo: ${controllers['controllerCS007']!.text}'),
                          Text(
                              'K008 - PLZ: ${controllers['controllerCS008']!.text}'),
                          Text(
                              'K009 - Ort: ${controllers['controllerCS009']!.text}'),
                          Text(
                              'K010 - Land: ${controllers['controllerCS010']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K011 - Telefon 1: ${controllers['controllerCS011']!.text}'),
                          Text(
                              'K012 - Telefon 2: ${controllers['controllerCS012']!.text}'),
                          Text(
                              'K013 - E-Mail 1: ${controllers['controllerCS013']!.text}'),
                          Text(
                              'K014 - Webseite: ${controllers['controllerCS014']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K015 - Firmenname: ${controllers['controllerCS015']!.text}'),
                          Text(
                              'K016 - Branche: ${controllers['controllerCS016']!.text}'),
                          Text(
                              'K017 - Warengruppen: ${controllers['controllerCS017']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K018 - Kontakt-Notizen: ${controllers['controllerCS018']!.text}'),
                          Text(
                              'K019 - Kontakt-Status: ${controllers['controllerCS019']!.text}'),
                          Text(
                              'K020 - Phone-Gruppe(n): ${controllers['controllerCS020']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K021 - Firmen-Straße: ${controllers['controllerCS021']!.text}'),
                          Text(
                              'K022 - Firmen-PLZ: ${controllers['controllerCS022']!.text}'),
                          Text(
                              'K023 - Firmen-Ort: ${controllers['controllerCS023']!.text}'),
                          Text(
                              'K024 - Firmen-Land: ${controllers['controllerCS024']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K025 - Komplett-Adresse Privat (aus dem Phone):\n${controllers['controllerCS025']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K026 - Komplett-Adresse Geschäft (aus dem Phone):\n${controllers['controllerCS026']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K027 - SmartKontakt-ID = SK-ID (aus dem Phone):\n${controllers['controllerCS027']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K028 - Reserve ${controllers['controllerCS028']!.text}'),
                          Text(
                              'K029 - x - Dokumente (in DID-05): ${controllers['controllerCS029']!.text}'),
                          Text(
                              'K030 - x - Bild des Ansprechpartners: ${controllers['controllerCS030']!.text}'),
                          Text(
                              'K031 - x - Logo der Firma: ${controllers['controllerCS031']!.text}'),
                          Text(
                              'K032 - x - LinkedIn-Profil: ${controllers['controllerCS032']!.text}'),
                          Text(
                              'K033 - x - XING-Profil: ${controllers['controllerCS033']!.text}'),
                          Text(
                              'K034 - x - Facebook-Profil: ${controllers['controllerCS034']!.text}'),
                          Text(
                              'K035 - x - Instagram-Profil: ${controllers['controllerCS035']!.text}'),
                          Text(
                              'K036 - x - Twitter-Profil: ${controllers['controllerCS036']!.text}'),
                          Text(
                              'K037 - x - Marketing-Einwilligung: ${controllers['controllerCS037']!.text}'),
                          Text(
                              'K038 - x - Bewertung abgegeben: App ${controllers['controllerCS038']!.text}'),
                          Text(
                              'K039 - x - Bewertung abgegeben: Google ${controllers['controllerCS039']!.text}'),
                          Text(
                              'K040 - x - Kontakt-Quelle: ${controllers['controllerCS040']!.text}'),
                          Text(
                              'K041 - x - Gebietskennung: ${controllers['controllerCS041']!.text}'),
                          Text(
                              'K042 - x - Betreuer MA-NR: ${controllers['controllerCS042']!.text}'),
                          Text(
                              'K043 - x - Stufe des Betreuers: ${controllers['controllerCS043']!.text}'),
                          Text(
                              'K044 - x - Betreuungsstatus: ${controllers['controllerCS044']!.text}'),
                          Text(
                              'K045 - Reserve ${controllers['controllerCS045']!.text}'),
                          Text(
                              'K046 - Reserve ${controllers['controllerCS046']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                          Text(
                              'K047 - Angelegt von ${controllers['controllerCS047']!.text}'),
                          Text(
                              'K048 - Angelegt am ${controllers['controllerCS048']!.text}'),
                          Text(
                              'K049 - Aktualisiert von ${controllers['controllerCS049']!.text}'),
                          Text(
                              'K050 - Aktualisiert am ${controllers['controllerCS050']!.text}'),
                          Divider(thickness: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*--------------------------------- Divider ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: const Divider(thickness: 3, color: wbColorLogoBlue),
              ),
              /*--------------------------------- Daten SPEICHERN oder UPDATE (if-else Button) ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: WbButtonUniversal2(
                    /*--- Hier wird die Schrift basierend auf den Bedingungen festgelegt (MUSTER) ---*/
                    wbText: widget.isNewContact
                        ? 'Daten SPEICHERN' // wenn es ein NEUER Kontakt ist
                        : 'Daten UPDATE', // wenn es ein UPDATE ist
                    /*--- Hier wird die Farbe basierend auf den Bedingungen festgelegt ---*/
                    wbColor: isButton09Clicked
                        ? Colors.black // immer wenn der Button GEKLICKT wird
                        : widget.isNewContact
                            ? wbColorButtonGreen // für NEUEN Kontakt (Button nicht geklickt)
                            : wbColorOrangeDarker, // für bestehenden Kontakt (Button nicht geklickt)
                    /*--- wenn der Button GEKLICKT wird ---*/
                    wbOnTapDown: (details) {
                      setState(() {
                        isButton09Clicked = true;
                      });
                    },
                    /*--- wenn der Button LOSGELASSEN wird ---*/
                    wbOnTapUp: (details) {
                      setState(() {
                        isButton09Clicked = false;
                      });
                    },
                    /*--- wenn der Button während dem Klick "BEWEGT" wird (ohne den Button loszulassen) ---*/
                    wbOnTapCancel: () {
                      setState(() {
                        isButton09Clicked = false;
                      });
                    },
                    /*--------------------------------- *** ---*/
                    wbFontSize24: 24,
                    wbWidth155: double.infinity,
                    wbHeight60: 60,
                    wbIcon: Icons.save_outlined,
                    wbIconSize40: 40,
                    wbOnTap: () {
                      if (widget.isNewContact) {
                        log("1449 - ContactScreen - Der Kontakt NEU ---> Daten SPEICHERN <-- geklickt");
                        if (controllers['controllerCS003']!.text.isEmpty &&
                            controllers['controllerCS004']!.text.isEmpty &&
                            controllers['controllerCS015']!.text.isEmpty) {
                          // /*--------------------------------- Sound ---*/
                          // player.play(AssetSource("sound/sound05xylophon.wav"));
                          /*--------------------------------- AlertDialog ---*/
                          showDialog(
                            context: context,
                            builder: (context) => WbDialogAlertUpdateComingSoon(
                              headlineText: 'Zum Speichern fehlen Daten!',
                              contentText:
                                  'BEIDE Felder für "Vorname" und "Nachname" sind leer.\n\nMindestens 1 Feld muss entweder "Vorname" oder "Nachname" enthalten, oder das Feld "Firma" muss ausgefüllt sein.\n\nBitte fülle MINDESTENS eines der drei Felder aus.',
                              actionsText: 'OK 👍',
                            ),
                          );
                          ////
                          // _checkAndScrollToEmptyField();
                          ////
                          return;
                        }
                        // /*--------------------------------- Sound ---*/
                        // player.play(AssetSource("sound/sound06pling.wav"));
                        /*--------------------------------- Snackbar ---*/
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: wbColorButtonGreen,
                          content: Text(
                            "Die Daten von\n${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • wurden unter der KontaktID ${controllers['controllerCS001']!.text} erfolgreich gespeichert! 😃👍",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ));
                        /*--------------------------------- Speicherung in die SQL ---*/
                        saveData(context); // Datensatz speichern
                        log('2280 - ContactScreen - Daten gespeichert (save)!');
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainSelectionScreen(),
                          ),
                        );
                      } else {
                        log("1500 - ContactScreen - Der Kontakt ist schon VORHANDEN ---> Daten UPDATE <-- geklickt");
                        // /*--------------------------------- Sound ---*/
                        // player.play(AssetSource("sound/sound06pling.wav"));
                        /*--------------------------------- Snackbar ---*/
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: wbColorOrangeDarker,
                          content: Text(
                            "Die Daten von\n${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • mit der KontaktID ${controllers['controllerCS001']!.text} wurden erfolgreich aktualisiert! 😃👍",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ));
                        /*--------------------------------- Daten updaten - Speicherung in die SQL---*/
                        updateData({});
                        log('1353 - ContactScreen - Daten "updateData": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                        saveChanges(context);
                        log('1355 - ContactScreen - Daten "saveChanges": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainSelectionScreen(),
                          ),
                        );
                        /*--------------------------------- Daten updaten - ENDE ---*/
                      }
                    }),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxHeight16,
              /*--------------------------------- Divider ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: const Divider(thickness: 3, color: wbColorLogoBlue),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxHeight8,
              /*--------------------------------- Button Daten ABBRECHEN oder LÖSCHEN - CS-1323 ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: WbButtonUniversal2(
                  /*--- Hier wird die Schrift basierend auf den Bedingungen festgelegt ---*/
                  wbText: widget.isNewContact
                      ? 'Vorgang ABBRECHEN' // wenn es ein NEUER Kontakt ist
                      : 'Daten LÖSCHEN', // wenn es ein UPDATE ist
                  /*--- Hier wird die Farbe basierend auf den Bedingungen festgelegt ---*/
                  wbColor: isButton10Clicked
                      ? Colors.black // Immer Gelb, wenn Button geklickt
                      : widget.isNewContact
                          ? wbColorAppBarBlue // Blau für neuen Kontakt (wenn Button nicht geklickt)
                          : wbColorButtonDarkRed, // Rot für bestehenden Kontakt (wenn Button nicht geklickt)
                  wbOnTapDown: (details) {
                    setState(() {
                      isButton10Clicked = true;
                    });
                  },
                  wbOnTapUp: (details) {
                    setState(() {
                      isButton10Clicked = false;
                    });
                  },
                  wbOnTapCancel: () {
                    setState(() {
                      isButton10Clicked = false;
                    });
                  },
                  /*--------------------------------- *** ---*/
                  wbIcon: Icons.delete_forever,
                  wbIconSize40: 40,
                  wbFontSize24: 24,
                  wbWidth155: double.infinity,
                  wbHeight60: 60,
                  wbOnTap: () {
                    log("1981 - ContactScreen - Daten LÖSCHEN - geklickt");
                    // /*--------------------------------- Sound abspielen ---*/
                    // player.play(AssetSource("sound/sound03enterprise.wav"));
                    /*--------------------------------- AlertDialog - START ---*/
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => WBDialog2Buttons(
                        headLineText: 'ACHTUNG:\nDie Daten werden gelöscht!',
                        descriptionText:
                            'Möchtest Du jetzt die Daten von ${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • ${controllers['controllerCS006']!.text} ${controllers['controllerCS008']!.text} ${controllers['controllerCS009']!.text} mit der KontaktID ${controllers['controllerCS001']!.text} wirklich ENDGÜLTIG löschen?\n\nDiese Aktion kann NICHT rückgängig gemacht werden!',
                        wbOnTap1: () {
                          log('2095 - ContactScreen - "Nein" wurde angeklickt');
                          // /*--------------------------------- Sound abspielen ---*/
                          // player.play(AssetSource("sound/sound06pling.wav"));
                          /*--------------------------------- Dialog ausblenden ---*/
                          Navigator.of(context).pop();
                          /*--------------------------------- Snackbar einblenden ---*/
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: wbColorOrangeDarker,
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                'Die Daten von ${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • wurden NICHT gelöscht!',
                              ),
                            ),
                          );
                        },
                        wbText2: "Ja • Löschen",
                        wbOnTap2: () async {
                          log('2117 - ContactScreen - "Ja • Löschen" wurde angeklickt');
                          // /*--------------------------------- Sound abspielen ---*/
                          // player.play(AssetSource("sound/sound06pling.wav"));
                          /*--------------------------------- Dialog ausblenden ---*/
                          /*--------------------------------- Snackbar einblenden ---*/
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: wbColorButtonDarkRed,
                            content: Text(
                              'Die Daten von ${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • ${controllers['controllerCS006']!.text} ${controllers['controllerCS008']!.text} ${controllers['controllerCS009']!.text} mit der KontaktID ${controllers['controllerCS001']!.text} wurden erfolgreich GELÖSCHT!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ));
                          /*--------------------------------- LÖSCHUNG aus der SQL ---*/
                          await deleteData({}); // Datensatz löschen
                          log('2135 - ContactScreen - Daten GEÖSCHT!');
                          /*--------------------------------- Wechsel zu MainSelectionScreen ---*/
                          log('2137 - ContactScreen - Wechsel zu MainSelectionScreen');
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              wbSizedBoxHeight16,
              Divider(thickness: 3, color: wbColorLogoBlue),

              /*--------------------------------- KontaktID anzeigen - CS-1420 ---*/
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // // Sound immer abspielen (Feedback für Tap)
                    // player.play(AssetSource("sound/sound06pling.wav"));

                    // Logging
                    final contactId = controllers['controllerCS001']!.text;
                    log('1876 - ContactScreen - KontaktID $contactId wurde angeklickt');

                    // Prüfung auf leere/ungültige ID
                    if (contactId.isEmpty || contactId == '0') {
                      log('1877 - ContactScreen - KontaktID ist leer/ungültig');
                      // /*--------------------------------- Sound abspielen ---*/
                      // player.play(AssetSource("sound/sound03enterprise.wav"));
                      /*--- AlertDialog anzeigen ---*/
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            /*--------------------------------- AlertDialog - START ---*/
                            title: const Text(
                                'Alle Datensätze mit ungültiger Kontakt-ID löschen?'),
                            content: const Text(
                              'Dieser Kontakt hat keine gültige Kontakt-ID.\n\nEs gibt möglicherweise noch andere Datensätze, die ebenfalls ungültige Kontakt-IDs haben.\n\nSollen jetzt ALLE diese Datensätze bereinigt, d.h. dauerhaft GELÖSCHT werden?\n\nACHTUNG:\nDiese Aktion kann NICHT rückgängig gemacht werden!',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Abbrechen'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Löschen',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );
                      /*--- wenn die Löschung bestätigt wird ---*/
                      if (shouldDelete == true) {
                        log('1878 - ContactScreen - Lösche Kontakt ohne ID');
                        // /*--------------------------------- Sound abspielen ---*/
                        // player.play(AssetSource("sound/sound07woosh.wav"));
                        /*--------------------------------- Snackbar einblenden ---*/
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: wbColorButtonDarkRed,
                          content: Text(
                            'Der Kontakt ohne gültige ID wurde erfolgreich gelöscht!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ));
                        await deleteDSNWhen01IsNull();
                        // if (mounted) Navigator.of(context).pop(); // Zurück zur vorherigen Seite
                      }
                    }
                  },
                  child: Text(
                      'Kontakt-ID: ${controllers['controllerCS001']!.text}'),
                ),
              ),
              /*--------------------------------- *** ---*/
              wbSizedBoxHeight8,
              wbSizedBoxHeight32,
              wbSizedBoxHeight16,
              SizedBox(height: double.tryParse('.')),
              /*--------------------------------- *** ---*/
              //     ],
              //   ),
              // ),
              wbSizedBoxHeight16,
            ],
          ),
        ),
      ),
      bottomSheet: WbInfoContainer(
        infoText:
            '${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} •\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}',
        wbColors: Colors.yellow,
      ),
    );
  }

  /*--- Berechne das Alter basierend auf dem Geburtstag ---*/
  void calculateAgeFromBirthday() {
    if (controllers['controllerCS005'] != null &&
        controllers['controllerCS005']!.text.isNotEmpty) {
      try {
        final birthday = DateTime.parse(controllers['controllerCS005']!.text);
        final today = DateTime.now();
        int ageY = today.year - birthday.year;
        int ageM = today.month - birthday.month;
        int ageD = today.day - birthday.day;

        if (ageM < 0 || (ageM == 0 && ageD < 0)) {
          ageY--;
        }

        log('Alter berechnet: $ageY Jahre, $ageM Monate, $ageD Tage');
      } catch (e) {
        log('Fehler beim Berechnen des Alters: $e');
      }
    } else {
      log('Geburtstag ist leer oder ungültig.');
    }
  }

  /*--- Eigene Methode für SQL-Löschung, wenn KontaktID leer ist ---*/
  Future<void> deleteDSNWhen01IsNull() async {
    try {
      var db = await DatabaseHelper.instance.database;
      await db.delete(
        'Tabelle01',
        where: 'Tabelle01_001 IS NULL OR TRIM(Tabelle01_001) = ?',
        whereArgs: [''],
      );
      log('Kontakt ohne gültige ID wurde erfolgreich gelöscht.');
    } catch (e) {
      log('Fehler beim Löschen des Kontakts ohne gültige ID: $e');
    }
  }

  /*--- Überprüft, ob sich die Daten geändert haben ---*/
  bool _hasDataChanged() {
    // Implement logic to check if data has changed
    // Example: Compare current data with initial data
    return false; // Replace with actual comparison logic
  }

  /*--- Füge Listener hinzu ---*/
  void _addListeners() {
    controllers.forEach((key, controller) {
      controller.addListener(() {
        log('Listener for $key triggered: ${controller.text}');
      });
    });
  }

  /*--- Entferne alle Listener und dispose die Controller ---*/
  @override
  void dispose() {
    // controllers.forEach((key, controller) {
    //   ////
    //   if (_listeners.containsKey(key)) {
    //     controller.removeListener(_listeners[key]!);
    //   }
    // });
    // _listeners.clear();
    ////
    scrollController.dispose();

    // player.dispose();
    super.dispose();
  }
}
