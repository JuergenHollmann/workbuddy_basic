/* WbTextFormFieldShadowWith1Icon - lib/config/wb_textformfield_shadow_with_1_icon.dart */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbTextFormFieldShadowWith1Icon extends StatelessWidget {
  const WbTextFormFieldShadowWith1Icon({
    super.key,
    required this.labelText,
    required this.hintText,
    this.labelFontSize22,
    this.labelBackgroundColor,
    this.labelTextColor,
    this.hintTextFontSize16,
    this.inputTextFontSize24,
    this.inputTextAlign,
    this.prefixIcon,
    this.prefixIconSize24,
    this.inputFontWeightW900,
    this.inputFontColor,
    this.fillColor,
    this.textInputTypeOnKeyboard,
    this.controller,
    this.textInputAction,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
    this.textAlignVertical,
    this.onTap,
  });

  final String labelText;
  final String hintText;
  final double? labelFontSize22;
  final Color? labelBackgroundColor;
  final Color? labelTextColor;
  final double? hintTextFontSize16;
  final double? inputTextFontSize24;
  final TextAlign? inputTextAlign;
  final IconData? prefixIcon;
  final double? prefixIconSize24;
  final FontWeight? inputFontWeightW900;
  final Color? inputFontColor;
  final Color? fillColor;
  final TextInputType? textInputTypeOnKeyboard;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final Function(String inputInWbTextFormField)? onChanged;
  final GestureTapCallback? onTap;
  // final IconData suffixIcon;
  // final double suffixIconSize24;
  // final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 12, 0),
      /*--------------------------------- Container ---*/
      child: Container(
        decoration: ShapeDecoration(
          shadows: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: Offset(4, 4),
              spreadRadius: 0,
            )
          ],
          // color: wbColor,
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
        /*--------------------------------- TextFormField ---*/
        child: TextFormField(
          maxLines: null,
          // inputFormatters: inputFormatters, // erlaubt nur bestimmte Eingaben, z.B. [FilteringTextInputFormatter.digitsOnly],
          expands:
              false, // bei "true: Das Textfeld wird größer, wenn mehrere Zeilen eingegeben werden.
          // maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
          keyboardType: textInputTypeOnKeyboard ?? TextInputType.text,
          textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
          /* horizontale Textausrichtung - wenn nichts expilzit angegeben wird, ist default = "TextAlign.left" */
          textAlign: inputTextAlign ?? TextAlign.left,
          textInputAction: textInputAction ?? TextInputAction.next,
          focusNode: focusNode ?? FocusNode(),
          // validator: validator ?? Validator.isValidEmail(),
          style: TextStyle(
            fontSize: inputTextFontSize24 ?? 24,
            fontWeight: inputFontWeightW900 ?? FontWeight.w900,
            color: inputFontColor ?? wbColorButtonGreen,
            height: 1, // Zeilenhöhe
          ),

          //obscureText: visibilityPassword, // Passwort sichtbar?
          /*--------------------------------- InputDecoration ---*/
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: fillColor ?? Colors.white, //wbColorBackgroundBlue
            contentPadding:
                const EdgeInsets.fromLTRB(16, 24, 8, 0), // Label-Abstand
            // contentPadding:
            //     const EdgeInsets.symmetric(vertical:0, horizontal: 16),

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
              color: labelTextColor ?? wbColorAppBarBlue,
              fontSize: labelFontSize22 ?? 22,
              fontWeight: FontWeight.bold,
              backgroundColor: labelBackgroundColor ?? Colors.white,
            ),

            /*--- prefixIcon ---*/
            prefixIcon:
                // Padding(
                // padding: const EdgeInsets.all(16),
                // child:
                Icon(
              size: prefixIconSize24 ?? 24,
              prefixIcon ?? Icons.info, //Icons.email_rounded,
              // ),
            ),

            /*--- hintText ---*/
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: hintTextFontSize16 ?? 16,
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
          //autofillHints: autofillHints, // wie funzt das?

          /*--- Specials ---*/
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,

          /*--- onChanged ---*/
          // onChanged: (String newInputPassword) {
          //   log("Eingabe: $newInputPassword");
          //   inputPassword = newInputPassword;
          //   setState(() => inputPassword = newInputPassword);
          //   if (newInputPassword == userPassword) {
          //     log("Das Passwort $userPassword ist KORREKT!");
          //     // ACHTUNG: Beim player den sound OHNE "assets/...", sondern gleich mit "sound/..." eintragen (siehe unten):
          //     player.play(AssetSource("sound/sound06pling.wav"));
          //   } else {
          //     log("Die Eingabe für das Passwort ist NICHT korrekt!");
          //   }
          // },
        ),
      ),
    );
  }
}
