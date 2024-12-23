import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbDialogAlertUpdateComingSoon extends StatelessWidget {
  const WbDialogAlertUpdateComingSoon({
    super.key,
    required this.headlineText,
    required this.contentText,
    required this.actionsText,
  });

  final String headlineText;
  final String contentText;
  final String actionsText;

  @override
  Widget build(BuildContext context) {
    log("0017 - WbDialogAlertUpdateComingSoon - aktiviert");
    return
/*-----------------------------------------------------------------*/
/* MUSTER - das muß zum Aufruf ab "showDialog" zum Widget hinzugefügt werden:
/*-----------------------------------------------------------------*/
                    GestureDetector(
                      onTap: () {
                        log("Einen Anruf starten");
/*-----------------------------------------------------------------*/
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: "Einen Anruf starten",
                            contentText:
                                "Willst Du jetzt die Nummer\n+49-XXX-XXXX-XXXX\nvon Klaus Müller anrufen?\n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CS-0282"),);
                                */
/*-----------------------------------------------------------------*/
        AlertDialog(
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
          fontWeight: FontWeight.bold, color: wbColorLogoBlue,
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
            log("0071 - WbDialogAlertUpdateComingSoon - angeklickt");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
