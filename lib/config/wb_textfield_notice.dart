import 'package:flutter/material.dart';

class WBTextfieldNotice extends StatelessWidget {
  const WBTextfieldNotice({
    super.key,
    required this.headlineText,
    required this.hintText,
  });

  final String headlineText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    // return mit Column und children:
    return Column(
      children: [
        SizedBox(
          width: 400,
          child: Text(
            textAlign: TextAlign.left,
            headlineText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            maxLines: 4,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.bottom,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 0),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 18),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
