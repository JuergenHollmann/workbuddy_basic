// import 'dart:developer';

// import 'package:age_calculator/age_calculator.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
// import 'package:workbuddy/config/wb_button_universal_2.dart';
// import 'package:workbuddy/config/wb_colors.dart';
// import 'package:workbuddy/config/wb_sizes.dart';
// import 'package:workbuddy/config/wb_text_form_field.dart';
// import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
// import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
// import 'package:workbuddy/shared/providers/current_user_provider.dart';
// import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
// import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
// import 'package:workbuddy/shared/widgets/wb_drop_downmenu_with_1_icon.dart';
// import 'package:workbuddy/shared/widgets/wb_info_container.dart';

// class ContactScreen extends StatefulWidget {
//   final Map<String, dynamic> contact;
//   const ContactScreen({super.key, required this.contact});

//   @override
//   State<ContactScreen> createState() => _ContactScreenState();
// }

// /*--------------------------------- Controller ---*/

// // final inputContactPersonBirthdayController =
// //     TimePickerSpinnerController(); // 4 = Geburtstag

// final controllerCS001 = TextEditingController(); // Anrede
// final controllerCS002 = TextEditingController(); // Vorname
// final controllerCS003 = TextEditingController(); // Nachname
// final controllerCS004 = TextEditingController(); // Geburtstag
// final controllerCS005 = TextEditingController(); // Straße
// final controllerCS006 = TextEditingController(); // PLZ
// final controllerCS007 = TextEditingController(); // Stadt
// final controllerCS008 = TextEditingController(); // Telefon_1
// final controllerCS009 = TextEditingController(); // E-Mail_1
// final controllerCS010 = TextEditingController(); // Telefon_2
// final controllerCS011 = TextEditingController(); // E-Mail_2
// final controllerCS012 = TextEditingController(); // Webseite
// final controllerCS013 = TextEditingController(); // Notizen
// final controllerCS014 = TextEditingController(); // Firma
// final controllerCS015 = TextEditingController(); // Logo
// final controllerCS016 = TextEditingController(); // Notizen
// final controllerCS017 = TextEditingController(); // Branche
// final controllerCS018 = TextEditingController(); // KontaktQuelle
// final controllerCS019 = TextEditingController(); // Status
// final controllerCS020 = TextEditingController(); // 'Position
// final controllerCS021 = TextEditingController(); // '77765
// final controllerCS022 = TextEditingController(); // 'noch NICHT versandt
// final controllerCS023 = TextEditingController(); // 'noch NICHT versandt
// final controllerCS024 = TextEditingController(); // '99 - Gebietskennung
// final controllerCS025 = TextEditingController(); // 
// final controllerCS026 = TextEditingController(); // 
// final controllerCS027 = TextEditingController(); // letzte_Aenderung_am_um
// final controllerCS028 = TextEditingController(); // Betreuer
// final controllerCS029 = TextEditingController(); // Betreuer_Job
// final controllerCS030 = TextEditingController(); // KontaktID

// /*--------------------------------- onChanged-Funktion ---*/
// String inputCompanyName =
//     "evtl. Firmenlogo?"; // nur für die "onChanged-Funktion"
// String inputVNContactPerson =
//     "Kontaktperson"; // nur für die "onChanged-Funktion"
// String inputNNContactPerson = ""; // nur für die "onChanged-Funktion"

// /*--------------------------------- *** ---*/
// class _ContactScreenState extends State<ContactScreen> {
//   late AudioPlayer player = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     /*--------------------------------- Daten aus der SQFlite ---*/
//     /*--- in der Reihenfolge wie auf dem ContactScreen ---*/
//     controllerCS019.text = widget.contact['TKD_Feld_019'] ?? ''; // Status
    
//     controllerCS001.text = widget.contact['TKD_Feld_001'] ?? ''; // Anrede // funzt nicht

//     controllerCS002.text = widget.contact['TKD_Feld_002'] ?? ''; // Vorname

//     controllerCS003.text = widget.contact['TKD_Feld_003'] ?? ''; // Nachname

//     // inputContactPersonBirthdayController.isUpdate =
//     //     widget.contact['TKD_Feld_004'] ?? ''; // Geburtstag

//     controllerCS016.text = widget.contact['TKD_Feld_016'] ?? ''; // Notizen

//     controllerCS005.text = widget.contact['TKD_Feld_005'] ?? ''; // Straße

//     controllerCS006.text = widget.contact['TKD_Feld_006'] ?? ''; // PLZ

//     controllerCS007.text = widget.contact['TKD_Feld_007'] ?? ''; // Stadt

//     controllerCS008.text = widget.contact['TKD_Feld_008'] ?? ''; // Telefon 1

//     controllerCS010.text = widget.contact['TKD_Feld_008'] ?? ''; // Telefon 2

//     controllerCS009.text = widget.contact['TKD_Feld_009'] ?? ''; // E-Mail 1

//     controllerCS012.text = widget.contact['TKD_Feld_012'] ?? ''; // E-Mail 2

//     controllerCS013.text = widget.contact['TKD_Feld_012'] ?? ''; // Webseite

//     controllerCS014.text = widget.contact['TDK_Feld_007'] ?? ''; // Firma
//   }

//   /*--- für die Berechnung des Alters und der Zeitspanne bis zum nächsten Geburtstag ---*/
//   int ageY = 0, ageM = 0, ageD = 0, nextY = 0, nextM = 0, nextD = 0;
//   DateTime initTime = DateTime.now();
//   DateTime selectedTime = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     log("0038 - ContactScreen - aktiviert");
//     return Scaffold(
//       backgroundColor: wbColorBackgroundBlue,
//       appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: wbColorLogoBlue, // Hintergrundfarbe
//           foregroundColor: Colors.white, // Icon-/Button-/Chevron-Farbe
//           shadowColor: Colors.black,
//           title: inputVNContactPerson.isEmpty
//               ? Text(
//                   'Einen Kontakt NEU anlegen',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.yellow,
//                   ),
//                 )
//               : Text(
//                   'Kontakt anzeigen',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.yellow,
//                   ),
//                 )),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     /*--------------------------------- Kontaktperson --- */
//                     Column(
//                       children: [
//                         Container(
//                           height: 136,
//                           width: 136,
//                           // Quadrat mit blauem Hintergrund und Schatten
//                           decoration: ShapeDecoration(
//                             shadows: const [
//                               BoxShadow(
//                                 color: Colors.black,
//                                 blurRadius: 8,
//                                 offset: Offset(4, 4),
//                                 spreadRadius: 0,
//                               )
//                             ],
//                             color: wbColorButtonBlue,
//                             shape: RoundedRectangleBorder(
//                               side: const BorderSide(
//                                 width: 2,
//                                 color: Colors.white,
//                               ),
//                               borderRadius: BorderRadius.circular(
//                                 16,
//                               ),
//                             ),
//                             image: const DecorationImage(
//                               image: AssetImage(
//                                 "assets/dummy_person_portrait.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         /*--------------------------------- Vor- und Nachname der Kontaktperson unter dem Bild ---*/
//                         SizedBox(
//                           width: 160,
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               height: 1.2,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             ("$inputVNContactPerson $inputNNContactPerson"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     /*--------------------------------- Abstand --- */
//                     const SizedBox(width: 14), // Zwischenabstand bei Expanded
//                     /*--------------------------------- Firmenlogo ---*/
//                     Column(
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black,
//                                 blurRadius: 8,
//                                 offset: Offset(3, 3),
//                                 spreadRadius: 0,
//                               ),
//                             ],
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: CircleAvatar(
//                             backgroundColor: wbColorButtonBlue,
//                             backgroundImage:
//                                 // AssetImage(
//                                 //   "assets/company_logos/obi.png",
//                                 // ),
//                                 // AssetImage("assets/dummy_person_portrait.png",),
//                                 // AssetImage("assets/dummy_no_logo.png",),
//                                 // AssetImage("assets/workbuddy_logo.png",),
//                                 //   AssetImage(
//                                 // "assets/workbuddy_logo_neon_green_512x512.png",
//                                 //   ),
//                                 AssetImage(
//                               "assets/company_logos/enpower_expert_logo_4_x_4.png",
//                             ),
//                             /*--------------------------------- *** ---*/
//                             // Bild aus dem Internet:
//                             // NetworkImage('https://picsum.photos/200'),
//                             /*--------------------------------- *** ---*/
//                             radius: 68,
//                           ),
//                         ),
//                         /*--------------------------------- Abstand ---*/
//                         // das ist nur der Abstand zwischen dem Logo und der Firmenbezeichnung:
//                         const SizedBox(height: 20),
//                         /*--------------------------------- Name der Firma unter dem Logo ---*/
//                         SizedBox(
//                           width: 160,
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               height: 1.2,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             inputCompanyName,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               /*--------------------------------- Divider ---*/
//               const Divider(thickness: 3, color: wbColorLogoBlue),
//               /*--------------------------------- *** ---*/
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Kontakt-Status auswählen ---*/
//                     WbDropDownMenu(
//                       label: "Kontakt-Staus",
//                       dropdownItems: [
//                         "Kontakt",
//                         "Interessent",
//                         "Kunde",
//                         // "Lieferant",
//                         // "Lieferant und Kunde",
//                         // "möglicher Lieferant",
//                       ],
//                       // leadingIconsInMenu: [
//                       //   // hat hier keine Auswikung // todo 0233 + 0406
//                       //   Icons.access_time,
//                       //   Icons.airline_seat_legroom_normal,
//                       //   Icons.access_time,
//                       //   Icons.dangerous,
//                       //   Icons.access_time,
//                       //   Icons.face,
//                       // ],
//                       leadingIconInTextField: Icons.create_new_folder_outlined,
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- WbDividerWithTextInCenter ---*/
//                     WbDividerWithTextInCenter(
//                       wbColor: wbColorLogoBlue,
//                       wbText: 'Kontaktperson',
//                       wbTextColor: wbColorLogoBlue,
//                       wbFontSize12: 18,
//                       wbHeight3: 3,
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Anrede ---*/
//                     WbDropDownMenu(
//                       label: "Anrede",
//                       dropdownItems: [
//                         "Herr",
//                         "Frau",
//                         "Divers",
//                         "Herr Dr.",
//                         "Frau Dr.",
//                         "Dr.",
//                         "Herr Prof.",
//                         "Frau Prof.",
//                         "Prof.",
//                       ],
//                       // leadingIconsInMenu: [
//                       //   // hat hier keine Auswikung // todo 0233 + 0406
//                       //   Icons.access_time,
//                       //   Icons.airline_seat_legroom_normal,
//                       //   Icons.access_time,
//                       //   Icons.dangerous,
//                       //   Icons.access_time,
//                       //   Icons.face,
//                       // ],
//                       leadingIconInTextField: Icons.person_2_outlined,
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Vorname ---*/

// // log('0044 - ContactScreen - Daten aus der SQFlite: $contact');

//                     /*--------------------------------- Vorname ---*/
//                     WbTextFormField(
//                       labelText: "Vorname",
//                       labelFontSize20: 20,
//                       hintText: "Bitte den Vornamen eintragen",
//                       hintTextFontSize16: 15,
//                       inputTextFontSize22: 22,
//                       prefixIcon: Icons.person,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       /*--------------------------------- onChanged ---*/
//                       //controller: controllerCS002, // funzt

//                       controller: controllerCS002, // funzt

//                       // controller: controllerCS002..text = contact[2]['TKD_Feld_002'] ?? '',

//                       onChanged: (controllerCS002) {
//                         log("0478 - ContactSreen - Eingabe: $controllerCS002");
//                         inputVNContactPerson = controllerCS002;
//                         setState(() => inputVNContactPerson = controllerCS002);
//                       },
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Nachname ---*/
//                     WbTextFormField(
//                       labelText: "Nachname",
//                       labelFontSize20: 20,
//                       hintText: "Bitte den Nachnamen eintragen",
//                       hintTextFontSize16: 15,
//                       inputTextFontSize22: 22,
//                       prefixIcon: Icons.person,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       /*--------------------------------- onChanged ---*/
//                       controller: controllerCS003, // Nachname
//                       onChanged: (String controllerCS003) {
//                         log("0504 - company_screen - Eingabe: $controllerCS003");
//                         inputNNContactPerson = controllerCS003;
//                         setState(() => inputNNContactPerson = controllerCS003);
//                       },
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--- TimePickerSpinnerPopUp wegen Geburtstag ---*/
//                     Container(
//                       width: 400,
//                       decoration: ShapeDecoration(
//                         color: wbColorLightYellowGreen,
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(
//                             width: 1,
//                             color: Colors.black,
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           /*--------------------------------- TimePickerSpinnerPopUp ---*/
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Geburtstag',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 /*--------------------------------- Abstand ---*/
//                                 wbSizedBoxWidth16,
//                                 /*--------------------------------- *** ---*/
//                                 TimePickerSpinnerPopUp(
//                                     // controller: inputContactPersonBirthdayController,
//                                     locale: Locale('de', 'DE'),
//                                     iconSize: 20,
//                                     textStyle: TextStyle(
//                                         backgroundColor:
//                                             wbColorLightYellowGreen,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold),
//                                     isCancelTextLeft: true,
//                                     paddingHorizontalOverlay: 80,
//                                     mode: CupertinoDatePickerMode.date,
//                                     radius: 16,
//                                     initTime: selectedTime,
//                                     minTime: DateTime.now()
//                                         .subtract(const Duration(days: 36500)),
//                                     /*--------------------------------- *** ---*/
//                                     /* das Geburtsdatum kann nicht in der Zukunft liegen */
//                                     maxTime: DateTime.now()
//                                         .add(const Duration(days: 0)),
//                                     /*--------------------------------- *** ---*/
//                                     use24hFormat: true,
//                                     barrierColor: Colors.black12,
//                                     minuteInterval: 1,
//                                     padding:
//                                         const EdgeInsets.fromLTRB(12, 8, 8, 8),
//                                     cancelText: 'Abbruch',
//                                     confirmText: 'OK',
//                                     pressType: PressType.singlePress,
//                                     timeFormat: 'dd.MM.yyyy',
//                                     onChange: (dateTime) {
//                                       log('0539 - CompanyScreen - Geburtsdatum eingegeben: $dateTime');
//                                       /*--- automatisch das Alter berechnen mit "age_calculator" ---*/
//                                       AgeCalculator();
//                                       DateTime birthday = dateTime;
//                                       var age = AgeCalculator.age(birthday);
//                                       log('0561 - CompanyScreen - Berechnetes Alter = ${age.years} Jahre + ${age.months} Monate + ${age.days} Tage');
//                                       /*--- automatisch die Zeit bis zum nächsten Geburtstag berechnen mit "age_calculator" ---*/
//                                       DateTime nextBirthday = dateTime;
//                                       var timeToNextBirthday =
//                                           AgeCalculator.timeToNextBirthday(
//                                         DateTime(
//                                           nextBirthday.year,
//                                           nextBirthday.month,
//                                           nextBirthday.day,
//                                         ),
//                                         fromDate: DateTime.now(),
//                                       );
//                                       /*--- die Daten aktualisieren ---*/
//                                       setState(() {
//                                         /*--- das Alter berechnen aktualisieren ---*/
//                                         ageY = age.years;
//                                         ageM = age.months;
//                                         ageD = age.days;
//                                         /*--- die Zeit bis zum nächsten Geburtstag aktualisieren ---*/
//                                         nextY = timeToNextBirthday.years;
//                                         nextM = timeToNextBirthday.months;
//                                         nextD = timeToNextBirthday.days;
//                                         /*--- Das angeklickte Geburtsdatum im "TimePickerSpinnerPopUp" soll behalten werden ---*/
//                                         selectedTime = birthday;
//                                         log('0573 - CompanyScreen - selectedTime: $selectedTime = birthday: $birthday');
//                                       });
//                                     }),
//                               ],
//                             ),
//                           ),
//                           /*--------------------------------- Alter anzeigen ---*/
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Alter:',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     '$ageY Jahre + $ageM Monate + $ageD Tage',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.right,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           /*--------------------------------- nächster Geburtstag ---*/
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Nächster ...',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     '$nextY Jahre + $nextM Monate + $nextD Tage',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.right,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Notizen zur Kontaktperson ---*/
//                     WbTextFormField(
//                       controller: controllerCS016,
//                       labelText: "Notizen Kontaktperson",
//                       labelFontSize20: 20,
//                       hintText:
//                           "Beispiele: Hobbys, Lieblingswein, Verein, etc.",
//                       hintTextFontSize16: 12,
//                       inputTextFontSize22: 14,
//                       prefixIcon: Icons.shopping_basket_outlined,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       textInputTypeOnKeyboard: TextInputType.multiline,
//                     ),
//                     /*--------------------------------- WbDividerWithTextInCenter ---*/
//                     wbSizedBoxHeight8,
//                     WbDividerWithTextInCenter(
//                       wbColor: wbColorLogoBlue,
//                       wbText: 'Kommunikation',
//                       wbTextColor: wbColorLogoBlue,
//                       wbFontSize12: 18,
//                       wbHeight3: 3,
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Telefon 1 ---*/
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 400,
//                             child: WbTextFormField(
//                               labelText: "Telefon 1 - Mobil",
//                               labelFontSize20: 20,
//                               hintText: "Bitte die Mobilnummer eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.phone_android_outlined,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard: TextInputType.phone,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- Telefon Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- Telefon-Anruf starten ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- Telefon-Anruf erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0510 - company_screen - Einen Anruf starten");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Einen Anruf starten",
//                                   contentText:
//                                       "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\nanrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0510",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon onTap ENDE---*/
//                             child: Image(
//                               image: AssetImage(
//                                   "assets/iconbuttons/icon_button_telefon_blau.png"),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     /*--------------------------------- WhatsApp ---*/
//                     wbSizedBoxHeight16,
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 185,
//                             child: WbTextFormField(
//                               labelText: "WhatsApp",
//                               labelFontSize20: 20,
//                               hintText: "Bitte die WhatsApp-Nr. eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.phone_android_outlined,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard: TextInputType.phone,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- WhatsApp Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- WhatsApp-Nachricht starten ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- WhatsApp erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0594 - company_screen - Eine WhatsApp senden");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Eine WhatsApp versenden",
//                                   contentText:
//                                       "Willst Du jetzt an die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\neine WhatsApp senden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0594",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon onTap ENDE---*/
//                             child: Image(
//                               image: AssetImage(
//                                 "assets/iconbuttons/icon_button_whatsapp.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Telefon 2 ---*/
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 185,
//                             child: WbTextFormField(
//                               labelText: "Telefon 2",
//                               labelFontSize20: 20,
//                               hintText: "Bitte ggf. die 2. Nummer eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.phone_callback,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard: TextInputType.phone,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- Telefon Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- Telefon-Anruf starten ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- Telefon-Anruf erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0661 - company_screen - Einen Anruf starten");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Einen Anruf starten",
//                                   contentText:
//                                       "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\nanrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-661",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon onTap ENDE---*/
//                             child: Image(
//                               image: AssetImage(
//                                   "assets/iconbuttons/icon_button_telefon_blau.png"),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- E-Mail 1 ---*/
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 185,
//                             child: WbTextFormField(
//                               labelText: "E-Mail 1",
//                               labelFontSize20: 20,
//                               hintText: "Bitte E-Mail-Adresse eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.mail_outline_outlined,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard:
//                                   TextInputType.emailAddress,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- E-Mail 1 Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- E-Mail versenden ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- E-Mail-Versand erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0727 - company_screen - Eine E-Mail versenden");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Eine E-Mail versenden",
//                                   contentText:
//                                       "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0727",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon onTap ENDE---*/
//                             child: Image(
//                               image: AssetImage(
//                                 "assets/iconbuttons/icon_button_email.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- E-Mail 2 ---*/
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 185,
//                             child: WbTextFormField(
//                               labelText: "E-Mail 2",
//                               labelFontSize20: 20,
//                               hintText: "Bitte ggf. die 2. E-Mail eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.mail_outline_outlined,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard:
//                                   TextInputType.emailAddress,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- E-Mail 2 Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- E-Mail versenden ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- E-Mail-Versand erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0794 - company_screen - Eine E-Mail versenden");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Eine E-Mail versenden",
//                                   contentText:
//                                       "Willst Du jetzt eine E-Mail an\nKlausMueller@mueller.de\nversenden?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0794",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon onTap ENDE ---*/
//                             child: Image(
//                               image: AssetImage(
//                                 "assets/iconbuttons/icon_button_email.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     /*--------------------------------- *** ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Webseite ---*/
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             width: 185,
//                             child: WbTextFormField(
//                               labelText: "Webseite vom Kontakt",
//                               labelFontSize20: 20,
//                               hintText: "Bitte Webseite der Firma eintragen",
//                               hintTextFontSize16: 13,
//                               inputTextFontSize22: 22,
//                               prefixIcon: Icons.language_outlined,
//                               prefixIconSize28: 24,
//                               inputFontWeightW900: FontWeight.w900,
//                               inputFontColor: wbColorLogoBlue,
//                               fillColor: wbColorLightYellowGreen,
//                               textInputTypeOnKeyboard:
//                                   TextInputType.emailAddress,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- Webseite Icon ---*/
//                         wbSizedBoxWidth8,
//                         SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: GestureDetector(
//                             //   /*--------------------------------- Webseite verlinken ---*/
//                             //   // benötigt package = recherchieren"
//                             //   onTap: () async {
//                             //   log("00513 - company_screen - Anruf starten");
//                             //   Uri.parse("+491789697193"); // funzt das?
//                             //   launchUrl("tel:+491789697193");
//                             //   UrlLauncher.launch('tel:+${p.phone.toString()}');
//                             //   final call = Uri.parse('tel:+491789697193');
//                             //   if (await canLaunchUrl(call)) {
//                             //     launchUrl(call);
//                             //   } else {
//                             //     throw 'Could not launch $call';
//                             //   }
//                             // },
//                             // /*--------------------------------- Webseite verlinken erledigt ---*/

//                             /*--------------------------------- Icon onTap ---*/
//                             onTap: () {
//                               log("0872 - company_screen - Webseite verlinken");
//                               showDialog(
//                                 context: context,
//                                 builder: (context) =>
//                                     const WbDialogAlertUpdateComingSoon(
//                                   headlineText: "Direkt auf die Webseite?",
//                                   contentText:
//                                       "Willst Du DIREKT auf die Webseite von\nKlausMueller@mueller.de?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0872",
//                                   actionsText: "OK 👍",
//                                 ),
//                               );
//                             },
//                             /*--------------------------------- Icon ---*/
//                             child: Image(
//                               image: AssetImage(
//                                 //"assets/iconbuttons/icon_button_quadrat_blau_leer.png",
//                                 "assets/iconbuttons/icon_button_quadrat_blau_leer.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     /*--------------------------------- *** ---*/
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- WbDividerWithTextInCenter ---*/
//                     WbDividerWithTextInCenter(
//                       wbColor: wbColorLogoBlue,
//                       wbText: 'Daten der Firma',
//                       wbTextColor: wbColorLogoBlue,
//                       wbFontSize12: 18,
//                       wbHeight3: 3,
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Firmenbezeichnung ---*/
//                     WbTextFormField(
//                       labelText: "Firmenbezeichnung",
//                       labelFontSize20: 20,
//                       hintText: "Wie heißt die Firma?",
//                       hintTextFontSize16: 16,
//                       inputTextFontSize22: 22,
//                       prefixIcon: Icons.source_outlined,
//                       prefixIconSize28: 28,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       // textInputTypeOnKeyboard: TextInputType.multiline,
//                       // suffixIcon: Icons.help_outline_outlined,
//                       // suffixIconSize48: 28,
//                       //textInputAction: textInputAction,
//                       /*--------------------------------- onChanged ---*/
//                       controller: controllerCS014,
//                       onChanged: (String controllerCS014) {
//                         log("0189 - company_screen - Eingabe: $controllerCS014");
//                         inputCompanyName = controllerCS014;
//                         setState(() => inputCompanyName = controllerCS014);
//                       },
//                     ),
//                     /*--------------------------------- Branchenzuordnung ---*/
//                     wbSizedBoxHeight16,
//                     WbTextFormField(
//                       labelText: "Branchenzuordnung",
//                       labelFontSize20: 20,
//                       hintText: "Welcher Branche zugeordnet?",
//                       hintTextFontSize16: 16,
//                       inputTextFontSize22: 22,
//                       prefixIcon: Icons.comment_bank_outlined,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                     ),
//                     /*--------------------------------- Notizen zu Warengruppen ---*/
//                     wbSizedBoxHeight16,
//                     WbTextFormField(
//                       labelText: "Notizen zu Warengruppen",
//                       labelFontSize20: 20,
//                       hintText:
//                           "Welche Waren sind für die Suchfunktion in der App relevant? Beispiele: Schrauben, Werkzeug, etc.?",
//                       hintTextFontSize16: 12,
//                       inputTextFontSize22: 15,
//                       prefixIcon: Icons.shopping_basket_outlined,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       textInputTypeOnKeyboard: TextInputType.multiline,
//                     ),
//                     /*--------------------------------- WbDividerWithTextInCenter ---*/
//                     wbSizedBoxHeight8,
//                     WbDividerWithTextInCenter(
//                       wbColor: wbColorLogoBlue,
//                       wbText: 'Adressdaten der Firma',
//                       wbTextColor: wbColorLogoBlue,
//                       wbFontSize12: 18,
//                       wbHeight3: 3,
//                     ),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- Straße + Nummer ---*/
//                     WbTextFormField(
//                       controller: controllerCS005,
//                       labelText: "Straße und Hausnummer",
//                       labelFontSize20: 20,
//                       hintText: "Bitte Straße + Hausnr. eintragen",
//                       hintTextFontSize16: 15,
//                       inputTextFontSize22: 22,
//                       prefixIcon: Icons.location_on_outlined,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                       textInputTypeOnKeyboard: TextInputType.streetAddress,
//                     ),
//                     /*--------------------------------- Zusatzinformation ---*/
//                     wbSizedBoxHeight16,
//                     WbTextFormField(
//                       labelText: "Zusatzinfo zur Adresse",
//                       labelFontSize20: 20,
//                       hintText: "c/o-Adresse? | Hinterhaus? | EG?",
//                       hintTextFontSize16: 15,
//                       inputTextFontSize22: 15,
//                       prefixIcon: Icons.location_on_outlined,
//                       prefixIconSize28: 24,
//                       inputFontWeightW900: FontWeight.w900,
//                       inputFontColor: wbColorLogoBlue,
//                       fillColor: wbColorLightYellowGreen,
//                     ),
//                     /*--------------------------------- PLZ ---*/
//                     wbSizedBoxHeight16,
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 114,
//                           child: WbTextFormFieldTEXTOnly(
//                             controller: controllerCS006,
//                             labelText: "PLZ",
//                             labelFontSize20: 20,
//                             hintText: "PLZ",
//                             inputTextFontSize22: 22,
//                             inputFontWeightW900: FontWeight.w900,
//                             inputFontColor: wbColorLogoBlue,
//                             fillColor: wbColorLightYellowGreen,
//                             textInputTypeOnKeyboard:
//                                 TextInputType.numberWithOptions(
//                               decimal: false,
//                               signed: true,
//                             ),
//                           ),
//                         ),
//                         /*--------------------------------- Firmensitz | Ort ---*/
//                         wbSizedBoxWidth8,
//                         Expanded(
//                           child: WbTextFormFieldTEXTOnly(
//                             controller: controllerCS007,
//                             labelText: "Firmensitz | Ort",
//                             labelFontSize20: 20,
//                             hintText: "Firmensitz",
//                             inputTextFontSize22: 22,
//                             inputFontWeightW900: FontWeight.w900,
//                             inputFontColor: wbColorLogoBlue,
//                             fillColor: wbColorLightYellowGreen,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // /*--------------------------------- *** ---*/
//                     wbSizedBoxHeight16,
//                     const Divider(thickness: 3, color: wbColorLogoBlue),
//                     wbSizedBoxHeight8,
//                     /*--------------------------------- Button Firma speichern ---*/
//                     WbButtonUniversal2(
//                         wbColor: wbColorButtonGreen,
//                         wbIcon: Icons.save_rounded,
//                         wbIconSize40: 40,
//                         wbText: "Kontakt SPEICHERN",
//                         wbFontSize24: 21,
//                         wbWidth155: 398,
//                         wbHeight60: 60,
//                         wbOnTap: () {
//                           log("0965 - ContactScreen - Kontakt speichern - angeklickt");
//                           /*--------------------------------- Snackbar ---*/
//                           player.play(AssetSource("sound/sound06pling.wav"));
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             backgroundColor: wbColorButtonGreen,
//                             content: Text(
//                               "Die Speicherung wird jetzt durchgeführt ... Bitte warten ...",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ));
//                           /*--------------------------------- Navigator.push ---*/
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const MainSelectionScreen(),
//                             ),
//                           );
//                         }),
//                     /*--------------------------------- Abstand ---*/
//                     wbSizedBoxHeight16,
//                     const Divider(thickness: 3, color: wbColorLogoBlue),
//                     wbSizedBoxHeight16,
//                     /*--------------------------------- *** ---*/
//                   ],
//                 ),
//               ),
//               /*--------------------------------- Abstand ---*/
//               wbSizedBoxHeight32,
//               wbSizedBoxHeight32,
//               /*--------------------------------- *** ---*/
//             ],
//           ),
//         ),
//       ),
//       /*--------------------------------- WbInfoContainer ---*/
//       bottomSheet: WbInfoContainer(
//         infoText:
//             '$inputVNContactPerson $inputNNContactPerson • $inputCompanyName\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\nLetzte Änderung: Am 18.12.2024 um 22:51 Uhr', // todo 1030
//         wbColors: Colors.yellow,
//       ),
//       /*--------------------------------- ENDE ---*/
//     );
//   }
// }
