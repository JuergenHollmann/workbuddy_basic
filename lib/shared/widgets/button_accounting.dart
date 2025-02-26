import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/features/accounting/screens/accounting_menu.dart';

class ButtonAccounting extends StatelessWidget {
  const ButtonAccounting({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("0015 - ButtonFinance - wechsle zur Seite AccountingMenu");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountingMenu(),
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
                image: AssetImage('assets/icon_button_finanzen_ohne_text.png'),
                height: 140,
                width: 140, // double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Finanzen',
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
//           log("0018 - ButtonAccounting - Wechsle zur Seite AccountingMenu");
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AccountingMenu(),
//             ),
//           );
//         },
//         child: const Image(
//           image: AssetImage("assets/icon_button_buchhaltung.png"),
//         ),
//       ),
//     );
//   }
// }
