import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:workbuddy/features/communication/screens/communication_menu.dart';


class ButtonCommunication extends StatelessWidget {
  const ButtonCommunication({super.key});

    @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("0015 - ButtonCommunication - wechsle zur Seite CommunicationMenu");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CommunicationMenu(),
          ),
        );
      },
      child: SizedBox(
        width: 155,
        height: 150,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/icon_button_kommunikation_ohne_text.png'),
                height: 140,
                width: 140, // double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Kommunikation',
                  style: TextStyle(
                      height: 16.2, // Abstand zur Mitte des Buttons
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
//           log("0015 - ButtonCommunication - Wechsle zur Seite CommunicationMenu");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const CommunicationMenu()),
//           );
//         },
//         child: const Image(
//           image: AssetImage("assets/icon_button_kommunikation.png"),
//         ),
//       ),
//     );
//   }
// }
