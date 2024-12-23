import 'dart:developer';

import 'package:flutter/material.dart';

class WbTextFixedNotWritable extends StatelessWidget {
  const WbTextFixedNotWritable({
    super.key,
    required this.headlineText,
    required this.hintText,
    required this.wbTextFieldWidth,
  });

  final String headlineText;
  final String hintText;
  final double wbTextFieldWidth;

  @override
  Widget build(BuildContext context) {
    log("0019 - WbTextFixedNotWritable - wird angezeigt");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            textAlign: TextAlign.right,
            headlineText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: 40,
          width: wbTextFieldWidth,
          //margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Text(
            hintText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }
}
