import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/features/home/screens/home_screen.dart';
import 'package:workbuddy/features/settings_menu.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';

class WbNavigationbar extends StatefulWidget {
  const WbNavigationbar({
    super.key,
    required this.wbImageAssetImage,
  });

  //final ImageProvider<Object> imageButton;
  //final Image imageButton;
  final ImageProvider<Object> wbImageAssetImage;
  //final String? wbImageAssetImage;

  @override
  State<WbNavigationbar> createState() => _WbNavigationbarState();
}

class _WbNavigationbarState extends State<WbNavigationbar> {
  //String imageButton;
  // get wbImageAssetImage =>
  //     Image(image: AssetImage("assets/button_info.png")); //OK

  get wbImageAssetImage => Image(
        image: AssetImage(
          "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon.png",
        ),
      );

  final preferencesRepository = SharedPreferencesRepository();
  final prefs = SharedPreferencesRepository();
  late String currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*--------------------------------- NavigationBarTheme ---*/
    //String? wbImageAssetImage;
    //var wbImageAssetImage;
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
        // width: 398,
        // height: 190,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black], //wbColorAppBarBlue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5],
            // tileMode: TileMode.mirror,
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
                //indicatorColor: Colors.black,
                selectedIndex: 0, //currentIndex,
                onDestinationSelected: (int index) {
                  log("0076 - WbNavigationbar - Button-Index $index angeklickt");
                  //currentIndex = index;
                  /*--------------------------------- Button (index 0) in der WbNavigationbar---*/
                  if (index == 0) {
                    /*--- Navigiere zur WbHomePage wenn der Home-Button in der NavigationBar angeklickt wird
                    ----> von dort geht es automatisch weiter zum P01LoginScreen,  ---*/
                    log('0084 - WbNavigationbar - Navigiere zur WbHomePage'); // anstatt direkt zum P01LoginScreen
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => P01LoginScreen(
                    //         // title: 'WorkBuddy • save time and money!',
                    //         // preferencesRepository: preferencesRepository,
                    //         ),
                    //   ),
                    // );
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
                    /*--------------------------------- Button (index 2) in der WbNavigationbar---*/
                  } else if (index == 2) {
                    showDialog(
                        context: context,
                        builder: (context) => WbDialogAlertUpdateComingSoon(
                              headlineText:
                                  'Ein paar Informationen zu WorkBuddy',
                              contentText:
                                  'Hallo ${value.currentUser},\nDu benutzt zur Zeit ${context.watch<CurrentAppVersionProvider>().currentAppVersion}.\n\n- Mit "Herz" ❤️ und 🖐️ "Hand"\n- gemacht im 🇩🇪 Schwabenland.\n\nDie App wird ständig weiterentwickelt ... Hast Du konstruktive Kritik oder Anregungen? Dann sende einfach eine E-Mail direkt an den Entwickler.\n\nKontaktinformationen:\n• Entwickler: Jürgen Hollmann\n• E-Mail: JOTHAsoft@gmail.com\n• Telefon: +49-178-9697-193\n\nInformation: NB-0136',
                              actionsText: 'OK 👍',
                            ));
                    /*--------------------------------- *** ---*/
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => WbInfoPage(
                    //       title: 'WorkBuddy • Info',
                    //       preferencesRepository: preferencesRepository,
                    //     ),
                    //   ),
                    // );
                    log('0165 - WbNavigationbar - Info wurde angezeigt √');
                    /*--------------------------------- Button (index 3) in der WbNavigationbar---*/
                  } else if (index == 3) {
                    log('0171 - WbNavigationbar - Navigiere zur WbExitApp');
                    /*--------------------------------- AlertDialog ---*/
                    /* Abfrage ob die App geschlossen werden soll */
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => WBDialog2Buttons(
                        headLineText:
                            "Hey ${value.currentUser},\nmöchtest Du jetzt wirklich diese tolle WorkBuddy-App beenden?",
                        descriptionText:
                            "Bevor Du diese tolle WorkBuddy-App beendest, denke bitte daran:\n\n Bei aller Aufregung sollten wir aber nicht vergessen, dass Al Bundy im Jahr 1966 vier Touchdowns in einem Spiel gemacht hat und damit den den Polk High School Panthers zur Stadtmeisterschaft verholfen hat!\n\nAußerdem sollte man auf gesunde Ernährung achten, deshalb empfehle ich täglich ein gutes Käsebrot (für Vegetarier und Veganer natürlich auch gerne mit veganer Butter).\n\nWenn du keinen Käse magst, dann kannst du natürlich auch ein Wurstbrot essen, aber dann ist das logischerweise wiederum nicht vegan (aber es gibt ja auch vegane Wurst) und in diesem Falle kannst du eben auch die Wurst weglassen, wenn Du eine vegane Butter auf dem Brot hast. \n\nWarum schreibe ich das alles hier hin?\n\nGanz einfach:\nWeil ich zeigen wollte, dass diese Textzeilen SCROLLBAR sind.",
                      ),
                    );
                    /*--------------------------------- AlertDialog ENDE ---*/
                  }
                },
                destinations: [
                  /*--------------------------------- Button X ---*/
                  // NavigationDestination(
                  //   //icon: wbImageAssetImage, // funzt noch nicht
                  //   //Image(image: AssetImage("assets/$wbImageAssetImage")), // OK nur wenn als String deklareirt ist
                  //   // icon: Image(image: AssetImage("assets/button_info.png")),//OK
                  //   icon: Image(
                  //     image: AssetImage(
                  //       "assets/iconbuttons/icon_button_home_rund_3d_neon.png",
                  //     ),
                  //   ),
                  //   label: "Home",
                  //   // enabled: true,
                  // ),
                  /*--------------------------------- Button 1 ---*/
                  const NavigationDestination(
                    // icon: Image(image: AssetImage("assets/button_settings.png")),
                    icon: Image(
                      image: AssetImage(
                        "assets/iconbuttons/icon_button_login_rund_3d_neon.png",
                      ),
                    ),
                    label: "Neuer Login",
                  ),
                  /*--------------------------------- Button 2 ---*/
                  const NavigationDestination(
                    // icon: Image(image: AssetImage("assets/button_settings.png")),
                    icon: Image(
                      image: AssetImage(
                        "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon.png",
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
