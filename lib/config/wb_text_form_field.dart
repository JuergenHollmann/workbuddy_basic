import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';

class WbTextFormField extends StatelessWidget {
  const WbTextFormField({
    super.key,
    required this.labelText,
    required this.labelFontSize20,
    required this.hintText,
    this.hintTextFontSize16,
    required this.inputTextFontSize22,
    required this.inputFontWeightW900,
    required this.inputFontColor,
    this.prefixIcon,
    this.prefixIconSize28,
    required this.fillColor,
    this.textInputTypeOnKeyboard,
    this.textInputAction, // default: Enter | TextInputAction.done
    this.controller,
    this.onChanged,
    this.initialValue,
    this.labelBackgroundColor,
    this.contentPadding,

    // required Null Function(String userNameTEC) onChanged,
    // this.suffixIcon,
    // this.suffixIconSize48,
    // this.autofillHints,
  });

  final String labelText;
  final double labelFontSize20;
  final String hintText;
  final double? hintTextFontSize16;
  final double inputTextFontSize22;
  final String? initialValue;
  final IconData? prefixIcon;
  final double? prefixIconSize28;
  final FontWeight inputFontWeightW900;
  final Color inputFontColor;
  final Color fillColor;
  final Color? labelBackgroundColor;
  final TextInputType? textInputTypeOnKeyboard;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String inputInWbTextFormField)? onChanged;
  final EdgeInsets? contentPadding;
  // final IconData? suffixIcon;
  // final double? suffixIconSize48;
  // final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    log("0051 - WbTextFormField - aktiviert");

    return SizedBox(
      width: 400,
      child: GestureDetector( // funzt nicht
        onTap: () {
          log('0062 - WbTextFormField - GestureDetector - onTap ausgelöst');
          // Scrollen, um das Feld unter die AppBar zu bringen
          final renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          final offset = position.dy - kToolbarHeight - 8;

          scrollController.animateTo(
            scrollController.offset + offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: TextFormField(
          //expands: false,
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          keyboardType: textInputTypeOnKeyboard,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          textInputAction: textInputAction,
          maxLines: null,
          //validator: Validator.isValidEmail,
          style: TextStyle(
            height: 1.1, // Zeilenhöhe
            fontSize: inputTextFontSize22,
            fontWeight: inputFontWeightW900,
            color: inputFontColor,
          ),

          //obscureText: visibilityPassword, //Passwort sichtbar?
          /*--------------------------------- InputDecoration ---*/
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: fillColor, //wbColorBackgroundBlue
            contentPadding: contentPadding ??
                EdgeInsets.fromLTRB(
                    16, 0, 8, 8), // für den Textinhalt im Textfeld
            /*--- errorStyle ---*/
            errorStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              backgroundColor: Colors.yellow,
            ),

            /*--- labelStyle ---*/
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.blue,
              fontSize: labelFontSize20,
              fontWeight: FontWeight.bold,
              backgroundColor: labelBackgroundColor,
            ),

            /*--- prefixIcon ---*/
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Icon(
                size: prefixIconSize28, //28
                prefixIcon, //Icons.email_rounded,
              ),
            ),

            /*--- hintText ---*/
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: hintTextFontSize16,
              fontWeight: FontWeight.w900,
              color: Colors.black45,
            ),

            // /*--- SuffixIcon ---*/
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Icon(
            //     size: suffixIconSize48, //28
            //     suffixIcon, //Icons.email_rounded,
            //   ),
            // ),

            /*--- border ---*/
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),

          /*--- autofillHints ---*/
          // autofillHints: autofillHints, // wie funzt das?

          /*--- onChanged ---*/
          controller: controller,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
