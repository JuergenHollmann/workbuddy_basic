// Todo's:

/* Wechsle die Farbe des Buttons beim Anklicken:
String color = isSunny ? 'yellow' : 'blue'; // ternärer Operator? */

/* anstelle von "MainSelectionScreen" eine Liste mit Verknüpfungen "NavigateToPageName" zu allen Seiten anlegen:
builder: (context) => const MainSelectionScreen(), // NavigateToPageName(), //MainSelectionScreen(),*/

import 'dart:developer';

import 'package:flutter/material.dart';

class WbButtonUniversal2 extends StatelessWidget {
  const WbButtonUniversal2({
    super.key,
    required this.wbColor,
    required this.wbIcon,
    required this.wbIconSize40,
    required this.wbText,
    required this.wbFontSize24,
    required this.wbWidth155,
    required this.wbHeight60,
    required this.wbOnTap,
  });

  final Color wbColor;
  final IconData wbIcon;
  final double wbIconSize40;
  final String wbText;
  final double wbFontSize24;
  final double wbWidth155;
  final double wbHeight60;
  final void Function() wbOnTap;

  @override
  Widget build(BuildContext context) {
    log("0037 - WbButtonUniversal2 - aktiviert");
    /*--------------------------------- GestureDetector ---*/
    return GestureDetector(
      onTap: wbOnTap,
      /*--------------------------------- Container ---*/
      child: Container(
        width: wbWidth155,
        height: wbHeight60,
        decoration: ShapeDecoration(
          shadows: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: Offset(4, 4),
              spreadRadius: 0,
            )
          ],
          color: wbColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),
        /*--------------------------------- Inhalt des Buttons ---*/
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              /*--------------------------------- Icon ---*/
              child: Icon(
                wbIcon,
                color: Colors.white,
                size: wbIconSize40,
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
            /*--------------------------------- Text ---*/
            Text(
              maxLines: null,
              wbText,
              style: TextStyle(
                color: Colors.white,
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                  )
                ],
                fontSize: wbFontSize24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2, // Zwischenraum der Buchtstaben
              ),
            ),
          ],
        ),
        /*--------------------------------- *** ---*/
      ),
    );
  }
}
