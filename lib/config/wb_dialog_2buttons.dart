import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';

class WBDialog2Buttons extends StatelessWidget {
   WBDialog2Buttons({
    super.key,
    required this.headLineText,
    required this.descriptionText,
    this.actions,
    this.snackBar1Text,
    this.wbColor1,
    this.wbIcon1,
    this.wbIcon1Size40,
    this.wbText1,
    this.wbFont1Size24,
    this.wbWidth1W155,
    this.wbHeight1H60,
    this.wbOnTap1,
    this.wbColor2,
    this.wbIcon2,
    this.wbIcon2Size40,
    this.wbText2,
    this.wbFont2Size24,
    this.wbWidth2W155,
    this.wbHeight2H60,
    this.wbOnTap2,
  });

  final String headLineText;
  final String descriptionText;
  final List<Widget>? actions;
  final String? snackBar1Text;

  final Color? wbColor1;
  final IconData? wbIcon1;
  final double? wbIcon1Size40;
  final String? wbText1;
  final double? wbFont1Size24;
  final double? wbWidth1W155;
  final double? wbHeight1H60;
  final void Function()? wbOnTap1;

  final Color? wbColor2;
  final IconData? wbIcon2;
  final double? wbIcon2Size40;
  final String? wbText2;
  final double? wbFont2Size24;
  final double? wbWidth2W155;
  final double? wbHeight2H60;
  final void Function()? wbOnTap2;

  /*--------------------------------- AudioPlayer ---*/
  final AudioPlayer player = AudioPlayer();
  /*--------------------------------- *** ---*/

  @override
  Widget build(BuildContext context) {
    log('0058 - WBDialog2Buttons - gestartet ...');


    /*--- Das muss zum Aufrufen des AlertDialogs vorangestellt werden ---*/
    // showDialog(
    // context: context,
    // builder: (BuildContext context) => 
    /*--------------------------------- AlertDialog ---*/

    return AlertDialog(
      backgroundColor: wbColorButtonBlue,
      scrollable: true,
      insetPadding: const EdgeInsets.all(4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        side: BorderSide(
          style: BorderStyle.solid,
          width: 3,
          color: wbColorBackgroundBlue,
          strokeAlign: 1,
        ),
      ),

      /*--------------------------------- Überschrift ---*/
      title: Text(headLineText,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),

      /*--------------------------------- Beschreibung ---*/
      content: Text(
        descriptionText,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      /*--------------------------------- actions ---*/
      actions: [
        /*--------------------------------- Abstand ---*/
        wbSizedBoxHeight24,
        /*--------------------------------- Button 1 ---*/
        WbButtonUniversal2(
          wbColor: wbColor1 ?? wbColorButtonGreen,
          wbIcon: wbIcon1 ?? Icons.report_outlined,
          wbIconSize40: wbIcon1Size40 ?? 40,
          wbText: wbText1 ?? "Nein",
          wbFontSize24: wbFont1Size24 ?? 24,
          wbWidth155: wbWidth1W155 ?? 162,
          wbHeight60: wbHeight1H60 ?? 60,
          wbOnTap: wbOnTap1 ??
              () {
                /*--------------------------------- Sound abspielen ---*/
                player.play(AssetSource("sound/sound06pling.wav"));
                /*--------------------------------- Navigator ---*/
                Navigator.pop(context);
                /*--------------------------------- Snackbar 1 ---*/
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   backgroundColor: wbColorButtonGreen,
                //   duration: Duration(milliseconds: 800),
                //   content: Text(
                //     '$snackBar1Text', // "Die App wurde NICHT beendet ... 😉",
                //     style: TextStyle(
                //       fontSize: 28,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ));
                /*--------------------------------- *** ---*/
                log("0123 - WBDialog2Buttons - Button 1 geklickt");
                /*--------------------------------- *** ---*/
              },
        ),
        /*--------------------------------- *** ---*/
        wbSizedBoxHeight24,
        /*--------------------------------- Button 2 ---*/
        WbButtonUniversal2(
          wbColor: wbColor2 ?? wbColorButtonDarkRed,
          wbIcon: wbIcon2 ?? Icons.report_outlined,
          wbIconSize40: wbIcon2Size40 ?? 40,
          wbText: wbText2 ?? "Ja • Löschen",
          wbFontSize24: wbFont2Size24 ?? 24,
          wbWidth155: wbWidth2W155 ?? 284,
          wbHeight60: wbHeight2H60 ?? 60,
          wbOnTap: wbOnTap2 ??
              () {
                /*--------------------------------- Sound abspielen ---*/
                player.play(AssetSource("sound/sound06pling.wav"));
                /*--------------------------------- Navigator ---*/
                Navigator.pop(context);
                /*--------------------------------- Snackbar ---*/
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //       backgroundColor: Colors.black,
                //       duration: Duration(milliseconds: 2000),
                //       content: Text(
                //         "Danke für das Benutzen der Stoppuhr-App ... 😉",
                //         style: TextStyle(
                //           fontSize: 28,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ));
                /*--------------------------------- *** ---*/
                //     log("223 - lib/config/wb_navigation_bar.dart");
                /*--------------------------------- *** ---*/
                //     // Verzögerug von 2 Sekunden einbauen: // funzt nicht!
                //     // Future<void> withDelay() async {
                //     //   await Future.delayed(
                //     //       const Duration(seconds: 2));
                //     //   log("229 - lib/config/wb_navigation_bar.dart");
                //     //   FlutterExitApp.exitApp(
                //     //       iosForceExit: true);
                //     // }
                /*--------------------------------- *** ---*/
                // FlutterExitApp.exitApp(iosForceExit: true);

                /*--------------------------------- *** ---*/
                log("0170 - WBDialog2Buttons - Button 2 geklickt");
                /*--------------------------------- *** ---*/
              },
        ),
        /*--------------------------------- *** ---*/
      ],
    );
  }
}
