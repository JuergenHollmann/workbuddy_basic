import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbDialogAlertUpdateComingSoon extends StatelessWidget {
  const WbDialogAlertUpdateComingSoon({
    super.key,
    required this.headlineText,
    required this.contentText,
    required this.actionsText,
    this.onTap,
  });

  final String headlineText;
  final String contentText;
  final String actionsText;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    log("0017 - WbDialogAlertUpdateComingSoon - aktiviert");
    return GestureDetector(
/*-----------------------------------------------------------------*/
/* MUSTER - das muß zum Aufruf ab "showDialog" zum Widget hinzugefügt werden:
/*-----------------------------------------------------------------*/
/*--------------------------------- showAlertDialog ---*/
showDialog(context: context, builder: (context) => const WbDialogAlertUpdateComingSoon(
headlineText: "Alle Aufgaben anlegen, bearbeiten, delegieren und verwalten?",
contentText: "Diese Funktion kommt bald in einem Update!\n\nUpdate AM-0019",
actionsText: "OK 👍",
),);/*--------------------------------- showAlertDialog ENDE ---*/
/*-----------------------------------------------------------------*/*/
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: AlertDialog(
                insetPadding: const EdgeInsets.all(8),

          scrollable: true,
          title: Text(
            headlineText,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blue),
          ),
          content: Text(
            contentText,
            // Individueller Text - Beispiel:
            // 'Diese Funktion kommt bald in einem kostenlosen Update!\n\nHinweis: CS-0000'
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: wbColorLogoBlue,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                actionsText, // "OK 👍",
                style: TextStyle(
                  color: Colors.blue,
                  shadows: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(4, 4),
                      spreadRadius: 0,
                    )
                  ],
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2, // Zwischenraum der Buchtstaben
                ),
              ),
              onPressed: () {
                log("0071 - WbDialogAlertUpdateComingSoon - OK wurde angeklickt");
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
