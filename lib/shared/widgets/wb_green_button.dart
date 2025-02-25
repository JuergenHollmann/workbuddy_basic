import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WBGreenButton extends StatelessWidget {
  const WBGreenButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    log("0011 - WBGreenButton - aktiviert");

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
        child: Container(
          width: 398,
          height: 60,
          decoration: ShapeDecoration(
            shadows: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(4, 4),
                spreadRadius: 0,
              )
            ],
            color: wbColorButtonGreen,
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
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.input_outlined,
                      color: Colors.white,
                      size: 40,
                      shadows: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 48,
                        ), // dieses Padding richtet den Text mittig aus (weil oben padding 16 + Rand 32 = 48 ist )
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                              )
                            ],
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            // height: 1, // nur wenn der Text innerhalb des Buttons verschoben werden soll
                            letterSpacing: 2, // Zwischenraum der Buchtstaben
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
