import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_container_with_icon_and_text.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_date_provider.dart';
import 'package:workbuddy/shared/providers/current_day_long_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';
import 'package:workbuddy/wb_impressum.dart';
import 'package:workbuddy/wb_privacy_policy_dsgvo.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  /*--------------------------------- AudioPlayer ---*/
  /*--- ACHTUNG: Beim player den sound OHNE "assets/...", sondern gleich mit "sound/..." eintragen ---*/
  late AudioPlayer player = AudioPlayer();

  bool _isWarningSoundEnabled = true;
  bool _isButtonSoundEnabled = false;
  bool _isPageChangeSoundEnabled = false;
  bool _isTextFieldSoundEnabled = false;
  bool _isSoundPanelExpanded = false;

  /*--- Liste der verfügbaren Sprachen und deren Flaggen ---*/
  final List<Map<String, String>> _languages = [
    {'name': 'Deutsch', 'flag': 'assets/flags/de.png'},
    {'name': 'Englisch', 'flag': 'assets/flags/gb.png'},
    {'name': 'Französisch', 'flag': 'assets/flags/fr.png'},
    {'name': 'Spanisch', 'flag': 'assets/flags/es.png'},
    {'name': 'Italienisch', 'flag': 'assets/flags/it.png'},
    {'name': 'Portugiesisch', 'flag': 'assets/flags/pt.png'},
    {'name': 'Niederländisch', 'flag': 'assets/flags/nl.png'},
    {'name': 'Russisch', 'flag': 'assets/flags/ru.png'},
    {'name': 'Chinesisch', 'flag': 'assets/flags/cn.png'},
    {'name': 'Japanisch', 'flag': 'assets/flags/jp.png'},
    {'name': 'Koreanisch', 'flag': 'assets/flags/kr.png'},
  ];

  /*--------------------------------- Aktuell ausgewählte Sprache ---*/
  String _selectedLanguage = 'Deutsch';

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
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'Deutsch';
    });
  }

  Future<void> _saveSettings(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  /*--------------------------------- *** ---*/
  @override
  Widget build(BuildContext context) {
    log("0057 - SettingsMenu - wird benutzt");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 243, 255),
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
      body: SingleChildScrollView(
        child: Padding(
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
              /*--------------------------------- *** ---*/
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
                          onTap: () {
                            setState(() {
                              _isSoundPanelExpanded = !_isSoundPanelExpanded;
                            });
                            /*--------------------------------- Sound abspielen ---*/
                            if (_isSoundPanelExpanded) {
                              player
                                  .play(AssetSource("sound/sound07woosh.wav"));
                            }
                          },
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
                            selectedTileColor:
                                wbColorButtonDarkRed, // funzt nicht
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
                              /*--------------------------------- Sound abspielen ---*/
                              if (_isWarningSoundEnabled) {
                                player.play(
                                    AssetSource("sound/sound07woosh.wav"));
                              }
                              /*--------------------------------- *** ---*/
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
                              /*--------------------------------- Sound abspielen ---*/
                              if (_isButtonSoundEnabled) {
                                player.play(
                                    AssetSource("sound/sound07woosh.wav"));
                              }
                              /*--------------------------------- *** ---*/
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
                              /*--------------------------------- Sound abspielen ---*/
                              if (_isPageChangeSoundEnabled) {
                                player.play(
                                    AssetSource("sound/sound07woosh.wav"));
                              }
                              /*--------------------------------- *** ---*/
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
                              /*--------------------------------- Sound abspielen ---*/
                              if (_isTextFieldSoundEnabled) {
                                player.play(
                                    AssetSource("sound/sound07woosh.wav"));
                              }
                              /*--------------------------------- *** ---*/
                            },
                          ),
                        ),
                      ],
                    ),
                    isExpanded: _isSoundPanelExpanded,
                  ),
                ],
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- Sprache auswählen ---*/
              Container(
                width: double.infinity, // maximale Breite
                color: wbColorDrawerOrangeLight,
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 32,
                  elevation: 166,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                    _saveLanguage(_selectedLanguage);
                    /*--- Wenn eine Sprache ausgewählt wird ---*/
                    if (_selectedLanguage == 'Deutsch') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WbDialogAlertUpdateComingSoon(
                            headlineText: 'Deine Sprachauswahl',
                            contentText:
                                'Du hast "$_selectedLanguage" als Systemsprache in "WorkBuddy" ausgewählt.',
                            actionsText: 'OK 👍',
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          );

                          // WBDialog2Buttons(
                          //   headLineText: 'Deine Sprachauswahl',
                          //   descriptionText:
                          //       'Du hast $_selectedLanguage als Systemsprache in "WorkBuddy" ausgewählt.',
                          //   wbText1: 'OK 👍',
                          //   wbOnTap1: () {
                          //     log('0370 - SettingsMenu - Sprache "$_selectedLanguage" ausgewählt.');
                          //     Navigator.of(context).pop();
                          //   },
                          // );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WbDialogAlertUpdateComingSoon(
                            headlineText: 'Deine Sprachauswahl',
                            contentText:
                                'Du hast "$_selectedLanguage" als Systemsprache in "WorkBuddy" ausgewählt.\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nBis dahin muss die App auf "Deutsch" eingestellt bleiben.\n\nHinweis: SM-0389',
                            actionsText: 'OK 👍',
                            onTap: () {
                              // funzt hier nicht - gb

                              setState(() {
                                _selectedLanguage = 'Deutsch';
                              });
                              _saveLanguage('Deutsch');
                              log('0405 - SettingsMenu - Sprache "$_selectedLanguage" ausgewählt.');
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    }
                  },
                  items: _languages.map<DropdownMenuItem<String>>(
                      (Map<String, String> language) {
                    return DropdownMenuItem<String>(
                      value: language['name'],
                      child: Row(
                        children: [
                          Image.asset(
                            language['flag']!,
                            width: 40,
                          ),
                          const SizedBox(width: 16),
                          Text(language['name']!),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              Text('Designauswahl Dark/Light'),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              Text('Erinnerungen'),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              Text('Kalender-Einstellungen'),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- Über uns ---*/
              WbContainerWithIconAndText(
                containerText: 'Über uns',
                containerIcon: Icons.diversity_3_outlined,
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- Datenschutz ---*/
              WbContainerWithIconAndText(
                containerText: 'Datenschutzerklärung',
                containerIcon: Icons.privacy_tip_outlined,
                onTap: () {
                  log('0452 - SettingsMenu - "Datenschutzerklärung" - angeklickt');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WbPrivacyPolicyDSGVO(),
                    ),
                  );
                },
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- Nutzungsbedingungen ---*/
              WbContainerWithIconAndText(
                containerText: 'Nutzungsbedingungen',
                containerIcon: Icons.rule_folder_outlined,
                onTap: () {
                  log('0467 - SettingsMenu - "Nutzungsbedingungen" - angeklickt');
                  Navigator.pushNamed(context, '/terms');
                },
              ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- Impressum ---*/
              WbContainerWithIconAndText(
                containerText: 'Impressum',
                containerIcon: Icons.privacy_tip_outlined,
                onTap: () {
                  log('0479 - SettingsMenu - "Impressum" - angeklickt');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WbImpressum(),
                    ),
                  );
                },
              ),

              // WbContainerWithIconAndText(
              //   containerText: 'Impressum',
              //   containerIcon: Icons.info_outline,
              // ),
              /*--------------------------------- Divider ---*/
              const Divider(thickness: 3, height: 32, color: wbColorLogoBlue),
              /*--------------------------------- *** ---*/
              SizedBox(height: 68),
            ],
          ),
        ),
      ),
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
