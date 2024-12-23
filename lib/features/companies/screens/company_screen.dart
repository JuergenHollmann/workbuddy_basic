import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/config/wb_text_form_field_text_only.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_drop_down_menu.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

/*--------------------------------- Controller ---*/
final TextEditingController inputCompanyNameTEC = TextEditingController();
final TextEditingController iinputCompanyVNContactPersonTEC =
    TextEditingController();
final TextEditingController iinputCompanyNNContactPersonTEC =
    TextEditingController();

/*--------------------------------- onChanged-Funktion ---*/
String inputCompanyName = "Firmenlogo"; // nur für die "onChanged-Funktion"
String inputCompanyVNContactPerson =
    "Ansprechpartner"; // nur für die "onChanged-Funktion"
String inputCompanyNNContactPerson = ""; // nur für die "onChanged-Funktion"

class _CompanyScreenState extends State<CompanyScreen> {
  late AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    log("0038 - CompanyScreen - aktiviert");

    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
        /*--- "toolbarHeight" wird hier nicht mehr benötigt, weil jetzt "WbInfoContainer" die Daten anzeigt */
        // toolbarHeight: 100,
        title: Text(
          'Firma bearbeiten',
          style: TextStyle(
            fontSize: 28,
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
        /*--- "RichText" wird hier nicht mehr benötigt, weil jetzt "WbInfoContainer" die Daten anzeigt */
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
                            backgroundImage:
                                // AssetImage(
                                //   "assets/company_logos/obi.png",
                                // ),
                                // AssetImage("assets/dummy_person_portrait.png",),
                                // AssetImage("assets/dummy_no_logo.png",),
                                // AssetImage("assets/workbuddy_logo.png",),
                                //   AssetImage(
                                // "assets/workbuddy_logo_neon_green_512x512.png",
                                //   ),
                                AssetImage(
                              "assets/company_logos/enpower_expert_logo_4_x_4.png",
                            ),
                            /*--------------------------------- *** ---*/
                            // Bild aus dem Internet:
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
                      leadingIconsInMenu: [
                        // hat hier keine Auswikung // todo 0233 + 0406
                        Icons.access_time,
                        Icons.airline_seat_legroom_normal,
                        Icons.access_time,
                        Icons.dangerous,
                        Icons.access_time,
                        Icons.face,
                      ],
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

                        /*--------------------------------- Firmensitz | Ort ---*/
                        wbSizedBoxWidth8,
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

                    /*--------------------------------- WbDividerWithTextInCenter ---*/
                    wbSizedBoxHeight8,
                    WbDividerWithTextInCenter(
                      wbColor: wbColorLogoBlue,
                      wbText: 'Ansprechpartner',
                      wbTextColor: wbColorLogoBlue,
                      wbFontSize12: 18,
                      wbHeight3: 3,
                    ),

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
                        // hat hier keine Auswikung // todo 0233 + 0406
                        Icons.access_time,
                        Icons.airline_seat_legroom_normal,
                        Icons.access_time,
                        Icons.dangerous,
                        Icons.access_time,
                        Icons.face,
                      ],
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
                      controller: iinputCompanyVNContactPersonTEC,
                      onChanged: (String iinputCompanyVNContactPersonTEC) {
                        log("0478 - company_screen - Eingabe: $iinputCompanyVNContactPersonTEC");

                        inputCompanyVNContactPerson =
                            iinputCompanyVNContactPersonTEC;

                        setState(() => inputCompanyVNContactPerson =
                            iinputCompanyVNContactPersonTEC);
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
                      controller: iinputCompanyNNContactPersonTEC,
                      onChanged: (String iinputCompanyNNContactPersonTEC) {
                        log("0504 - company_screen - Eingabe: $iinputCompanyNNContactPersonTEC");

                        inputCompanyNNContactPerson =
                            iinputCompanyNNContactPersonTEC;

                        setState(() => inputCompanyNNContactPerson =
                            iinputCompanyNNContactPersonTEC);
                      },
                    ),
                    /*--------------------------------- Geburtstag ---*/
                    wbSizedBoxHeight16,
                    const Row(
                      children: [
                        SizedBox(
                          width: 185,
                          child: WbTextFormField(
                            labelText: "Geburtstag",
                            labelFontSize20: 20,
                            hintText: "Geburtstag",
                            hintTextFontSize16: 15,
                            inputTextFontSize22: 22,
                            prefixIcon: Icons.card_giftcard_outlined,
                            prefixIconSize28: 24,
                            inputFontWeightW900: FontWeight.w900,
                            inputFontColor: wbColorLogoBlue,
                            fillColor: wbColorLightYellowGreen,
                            textInputTypeOnKeyboard: TextInputType.number,
                          ),
                        ),
                        /*--------------------------------- Abstand ---*/
                        wbSizedBoxWidth8,
                        /*--------------------------------- Alter (berechnet) ---*/
                        /* Alter anhand vom Geburtstag automatisch berechnen und im Feld eintragen - 0491 - CompanyScreen */
                        Expanded(
                          child: WbTextFormField(
                            labelText: "Alter",
                            labelFontSize20: 20,
                            hintText: "Alter",
                            hintTextFontSize16: 15,
                            inputTextFontSize22: 22,
                            prefixIcon: Icons.calendar_today_outlined,
                            prefixIconSize28: 24,
                            inputFontWeightW900: FontWeight.w900,
                            inputFontColor: wbColorLogoBlue,
                            fillColor: wbColorLightYellowGreen,
                            textInputTypeOnKeyboard: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight16,
                    /*--------------------------------- Notizen zum Ansprechpartner ---*/
                    WbTextFormField(
                      labelText: "Notizen Ansprechpartner",
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
                    /*--------------------------------- Telefon 1 ---*/
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
                              log("0510 - company_screen - Einen Anruf starten");
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Einen Anruf starten",
                                  contentText:
                                      "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller\nin der Firma XXXXXXXXXXXX GmbH & Co. KG\nanrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0510",
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
            '$inputCompanyName • $inputCompanyVNContactPerson $inputCompanyNNContactPerson\nAngemeldet zur Bearbeitung: JH-01\nLetzte Änderung: Am 18.12.2024 um 22:51 Uhr',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- ENDE ---*/
    );
  }
}
