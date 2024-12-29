import 'dart:developer';

import 'package:flutter/material.dart';
import '../../features/authentication/screens/p01_login_screen.dart';

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
          "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon.png")); //OK

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
          child: NavigationBar(
            /*--- backgroundColor ist transparent, damit LinearGradient sichtbar ist ---*/
            backgroundColor: Colors.transparent,
            height: 110,
            //indicatorColor: Colors.black,
            selectedIndex: 0, //currentIndex,
            onDestinationSelected: (int index) {
              log("0076 - WbNavigationbar - Button-Index $index angeklickt");
              //currentIndex = index;
              setState(() {});
              if (index == 0) {
                /*--- Navigiere zum P01LoginScreen, wenn der Home-Button angeklickt wird ---*/ // funzt nicht - friert ein!
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => P01LoginScreen()),
                );
              }
            },
            destinations: [
              /*--------------------------------- Button 1 ---*/
              NavigationDestination(
                //icon: wbImageAssetImage, // funzt noch nicht
                //Image(image: AssetImage("assets/$wbImageAssetImage")), // OK nur wenn als String deklareirt ist
                // icon: Image(image: AssetImage("assets/button_info.png")),//OK
                icon: Image(
                  image: AssetImage(
                    "assets/iconbuttons/icon_button_home_rund_3d_neon.png",
                  ),
                ),
                label: "Home",
                // enabled: true,
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
                label: "Info",
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
                // selectedIcon: ExitApp(),
// /*--------------------------------- AlertDialog ---*/
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
//                   child: WbButtonUniversal2(
//                     wbColor: wbColorButtonDarkRed,
//                     wbIcon: Icons.report_outlined,
//                     wbIconSize40: 40,
//                     wbText: 'WorkBuddy beenden',
//                     wbFontSize24: 20,
//                     wbWidth155: 155, // hat hier keine Auswirkung
//                     wbHeight60: 60,
//                     wbOnTap: () {
//                       /*--------------------------------- AlertDialog ---*/
//                       // Abfrage ob die App geschlossen werden soll:
//                       showDialog(
//                           context: context,
//                           builder: (BuildContext context) =>
//                               const WBDialog2Buttons(
//                                 headLineText:
//                                     "Möchtest Du jetzt wirklich diese tolle WorkBuddy-App beenden?",
//                                 descriptionText:
//                                     "Bevor Du diese tolle WorkBuddy-App beendest, denke bitte daran:\n\n Bei aller Aufregung sollten wir aber nicht vergessen, dass Al Bundy im Jahr 1966 vier Touchdowns in einem Spiel gemacht hat und damit den den Polk High School Panthers zur Stadtmeisterschaft verholfen hat!\n\nAußerdem sollte man auf gesunde Ernährung achten, deshalb empfehle ich täglich ein gutes Käsebrot (für Vegetarier und Veganer natürlich auch gerne mit veganer Butter).\n\nWenn du keinen Käse magst, dann kannst du natürlich auch ein Wurstbrot essen, aber dann ist das logischerweise wiederum nicht vegan (aber es gibt ja auch vegane Wurst) und in diesem Falle kannst du eben auch die Wurst weglassen, wenn Du eine vegane Butter auf dem Brot hast. \n\nWarum schreibe ich das alles hier hin?\n\nGanz einfach:\nWeil ich zeigen wollte, dass diese Textzeilen SCROLLBAR sind.",
//                               ));
//                       /*--------------------------------- AlertDialog ---*/
//                     },
//                   ),
//                 ),
// /*--------------------------------- AlertDialog ENDE ---*/
              ),
              /*--------------------------------- *** ---*/
            ],
          ),
        ),
      ),
    );
  }
}
