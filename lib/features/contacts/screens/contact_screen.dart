import 'dart:developer';
import 'dart:io';

import 'package:age_calculator/age_calculator.dart' show AgeCalculator;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_only_date.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class ContactScreen extends StatefulWidget {
  final Map<String, dynamic> contact;
  const ContactScreen({super.key, required this.contact});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

/*--------------------------------- Controller ---*/
final compPersonAge = TextEditingController();
final controllerCS001 = TextEditingController(); // Anrede
final controllerCS002 = TextEditingController(); // Vorname
final controllerCS003 = TextEditingController(); // Nachname
// final controllerCS004 = TimePickerSpinnerController(); // Geburtstag
final controllerCS004 = TextEditingController(); // Geburtstag
final controllerCS005 = TextEditingController(); // Straße
final controllerCS006 = TextEditingController(); // PLZ
final controllerCS007 = TextEditingController(); // Stadt
final controllerCS008 = TextEditingController(); // Telefon_1
final controllerCS009 = TextEditingController(); // E-Mail_1
final controllerCS010 = TextEditingController(); // Telefon_2
final controllerCS011 = TextEditingController(); // E-Mail_2
final controllerCS012 = TextEditingController(); // Webseite
final controllerCS013 = TextEditingController(); //
final controllerCS014 = TextEditingController(); // Firma
final controllerCS015 = TextEditingController(); // Logo
final controllerCS016 = TextEditingController(); // Notizen
final controllerCS017 = TextEditingController(); // Branche
final controllerCS018 = TextEditingController(); // KontaktQuelle
final controllerCS019 = TextEditingController(); // Status
final controllerCS020 = TextEditingController(); // 'Position
final controllerCS021 = TextEditingController(); // '77765
final controllerCS022 = TextEditingController(); // 'noch NICHT versandt
final controllerCS023 = TextEditingController(); // 'noch NICHT versandt
final controllerCS024 = TextEditingController(); // '99 - Gebietskennung
final controllerCS025 = TextEditingController(); //
final controllerCS026 = TextEditingController(); //
final controllerCS027 = TextEditingController(); // letzte_Aenderung_am_um
final controllerCS028 = TextEditingController(); // Betreuer
final controllerCS029 = TextEditingController(); // Betreuer_Job
final controllerCS030 = TextEditingController(); // KontaktID

// @override
// void initState() {
//   super.initState();
//   controllerCS030.text = widget.contact['TKD_Feld_030'] ?? '';
// }

/*--------------------------------- Daten speichern ---*/
Future<void> saveData(BuildContext context) async {
  var db = await DatabaseHelper().database;

  // Überprüfen, ob ein Datensatz mit der gleichen KundenID bereits existiert
  final List<Map<String, dynamic>> result = await db.query(
    'KundenDaten',
    where: 'TKD_Feld_030 = ?',
    whereArgs: [controllerCS030.text],
  );

  if (result.isNotEmpty) {
    log('Daten mit der KundenID ${controllerCS030.text} existieren bereits.');
    // Optional: Zeige eine Nachricht an, dass die Daten bereits existieren
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Ein Datensatz mit der KundenID ${controllerCS030.text} existiert bereits!',
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

  await db.insert('KundenDaten', {
    'TKD_Feld_001': controllerCS001.text,
    'TKD_Feld_002': controllerCS002.text,
    'TKD_Feld_003': controllerCS003.text,
    'TKD_Feld_004': controllerCS004.text,
    'TKD_Feld_005': controllerCS005.text,
    'TKD_Feld_006': controllerCS006.text,
    'TKD_Feld_007': controllerCS007.text,
    'TKD_Feld_008': controllerCS008.text,
    'TKD_Feld_009': controllerCS009.text,
    'TKD_Feld_010': controllerCS010.text,
    'TKD_Feld_011': controllerCS011.text,
    'TKD_Feld_012': controllerCS012.text,
    'TKD_Feld_013': controllerCS013.text,
    'TKD_Feld_014': controllerCS014.text,
    'TKD_Feld_015': controllerCS015.text,
    'TKD_Feld_016': controllerCS016.text,
    'TKD_Feld_017': controllerCS017.text,
    'TKD_Feld_018': controllerCS018.text,
    'TKD_Feld_019': controllerCS019.text,
    'TKD_Feld_020': controllerCS020.text,
    'TKD_Feld_021': controllerCS021.text,
    'TKD_Feld_022': controllerCS022.text,
    'TKD_Feld_023': controllerCS023.text,
    'TKD_Feld_024': controllerCS024.text,
    'TKD_Feld_025': controllerCS025.text,
    'TKD_Feld_026': controllerCS026.text,
    'TKD_Feld_027': controllerCS027.text,
    'TKD_Feld_028': controllerCS028.text,
    'TKD_Feld_029': controllerCS029.text,
    'TKD_Feld_030': controllerCS030.text,
  });
  log('0138 - ContactScreen - Daten gespeichert von ${controllerCS001.text} ${controllerCS002.text} ${controllerCS003.text} / KontaktID: ${controllerCS030.text}');
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

// /*--------------------------------- SQL-Datenbank ---*/
// class DatabaseHelper {
//   static Database? _database;

//   // Singleton-Muster
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _openDatabaseFromAssets();
//     return _database!;
//   }

//   Future<Database> _openDatabaseFromAssets() async {
//     log('0046 - ContactScreen - Öffnet die Datenbank');
//     Directory documentsDir = await getApplicationDocumentsDirectory();
//     String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
//     bool dbExists = await databaseExists(dbPath);

//     if (!dbExists) {
//       ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
//       List<int> bytes = data.buffer.asUint8List();
//       await File(dbPath).writeAsBytes(bytes, flush: true);
//     }
//     return openDatabase(dbPath);
//   }
// }

Future<void> fetchData() async {
  var db = await DatabaseHelper().database;

  /*--- Zeige alle Kontakte aus Schwäbisch Gmünd ---*/
  // var query = await db.rawQuery(
  //     "SELECT * FROM KundenDaten WHERE TKD_Feld_007 = 'Schwäbisch Gmünd'");

  /*--- Zeige den Kontakt mit der KundenID: 1683296820166' ---*/
  var query = await db.rawQuery(
      "SELECT * FROM KundenDaten WHERE TKD_Feld_030 = 'KundenID: 1683296820166'");

  /*--- Zeige alle Kunden mit allen Daten ---*/
  // var query = await db.rawQuery("SELECT * FROM KundenDaten");

  log('0062 - ContactScreen - Abfrage Ergebnis: $query');
}

// Future<int> updateTest(Map<String, dynamic> row) async {
//   Database db = await instance.database;
//   int id = row[columnId];
//   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
// }

// Future<void> updateDog() async {
//   // Get a reference to the database.
//   final db = await database;

//   // Update the given Dog.
//   await db.update(
//     'dogs',
//     dog.toMap(),
//     // Ensure that the Dog has a matching id.
//     where: "id = ?",
//     // Pass the Dog's id as a whereArg to prevent SQL injection.
//     whereArgs: [dog.id],
//   );
// }

/*--------------------------------- Daten aktualisieren ---*/
Future<void> updateData(Map<String, dynamic> row) async {
  var db = await DatabaseHelper().database;

  /*--- Ändere den Kontakt mit der KundenID: 1683296820166 ---*/
  var query = await db.rawUpdate('''
    UPDATE KundenDaten SET
      TKD_Feld_001 = ?,
      TKD_Feld_002 = ?,
      TKD_Feld_003 = ?,
      TKD_Feld_004 = ?,
      TKD_Feld_005 = ?,
      TKD_Feld_006 = ?,
      TKD_Feld_007 = ?,
      TKD_Feld_008 = ?,
      TKD_Feld_009 = ?,
      TKD_Feld_010 = ?,
      TKD_Feld_011 = ?,
      TKD_Feld_012 = ?,
      TKD_Feld_013 = ?,
      TKD_Feld_014 = ?,
      TKD_Feld_015 = ?,
      TKD_Feld_016 = ?,
      TKD_Feld_017 = ?,
      TKD_Feld_018 = ?,
      TKD_Feld_019 = ?,
      TKD_Feld_020 = ?,
      TKD_Feld_021 = ?,
      TKD_Feld_022 = ?,
      TKD_Feld_023 = ?,
      TKD_Feld_024 = ?,
      TKD_Feld_025 = ?,
      TKD_Feld_026 = ?,
      TKD_Feld_027 = ?,
      TKD_Feld_028 = ?,
      TKD_Feld_029 = ?
    WHERE TKD_Feld_030 = ?
  ''', [
    controllerCS001.text,
    controllerCS002.text,
    controllerCS003.text,
    controllerCS004.text,
    controllerCS005.text,
    controllerCS006.text,
    controllerCS007.text,
    controllerCS008.text,
    controllerCS009.text,
    controllerCS010.text,
    controllerCS011.text,
    controllerCS012.text,
    controllerCS013.text,
    controllerCS014.text,
    controllerCS015.text,
    controllerCS016.text,
    controllerCS017.text,
    controllerCS018.text,
    controllerCS019.text,
    controllerCS020.text,
    controllerCS021.text,
    controllerCS022.text,
    controllerCS023.text,
    controllerCS024.text,
    controllerCS025.text,
    controllerCS026.text,
    controllerCS027.text,
    controllerCS028.text,
    controllerCS029.text,
    controllerCS030.text,
  ]);

  log('0202 - ContactScreen - Abfrage Ergebnis: $query'); // Ergebnis: 1
  log('0203 - ContactScreen - Abfrage Ergebnis: $controllerCS004'); // Geburtstag als Instance
  log('0204 - ContactScreen - Abfrage Ergebnis: ${controllerCS004.text}'); // Geburtstag als Datum (oder leer)
}

/*--------------------------------- Datensatz löschen ---*/
Future<void> deleteData(Map<String, dynamic> row) async {
  // Die Datenbank öffnen, indem auf die Instanz von DatabaseHelper zugegriffen wird
  var db = await DatabaseHelper().database;

  // Der Name der Tabelle, aus der der Datensatz gelöscht werden soll
  final String tableName = 'KundenDaten';

  // Die Spalte, welche KundenID enthält
  final String columnKundenID = 'TKD_Feld_030';

  // Die KundenID, die gelöscht werden soll
  final String kundenIDToDelete = controllerCS030.text;

  // Den Löschvorgang durchführen
  await db.delete(
    tableName, // Name der Tabelle
    where:
        '$columnKundenID = ?', // WHERE-Bedingung: Löschen, wo die KundenID gleich dem Wert ist
    whereArgs: [
      kundenIDToDelete
    ], // Argument für die WHERE-Bedingung (hier: KundenID 1234)
  );

  // Optional: Gib eine Bestätigung aus, dass der Datensatz gelöscht wurde
  log('0227 - ContactScreen - Der Datensatz mit KundenID $kundenIDToDelete wurde gelöscht.');
}

/*--------------------------------- State ---*/
class _ContactScreenState extends State<ContactScreen> {
  /*--------------------------------- AudioPlayer ---*/
  late AudioPlayer player = AudioPlayer();

  /*--- für die Berechnung des Alters und der Zeitspanne bis zum nächsten Geburtstag ---*/
  int ageY = 0, ageM = 0, ageD = 0, nextY = 0, nextM = 0, nextD = 0;
  DateTime initTime = DateTime.now();
  DateTime selectedTime = DateTime.now();
  String today = DateFormat('dd.MM.yyyy').format(DateTime.now());

  /*--- Automatisch das Alter berechnen mit "age_calculator" 0785 - ContactScreen ---*/
  void calculateAgeFromBirthday() {
    try {
      AgeCalculator();
      // DateTime birthday = DateTime.parse('29.02.1964');
      // DateTime birthday =
      // DateTime.now().subtract(const Duration(days: 20505)); // funzt - nur zum Testen!
      // String birthday = '29.02.1964'; // funzt - nur zum Testen!

      //  String birthday = controllerCS004.text; // leer? warum?
      log('Geburtstag: ${controllerCS004.text}'); // leer? warum?
      log('Geburtstag: $controllerCS004'); // leer? warum?

      // DateTime birthday = DateTime.parse(controllerCS004.text); // leer? warum?
      String birthday = controllerCS004.text;

      log('Geburtstag: $birthday / ${controllerCS004.text}');

      /*--- Den String in Tag, Monat und Jahr aufteilen ---*/
      List<String> dateParts = controllerCS004.text.split('.');
      String day = dateParts[0];
      String month = dateParts[1];
      String year = dateParts[2];

      /*--- Einen neuen String im ISO 8601 Format erstellen ---*/
      String isoDateString = "$year-$month-$day";

      /*--- Den String in ein DateTime-Objekt parsen ---*/
      DateTime dateTime = DateTime.parse(isoDateString);

      log('0267 - ContactScreen - $birthday');
      log('0268 - ContactScreen - $dateTime');

      // DateTime birthday = DateTime.parse(controllerCS004.text);
      var age = AgeCalculator.age(dateTime);
      log('0297 - ContactScreen - Berechnetes Alter = ${age.years} Jahre + ${age.months} Monate + ${age.days} Tage');

      /*--- Automatisch die Zeit bis zum nächsten Geburtstag berechnen mit "age_calculator" ---*/
      // DateTime nextBirthday = DateTime.parse(controllerCS004.text);
      DateTime nextBirthday = dateTime;

      var timeToNextBirthday = AgeCalculator.timeToNextBirthday(
        DateTime(
          nextBirthday.year,
          nextBirthday.month,
          nextBirthday.day,
        ),
        fromDate: DateTime.now(),
      );

      /*--- die Daten aktualisieren ---*/
      setState(() {
        /*--- das Alter berechnen aktualisieren ---*/
        ageY = age.years;
        ageM = age.months;
        ageD = age.days;

        /*--- die Zeit bis zum nächsten Geburtstag aktualisieren ---*/
        nextY = timeToNextBirthday.years;
        nextM = timeToNextBirthday.months;
        nextD = timeToNextBirthday.days;
      });
    } catch (e) {
      log('0309 - ContactScreen - Fehlermeldung: $e');
      // /*--------------------------------- showAlertDialog ---*/ // funzt nicht!
      // showDialog(

      //   context: context,
      //   builder: (context) => const WbDialogAlertUpdateComingSoon(
      //     headlineText:
      //         "Das Geburtsdatum ist nicht korrekt!\n\nBitte überprüfe das Datum.",
      //     contentText: "Bitte überprüfe das Datum.\n\nUpdate CS-0317",
      //     actionsText: "OK 👍",
      //   ),
      // );
      // /*--------------------------------- showAlertDialog ENDE ---*/

      // /*--------------------------------- showAlertDialog ---*/
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text("Fehler"),
      //     content: Text(
      //         "Das Geburtsdatum ist nicht korrekt!\n\nBitte überprüfe das Datum."),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         child: Text("OK 👍"),
      //       ),
      //     ],
      //   ),
      // );
      // /*--------------------------------- showAlertDialog ENDE ---*/
    }
  }

  /*--------------------------------- getNextBirthdayText ---*/
  String getNextBirthdayText() {
    log('0314 - ContactScreen - Abfrage Ergebnis: ${controllerCS004.text}'); // Geburtstag als Datum (oder leer)

    /*--- Wenn das Geburtsdatum leer ist, dann ist das Alter und die Zeit bis zum nächsten Geburtstag unbekannt ---*/
    if (controllerCS004.text.isEmpty) {
      log('0318 - ContactScreen ---> controllerCS004.text.isEmpty: ${controllerCS004.text.isEmpty} <---');
      return '---> ist UNBEKANNT!';
    }
    if (nextD == 0 && nextM == 0) {
      log('0322 - ContactScreen - .... ist wieder in 1 Jahr 😃');
      return '... ist wieder in 1 Jahr 😃';
    }
    if (nextD == 1 && nextM == 0) {
      log('0326 - ContactScreen - ... ist schon MORGEN 🚀');
      return '... ist schon MORGEN 🚀';
    }
    if (nextD == 2 && nextM == 0) {
      log('0330 - ContactScreen - ... ist schon ÜBERMORGEN!');
      return '... ist schon ÜBERMORGEN!';
    }
    if (nextD >= 3 && nextM == 0) {
      log('0334 - ContactScreen - .. ist schon in $nextD Tagen!');
      return '... ist schon in $nextD Tagen!';
    }

    List<String> parts = [];
    log('0339 - ContactScreen ---> parts: $parts <--- müssten hier leer sein!');
    if (nextY > 0) {
      parts.add(nextY == 1 ? '... in $nextY Jahr' : '$nextY Jahre');
    }
    if (nextM > 0) {
      parts.add(nextM == 1 ? '... in $nextM Monat' : '$nextM Monate');
    }
    if (nextD > 0) {
      parts.add(nextD == 1 ? '... in $nextD Tag' : '$nextD Tage');
    }
    if (parts.isEmpty) {
      return '---> ist UNBEKANNT!';
    }
    log('0352 - ContactScreen ---> parts: $parts <--- müssten hier gefüllt sein!');

    return parts.join(' + ');

    //return '---> ist UNBEKANNT!';
  }

  /*--------------------------------- onChanged-Funktion ---*/
  String inputCompanyName = "Firmenlogo"; // nur für die "onChanged-Funktion"
  String inputCompanyVNContactPerson =
      "Ansprechpartner"; // nur für die "onChanged-Funktion"
  String inputCompanyNNContactPerson = ""; // nur für die "onChanged-Funktion"

  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  bool _hasCallSupport = false;
  late String _phone = '';
  Future<void>? _launched;

  bool isDataChanged = false;

  void _onDataChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isDataChanged = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    log("0344 - ContactScreen - initState - aktiviert");
    controllerCS030.text = widget.contact['TKD_Feld_030'] ??
        ''; // Fehlermeldung: disposed() called on null - 0466 - ContactScreen

    /*--- Den Zustand (State) erst nach dem Build ändern.
          Diese Methode wird verwendet, um eine Aktion auszuführen, nachdem das Widget vollständig aufgebaut wurde. 
          Die Daten werden direkt nach dem Rendern gespeichert. ---*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('0350 - ContactScreen - WidgetsBinding.instance.addPostFrameCallback - aktiviert');
      setState(() {
        try {
          /*--------------------------------- Daten aus der SQFlite ---*/
          controllerCS001.text = widget.contact['TKD_Feld_001'] ?? ''; // Anrede
          controllerCS002.text =
              widget.contact['TKD_Feld_002'] ?? ''; // Vorname
          controllerCS003.text =
              widget.contact['TKD_Feld_003'] ?? ''; // Nachname

          // Geburtstag ist ein Datum und kein String - wie kann ich das mit einem Controller verarbeiten? - 0146 - ContactScreen
          // controllerCS004.menuIsShowing = widget.contact['TKD_Feld_004'] ?? ''; // Geburtstag

          controllerCS004.text =
              widget.contact['TKD_Feld_004'] ?? ''; // Geburtstag
          controllerCS005.text = widget.contact['TKD_Feld_005'] ?? ''; // Straße
          controllerCS006.text = widget.contact['TKD_Feld_006'] ?? ''; // PLZ
          controllerCS007.text = widget.contact['TKD_Feld_007'] ?? ''; // Ort
          controllerCS008.text =
              widget.contact['TKD_Feld_008'] ?? ''; // Telefon 1
          controllerCS009.text =
              widget.contact['TKD_Feld_009'] ?? ''; // E-Mail 1
          controllerCS010.text =
              widget.contact['TKD_Feld_010'] ?? ''; // Telefon 2
          controllerCS011.text =
              widget.contact['TKD_Feld_011'] ?? ''; // E-Mail 2
          controllerCS012.text =
              widget.contact['TKD_Feld_012'] ?? ''; // Webseite
          controllerCS013.text = widget.contact['TKD_Feld_013'] ?? ''; //
          controllerCS014.text = widget.contact['TKD_Feld_014'] ?? ''; // Firma
          controllerCS015.text = widget.contact['TKD_Feld_015'] ?? ''; // Logo
          controllerCS016.text =
              widget.contact['TKD_Feld_016'] ?? ''; // Notizen
          controllerCS017.text = widget.contact['TKD_Feld_017'] ?? ''; //
          controllerCS018.text = widget.contact['TKD_Feld_018'] ?? ''; //
          controllerCS019.text = widget.contact['TKD_Feld_019'] ?? ''; // Status
          controllerCS020.text =
              widget.contact['TKD_Feld_020'] ?? ''; // 'Position
          controllerCS021.text = widget.contact['TKD_Feld_021'] ?? ''; // '77765
          controllerCS022.text =
              widget.contact['TKD_Feld_022'] ?? ''; // 'noch NICHT versandt
          controllerCS023.text =
              widget.contact['TKD_Feld_023'] ?? ''; // 'noch NICHT versandt
          controllerCS024.text =
              widget.contact['TKD_Feld_024'] ?? ''; // '99 - Gebietskennung
          controllerCS025.text = widget.contact['TKD_Feld_025'] ?? ''; //
          controllerCS026.text = widget.contact['TKD_Feld_026'] ?? ''; //
          controllerCS027.text =
              widget.contact['TKD_Feld_027'] ?? ''; // letzte_Aenderung_am_um
          updateData({});
          widget.contact['TKD_Feld_028'] ?? ''; // Betreuer
          controllerCS029.text =
              widget.contact['TKD_Feld_029'] ?? ''; // Betreuer_Job
          controllerCS030.text =
              widget.contact['TKD_Feld_030'] ?? ''; // KontaktID
        } catch (e) {
          log('0271 - ContactScreen - Fehler: $e');
        }
      });

      /*--- Daten direkt nach dem Rendern speichern ---*/
      updateData({});

      /*--- Hier nochmal das Alter aus dem Geburtstag berechnen ---*/
      calculateAgeFromBirthday();
    });

    /*--- Zeitstempel in ein lesbares Datum umwandeln ---*/
    void timestampToDateTime(int timestamp) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
      DateTime localDateTime = dateTime.toLocal();
      String formattedDate =
          DateFormat('dd.MM.yyyy HH:mm').format(localDateTime);
      log('0192 - ContactScreen - formattedDate: $formattedDate');
    }
    // // Zeitstempel als String aus dem Controller
    // String timestampString = controllerCS027.text;

    // // Umwandlung des Strings in einen Integer
    // int timestamp = int.parse(timestampString);

    // // Umwandlung des Zeitstempels in ein DateTime-Objekt
    // DateTime dateTime =
    //     DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

    // // Umwandlung in die lokale Zeit (MESZ)
    // DateTime localDateTime = dateTime.toLocal();

    // // Formatierung des Datums im europäischen Format
    // String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(localDateTime);
    // log('0192 - ContactScreen - formattedDate: $formattedDate');

    // String formatEuropeanTimeLocal(String timestamp) {
    //   final dateTime =
    //       DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    //   final localTime = dateTime.toLocal();
    //   final formatter = DateFormat('dd.MM.yyyy HH:mm:ss');
    //   final isDst = localTime.timeZoneOffset.inHours == 2;
    //   return '${formatter.format(localTime)} ${isDst ? 'MESZ' : 'MEZ'}';
    // }

    /*--- Überprüfe den Telefon-Anruf-Support ---*/
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });

    fetchData();
    calculateAgeFromBirthday();
    //dispose();
    //updateData();
    _addListeners();
  }

  void _addListeners() {
    controllerCS001.addListener(_onDataChanged);
    controllerCS002.addListener(_onDataChanged);
    controllerCS003.addListener(_onDataChanged);
    controllerCS004.addListener(_onDataChanged);
    controllerCS005.addListener(_onDataChanged);
    controllerCS006.addListener(_onDataChanged);
    controllerCS007.addListener(_onDataChanged);
    controllerCS008.addListener(_onDataChanged);
    controllerCS009.addListener(_onDataChanged);
    controllerCS010.addListener(_onDataChanged);
    controllerCS011.addListener(_onDataChanged);
    controllerCS012.addListener(_onDataChanged);
    controllerCS013.addListener(_onDataChanged);
    controllerCS014.addListener(_onDataChanged);
    controllerCS015.addListener(_onDataChanged);
    controllerCS016.addListener(_onDataChanged);
    controllerCS017.addListener(_onDataChanged);
    controllerCS018.addListener(_onDataChanged);
    controllerCS019.addListener(_onDataChanged);
    controllerCS020.addListener(_onDataChanged);
    controllerCS021.addListener(_onDataChanged);
    controllerCS022.addListener(_onDataChanged);
    controllerCS023.addListener(_onDataChanged);
    controllerCS024.addListener(_onDataChanged);
    controllerCS025.addListener(_onDataChanged);
    controllerCS026.addListener(_onDataChanged);
    controllerCS027.addListener(_onDataChanged);
    controllerCS028.addListener(_onDataChanged);
    controllerCS029.addListener(_onDataChanged);
    controllerCS030.addListener(_onDataChanged);
  }

  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      log('0072 - ContactScreen - _launchStatus:     $_launchStatus');
      log('0073 - ContactScreen - context:           $context');
      log('0074 - ContactScreen - snapshot:          $snapshot');
      log('0075 - ContactScreen - snapshot.hasError: ${snapshot.hasError}');
      log('0076 - ContactScreen - snapshot.error:    ${snapshot.error}');
      return Text('Error: ${snapshot.error}');
    } else {
      log('0080 - ContactScreen - _launchStatus:     $_launchStatus');
      log('0081 - ContactScreen - context:           $context');
      log('0082 - ContactScreen - snapshot:          $snapshot');
      log('0083 - ContactScreen - snapshot.hasError: ${snapshot.hasError}');
      log('0084 - ContactScreen - snapshot.error:    ${snapshot.error}');
      return const Text('');
    }
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
  Widget build(BuildContext context) {
    log("0038 - ContactScreen - aktiviert");

    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
          /*--- "toolbarHeight" wird hier nicht mehr benötigt, weil jetzt "WbInfoContainer" die Daten anzeigt ---*/
          // toolbarHeight: 100,
          title: Text(
            'Kontakt zeigen   |   bearbeiten', // oder NEU anlegen
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
          //elevation: 10,
          //scrolledUnderElevation: 10,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // if (isDataChanged) {
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text("Datenänderungen wurden nicht gespeichert!"),
                //         content: Text(
                //             "Es gibt ungespeicherte Änderungen. Möchtest du die Daten speichern, bevor du zurückgehst?"),
                //         actions: [
                //           TextButton(
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => const MainSelectionScreen(),
                //                 ),
                //               );
                //             },
                //             child: Text("Die Daten nicht speichern"),
                //           ),
                //           TextButton(
                //             onPressed: () async {
                //               Navigator.of(context).pop();
                //               await saveData(context);
                //               Navigator.push(
                //                 // ignore: use_build_context_synchronously
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => const MainSelectionScreen(),
                //                 ),
                //               );
                //             },
                //             child: Text("Die geänderten Daten speichern"),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainSelectionScreen(),
                  ),
                );
              })

          /*--------------------------------- *** ---*/
          /*--- "RichText" wird hier nicht mehr benötigt, weil jetzt "WbInfoContainer" die Daten anzeigt ---*/
          // title: RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(
          //     text: "Firma bearbeiten\n",
          //     style: TextStyle(
          //       fontSize: 28,
          //       fontWeight: FontWeight.w900,
          //       color: Colors.yellow,
          //     ),
          //     children: <TextSpan>[
          //       // children: [
          //       TextSpan(
          //         text:
          //             "• $inputCompanyName\n• $inputCompanyVNContactPerson $inputCompanyNNContactPerson",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w900,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // /*--------------------------------- *** ---*/
          // shape: Border.symmetric(
          //   horizontal: BorderSide(
          //     width: 3,
          //   ),
          // ),
          // /*--------------------------------- *** ---*/
          ),
      /*--------------------------------- *** ---*/
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //const Divider(thickness: 3, color: wbColorLogoBlue),
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
                            /*--------------------------------- *** ---*/
                            // Außenlinie mit Farbverlauf:
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Colors.red,
                            //     Colors.yellow,
                            //   ],
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            // ),
                            /*--------------------------------- *** ---*/
                          ),
                          child: CircleAvatar(
                            backgroundColor: wbColorButtonBlue,
                            backgroundImage: AssetImage(
                              "assets/company_logos/enpower_expert_logo_4_x_4.png",
                            ),
                            /*--------------------------------- *** ---*/
                            // Alternativ-Bild aus dem Internet:
                            // NetworkImage('https://picsum.photos/200'),
                            /*--------------------------------- *** ---*/
                            radius: 68,
                          ),
                        ),
                        /*--- Das ist der Abstand zwischen dem Logo und der Firmenbezeichnung ---*/
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
                            controllerCS014.text.isEmpty
                                ? "KEINE Firma"
                                : controllerCS014.text,
                          ),
                        ),
                      ],
                    ),
                    /*--- Das ist der Zwischenabstand bei Expanded --- */
                    const SizedBox(width: 14),
                    /*--------------------------------- Bild des Ansprechpartners --- */
                    Column(
                      children: [
                        Container(
                          height: 136,
                          width: 136,
                          // Quadrat mit blauem Hintergrund und Schatten
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
                            ('${controllerCS002.text} ${controllerCS003.text}'),
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
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Kontakt-Status auswählen ---*/
                    WbDropDownMenu(
                      controller: controllerCS019,
                      label: "Kontakt-Staus",
                      dropdownItems: [
                        controllerCS019.text,
                        "Kontakt",
                        "Interessent",
                        "Kunde",
                        "Lieferant",
                        "Lieferant und Kunde",
                        "möglicher Lieferant",
                      ],
                      // leadingIconsInMenu: [
                      //   // hat hier keine Auswikung // todo 0233 + 0406
                      //   Icons.access_time,
                      //   Icons.airline_seat_legroom_normal,
                      //   Icons.access_time,
                      //   Icons.dangerous,
                      //   Icons.access_time,
                      //   Icons.face,
                      // ],
                      leadingIconInTextField: Icons.create_new_folder_outlined,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Divider ---*/
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Anrede ---*/
                    WbDropDownMenu(
                      controller: controllerCS001,
                      label: "Anrede",
                      dropdownItems: [
                        // controllerCS001.text,
                        "Herr",
                        "Frau",
                        "Divers",
                        "Herr Dr.",
                        "Frau Dr.",
                        "Dr.",
                        "Herr Prof.",
                        "Frau Prof.",
                        "Prof.",
                      ],
                      leadingIconsInMenu: [
                        // als Map oder besser noch aus der Datenbank auslesen - todo 0233 + 0406
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
                      leadingIconInTextField: Icons.person_2_outlined,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Vorname ---*/
                    WbTextFormField(
                      labelText: "Vorname",
                      labelFontSize20: 20,
                      hintText: "Bitte den Vornamen eintragen",
                      hintTextFontSize16: 15,
                      inputTextFontSize22: 22,
                      prefixIcon: Icons.person,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      /*--------------------------------- onChanged ---*/
                      controller: controllerCS002,
                      onChanged: (String controllerCS002) {
                        log("0478 - company_screen - Eingabe: $controllerCS002");

                        inputCompanyVNContactPerson = controllerCS002;

                        setState(() =>
                            inputCompanyVNContactPerson = controllerCS002);
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Nachname ---*/
                    WbTextFormField(
                      labelText: "Nachname",
                      labelFontSize20: 20,
                      hintText: "Bitte den Nachnamen eintragen",
                      hintTextFontSize16: 15,
                      inputTextFontSize22: 22,
                      prefixIcon: Icons.person,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      /*--------------------------------- onChanged ---*/
                      controller: controllerCS003,
                      onChanged: (String controllerCS003) {
                        log("0504 - ContactScreen - Eingabe: $controllerCS003");

                        inputCompanyNNContactPerson = controllerCS003;

                        setState(() =>
                            inputCompanyNNContactPerson = controllerCS003);
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
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
                                    log('0752 - ContactScreen - das Alter mit "${controllerCS004.text}" berechnen');
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
                                /*--------------------------------- Abstand zum Geburtstag-Feld ---*/
                                wbSizedBoxWidth16,
                                /*--------------------------------- Geburtstag-Feld ---*/
                                Expanded(
                                  child: WbTextFormFieldOnlyDATE(
                                      // width: 210, // ist hier ohne Auswirkung wegen Expanded
                                      controller: controllerCS004,
                                      // validator?
                                      prefixIcon: Icons.cake_outlined,
                                      labelText: 'Geburtstag',
                                      labelFontSize20: 20,
                                      hintText: 'Geburtstag',
                                      inputTextFontSize22: 22,
                                      inputFontWeightW900: FontWeight.w900,
                                      inputFontColor: wbColorButtonDarkRed,
                                      fillColor: Colors.yellow,

                                      // textInputAction: TextInputAction
                                      //     .go, // auf der Tastatur erscheint der Button "go"

                                      onEditingComplete: () {
                                        log('0890 - ContactScreen - das Alter mit "${controllerCS004.text}" berechnen');
                                        calculateAgeFromBirthday();
                                      }

                                      // /*--- Automatisch das Alter berechnen mit "age_calculator" 0785 - ContactScreen ---*/
                                      // AgeCalculator();
                                      // DateTime birthday = DateTime.parse(
                                      //     '${controllerCS004.text}');
                                      // var age = AgeCalculator.age(birthday);
                                      // log('1069 - ContactScreen - Berechnetes Alter = ${age.years} Jahre + ${age.months} Monate + ${age.days} Tage');

                                      // /*--- Automatisch die Zeit bis zum nächsten Geburtstag berechnen mit "age_calculator" ---*/
                                      // DateTime nextBirthday = DateTime.parse(
                                      //     '${controllerCS004.text}');
                                      // var timeToNextBirthday =
                                      //     AgeCalculator.timeToNextBirthday(
                                      //   DateTime(
                                      //     nextBirthday.year,
                                      //     nextBirthday.month,
                                      //     nextBirthday.day,
                                      //   ),
                                      //   fromDate: DateTime.now(),
                                      // );

                                      // /*--- die Daten aktualisieren ---*/
                                      // setState(() {
                                      //   /*--- das Alter berechnen aktualisieren ---*/
                                      //   ageY = age.years;
                                      //   ageM = age.months;
                                      //   ageD = age.days;

                                      //   /*--- die Zeit bis zum nächsten Geburtstag aktualisieren ---*/
                                      //   nextY = timeToNextBirthday.years;
                                      //   nextM = timeToNextBirthday.months;
                                      //   nextD = timeToNextBirthday.days;
                                      // });

                                      // },

                                      // onChanged: (controllerCS004) {

                                      //   log('0887 - ContactScreen - onChanged $controllerCS004 - Geburtsdatum berechnen');

                                      // }
                                      ),
                                ),

                                /*--------------------------------- *** ---*/
                                /*--- vorübergehend deaktiviert: TimePickerSpinnerPopUp ---*/
                                // TimePickerSpinnerPopUp(
                                //     // controller: controllerCS004,
                                //     locale: Locale('de', 'DE'),
                                //     iconSize: 20,
                                //     textStyle: TextStyle(
                                //         backgroundColor:
                                //             wbColorLightYellowGreen,
                                //         fontSize: 22,
                                //         fontWeight: FontWeight.bold),
                                //     isCancelTextLeft: true,
                                //     paddingHorizontalOverlay: 80,
                                //     mode: CupertinoDatePickerMode.date,
                                //     radius: 16,
                                //     initTime: selectedTime,
                                //     minTime: DateTime.now()
                                //         .subtract(const Duration(days: 36500)),
                                //     /*--------------------------------- *** ---*/
                                //     /* das Geburtsdatum kann nicht in der Zukunft liegen */
                                //     maxTime: DateTime.now()
                                //         .add(const Duration(days: 0)),
                                //     /*--------------------------------- *** ---*/
                                //     use24hFormat: true,
                                //     barrierColor: Colors.black12,
                                //     minuteInterval: 1,
                                //     padding:
                                //         const EdgeInsets.fromLTRB(12, 8, 8, 8),
                                //     cancelText: 'Abbruch',
                                //     confirmText: 'OK',
                                //     pressType: PressType.singlePress,
                                //     timeFormat: 'dd.MM.yyyy',

                                /*--------------------------------- *** ---*/
                                // onChanged: (dateTime) {
                                //   log('0539 - ContactScreen - Geburtsdatum eingegeben: $dateTime');
                                /*--------------------------------- *** ---*/

                                //     /*--- Das angeklickte Geburtsdatum im "TimePickerSpinnerPopUp" soll behalten werden ---*/
                                //     selectedTime = birthday;
                                //     log('0573 - ContactScreen - selectedTime: $selectedTime = birthday: $birthday');
                                //   });
                                // }),
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
                                        // : (ageD != 0 && ageM != 0 && ageY == 0)
                                        //     ? '$ageM Monate + $ageD Tage'
                                        //     : (ageD != 0 && ageM == 0 && ageY == 0)
                                        //         ? '$ageD Tage'
                                        //         : '---> ist UNBEKANNT!',
                                        // ? '$ageY Jahre + $ageM Monate + $ageD Tage'
                                        // : '$ageY Jahre + $ageM Monate + $ageD Tage',
                                        /*--------------------------------- mehrfach verschachtelter ternärer Operator ---*/
                                        : (ageY == 1 && ageM == 1 && ageD == 1)
                                            ? '$ageY Jahr + $ageM Monat + $ageD Tag'
                                            : (ageY == 0 &&
                                                    ageM == 0 &&
                                                    ageD == 1)
                                                ? '$ageD Tag'
                                                : (ageY == 1 &&
                                                        ageM == 0 &&
                                                        ageD == 1)
                                                    ? '$ageY Jahr + $ageD Tag'
                                                    : (ageY == 1 &&
                                                            ageM == 1 &&
                                                            ageD == 0)
                                                        ? '$ageY Jahr + $ageM Monat'
                                                        /*--------------------------------- *** ---*/
                                                        : (controllerCS004
                                                                    .text ==
                                                                today)
                                                            ? '---> ist HEUTE 😃'
                                                            : (ageY == 0 &&
                                                                    ageM == 0 &&
                                                                    ageD == 0)
                                                                ? '---> ist UNBEKANNT!'
                                                                : (ageM == 1)
                                                                    ? '$ageM Monat'
                                                                    : (ageD ==
                                                                            1)
                                                                        ? '+ $ageD Tag'
                                                                        : (ageM ==
                                                                                0)
                                                                            ? '+ $ageM Monat'
                                                                            /*--------------------------------- *** ---*/
                                                                            : (ageY == 0 && ageM == 0 && ageD == 0)
                                                                                ? '---> ist UNBEKANNT!'
                                                                                : (ageY == 1)
                                                                                    ? '$ageY Jahr'
                                                                                    : (ageM == 1)
                                                                                        ? '$ageM Monat'
                                                                                        : (ageD == 1)
                                                                                            ? '$ageD Tag'
                                                                                            : (ageY == 0)
                                                                                                ? '$ageY Jahr'
                                                                                                : (ageM == 0)
                                                                                                    ? '$ageM Monat'
                                                                                                    : '$ageY Jahre + $ageM Monate + $ageD Tage',
                                    // /*--------------------------------- mehrfach verschachtelter ternärer Operator ---*/
                                    // (nextY == 0 && nextM == 0 && nextD == 0)
                                    //     ? '---> ist UNBEKANNT!'
                                    //     // : (nextY == 1 &&
                                    //     //         nextM == 1 &&
                                    //     //         nextD == 1)
                                    //     //     ? '$ageY Jahr + $nextM Monate + $nextD Tage'
                                    //     //     : (nextY == 0 &&
                                    //     //             nextM == 0 &&
                                    //     //             nextD == 1)
                                    //     //         ? '$ageD Tag'
                                    //     //         : (nextY == 1 &&
                                    //     //                 nextM == 0 &&
                                    //     //                 nextD == 1)
                                    //     //             ? '$ageY Jahr + $ageD Tag'
                                    //     //             : (nextY == 1 &&
                                    //     //                     nextM == 1 &&
                                    //     //                     nextD == 0)
                                    //     //                 ? '$ageY Jahr + $ageM Monat'
                                    //                     : '$ageY Jahre + $nextM Monate + $nextD Tage',

                                    // (nextY == 0 && nextM == 0 && nextD == 0)
                                    //     ? '---> ist UNBEKANNT!'
                                    //     : (nextM ==
                                    //             1) // verschachtelter ternärer Operator
                                    //         ? '$nextM Monat'
                                    //         : (nextD == 1)
                                    //             ? '+ $nextD Tag'
                                    //             : (nextM == 0)
                                    //                 ? '+ $nextM Monat'
                                    //                 : '$ageY Jahre + $nextM Monate + $nextD Tage',

                                    /*--------------------------------- *** ---*/
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
                                    getNextBirthdayText(), // 1075 - ContactScreen

                                    // /*--------------------------------- mehrfach verschachtelter ternärer Operator ---*/
                                    // child: Text(
                                    //   (nextY == 0 && nextM == 0 && nextD == 0)
                                    //       ? '---> ist UNBEKANNT!'
                                    //       : (nextD == 1)
                                    //           ? '---> ist schon MORGEN!'
                                    //           : (nextD == 0)
                                    //               ? '---> ist HEUTE!'
                                    //               : (nextM == 0)
                                    //                   ? '---> in $nextD Tagen'
                                    //                   : 'noch $nextM Monate + $nextD Tage',
                                    //   /*--------------------------------- *** ---*/
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
                    // /*--------------------------------- Abstand ---*/
                    // wbSizedBoxWidth8,
                    /*--------------------------------- Alter (berechnet) ---*/
                    /* Alter anhand vom Geburtstag automatisch berechnen und im Feld eintragen - 0491 - ContactScreen */
                    //     Expanded(
                    //       // child: Text('${AgeCalculator.dateDifference(
                    //       //   fromDate: DateTime(1964, 2, 29),
                    //       //   toDate: DateTime.now(),
                    //       // )}'),

                    //       // child: Text('${AgeCalculator.timeToNextBirthday(
                    //       //   DateTime(1964, 2, 29),
                    //       //   fromDate: DateTime.now(),
                    //       // )}'),

                    //       child: WbTextFormField(
                    //         labelText: "Alter",
                    //         labelFontSize20: 20,
                    //         hintText: "Alter",
                    //         hintTextFontSize16: 15,
                    //         inputTextFontSize22: 22,
                    //         initialValue: '60 Jahre',
                    //         // textInputAction:'60',
                    //         prefixIcon: Icons.calendar_today_outlined,
                    //         prefixIconSize28: 24,
                    //         inputFontWeightW900: FontWeight.w900,
                    //         inputFontColor: wbColorLogoBlue,
                    //         fillColor: wbColorLightYellowGreen,
                    //         textInputTypeOnKeyboard: TextInputType.number,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    /*--------------------------------- Daten der Firma ---*/
                    wbSizedBoxHeight8,
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
                      // textInputTypeOnKeyboard: TextInputType.multiline,
                      // suffixIcon: Icons.help_outline_outlined,
                      // suffixIconSize48: 28,
                      //textInputAction: textInputAction,
                      /*--------------------------------- onChanged ---*/
                      controller: controllerCS014,
                      onChanged: (String controllerCS014) {
                        log("0189 - company_screen - Eingabe: $controllerCS014");
                        inputCompanyName = controllerCS014;
                        setState(() => inputCompanyName = controllerCS014);
                      },
                    ),
                    /*--------------------------------- Branchenzuordnung ---*/
                    wbSizedBoxHeight16,
                    WbTextFormField(
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
                    /*--------------------------------- Notizen zu Warengruppen ---*/
                    wbSizedBoxHeight16,
                    WbTextFormField(
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
                    /*--------------------------------- WbDividerWithTextInCenter ---*/
                    wbSizedBoxHeight8,
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Adressdaten der Firma',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Straße + Nummer ---*/
                    WbTextFormField(
                      controller: controllerCS005,
                      labelText: "Straße und Hausnummer",
                      labelFontSize20: 20,
                      hintText: "Bitte Straße + Hausnr. eintragen",
                      hintTextFontSize16: 15,
                      inputTextFontSize22: 22,
                      prefixIcon: Icons.location_on_outlined,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                      textInputTypeOnKeyboard: TextInputType.streetAddress,
                    ),
                    /*--------------------------------- Zusatzinformation ---*/
                    wbSizedBoxHeight16,
                    WbTextFormField(
                      labelText: "Zusatzinfo zur Adresse",
                      labelFontSize20: 20,
                      hintText: "c/o-Adresse? | Hinterhaus? | EG?",
                      hintTextFontSize16: 15,
                      inputTextFontSize22: 15,
                      prefixIcon: Icons.location_on_outlined,
                      prefixIconSize28: 24,
                      inputFontWeightW900: FontWeight.w900,
                      inputFontColor: wbColorLogoBlue,
                      fillColor: wbColorLightYellowGreen,
                    ),
                    /*--------------------------------- PLZ ---*/
                    wbSizedBoxHeight16,
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: WbTextFormFieldTEXTOnly(
                            controller: controllerCS006,
                            labelText: "PLZ",
                            labelFontSize20: 20,
                            hintText: "PLZ",
                            inputTextFontSize22: 22,
                            inputFontWeightW900: FontWeight.w900,
                            inputFontColor: wbColorLogoBlue,
                            fillColor: wbColorLightYellowGreen,
                            textInputTypeOnKeyboard:
                                TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            ),
                          ),
                        ),
                        /*--------------------------------- Abstand ---*/
                        wbSizedBoxWidth8,
                        /*--------------------------------- Firmensitz | Ort ---*/
                        Expanded(
                          child: WbTextFormField(
                            labelText: "Firmensitz | Ort",
                            labelFontSize20: 20,
                            hintText: "Bitte den Ort eintragen",
                            hintTextFontSize16: 15,
                            inputTextFontSize22: 22,
                            prefixIcon: Icons.home_work_outlined,
                            prefixIconSize28: 24,
                            inputFontWeightW900: FontWeight.w900,
                            inputFontColor: wbColorLogoBlue,
                            fillColor: wbColorLightYellowGreen,
                            controller: controllerCS007,
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Divider ---*/
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Notizen zum Ansprechpartner',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Notizen zum Ansprechpartner ---*/
                    WbTextFormField(
                      controller: controllerCS016, // Notizen
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
                      // suffixIcon: Icons.menu_outlined,
                      // suffixIconSize48: 28,
                      textInputTypeOnKeyboard: TextInputType.multiline,
                    ),
                    /*--------------------------------- WbDividerWithTextInCenter ---*/
                    wbSizedBoxHeight8,
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Kommunikation',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    wbSizedBoxHeight8,
                    // const WBTextfieldNotice(
                    //     headlineText: "Notizen zum Ansprechpartner:",
                    //     hintText: "Beispiele: Hobbys, Lieblingswein, usw."),
                    /*--------------------------------- Telefon 1 - TKD_Feld_008 ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 400,
                            child: WbTextFormField(
                              controller: controllerCS008,
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
                              onChanged: (String text) => _phone = text,
                            ),
                          ),
                        ),
                        /*--------------------------------- Telefon Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            /*--------------------------------- Telefon-Anruf starten ---*/
                            onTap: () async {
                              log("0767 - ContactScreen - Anruf starten");
                              /*--------------------------------- Telefon-Anruf - Variante 1 ---*/
                              /*--- Überprüfe den Telefon-Anruf-Support ---*/
                              _hasCallSupport
                                  ? () => setState(() {
                                        _launched = _makePhoneCall(_phone);
                                      })
                                  : null;
                              log('0785 - ContactScreen - Anruf wird supportet, $_hasCallSupport wenn result = "$_launched" | Telefonnummer: $_phone');
                              log('0786 - ContactScreen - Anruf wird supportet');
                              log('0787 - ContactScreen - _launched:       $_launched');
                              //log('0788 - ContactScreen - call:            $call');
                              log('0789 - ContactScreen - _phone:          $_phone');
                              log('0790 - ContactScreen - _hasCallSupport: $_hasCallSupport');

                              final call = Uri.parse(_phone);
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                                log('0793 - ContactScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                              } else {
                                log('0795 - ContactScreen - Anruf wird NICHT supportet');
                                log('0796 - ContactScreen - _launched:       $_launched');
                                log('0797 - ContactScreen - call:            $call');
                                log('0798 - ContactScreen - _phone:          $_phone');
                                log('0799 - ContactScreen - _hasCallSupport: $_hasCallSupport');
                              }

                              FutureBuilder<void>(
                                future: _launched,
                                builder: _launchStatus,
                              );
                              log('0785 - ContactScreen - future: $_launched');
                              log('0787 - ContactScreen - builder: $_launchStatus');

                              /*--------------------------------- Telefon-Anruf - Variante 2 ---*/
                              // Uri.parse(_phone); // funzt
                              // log('0782 - ContactScreen - $_phone');
                              // launchUrl(Uri.parse(_phone)); // funzt
                              // log('0787 - ContactScreen - $_phone');
                              // launchUrl(Uri.parse('${_phone.toString()} ')); // funzt
                              // log('0790 - ContactScreen - $_phone');

                              // final call = Uri.parse(_phone);
                              // if (await canLaunchUrl(call)) {
                              //   launchUrl(call);
                              //   log('0793 - ContactScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                              // } else {
                              //   log('0795 - ContactScreen - Anruf wird NICHT supportet');
                              //   log('0796 - ContactScreen - _launched:       $_launched');
                              //   log('0797 - ContactScreen - call:            $call');
                              //   log('0798 - ContactScreen - _phone:          $_phone');
                              //   log('0799 - ContactScreen - _hasCallSupport: $_hasCallSupport');
                              // }
                              /*--------------------------------- Telefon-Anruf erledigt ---*/

                              /*--------------------------------- Icon onTap ---*/
                              // onTap: () {

                              //                                   /*--------------------------------- Telefon-Anruf starten  ---*/
                              //     child: TextField(
                              //         onChanged: (String text) => _phone = text,
                              //         decoration: const InputDecoration(
                              //             hintText: 'Hier die Telefonnummer eingeben')),
                              //   ),
                              //   ElevatedButton(
                              //     onPressed:
                              // _hasCallSupport
                              //         ? () => setState(() {
                              //               _launched = _makePhoneCall(_phone);
                              //             })
                              //         : null,
                              //     child: _hasCallSupport
                              //         ? const Text('Rufe diese Nummer an')
                              //         : const Text('Anrufe sind zur Zeit nicht möglich'),
                              //   ),

                              // log("0744 - ContactScreen - Einen Anruf starten");
                              // showDialog(
                              //   context: context,
                              //   builder: (context) =>
                              //       const WbDialogAlertUpdateComingSoon(
                              //     headlineText: "Einen Anruf starten",
                              //     contentText:
                              //         "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\nanrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0510",
                              //     actionsText: "OK 👍",
                              //   ),
                              // );
                            },

                            /*--------------------------------- Icon onTap ENDE---*/

                            child: Image(
                              image: AssetImage(
                                  "assets/iconbuttons/icon_button_telefon_blau.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- WhatsApp ---*/
                    wbSizedBoxHeight16,
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllerCS008,
                              labelText: "WhatsApp",
                              labelFontSize20: 20,
                              hintText: "Bitte die WhatsApp-Nr. eintragen",
                              hintTextFontSize16: 13,
                              inputTextFontSize22: 22,
                              prefixIcon: Icons.phone_android_outlined,
                              prefixIconSize28: 24,
                              inputFontWeightW900: FontWeight.w900,
                              inputFontColor: wbColorLogoBlue,
                              fillColor: wbColorLightYellowGreen,
                              textInputTypeOnKeyboard: TextInputType.phone,
                            ),
                          ),
                        ),
                        /*--------------------------------- WhatsApp Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            //   /*--------------------------------- WhatsApp-Nachricht starten ---*/
                            //   // benötigt package = recherchieren"
                            //   onTap: () async {
                            //   log("00513 - company_screen - Anruf starten");
                            //   Uri.parse("+491789697193"); // funzt das?
                            //   launchUrl("tel:+491789697193");
                            //   UrlLauncher.launch('tel:+${p.phone.toString()}');
                            //   final call = Uri.parse('tel:+491789697193');
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //   } else {
                            //     throw 'Could not launch $call';
                            //   }
                            // },
                            // /*--------------------------------- WhatsApp erledigt ---*/

                            /*--------------------------------- Icon onTap ---*/
                            onTap: () {
                              log("0594 - company_screen - Eine WhatsApp senden");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine WhatsApp versenden",
                                  contentText:
                                      "Willst Du jetzt an die Nummer\n${controllerCS008.text}\nvon ${controllerCS002.text} ${controllerCS003.text}\neine WhatsApp senden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0594",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            /*--------------------------------- Icon onTap ENDE---*/
                            child: Image(
                              image: AssetImage(
                                "assets/iconbuttons/icon_button_whatsapp.png",
                              ),
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
                              controller: controllerCS010,
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
                        /*--------------------------------- Telefon Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            //   /*--------------------------------- Telefon-Anruf starten ---*/
                            //   // benötigt package = recherchieren"
                            //   onTap: () async {
                            //   log("00513 - company_screen - Anruf starten");
                            //   Uri.parse("+491789697193"); // funzt das?
                            //   launchUrl("tel:+491789697193");
                            //   UrlLauncher.launch('tel:+${p.phone.toString()}');
                            //   final call = Uri.parse('tel:+491789697193');
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //   } else {
                            //     throw 'Could not launch $call';
                            //   }
                            // },
                            // /*--------------------------------- Telefon-Anruf erledigt ---*/

                            /*--------------------------------- Icon onTap ---*/
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
                            /*--------------------------------- Icon onTap ENDE---*/
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
                              controller: controllerCS009,
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
                        /*--------------------------------- E-Mail 1 Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            //   /*--------------------------------- E-Mail versenden ---*/
                            //   // benötigt package = recherchieren"
                            //   onTap: () async {
                            //   log("00513 - company_screen - Anruf starten");
                            //   Uri.parse("+491789697193"); // funzt das?
                            //   launchUrl("tel:+491789697193");
                            //   UrlLauncher.launch('tel:+${p.phone.toString()}');
                            //   final call = Uri.parse('tel:+491789697193');
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //   } else {
                            //     throw 'Could not launch $call';
                            //   }
                            // },
                            // /*--------------------------------- E-Mail-Versand erledigt ---*/

                            /*--------------------------------- Icon onTap ---*/
                            onTap: () {
                              log("0727 - company_screen - Eine E-Mail versenden");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0727",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            /*--------------------------------- Icon onTap ENDE---*/
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
                    /*--------------------------------- E-Mail 2 ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllerCS011,
                              labelText: "E-Mail 2",
                              labelFontSize20: 20,
                              hintText: "Bitte ggf. die 2. E-Mail eintragen",
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
                        /*--------------------------------- E-Mail 2 Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            //   /*--------------------------------- E-Mail versenden ---*/
                            //   // benötigt package = recherchieren"
                            //   onTap: () async {
                            //   log("00513 - company_screen - Anruf starten");
                            //   Uri.parse("+491789697193"); // funzt das?
                            //   launchUrl("tel:+491789697193");
                            //   UrlLauncher.launch('tel:+${p.phone.toString()}');
                            //   final call = Uri.parse('tel:+491789697193');
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //   } else {
                            //     throw 'Could not launch $call';
                            //   }
                            // },
                            // /*--------------------------------- E-Mail-Versand erledigt ---*/

                            /*--------------------------------- Icon onTap ---*/
                            onTap: () {
                              log("0794 - company_screen - Eine E-Mail versenden");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0794",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            /*--------------------------------- Icon onTap ENDE ---*/
                            child: Image(
                              image: AssetImage(
                                "assets/iconbuttons/icon_button_email.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- *** ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Webseite ---*/
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 185,
                            child: WbTextFormField(
                              controller: controllerCS012,
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
                        /*--------------------------------- Webseite Icon ---*/
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            //   /*--------------------------------- Webseite verlinken ---*/
                            //   // benötigt package = recherchieren"
                            //   onTap: () async {
                            //   log("00513 - company_screen - Anruf starten");
                            //   Uri.parse("+491789697193"); // funzt das?
                            //   launchUrl("tel:+491789697193");
                            //   UrlLauncher.launch('tel:+${p.phone.toString()}');
                            //   final call = Uri.parse('tel:+491789697193');
                            //   if (await canLaunchUrl(call)) {
                            //     launchUrl(call);
                            //   } else {
                            //     throw 'Could not launch $call';
                            //   }
                            // },
                            // /*--------------------------------- Webseite verlinken erledigt ---*/

                            /*--------------------------------- Icon onTap ---*/
                            onTap: () {
                              log("0872 - company_screen - Webseite verlinken");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0872",
                                  actionsText: "OK 👍",
                                ),
                              );
                            },
                            /*--------------------------------- Icon ---*/
                            child: Image(
                              image: AssetImage(
                                //"assets/iconbuttons/icon_button_quadrat_blau_leer.png",
                                "assets/iconbuttons/icon_button_quadrat_blau_leer.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- *** ---*/
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,

                    // /*--- Zeitstempel in ein lesbares Datum umwandeln ---*/
                    // // Zeitstempel als String aus dem Controller
                    // String timestampString = '${controllerCS027.text}';

                    // // Umwandlung des Strings in einen Integer
                    // int timestamp = int.parse(timestampString);

                    // // Umwandlung des Zeitstempels in ein DateTime-Objekt
                    // DateTime dateTime =
                    //     DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

                    // // Umwandlung in die lokale Zeit (MESZ)
                    // DateTime localDateTime = dateTime.toLocal();

                    // // Formatierung des Datums im europäischen Format
                    // String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(localDateTime);
                    // log('0192 - ContactScreen - formattedDate: $formattedDate');

                    /*--------------------------------- Zeitstempel ---*/
                    Text(
                        'Zuletzt aktualisiert am ${controllerCS027.text}'), // Zeitstempel formatieren - 01441 - ContactScreen
                    Text('Kontakt-Quelle: ${controllerCS018.text}'),
                    Text('Betreut durch: ${controllerCS028.text}'),
                    Text('Betreuer-Stufe: ${controllerCS029.text}'),
                    Text('Gebietskennung: ${controllerCS024.text}'),
                    // Text('${controllerCS030.text} '), // KontaktID
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,
                    /*--------------------------------- if-else Button ---*/
                    if (!isDataChanged)
                      WbButtonUniversal2(
                          wbColor: isButton09Clicked
                              ? wbColorButtonDarkRed
                              : wbColorButtonGreen,
                          wbOnTapDown: (details) {
                            setState(() {
                              isButton09Clicked = true;
                            });
                          },
                          wbOnTapUp: (details) {
                            setState(() {
                              isButton09Clicked = false;
                            });
                          },
                          wbOnTapCancel: () {
                            setState(() {
                              isButton09Clicked = false;
                            });
                          },
                          wbIcon: Icons.save_rounded,
                          wbIconSize40: 40,
                          wbText: "Daten SPEICHERN",
                          wbFontSize24: 24,
                          wbWidth155: 398,
                          wbHeight60: 60,
                          wbOnTap: () async {
                            log("1584 - ContactScreen - Daten speichern - geklickt");
                            /*--------------------------------- Sound ---*/
                            player.play(AssetSource("sound/sound06pling.wav"));
                            /*--------------------------------- Snackbar ---*/
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: wbColorButtonGreen,
                              content: Text(
                                "Die Daten von\n${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} • wurden erfolgreich gespeichert! 😃👍",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ));
                            /*--------------------------------- Speicherung in die SQL ---*/
                            await saveData(context); // Datensatz speichern
                            log('1600 - ContactScreen - Daten gespeichert (save)!');
                            // await updateData({}); // Datensatz aktualisieren
                            // log('1646 - ContactScreen - Daten aktualisiert (update)!');
                            /*--------------------------------- Navigator.push ---*/
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainSelectionScreen(),
                              ),
                            );
                          })
                    else
                      WbButtonUniversal2(
                          wbColor: wbColorOrangeDarker,
                          wbOnTapDown: (details) {
                            setState(() {
                              isButton09Clicked = true;
                            });
                          },
                          wbOnTapUp: (details) {
                            setState(() {
                              isButton09Clicked = false;
                            });
                          },
                          wbOnTapCancel: () {
                            setState(() {
                              isButton09Clicked = false;
                            });
                          },
                          wbIcon: Icons.update,
                          wbIconSize40: 40,
                          wbText: "Daten UPDATE",
                          wbFontSize24: 24,
                          wbWidth155: 398,
                          wbHeight60: 60,
                          wbOnTap: () async {
                            log("1584 - ContactScreen - Daten UPDATE - geklickt");
                            /*--------------------------------- Sound ---*/
                            player.play(AssetSource("sound/sound06pling.wav"));
                            /*--------------------------------- Snackbar ---*/
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: wbColorOrangeDarker,
                              content: Text(
                                "Die Daten von\n${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} • wurden erfolgreich aktualisiert! 😃👍",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ));
                            /*--------------------------------- Speicherung in die SQL ---*/
                            await updateData({}); // Datensatz aktualisieren
                            log('1600 - ContactScreen - Daten aktualisiert (update)!');
                            /*--------------------------------- Navigator.push ---*/
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainSelectionScreen(),
                              ),
                            );
                          }),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Button Daten LÖSCHEN ---*/
                    WbButtonUniversal2(
                      wbColor: isButton10Clicked
                          ? Colors.yellow
                          : wbColorButtonDarkRed,
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
                      wbIcon: Icons.delete_forever,
                      wbIconSize40: 40,
                      wbText: "Daten LÖSCHEN",
                      wbFontSize24: 24,
                      wbWidth155: 398,
                      wbHeight60: 60,
                      wbOnTap: () {
                        log("1981 - ContactScreen - Daten LÖSCHEN - geklickt");
                        /*--------------------------------- Sound abspielen ---*/
                        player.play(AssetSource("sound/sound03enterprise.wav"));
                        /*--------------------------------- AlertDialog - START ---*/
                        /* Abfrage ob die App geschlossen werden soll */
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => WBDialog2Buttons(
                            headLineText:
                                'ACHTUNG:\nDie Daten werden gelöscht!',
                            descriptionText:
                                'Möchtest Du jetzt die Daten von ${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} • ${controllerCS005.text} ${controllerCS006.text} ${controllerCS007.text} ${controllerCS030.text} wirklich ENDGÜLTIG löschen?\n\nDiese Aktion kann NICHT rückgängig gemacht werden!',

                            /*--------------------------------- Button 1 ---*/
                            // wbText1: "Nein",
                            wbOnTap1: () {
                              log('2095 - ContactScreen - "Nein" wurde angeklickt');
                              /*--------------------------------- Sound abspielen ---*/
                              player
                                  .play(AssetSource("sound/sound06pling.wav"));
                              /*--------------------------------- Dialog ausblenden ---*/
                              Navigator.of(context).pop();

                              // /*--- Noch 2 Sekunden warten, bevor die Snackbar eingeblendet wird ---*/
                              // Future.delayed(
                              //   const Duration(seconds: 1),
                              //   () {},
                              // );

                              /*--------------------------------- Snackbar einblenden funzt hier nicht! 2101 - ContactScreen ---*/
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: wbColorOrangeDarker,
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                    'Die Daten von ${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} • wurden NICHT gelöscht!',
                                  ),
                                ),
                              );
                            },

                            /*--------------------------------- Button 2 ---*/
                            wbText2: "Ja • Löschen",
                            wbOnTap2: () async {
                              log('2117 - ContactScreen - "Ja • Löschen" wurde angeklickt');
                              /*--------------------------------- Sound abspielen ---*/
                              player
                                  .play(AssetSource("sound/sound06pling.wav"));
                              /*--------------------------------- Dialog ausblenden ---*/
                              //Navigator.of(context).pop();
                              /*--------------------------------- Snackbar einblenden ---*/
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: wbColorButtonDarkRed,
                                content: Text(
                                  'Die Daten von ${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} • ${controllerCS005.text} ${controllerCS006.text} ${controllerCS007.text} ${controllerCS030.text} wurden erfolgreich GELÖSCHT!',
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
                                  builder: (context) =>
                                      const MainSelectionScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- AlertDialog - ENDE---*/

                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    /*--------------------------------- KontaktID ---*/
                    Center(
                      child: Text(controllerCS030.text),
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Abstand nach unten wegen anderer Devices ---*/
                    wbSizedBoxHeight32,
                    wbSizedBoxHeight16,
                    /* das sorgt für die automatische Anpassung der Höhe, wenn mehr Text hineingeschrieben wird */
                    SizedBox(
                        height:
                            double.tryParse('.')) // hat hier keine Auswirkung!
                    /*--------------------------------- ENDE ---*/
                  ],
                ),
              ),
              /*--------------------------------- Abstand ---*/
              wbSizedBoxHeight16,
              /*--------------------------------- *** ---*/
            ],
          ),
        ),
      ),
      /*--------------------------------- WbInfoContainer ---*/
      bottomSheet: WbInfoContainer(
        infoText:
            '${controllerCS014.text} • ${controllerCS002.text} ${controllerCS003.text} •\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- ENDE ---*/
    );
  }

  @override
  void dispose() {
    /* Nicht vergessen: Alle Controller freigeben = Speicher freigeben! */
    controllerCS001.dispose();
    controllerCS002.dispose();
    controllerCS003.dispose();
    controllerCS004.dispose();
    controllerCS005.dispose();
    controllerCS006.dispose();
    controllerCS007.dispose();
    controllerCS008.dispose();
    controllerCS009.dispose();
    controllerCS010.dispose();
    controllerCS011.dispose();
    controllerCS012.dispose();
    controllerCS013.dispose();
    controllerCS014.dispose();
    controllerCS015.dispose();
    controllerCS016.dispose();
    controllerCS017.dispose();
    controllerCS018.dispose();
    controllerCS019.dispose();
    controllerCS020.dispose();
    controllerCS021.dispose();
    controllerCS022.dispose();
    controllerCS023.dispose();
    controllerCS024.dispose();
    controllerCS025.dispose();
    controllerCS026.dispose();
    controllerCS027.dispose();
    controllerCS028.dispose();
    controllerCS029.dispose();
    controllerCS030.dispose();
    super.dispose();
  }
}

/*--------------------------------- SQL-Datenbank ---*/
class DatabaseHelper {
  static Database? _database;

  // Singleton-Muster
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabaseFromAssets();
    return _database!;
  }

  Future<Database> _openDatabaseFromAssets() async {
    log('0046 - ContactScreen - Öffnet die Datenbank');
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
    bool dbExists = await databaseExists(dbPath);

    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS KundenDaten (
          TKD_Feld_001 TEXT,
          TKD_Feld_002 TEXT,
          TKD_Feld_003 TEXT,
          TKD_Feld_004 TEXT,
          TKD_Feld_005 TEXT,
          TKD_Feld_006 TEXT,
          TKD_Feld_007 TEXT,
          TKD_Feld_008 TEXT,
          TKD_Feld_009 TEXT,
          TKD_Feld_010 TEXT,
          TKD_Feld_011 TEXT,
          TKD_Feld_012 TEXT,
          TKD_Feld_013 TEXT,
          TKD_Feld_014 TEXT,
          TKD_Feld_015 TEXT,
          TKD_Feld_016 TEXT,
          TKD_Feld_017 TEXT,
          TKD_Feld_018 TEXT,
          TKD_Feld_019 TEXT,
          TKD_Feld_020 TEXT,
          TKD_Feld_021 TEXT,
          TKD_Feld_022 TEXT,
          TKD_Feld_023 TEXT,
          TKD_Feld_024 TEXT,
          TKD_Feld_025 TEXT,
          TKD_Feld_026 TEXT,
          TKD_Feld_027 TEXT,
          TKD_Feld_028 TEXT,
          TKD_Feld_029 TEXT,
          TKD_Feld_030 TEXT PRIMARY KEY
        )
      ''');
    });
  }
}
