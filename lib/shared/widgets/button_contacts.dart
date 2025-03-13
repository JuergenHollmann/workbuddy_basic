import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/features/contacts/screens/contact_menu.dart';

class ButtonContacts extends StatelessWidget {
  const ButtonContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("0015 - ButtonContacts - wechsle zur Seite ContactScreen");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactMenu(),
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
                image: AssetImage('assets/icon_button_kontakte_ohne_text.png'),
                height: 140,
                width: 140, // double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Kontakte',
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
