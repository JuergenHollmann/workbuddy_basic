import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WBTextfieldQuantity extends StatelessWidget {
  const WBTextfieldQuantity({
    super.key,
    required this.headlineText,
    required this.hintText,
  });

  final String headlineText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            headlineText, //"Anzahl",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              fontSize: 24,
            ),
            // es dürfen nur Ziffern (auch dezimale) eingetragen werden = Keyboard nur mit Ziffern und decimal:
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            // der Input muss mit Regex überprüft werden:
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            ],

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 14),
              hintText: hintText, //'Anzahl',
              hintStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
