import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_sizes.dart';

class WbDividerWithTextInCenter extends StatelessWidget {
  const WbDividerWithTextInCenter({
    super.key,
    required this.wbColor,
    required this.wbText,
    required this.wbTextColor,
    required this.wbFontSize12,
    required this.wbHeight3,
  });

  final Color wbColor;
  final String wbText;
  final Color wbTextColor;
  final double wbFontSize12;
  final double wbHeight3;

  @override
  Widget build(BuildContext context) {
    log("0022 - WbDividerWithTextInCenter - aktiviert");
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: 30,
            height: wbHeight3,
            color: wbColor,
          ),
        ),
        wbSizedBoxWidth8,
        Text(
          wbText,
          style: TextStyle(
            fontSize: wbFontSize12,
            fontWeight: FontWeight.w900,
            color: wbTextColor, // Schriftfarbe
          ),
        ),
        wbSizedBoxWidth8,
        Expanded(
          child: Container(
            width: 30,
            height: wbHeight3,
            color: wbColor,
          ),
        ),
      ],
    );
  }
}
