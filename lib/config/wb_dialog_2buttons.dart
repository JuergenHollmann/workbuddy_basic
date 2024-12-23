import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';

class WBDialog2Buttons extends StatelessWidget {
  const WBDialog2Buttons({
    super.key,
    required this.headLineText,
    required this.descriptionText,
    //required this.fullscreen,
    this.actions,
    //required IconData icon,
  });

  // required List actions,
  // final String builder;

  // const WBDialog2Buttons.fullscreen({
  //   super.key,
  //   // this.backgroundColor,
  //   // this.insetAnimationDuration = Duration.zero,
  //   // this.insetAnimationCurve = Curves.decelerate,
  //   // this.child,
  //   required this.headLineText,
  //   required this.descriptionText,
  //   this.actions,
  // })  : //  elevation = 0,
  //       //  shadowColor = null,
  //       //  surfaceTintColor = null,
  //       //  insetPadding = EdgeInsets.zero,
  //       //  clipBehavior = Clip.none,
  //       //  shape = null,
  //       alignment = null;
  //       // _fullscreen = true;

  final String headLineText;
  final String descriptionText;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    // String builder = "(BuildContext context) => const WBDialog2Buttons());";
    return AlertDialog(
      backgroundColor: wbColorButtonBlue,
      scrollable: true,
      // icon: Icons.aspect_ratio_outlined, // funzt hier nicht?

      // shadowColor: Colors.black, // funzt hier nicht?

      // shape: const BeveledRectangleBorder(
      //   side: BorderSide(
      //     style: BorderStyle.solid,
      //     width: 3,
      //     color: wbColorBackgroundBlue,
      //     strokeAlign: 1,
      //   ),
      // ),

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
          wbColor: wbColorButtonGreen,
          wbIcon: Icons.report_outlined,
          wbIconSize40: 40,
          wbText: "Nein",
          wbFontSize24: 24,
          wbWidth155: 162,
          wbHeight60: 60,
          wbOnTap: () {
            Navigator.pop(context);
            /*--------------------------------- Snackbar ---*/
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: wbColorButtonGreen,
              duration: Duration(milliseconds: 800),
              content: Text(
                "Die App wurde NICHT beendet ... 😉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ));
            /*--------------------------------- *** ---*/
            log("192 - lib/config/wb_navigation_bar.dart");
          },
        ),
        /*--------------------------------- *** ---*/
        wbSizedBoxHeight24,
        /*--------------------------------- Button 2 ---*/
        WbButtonUniversal2(
          wbColor: wbColorButtonDarkRed,
          wbIcon: Icons.dangerous_outlined,
          wbIconSize40: 40,
          wbText: "Ja • Beenden",
          wbFontSize24: 20,
          wbWidth155: 284,
          wbHeight60: 60,
          wbOnTap: () {
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
            FlutterExitApp.exitApp(iosForceExit: true);
          },
        ),
        /*--------------------------------- *** ---*/
      ],
    );
  }
}



//   @override
//       Widget build(BuildContext context) {
//     return 
//  OutlinedButton(
//           onPressed: () => _dialogBuilder(context),
//           child: const Text('Open Dialog'));



      // Future<void> _dialogBuilder(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Basic dialog title'),
  //         content: const Text(
  //           'A dialog is a type of modal window that\n'
  //           'appears in front of app content to\n'
  //           'provide critical information, or prompt\n'
  //           'for a decision to be made.',
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('Disable'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('Enable'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

// Future<void> _showMyDialog() async {

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // User muss KEINEN Button klicken
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Basic dialog title'),
//           content: const Text(
//             'A dialog is a type of modal window that\n'
//             'appears in front of app content to\n'
//             'provide critical information, or prompt\n'
//             'for a decision to be made.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Disable'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Enable'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//  }