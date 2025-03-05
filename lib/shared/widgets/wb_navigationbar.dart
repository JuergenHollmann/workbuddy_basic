import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/features/home/screens/home_screen.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/features/settings_menu.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';

class WbNavigationbar extends StatefulWidget {
  const WbNavigationbar({
    super.key,
    //required this.wbImageAssetImage,
    this.wbIcon1,
    this.wbIcon2,
    this.wbIcon3,
    this.wbIcon4,
    this.wbTextButton1,
    this.wbTextButton2,
    this.wbTextButton3,
    this.wbTextButton4,
  });

  final ImageProvider<Object>? wbIcon1;
  final ImageProvider<Object>? wbIcon2;
  final ImageProvider<Object>? wbIcon3;
  final ImageProvider<Object>? wbIcon4;
  final String? wbTextButton1;
  final String? wbTextButton2;
  final String? wbTextButton3;
  final String? wbTextButton4;

  @override
  State<WbNavigationbar> createState() => _WbNavigationbarState();
}

class _WbNavigationbarState extends State<WbNavigationbar> {
  // get wbImageAssetImage => Image(
  //       image: AssetImage(
  //         "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon.png",
  //       ),
  //     );

  final preferencesRepository = SharedPreferencesRepository();
  final prefs = SharedPreferencesRepository();
  late String currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('0061 - WbNavigationBar - aktiviert');
    /*--------------------------------- *** ---*/
    return NavigationBarTheme(
      data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) => states.contains(WidgetState.pressed)
            ? const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )
            : const TextStyle(
                color: Colors.yellow,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
      )),
      /*--------------------------------- *** ---*/
      child: Container(
        width: MediaQuery.of(context).size.width, // gesamte Screen-Breite
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black], //wbColorAppBarBlue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
          /*--------------------------------- *** ---*/
          child: Consumer<CurrentUserProvider>(
            builder: (context, value, child) {
              return NavigationBar(
                /*--- backgroundColor ist transparent, damit LinearGradient sichtbar ist ---*/
                backgroundColor: Colors.transparent,
                height: 110,
                // indicatorColor: Colors.black, // hat keinen Effekt
                selectedIndex: 0, //currentIndex,
                onDestinationSelected: (int index) {
                  log("0101 - WbNavigationbar - Button-Index $index angeklickt");
                  /*--------------------------------- Button (index 0) in der WbNavigationbar---*/
                  if (index == 0 && widget.wbTextButton1 == 'Neuer Login') {
                    /*--- Navigiere zur WbHomePage wenn der Home-Button in der NavigationBar angeklickt wird
                    ----> von dort geht es automatisch weiter zum P01LoginScreen,  ---*/
                    log('0106 - WbNavigationbar - Navigiere zur WbHomePage'); // anstatt direkt zum P01LoginScreen
                    /*--------------------------------- Navigator.push ---*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WbHomePage(
                          title: 'WorkBuddy • save time and money!!',
                          // preferencesRepository: preferencesRepository,
                          preferencesRepository: prefs,
                        ),
                      ),
                    );
                    /*--------------------------------- *** ---*/
                  } else if (index == 0 &&
                      widget.wbTextButton1 == 'Startseite') {
                    /*--- Navigiere zur 'Startseite' = WbHomePage wenn der Home-Button in der NavigationBar angeklickt wird */
                    log('0132 - WbNavigationbar - Navigiere zur WbHomePage'); // anstatt direkt zum P01LoginScreen
                    /*--------------------------------- Navigator.push ---*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainSelectionScreen(),
                      ),
                    );

                    /*--------------------------------- Button (index 1) in der WbNavigationbar---*/
                  } else if (index == 1) {
                    log('00125 - WbNavigationbar - Navigiere zur SettingsScreen');
                    /*--------------------------------- *** ---*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsMenu(
                            //title: 'WorkBuddy • save time and money!!',
                            //preferencesRepository: preferencesRepository,
                            //preferencesRepository: prefs,
                            ),
                      ),
                    );

                    /*---- Button (index 2 && widget.wbTextButton1 == 'Neuer Login') in der WbNavigationbar ---*/
                  } else if (index == 2 &&
                      widget.wbTextButton1 == 'Neuer Login') {
                    showDialog(
                        context: context,
                        builder: (context) => WbDialogAlertUpdateComingSoon(
                              headlineText:
                                  'Informationen zur Startseite von WorkBuddy',
                              contentText:
                                  'Hallo ${value.currentUser},\n\nDu befindest dich hier auf der "Startseite" von WorkBuddy.\n\nHier kannst Du deine Aktivitäten zentral verwalten und steuern.\n\nDu benutzt zur Zeit ${context.watch<CurrentAppVersionProvider>().currentAppVersion}.\n\n   • Mit "Herz" ❤️ und 🖐️ "Hand",\n   • gemacht im 🇩🇪 Schwabenland.\n\nWorkBuddy wird ständig weiterentwickelt.\n\nHast Du konstruktive Kritik oder Anregungen? Dann sende einfach eine E-Mail direkt an den Entwickler.\n\nKontaktinformationen:\n• Entwickler: Jürgen Hollmann\n• E-Mail: JOTHAsoft@gmail.com\n• Telefon:  +49-178-9697-193\n\nInfo: NB-0156',
                              actionsText: 'OK 👍',
                            ));
                    log('0165 - WbNavigationbar - Info "Startseite" wurde angezeigt √');

                    /*---- Button (index 2 && widget.wbTextButton1 == 'Startseite') in der WbNavigationbar ---*/
                  } else if (index == 2 && widget.wbTextButton1 == 'Startseite') {
                    showDialog(
                        context: context,
                        builder: (context) => WbDialogAlertUpdateComingSoon(
                              headlineText:
                                  'Informationen zur Kontaktliste von WorkBuddy',
                              contentText:
                                  'Hallo ${value.currentUser},\n\nDu befindest dich hier auf der "Kontaktliste" von WorkBuddy.\n\nHier werden alle deine Kontakte an einer Stelle zentral verwaltet, egal ob es nur Kontakte, Interessenten, Firmen, Lieferanten, Mitbewerber oder Mitarbeiter sind.\n\nDu kannst in der Suchfunktion (gelb) nach Vornamen, Nachnamen, Firmennamen oder nach Orten suchen.\n\nDurch anklicken der "Visitenkarte" kommst Du dann an alle weiteren Informationen.\n\nInfo: NB-0168',
                              actionsText: 'OK 👍',
                            ));
                    log('0165 - WbNavigationbar - Info "Startseite" wurde angezeigt √');

                    /*--------------------------------- Button (index 3) in der WbNavigationbar---*/
                  } else if (index == 3) {
                    log('0171 - WbNavigationbar - Navigiere zur WbExitApp');
                    /*--------------------------------- AlertDialog - START ---*/
                    /* Abfrage ob die App geschlossen werden soll */
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => WBDialog2Buttons(
                        headLineText:
                            'Hey ${value.currentUser},\nmöchtest Du jetzt die WorkBuddy-App beenden?',
                        descriptionText:
                            'Wenn die App hier beendet wird, musst Du dich später wieder einloggen.\n\nWenn Du WorkBuddy im Hintergrund einfach weiterlaufen läßt, hast Du schnelleren Zugriff auf deine Daten.',
                        wbText2: "Ja • Beenden",
                        wbOnTap2: () {
                          Navigator.of(context).pop();
                          log('0185 - WbNavigationbar - Button 2 wurde angeklickt');

                          /*--------------------------------- Snackbar ---*/
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: wbColorOrangeDarker,
                            content: Text(
                              "Danke für das Benutzen der WorkBuddy-App ... 😉",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ));

                          /*--------------------------------- *** ---*/
                          log('0199 - WbNavigationbar - App wird beendet ...');
                          /*--- Noch 2 Sekunden warten, bevor die App beendet wird ---*/
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              FlutterExitApp.exitApp(iosForceExit: true);
                            },
                          );
                          /*--------------------------------- *** ---*/
                        },
                      ),
                    );
                    /*--------------------------------- AlertDialog ENDE ---*/
                  }
                },
                /*--------------------------------- destinations ---*/
                destinations: [
                  /*--------------------------------- Button 1 ---*/
                  NavigationDestination(
                    icon: Image(
                      image: widget.wbIcon1 ??
                          AssetImage(
                            "assets/iconbuttons/icon_button_login_rund_3d_neon.png", // icon_button_home_rund_3d_neon
                          ),
                    ),
                    label: widget.wbTextButton1 ?? 'Neuer Login',
                  ),
                  /*--------------------------------- Button 2 ---*/
                  const NavigationDestination(
                    icon: Image(
                      image: AssetImage(
                        "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon.png", // assets/button_settings.png
                      ),
                    ),
                    label: "Einstellungen",
                  ),
                  /*--------------------------------- Button 3 ---*/
                  const NavigationDestination(
                    // icon: Image(image: AssetImage("assets/button_arrow_right.png")),
                    icon: Image(
                      image: AssetImage(
                        "assets/iconbuttons/icon_button_info_rund_3d_neon.png",
                      ),
                    ),
                    label: "Information",
                  ),
                  /*--------------------------------- Button 4 ---*/
                  const NavigationDestination(
                    // icon: Image(image: AssetImage("assets/button_close.png")),
                    icon: Image(
                      image: AssetImage(
                        "assets/iconbuttons/icon_button_beenden_rund_3d_neon.png",
                      ),
                    ),
                    label: "Beenden",
                  ),
                  /*--------------------------------- *** ---*/
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
