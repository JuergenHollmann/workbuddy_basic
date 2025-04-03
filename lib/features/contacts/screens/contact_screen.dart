import 'dart:developer';

import 'package:age_calculator/age_calculator.dart' show AgeCalculator;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  await db.insert('Tabelle01', {
    for (var i = 1; i <= 30; i++)
      'Tabelle01_${i.toString().padLeft(3, '0')}':
          controllers['controllerCS${i.toString().padLeft(3, '0')}']!.text,
  });
  log('0164 - ContactScreen - Daten gespeichert von ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
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

void saveChanges() async {
  final updatedRow = {
    for (var i = 1; i <= 50; i++)
      'Tabelle01_${i.toString().padLeft(3, '0')}':
          controllers['controllerCS${i.toString().padLeft(3, '0')}']!.text,
  };
  updatedRow['Tabelle01_001'] = controllers['controllerCS001']!.text;

  await updateData(updatedRow);
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
  bool _hasDataChanged() {
    for (var i = 1; i <= 50; i++) {
      final key = 'controllerCS${i.toString().padLeft(3, '0')}';
      final fieldKey = 'Tabelle01_${i.toString().padLeft(3, '0')}';
      if (controllers[key]!.text != (widget.contact[fieldKey] ?? '')) {
        return true;
      }
    }
    return false;
  }

  void _checkAndScrollToEmptyField() {
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
      String birthday = controllers['controllerCS005']!.text;

      log('0223 - ContactScreen - Geburtstag: $birthday / ${controllers['controllerCS005']!.text}');

      /*--- Den String in Tag, Monat und Jahr aufteilen ---*/
      List<String> dateParts = controllers['controllerCS005']!.text.split('.');
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
    }
  }

  /*--------------------------------- getNextBirthdayText ---*/
  String getNextBirthdayText() {
    log('0500 - ContactScreen - Geburtstag - Abfrage Ergebnis: ${controllers['controllerCS005']!.text}'); // Geburtstag als Datum (oder leer)

    /*--- Wenn das Geburtsdatum leer ist, dann ist das Alter und die Zeit bis zum nächsten Geburtstag unbekannt ---*/
    if (controllers['controllerCS005']!.text.isEmpty) {
      log('0504 - ContactScreen ---> Geburtstag - controllers["controllerCS005"]!.text.isEmpty: ${controllers["controllerCS005"]!.text.isEmpty} <---');
      return '---> ist UNBEKANNT!';
    }
    if (nextD == 0 && nextM == 0) {
      log('0508 - ContactScreen - .... ist wieder in 1 Jahr 😃');
      return '... ist wieder in 1 Jahr 😃';
    }
    if (nextD == 1 && nextM == 0) {
      log('0512 - ContactScreen - ... ist schon MORGEN 🚀');
      return '... ist schon MORGEN 🚀';
    }
    if (nextD == 2 && nextM == 0) {
      log('0516 - ContactScreen - ... ist schon ÜBERMORGEN!');
      return '... ist schon ÜBERMORGEN!';
    }
    if (nextD >= 3 && nextM == 0) {
      log('0520 - ContactScreen - .. ist schon in $nextD Tagen!');
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
  }

  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  bool _hasCallSupport = false;
  late String _phone = '';
  Future<void>? _launched;

  bool isDataChanged = false;

  void _addListeners() { // evtl. hinter "WidgetsBinding.instance.addPostFrameCallback" verschieben?
    controllers.forEach((key, controller) {
      controller.addListener(() {
        _onDataChanged(key, controller.text);
      });
    });
  }

  void _onDataChanged(String key, String value) {
    log('0332 - ContactScreen - $key geändert: $value');
    setState(() {
      isDataChanged = _hasDataChanged();
    });
  }

  @override
  void initState() {
    super.initState();
    log("0344 - ContactScreen - initState - aktiviert");

    // /*--- Controller hier initialisieren ---*/
    // controllers['controllerCS001']!.text =
    //     widget.contact['Tabelle01_001'] ?? '';

    /*--- Den Zustand (State) erst nach dem Build ändern.
          Diese Methode wird verwendet, um eine Aktion auszuführen, nachdem das Widget vollständig aufgebaut wurde. 
          Die Daten werden direkt nach dem Rendern gespeichert. ---*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('0350 - ContactScreen - WidgetsBinding.instance.addPostFrameCallback - aktiviert');

      /*--- Controller hier initialisieren ---*/
      controllers['controllerCS001']!.text =
          widget.contact['Tabelle01_001'] ?? '';
      /*--------------------------------- *** ---*/

      setState(() {
        try {
          /*--------------------------------- Daten aus der SQFlite ---*/
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
      saveChanges();

      /*--- Hier nochmal das Alter aus dem Geburtstag berechnen ---*/
      calculateAgeFromBirthday();

      /*--- Überprüfe, ob sich die Daten geändert haben ---*/
      setState(() {
        isDataChanged = _hasDataChanged();
      });
    });

    /*--- Überprüfe den Telefon-Anruf-Support ---*/
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });

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
  Widget build(BuildContext context) {
    log("0824 - ContactScreen - aktiviert");

    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
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
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (isDataChanged) {
                  log('0435 - ContactScreen - Daten wurden geändert!');
                  /*--------------------------------- Sound ---*/
                  player.play(AssetSource("sound/sound05xylophon.wav"));
                  /*--------------------------------- AlertDialog ---*/
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            'Deine Datenänderungen bei ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} wurden NICHT aktualisiert!',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: wbColorLogoBlue)),
                        content: Text(
                          "Es gibt ungespeicherte Änderungen!\n\nMöchtest du die Daten aktualisieren, bevor du zurückgehst?",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainSelectionScreen(),
                                ),
                              );
                            },
                            child: Text('Die Daten NICHT aktualisieren',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: wbColorLogoBlue)),
                          ),
                          TextButton(
                            onPressed: () async {
                              /*--------------------------------- Sound ---*/
                              player
                                  .play(AssetSource("sound/sound06pling.wav"));
                              /*--------------------------------- Snackbar ---*/
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: wbColorOrangeDarker,
                                content: Text(
                                  "Die Daten von\n${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • wurden erfolgreich aktualisiert! 😃👍",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ));
                              /*--------------------------------- Snackbar ENDE ---*/
                              /*--------------------------------- Daten updaten ---*/
                              Navigator.of(context).pop();
                              await updateData({});
                              log('0493 - ContactScreen - Daten "updateData": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                              saveChanges();
                              log('0495 - ContactScreen - Daten "saveChanges": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainSelectionScreen(),
                                ),
                              );
                              /*--------------------------------- Daten updaten - ENDE ---*/
                            },
                            child: Text(
                                'Die geänderten Daten jetzt AKTUALISIEREN! 😃👍',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: wbColorLogoBlue)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainSelectionScreen(),
                    ),
                  );
                }
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
              const Divider(thickness: 3, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    wbSizedBoxHeight16,
                    /*--------------------------------- Kontakt-Status auswählen ---*/
                    WbDropDownMenu(
                      controller: controllers['controllerCS019']!,
                      label: "Kontakt-Staus",
                      dropdownItems: [
                        controllers['controllerCS019']!.text,
                        "Kontakt",
                        "Interessent",
                        "Kunde",
                        "Lieferant",
                        "Lieferant und Kunde",
                        "möglicher Lieferant",
                      ],
                      leadingIconInTextField: Icons.create_new_folder_outlined,
                    ),
                    wbSizedBoxHeight8,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight16,

                    /*--------------------------------- Anrede ---*/
                    WbDropDownMenu(
                      controller: controllers['controllerCS002']!,
                      label: "Anrede",
                      dropdownItems: [
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
                      controller: controllers['controllerCS003']!,
                    ),
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
                      controller: controllers['controllerCS004']!,
                    ),
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
                      controller: controllers['controllerCS006']!,
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
                    wbSizedBoxHeight16,
                    /*--------------------------------- Zusatzinformation ---*/
                    WbTextFormField(
                      controller: controllers['controllerCS007']!,
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
                    wbSizedBoxHeight16,
                    /*--------------------------------- PLZ ---*/
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: WbTextFormFieldTEXTOnly(
                            controller: controllers['controllerCS008']!,
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
                        wbSizedBoxWidth8,
                        /*--------------------------------- Firmensitz | Ort ---*/
                        Expanded(
                          child: WbTextFormField(
                            controller: controllers['controllerCS009']!,
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
                          ),
                        ),
                      ],
                    ),
                    wbSizedBoxHeight8,
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
                              onChanged: (String text) => _phone = text,
                            ),
                          ),
                        ),
                        wbSizedBoxWidth8,
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () async {
                              log("0767 - ContactScreen - Anruf starten");
                              _hasCallSupport
                                  ? () => setState(() {
                                        _launched = _makePhoneCall(_phone);
                                      })
                                  : null;
                              log('0785 - ContactScreen - Anruf wird supportet, $_hasCallSupport wenn result = "$_launched" | Telefonnummer: $_phone');
                              final call = Uri.parse(_phone);
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                                log('0793 - ContactScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                              } else {
                                log('0795 - ContactScreen - Anruf wird NICHT supportet');
                              }

                              FutureBuilder<void>(
                                future: _launched,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return const Text('');
                                  }
                                },
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
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0727",
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
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine E-Mail versenden",
                                  contentText:
                                      "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0872",
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
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Zeitstempel ---*/
                    Text(
                        'Zuletzt aktualisiert am ${controllers['controllerCS050']!.text}'),
                    Text(
                        'Kontakt-Quelle: ${controllers['controllerCS046']!.text}'),
                    Text(
                        'Betreut durch: ${controllers['controllerCS048']!.text}'),
                    Text(
                        'Betreuer-Stufe: ${controllers['controllerCS049']!.text}'),
                    Text(
                        'Gebietskennung: ${controllers['controllerCS047']!.text}'),
                    wbSizedBoxHeight8,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,
                    /*--------------------------------- if-else Button ---*/
                    if (!isDataChanged || widget.isNewContact)
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
                            log("2240 - ContactScreen - Daten speichern - geklickt");
                            if (controllers['controllerCS003']!.text.isEmpty &&
                                controllers['controllerCS004']!.text.isEmpty &&
                                controllers['controllerCS015']!.text.isEmpty) {
                              /*--------------------------------- Sound ---*/
                              player.play(
                                  AssetSource("sound/sound05xylophon.wav"));

                              /*--------------------------------- AlertDialog ---*/
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    WbDialogAlertUpdateComingSoon(
                                  headlineText: 'Zum Speichern fehlen Daten!',
                                  contentText:
                                      'BEIDE Felder für "Vorname" und "Nachname" sind leer.\n\nMindestens 1 Feld muss entweder "Vorname" oder "Nachname" enthalten, oder das Feld "Firma" muss ausgefüllt sein.\n\nBitte fülle MINDESTENS eines der drei Felder aus.',
                                  actionsText: 'OK 👍',
                                ),
                              );

                              _checkAndScrollToEmptyField();

                              return;
                            }

                            /*--------------------------------- Sound ---*/
                            player.play(AssetSource("sound/sound06pling.wav"));

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
                            await saveData(context); // Datensatz speichern
                            log('2280 - ContactScreen - Daten gespeichert (save)!');
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
                            log("2318 - ContactScreen - Daten UPDATE - geklickt");
                            /*--------------------------------- Sound ---*/
                            player.play(AssetSource("sound/sound06pling.wav"));
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
                            /*--------------------------------- Speicherung in die SQL ---*/
                            /*--------------------------------- Daten updaten ---*/
                            Navigator.of(context).pop();
                            await updateData({});
                            log('1353 - ContactScreen - Daten "updateData": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                            saveChanges();
                            log('1355 - ContactScreen - Daten "saveChanges": ${controllers['controllerCS001']!.text} ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} / KontaktID: ${controllers['controllerCS001']!.text}');
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainSelectionScreen(),
                              ),
                            );
                            /*--------------------------------- Daten updaten - ENDE ---*/
                          }),
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight8,
                    /*--------------------------------- Button Daten LÖSCHEN - CS-1323 ---*/
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => WBDialog2Buttons(
                            headLineText:
                                'ACHTUNG:\nDie Daten werden gelöscht!',
                            descriptionText:
                                'Möchtest Du jetzt die Daten von ${controllers['controllerCS015']!.text} • ${controllers['controllerCS003']!.text} ${controllers['controllerCS004']!.text} • ${controllers['controllerCS006']!.text} ${controllers['controllerCS008']!.text} ${controllers['controllerCS009']!.text} mit der KontaktID ${controllers['controllerCS001']!.text} wirklich ENDGÜLTIG löschen?\n\nDiese Aktion kann NICHT rückgängig gemacht werden!',
                            wbOnTap1: () {
                              log('2095 - ContactScreen - "Nein" wurde angeklickt');
                              /*--------------------------------- Sound abspielen ---*/
                              player
                                  .play(AssetSource("sound/sound06pling.wav"));
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
                              /*--------------------------------- Sound abspielen ---*/
                              player
                                  .play(AssetSource("sound/sound06pling.wav"));
                              /*--------------------------------- Dialog ausblenden ---*/
                              /*--------------------------------- Snackbar einblenden ---*/
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                                  builder: (context) =>
                                      const MainSelectionScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),

                    /*--------------------------------- KontaktID anzeigen - CS-1420 ---*/
                    Center(
                      child: Text(controllers['controllerCS001']!.text),
                    ),
                    /*--------------------------------- *** ---*/

                    wbSizedBoxHeight8,
                    wbSizedBoxHeight32,
                    wbSizedBoxHeight16,
                    SizedBox(height: double.tryParse('.')),
                  ],
                ),
              ),
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

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
