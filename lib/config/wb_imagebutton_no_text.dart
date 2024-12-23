/* Ein IconButton mit speziellen Einstellungen */

import 'dart:developer';

import 'package:flutter/material.dart';

class WbImageButtonNoText extends StatelessWidget {
  const WbImageButtonNoText({
    super.key,
    required this.wbColor,
    required this.wbImage,
    required this.wbImagePadding,
    required this.wbWidth60,
    required this.wbHeight60,
    required this.wbBorderRadius16,
    required this.hasShadow,
    required this.wbOnTap,
  });

  final Color wbColor;
  final Image wbImage;
  final double wbImagePadding;
  final double wbWidth60;
  final double wbHeight60;
  final double wbBorderRadius16;
  final bool hasShadow;
  final void Function() wbOnTap;

  @override
  Widget build(BuildContext context) {
    log("0025 - WbImageButtonNoText - aktiviert");
    /*--------------------------------- *** ---*/
    return GestureDetector(
      onTap: wbOnTap,
      child: Container(
        width: wbWidth60,
        height: wbHeight60,
        decoration: ShapeDecoration(
          shadows: [
            // Abfrage ob mit oder ohne Schatten: 0038
            // if (hasShadow) {
            // bool hasShadow ? true : false;
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: Offset(4, 4),
              spreadRadius: 0,
            )
            // }else{
            // // ohne Schatten
            // }
          ],
          color: wbColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(wbBorderRadius16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(wbImagePadding),
          child: wbImage,
        ),
      ),
    );
  }
}
