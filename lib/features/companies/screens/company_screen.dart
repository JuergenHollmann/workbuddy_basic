import 'dart:developer';
import 'dart:io';

import 'package:age_calculator/age_calculator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
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
    log('0046 - CompanyScreen - Öffnet die Datenbank');
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
    bool dbExists = await databaseExists(dbPath);
    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath);
  }
}

Future<void> fetchData() async {
  var db = await DatabaseHelper().database;
  // var query = await db.rawQuery("SELECT * FROM KundenDaten WHERE TKD_Feld_007 = 'Schwäbisch Gmünd'");
    var query = await db.rawQuery(
      "SELECT * FROM KundenDaten WHERE TKD_Feld_030 = 'KundenID: 1683296820166'");
  log('0062 - CompanyScreen - Abfrage Ergebnis: $query');

  /* Die Daten in die dazugehörgen Felder einfügen. */
  
}

class _CompanyScreenState extends State<CompanyScreen> {
  late AudioPlayer player = AudioPlayer();

  /* für die Berechnung des Alters und der Zeitspanne bis zum nächsten Geburtstag */
  int ageY = 0, ageM = 0, ageD = 0, nextY = 0, nextM = 0, nextD = 0;
  DateTime initTime = DateTime.now();
  DateTime selectedTime = DateTime.now();

/*--------------------------------- Controller ---*/
final TextEditingController inputCompanyNameTEC = TextEditingController();
final TextEditingController inputCompanyVNContactPersonTEC =
    TextEditingController();
final TextEditingController inputCompanyNNContactPersonTEC =
    TextEditingController();
final TextEditingController compPersonAge = TextEditingController();

/*--------------------------------- onChanged-Funktion ---*/
String inputCompanyName = "Firmenlogo"; // nur für die "onChanged-Funktion"
String inputCompanyVNContactPerson =
    "Ansprechpartner"; // nur für die "onChanged-Funktion"
String inputCompanyNNContactPerson = ""; // nur für die "onChanged-Funktion"


  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  bool _hasCallSupport = false;
  late String _phone = '';
  Future<void>? _launched;

  /*--------------------------------- *** ---*/
  @override
  void initState() {
    super.initState();

    /*--- Überprüfe den Telefon-Anruf-Support ---*/
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });

    fetchData();
  }

  /*--------------------------------- Telefon-Anruf-Funktionen ---*/
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      log('0072 - CompanyScreen - _launchStatus:     $_launchStatus');
      log('0073 - CompanyScreen - context:           $context');
      log('0074 - CompanyScreen - snapshot:          $snapshot');
      log('0075 - CompanyScreen - snapshot.hasError: ${snapshot.hasError}');
      log('0076 - CompanyScreen - snapshot.error:    ${snapshot.error}');
      return Text('Error: ${snapshot.error}');
    } else {
      log('0080 - CompanyScreen - _launchStatus:     $_launchStatus');
      log('0081 - CompanyScreen - context:           $context');
      log('0082 - CompanyScreen - snapshot:          $snapshot');
      log('0083 - CompanyScreen - snapshot.hasError: ${snapshot.hasError}');
      log('0084 - CompanyScreen - snapshot.error:    ${snapshot.error}');
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

/*--------------------------------- *** ---*/
  @override
  Widget build(BuildContext context) {
    log("0038 - CompanyScreen - aktiviert");

    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
        /*--- "toolbarHeight" wird hier nicht mehr benötigt, weil jetzt "WbInfoContainer" die Daten anzeigt ---*/
        // toolbarHeight: 100,
        title: Text(
          'Eine Firma NEU anlegen',
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
                            inputCompanyName,
                          ),
                        ),
                      ],
                    ),
                    /*--- Das ist der Zwischenabstand bei Expanded --- */
                    const SizedBox(width: 14),
                    /*--------------------------------- Ansprechpartner --- */
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
                            ("$inputCompanyVNContactPerson $inputCompanyNNContactPerson"),
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
                      label: "Kontakt-Staus",
                      dropdownItems: [
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
                      controller: inputCompanyNameTEC,
                      onChanged: (String inputCompanyNameTEC) {
                        log("0189 - company_screen - Eingabe: $inputCompanyNameTEC");
                        inputCompanyName = inputCompanyNameTEC;
                        setState(() => inputCompanyName = inputCompanyNameTEC);
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
                    wbSizedBoxHeight16,
                    /*--------------------------------- Straße + Nummer ---*/
                    WbTextFormField(
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
                    const Row(
                      children: [
                        SizedBox(
                          width: 114,
                          child: WbTextFormFieldTEXTOnly(
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
                          child: WbTextFormFieldTEXTOnly(
                            labelText: "Firmensitz | Ort",
                            labelFontSize20: 20,
                            hintText: "Firmensitz",
                            inputTextFontSize22: 22,
                            inputFontWeightW900: FontWeight.w900,
                            inputFontColor: wbColorLogoBlue,
                            fillColor: wbColorLightYellowGreen,
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- Divider ---*/
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Ansprechpartner',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Anrede ---*/
                    WbDropDownMenu(
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
                      controller: inputCompanyVNContactPersonTEC,
                      onChanged: (String inputCompanyVNContactPersonTEC) {
                        log("0478 - company_screen - Eingabe: $inputCompanyVNContactPersonTEC");

                        inputCompanyVNContactPerson =
                            inputCompanyVNContactPersonTEC;

                        setState(() => inputCompanyVNContactPerson =
                            inputCompanyVNContactPersonTEC);
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
                      controller: inputCompanyNNContactPersonTEC,
                      onChanged: (String inputCompanyNNContactPersonTEC) {
                        log("0504 - CompanyScreen - Eingabe: $inputCompanyNNContactPersonTEC");

                        inputCompanyNNContactPerson =
                            inputCompanyNNContactPersonTEC;

                        setState(() => inputCompanyNNContactPerson =
                            inputCompanyNNContactPersonTEC);
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--- TimePickerSpinnerPopUp wegen Geburtstag ---*/
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
                          /*--------------------------------- TimePickerSpinnerPopUp ---*/
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                Text(
                                  'Geburtstag',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                /*--------------------------------- Abstand ---*/
                                wbSizedBoxWidth16,
                                /*--------------------------------- *** ---*/
                                TimePickerSpinnerPopUp(
                                    locale: Locale('de', 'DE'),
                                    iconSize: 20,
                                    textStyle: TextStyle(
                                        backgroundColor:
                                            wbColorLightYellowGreen,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    isCancelTextLeft: true,
                                    paddingHorizontalOverlay: 80,
                                    mode: CupertinoDatePickerMode.date,
                                    radius: 16,
                                    initTime: selectedTime,
                                    minTime: DateTime.now()
                                        .subtract(const Duration(days: 36500)),
                                    /*--------------------------------- *** ---*/
                                    /* das Geburtsdatum kann nicht in der Zukunft liegen */
                                    maxTime: DateTime.now()
                                        .add(const Duration(days: 0)),
                                    /*--------------------------------- *** ---*/
                                    use24hFormat: true,
                                    barrierColor: Colors.black12,
                                    minuteInterval: 1,
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 8, 8, 8),
                                    cancelText: 'Abbruch',
                                    confirmText: 'OK',
                                    pressType: PressType.singlePress,
                                    timeFormat: 'dd.MM.yyyy',
                                    onChange: (dateTime) {
                                      log('0539 - CompanyScreen - Geburtsdatum eingegeben: $dateTime');
                                      /*--- automatisch das Alter berechnen mit "age_calculator" ---*/
                                      AgeCalculator();
                                      DateTime birthday = dateTime;
                                      var age = AgeCalculator.age(birthday);
                                      log('0561 - CompanyScreen - Berechnetes Alter = ${age.years} Jahre + ${age.months} Monate + ${age.days} Tage');
                                      /*--- automatisch die Zeit bis zum nächsten Geburtstag berechnen mit "age_calculator" ---*/
                                      DateTime nextBirthday = dateTime;
                                      var timeToNextBirthday =
                                          AgeCalculator.timeToNextBirthday(
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
                                        /*--- Das angeklickte Geburtsdatum im "TimePickerSpinnerPopUp" soll behalten werden ---*/
                                        selectedTime = birthday;
                                        log('0573 - CompanyScreen - selectedTime: $selectedTime = birthday: $birthday');
                                      });
                                    }),
                              ],
                            ),
                          ),
                          /*--------------------------------- Alter anzeigen ---*/
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Alter:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '$ageY Jahre + $ageM Monate + $ageD Tage',
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
                                  'Nächster ...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '$nextY Jahre + $nextM Monate + $nextD Tage',
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
                    /* Alter anhand vom Geburtstag automatisch berechnen und im Feld eintragen - 0491 - CompanyScreen */
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
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Notizen zum Ansprechpartner ---*/
                    WbTextFormField(
                      labelText: "Notizen zum Ansprechpartner",
                      labelFontSize20: 20,
                      hintText:
                          "Beispiele: Hobbys, Lieblingswein, Verein, etc.",
                      hintTextFontSize16: 12,
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
                    wbSizedBoxHeight16,
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
                              log("0767 - CompanyScreen - Anruf starten");
                              /*--------------------------------- Telefon-Anruf - Variante 1 ---*/
                              /*--- Überprüfe den Telefon-Anruf-Support ---*/
                              _hasCallSupport
                                  ? () => setState(() {
                                        _launched = _makePhoneCall(_phone);
                                      })
                                  : null;
                              log('0785 - CompanyScreen - Anruf wird supportet, $_hasCallSupport wenn result = "$_launched" | Telefonnummer: $_phone');
                              log('0786 - CompanyScreen - Anruf wird supportet');
                              log('0787 - CompanyScreen - _launched:       $_launched');
                              //log('0788 - CompanyScreen - call:            $call');
                              log('0789 - CompanyScreen - _phone:          $_phone');
                              log('0790 - CompanyScreen - _hasCallSupport: $_hasCallSupport');

                              final call = Uri.parse(_phone);
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                                log('0793 - CompanyScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                              } else {
                                log('0795 - CompanyScreen - Anruf wird NICHT supportet');
                                log('0796 - CompanyScreen - _launched:       $_launched');
                                log('0797 - CompanyScreen - call:            $call');
                                log('0798 - CompanyScreen - _phone:          $_phone');
                                log('0799 - CompanyScreen - _hasCallSupport: $_hasCallSupport');
                              }

                              FutureBuilder<void>(
                                future: _launched,
                                builder: _launchStatus,
                              );
                              log('0785 - CompanyScreen - future: $_launched');
                              log('0787 - CompanyScreen - builder: $_launchStatus');

                              /*--------------------------------- Telefon-Anruf - Variante 2 ---*/
                              // Uri.parse(_phone); // funzt
                              // log('0782 - CompanyScreen - $_phone');
                              // launchUrl(Uri.parse(_phone)); // funzt
                              // log('0787 - CompanyScreen - $_phone');
                              // launchUrl(Uri.parse('${_phone.toString()} ')); // funzt
                              // log('0790 - CompanyScreen - $_phone');

                              // final call = Uri.parse(_phone);
                              // if (await canLaunchUrl(call)) {
                              //   launchUrl(call);
                              //   log('0793 - CompanyScreen - Anruf wird supportet - Telefonnummer anrufen: $_phone / Freigabe: $call');
                              // } else {
                              //   log('0795 - CompanyScreen - Anruf wird NICHT supportet');
                              //   log('0796 - CompanyScreen - _launched:       $_launched');
                              //   log('0797 - CompanyScreen - call:            $call');
                              //   log('0798 - CompanyScreen - _phone:          $_phone');
                              //   log('0799 - CompanyScreen - _hasCallSupport: $_hasCallSupport');
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

                              // log("0744 - CompanyScreen - Einen Anruf starten");
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
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Eine WhatsApp versenden",
                                  contentText:
                                      "Willst Du jetzt an die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\neine WhatsApp senden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0594",
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
                    /*--------------------------------- Button Firma speichern ---*/
                    WbButtonUniversal2(
                        wbColor: wbColorButtonGreen,
                        wbIcon: Icons.save_rounded,
                        wbIconSize40: 40,
                        wbText: "Firma SPEICHERN",
                        wbFontSize24: 24,
                        wbWidth155: 398,
                        wbHeight60: 60,
                        wbOnTap: () {
                          log("0965 - CompanyScreen - Firma speichern - geklick");
                          /*--------------------------------- Snackbar ---*/

                          player.play(AssetSource("sound/sound06pling.wav"));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: wbColorButtonGreen,
                            content: Text(
                              "Die Speicherung wird jetzt durchgeführt ... Bitte warten ...",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ));

                          /*--------------------------------- Navigator.push ---*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainSelectionScreen(),
                            ),
                          );
                        }),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    const Divider(thickness: 3, color: wbColorLogoBlue),
                    wbSizedBoxHeight32,
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
            '$inputCompanyName • $inputCompanyVNContactPerson $inputCompanyNNContactPerson\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\nLetzte Änderung: Am 18.12.2024 um 22:51 Uhr', // todo 1030
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- ENDE ---*/
    );
  }
}

              //   /*--------------------------------- Telefon ---*/
              //   child: TextField(
              //       onChanged: (String text) => _phone = text,
              //       decoration: const InputDecoration(
              //           hintText: 'Hier die Telefonnummer eingeben')),
              // ),
              // ElevatedButton(
              //   onPressed: _hasCallSupport
              //       ? () => setState(() {
              //             _launched = _makePhoneCall(_phone);
              //           })
              //       : null,
              //   child: _hasCallSupport
              //       ? const Text('Rufe diese Nummer an')
              //       : const Text('Anrufe sind zur Zeit nicht möglich'),
              // ),
              // /*--------------------------------- *** ---*/
              // FutureBuilder<void>(future: _launched, builder: _launchStatus),
              // /*--------------------------------- *** ---*/

