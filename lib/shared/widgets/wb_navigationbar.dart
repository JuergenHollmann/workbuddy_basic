import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/exit_app.dart';

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
  get wbImageAssetImage =>
      Image(image: AssetImage("assets/button_info.png")); //OK

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
          stops: [0.0, 0.6],
          // tileMode: TileMode.mirror,
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
          /*--------------------------------- *** ---*/
          child: NavigationBar(
            /*--- backgroundColor ist transparent, damit LinearGradient sichtbar ist ---*/
            backgroundColor: Colors.transparent,
            height: 110,
            //indicatorColor: Colors.black,
            selectedIndex: 1, //currentIndex,
            onDestinationSelected: (int index) {
              log("0022 - WbNavigationbar - Button-Index $index angeklickt");
              // currentIndex = index;
              setState(() {});
            },
            destinations: [
              /*--------------------------------- Button 1 ---*/
              NavigationDestination(
                icon: wbImageAssetImage,

                //Image(image: AssetImage("assets/button_info.png")),//OK
                //Image(image: AssetImage("assets/$wbImageAssetImage")), // OK nur wenn als String deklareirt ist
                //Image(image: wbImageAssetImage),

                label: "Info",
                //enabled: true,
              ),
              /*--------------------------------- Button 2 ---*/
              const NavigationDestination(
                icon: Image(image: AssetImage("assets/button_settings.png")),
                label: "Einstellungen",
              ),
              /*--------------------------------- Button 3 ---*/
              const NavigationDestination(
                icon: Image(image: AssetImage("assets/button_arrow_right.png")),
                label: "Weiter",
              ),
              /*--------------------------------- Button 4 ---*/
              const NavigationDestination(
                icon: Image(image: AssetImage("assets/button_close.png")),
                label: "Beenden",
                selectedIcon: ExitApp(),
              ),
              /*--------------------------------- *** ---*/
            ],
          ),
        ),
      ),
    );
  }
}
