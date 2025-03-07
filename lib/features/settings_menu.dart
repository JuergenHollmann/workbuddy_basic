import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_date_provider.dart';
import 'package:workbuddy/shared/providers/current_day_long_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  bool _isWarningSoundEnabled = true;
  bool _isButtonSoundEnabled = false;
  bool _isPageChangeSoundEnabled = false;
  bool _isTextFieldSoundEnabled = false;
  bool _isSoundPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isWarningSoundEnabled = prefs.getBool('warningSound') ?? true;
      _isButtonSoundEnabled = prefs.getBool('buttonSound') ?? false;
      _isPageChangeSoundEnabled = prefs.getBool('pageChangeSound') ?? false;
      _isTextFieldSoundEnabled = prefs.getBool('textFieldSound') ?? false;
    });
  }

  Future<void> _saveSettings(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /*--------------------------------- *** ---*/
  @override
  Widget build(BuildContext context) {
    log("0016 - SettingsMenu - wird benutzt");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      /*--------------------------------- *** ---*/
      appBar: AppBar(
        title: const Text(
          'System-Einstellungen',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black, // Schriftfarbe
          ),
        ),
        backgroundColor: wbColorBackgroundBlue, // Hintergrundfarbe
        foregroundColor: Colors.black, // Icon-/Button-/Chevron-Farbe
      ),
      /*--------------------------------- *** ---*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
            ),
            // --------------------------------------- Einstellungen-Menü ---
            const WbDividerWithTextInCenter(
              wbColor: wbColorLogoBlue,
              wbText: "Einstellungen",
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 28,
              wbHeight3: 3,
            ),

            /*--------------------------------- ExpansionPanelList - START ---*/
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  /*--- Logik für das Öffnen/Schließen der Akkordeons ---*/
                  _isSoundPanelExpanded = isExpanded;
                });
              },
              children: [
                /*--------------------------------- Header: Töne bei Aktionen - ExpansionPanel ---*/
                ExpansionPanel(
                  backgroundColor: wbColorDrawerOrangeLight,
                  splashColor: wbColorAppBarBlue, // beim Anklicken
                  highlightColor: Colors.yellow, // bei längerem Drücken
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    /*--------------------------------- Töne bei Aktionen - ListTile ---*/
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: wbColorBackgroundBlue,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        leading: const Icon(
                          Icons.volume_up,
                          size: 40,
                          color: wbColorAppBarBlue,
                        ),
                        title: Text('Töne bei Aktionen',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        subtitle: Text(
                          'Bei welchen Aktionen sollen Töne abgespielt werden?',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                  /*--------------------------------- Body: Töne bei Aktionen - Column ---*/
                  body: Column(
                    children: [
                      /*--------------------------------- ListTile - Warnung beim Löschen ---*/
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: SwitchListTile(
                          // activeColor: wbColorButtonGreen,
                          // ignore: deprecated_member_use
                          // activeTrackColor: wbColorButtonGreen.withOpacity(0.5),
                          selectedTileColor: wbColorButtonDarkRed, // funzt nicht
                          // selectedColor: wbColorButtonDarkRed, // funzt nicht
                          // focusColor: wbColorButtonDarkRed, // funzt nicht
                          hoverColor: wbColorButtonDarkRed, // funzt nicht
                          // splashColor: wbColorButtonDarkRed, // funzt nicht
                          // highlightColor: wbColorButtonDarkRed, // funzt nicht
                          // backgroundColor: wbColorButtonDarkRed, // funzt nicht
                          // foregroundColor: wbColorButtonDarkRed, // funzt nicht
                          // icon: Icon(Icons.volume_up, size: 40, color: wbColorAppBarBlue), // funzt nicht
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          title: Text('Warnung beim Löschen',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          value: _isWarningSoundEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isWarningSoundEnabled = value;
                              _saveSettings('warningSound', value);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: SwitchListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          title: Text('Buttons anklicken',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          value: _isButtonSoundEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isButtonSoundEnabled = value;
                              _saveSettings('buttonSound', value);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: SwitchListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          title: Text('Wechsel zu Seiten',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          value: _isPageChangeSoundEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isPageChangeSoundEnabled = value;
                              _saveSettings('pageChangeSound', value);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: SwitchListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          title: Text('Textfelder anklicken',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          value: _isTextFieldSoundEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isTextFieldSoundEnabled = value;
                              _saveSettings('textFieldSound', value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _isSoundPanelExpanded,
                ),
              ],
            ),
          ],
        ),
      ),

      //       /*--------------------------------- Listview mit AuswahlButtons ---*/
      //       Expanded(
      //         child: ListView(
      //           padding: const EdgeInsets.all(8),
      //           children: [
      //             Text(
      //               'Diese Seite wird gerade NEU programmiert ...',
      //               style: TextStyle(
      //                 fontSize: 24,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             /*--------------------------------- Divider ---*/
      //             const Divider(
      //                 thickness: 3, height: 32, color: wbColorLogoBlue),
      //             /*--------------------------------- WhatsApp ---*/

      //             Text('Sprache'),

      //             Text('Sound an/aus'),
      //             Text('Designauswahl Dark/Light'),
      //             Text('Erinnerungen'),
      //             Text('Kalender-Einstellungen'),
      //             Text('Datenschutz'),
      //             Text('Nutzungsbedingugen'),
      //             Text('Impressum'),
      //             Text('Über uns'),

      //             // /*--------------------------------- WbButtonsUniWithImageButton - Telefonanruf ---*/
      //             // WbButtonsUniWithImageButton(
      //             //   wbColor: wbColorButtonDarkRed,
      //             //   wbIcon: Icons.phone_forwarded,
      //             //   wbIconSize40: 40,
      //             //   wbText: "Kontakt anrufen",
      //             //   wbFontSize24: 22,
      //             //   wbWidth276: 276,
      //             //   wbHeight90: 90,
      //             //   wbHeightAssetImage90: 90,
      //             //   wbImageAssetImage: const AssetImage(
      //             //     "assets/iconbuttons/icon_button_kontakte.png",
      //             //   ),
      //             //   wbImageButtonRadius12: 12,
      //             //   wbOnTapTextButton: () {
      //             //     log("0069 - SettingsMenu - großer roter Button angeklickt"); // nur das Smartphone starten
      //             //     showDialog(
      //             //       context: context,
      //             //       builder: (context) =>
      //             //           const WbDialogAlertUpdateComingSoon(
      //             //         headlineText: "Kontakt anrufen?",
      //             //         contentText:
      //             //             "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0090",
      //             //         actionsText: "OK 👍",
      //             //       ),
      //             //     );
      //             //     /*--------------------------------- *** ---*/
      //             //     // Navigator.push(
      //             //     //   context,
      //             //     //   MaterialPageRoute(
      //             //     //     builder: (context) => const ContactScreen(),
      //             //     //   ),
      //             //     // );
      //             //   },
      //             //   wbOnTapImageButton: () {
      //             //     log("0069 - SettingsMenu - Icon Kontakt anrufen angeklickt"); // erst Kontakt auswählen, dann anrufen:
      //             //     showDialog(
      //             //       context: context,
      //             //       builder: (context) =>
      //             //           const WbDialogAlertUpdateComingSoon(
      //             //         headlineText: "Kontakt anrufen?",
      //             //         contentText:
      //             //             "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0090",
      //             //         actionsText: "OK 👍",
      //             //       ),
      //             //     );
      //             //     /*--------------------------------- *** ---*/
      //             //     // Navigator.push(
      //             //     //   context,
      //             //     //   MaterialPageRoute(
      //             //     //     builder: (context) => const ContactScreen(),
      //             //     //   ),
      //             //     // );
      //             //   },
      //             // ),
      //             // /*--------------------------------- *** ---*/
      //             // wbSizedBoxHeight8,
      //             // /*--------------------------------- *** ---*/
      //             // const Divider(
      //             //     thickness: 3, height: 32, color: wbColorLogoBlue),
      //             // /*--------------------------------- WhatsApp ---*/
      //             // WbButtonsUniWithImageButton(
      //             //   wbColor: wbColorButtonGreen,
      //             //   wbIcon: Icons.phonelink_ring_outlined,
      //             //   wbIconSize40: 40,
      //             //   wbText: "WhatsApp versenden",
      //             //   wbFontSize24: 22,
      //             //   wbWidth276: 276,
      //             //   wbHeight90: 90,
      //             //   wbHeightAssetImage90: 90,
      //             //   wbImageAssetImage: const AssetImage(
      //             //     "assets/icon_button_whatsapp.png",
      //             //   ),
      //             //   wbImageButtonRadius12: 12,
      //             //   wbOnTapTextButton: () {
      //             //     log("0031 - SettingsMenu - großer grüner WhatsApp Button angeklickt");
      //             //     showDialog(
      //             //       context: context,
      //             //       builder: (context) =>
      //             //           const WbDialogAlertUpdateComingSoon(
      //             //         headlineText: "WhatsApp versenden?",
      //             //         contentText:
      //             //             "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0136",
      //             //         actionsText: "OK 👍",
      //             //       ),
      //             //     );
      //             //     /*--------------------------------- *** ---*/
      //             //     // Navigator.push(
      //             //     //   context,
      //             //     //   MaterialPageRoute(
      //             //     //     builder: (context) => const ContactScreen(),
      //             //     //   ),
      //             //     // );
      //             //   },
      //             //   wbOnTapImageButton: () {
      //             //     log("0150 - SettingsMenu - großer grüner WhatsApp Button angeklickt");
      //             //     showDialog(
      //             //       context: context,
      //             //       builder: (context) =>
      //             //           const WbDialogAlertUpdateComingSoon(
      //             //         headlineText: "WhatsApp versenden?",
      //             //         contentText:
      //             //             "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0150",
      //             //         actionsText: "OK 👍",
      //             //       ),
      //             //     );
      //             //     /*--------------------------------- *** ---*/
      //             //     // Navigator.push(
      //             //     //   context,
      //             //     //   MaterialPageRoute(
      //             //     //     builder: (context) => const ContactScreen(),
      //             //     //   ),
      //             //     // );
      //             //   },
      //             // ),
      //             // /*--------------------------------- *** ---*/
      //             // wbSizedBoxHeight8,
      //             // /*--------------------------------- Divider ---*/
      //             // const Divider(
      //             //     thickness: 3, height: 32, color: wbColorLogoBlue),
      //             // /*--------------------------------- E-Mail senden ---*/
      //             // WbButtonsUniWithImageButton(
      //             //   wbColor: wbColorButtonBlue,
      //             //   wbIcon: Icons.forward_to_inbox_outlined,
      //             //   wbIconSize40: 40,
      //             //   wbText: "E-Mail versenden",
      //             //   wbFontSize24: 22,
      //             //   wbWidth276: 276,
      //             //   wbHeight90: 90,
      //             //   wbHeightAssetImage90: 90,
      //             //   wbImageAssetImage: const AssetImage(
      //             //     "assets/iconbuttons/icon_button_email.png",
      //             //   ),
      //             //   wbImageButtonRadius12: 12,
      //             //   wbOnTapTextButton: () {
      //             //     log("0190 - SettingsMenu - zeige EMailScreenP043");
      //             //     Navigator.push(
      //             //       context,
      //             //       MaterialPageRoute(
      //             //         // builder: (context) => const EMailScreenP043(),
      //             //         // direkten Weg finden:
      //             //         builder: (context) => const EMailScreenP043(
      //             //           emailUserModel: '',
      //             //         ), // EmailUserSelection(), // funzt noch nicht
      //             //       ),
      //             //     );
      //             //   },
      //             //   wbOnTapImageButton: () {
      //             //     log("0199 - SettingsMenu - zeige EMailScreenP043");
      //             //     Navigator.push(
      //             //       context,
      //             //       MaterialPageRoute(
      //             //         builder: (context) => const EMailScreenP043(
      //             //           emailUserModel: 'aa@aa.de',
      //             //         ),
      //             //       ),
      //             //     );
      //             //   },
      //             // ),
      //             /*--------------------------------- Abstand ---*/
      //             // wbSizedBoxHeight16,
      //             /*--------------------------------- Divider ---*/
      //             const Divider(
      //                 thickness: 3, height: 32, color: wbColorLogoBlue),
      //             /*--------------------------------- WbButtonUniversal2 - Neue Funktionen? ---*/
      //             WbButtonUniversal2(
      //               wbColor: const Color.fromARGB(255, 255, 102, 219),
      //               wbIcon: Icons.forward_to_inbox_outlined,
      //               wbIconSize40: 40,
      //               wbText:
      //                   "Möchtest Du\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
      //               wbFontSize24: 14,
      //               wbWidth155: 398,
      //               wbHeight60: 110,
      //               wbOnTap: () {
      //                 log("0249 - SettingsMenu - großer rosa Entwickler Button angeklickt");
      //                 showDialog(
      //                   context: context,
      //                   builder: (context) =>
      //                       const WbDialogAlertUpdateComingSoon(
      //                     headlineText: "Mehr Funktionen?",
      //                     contentText:
      //                         "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: SM-0263",
      //                     actionsText: "OK 👍",
      //                   ),
      //                 );
      //               },
      //             ),
      //             /*--------------------------------- Abstand ---*/
      //             wbSizedBoxHeight8,
      //             /*--------------------------------- Divider ---*/
      //             const Divider(
      //                 thickness: 3, height: 32, color: wbColorLogoBlue),
      //             /*--------------------------------- Abstand ---*/
      //             wbSizedBoxHeight32,
      //             wbSizedBoxHeight32,
      //             /*--------------------------------- *** ---*/
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      /*--------------------------------- WbInfoContainer ---*/
      bottomSheet: WbInfoContainer(
        infoText:
            'Heute ist ${context.watch<CurrentDayLongProvider>().currentDayLong}, ${context.watch<CurrentDateProvider>().currentDate}\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- WbInfoContainer ENDE ---*/
    );
  }
}
