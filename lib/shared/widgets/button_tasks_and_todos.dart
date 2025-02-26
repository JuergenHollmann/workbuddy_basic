import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';

class ButtonTasksAndToDos extends StatelessWidget {
  const ButtonTasksAndToDos({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*--------------------------------- showAlertDialog ---*/
        showDialog(
          context: context,
          builder: (context) => const WbDialogAlertUpdateComingSoon(
            headlineText:
                "Alle Aufgaben anlegen, bearbeiten, delegieren und verwalten?",
            contentText:
                "Diese Funktion kommt bald in einem Update!\n\nUpdate AM-0019",
            actionsText: "OK 👍",
          ),
        ); /*--------------------------------- showAlertDialog ENDE ---*/
        log("0015 - ButtonTasksAndToDos - wechsle zur Seite TasksAndToDos");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const TasksAndToDos(),
        //   ),
        // );
        /*--------------------------------- *** ---*/
      },
      child: SizedBox(
        width: 155,
        height: 150,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/icon_button_aufgaben_ohne_text.png'),
                height: 140,
                width: 140, // double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Aufgaben',
                  style: TextStyle(
                      height: 13.2, // Abstand zur Mitte des Buttons
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.blue,
                          offset: Offset(2, 2),
                        ),
                      ]),
                )),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 160,
//       height: 160,
//       child: GestureDetector(
//         onTap: () {
//           log("0015 - ButtonTasksAndToDos - wechsle zur Seite ContactMenu");
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ContactMenu(),
//             ),
//           );
//         },
//         child: const Image(
//           image: AssetImage("assets/icon_button_kunden.png"),
//         ),
//       ),
//     );
//   }
// }
