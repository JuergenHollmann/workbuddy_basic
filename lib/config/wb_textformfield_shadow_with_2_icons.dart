/* WbTextFormFieldShadowWith2Icons - lib/config/wb_textformfield_shadow_with_2_icons.dart */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/features/authentication/screens/p01_login_screen.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';

class WbTextFormFieldShadowWith2Icons extends StatelessWidget {
  const WbTextFormFieldShadowWith2Icons({
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
    this.prefixIconSize32,
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
    this.suffixIcon,
    this.suffixIconSize32,
    this.onPressed,
    this.contentPadding,
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
  final double? prefixIconSize32;
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
  final GestureTapCallback? onPressed;
  final IconData? suffixIcon;
  final double? suffixIconSize32;
  final EdgeInsets? contentPadding;
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
          onTap: () {
            try {
              /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
              log('0116 - WbTextFormFieldShadowWith2Icons - Widget OBEN positionieren nach onTap auf das Textfeld');
              final renderBox = context.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              /*--- Abstand von 136 Punkte = 1 Feld oben sichtbar oder 68 Punkte  = direkt unter der AppBar ---*/
              final offset = position.dy - kToolbarHeight - 68;
              scrollController.animateTo(
                scrollController.offset + offset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } catch (e) {
              log('0128 - WbTextFormFieldShadowWith2Icons - Fehler beim Scrollen: $e');
            }
            /*--------------------------------- *** ---*/
          },
          //obscureText: visibilityPassword, // Passwort sichtbar?
          /*--------------------------------- InputDecoration ---*/
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: fillColor ?? Colors.white, //wbColorBackgroundBlue
            contentPadding: contentPadding ??
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
              size: prefixIconSize32 ?? 32,
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

            /*--- SuffixIcon ---*/
            suffixIcon: IconButton(
              icon: Icon(
                suffixIcon ??
                    Icons.replay, //Icons.delete_forever, //Icons.email_rounded,
                size: suffixIconSize32 ?? 32,
              ),
              onPressed: () {
                // log('0169 - WbTextFormFieldShadowWith2Icons - Widget OBEN positionieren nachdem "suffixIcon" - onPressed');
                // Scrollable.ensureVisible(
                //   context,
                //   alignment:
                //       0, // Positioniere das Widget etwas unterhalb der AppBar
                //   duration: const Duration(milliseconds: 300),
                //   curve: Curves.easeInOut,
                // );
                /*--------------------------------- Scrollen um das Textfeld unter die AppBar zu bringen ---*/
                try {
                  log('0192 - WbTextFormFieldShadowWith2Icons - Widget OBEN positionieren nachdem "suffixIcon" - onPressed');
                  controller!.clear();
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  /*--- Abstand von 136 Punkte = 1 Feld oben sichtbar oder 68 Punkte  = direkt unter der AppBar ---*/
                  final offset = position.dy - kToolbarHeight - 68;
                  scrollController.animateTo(
                    scrollController.offset + offset,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } catch (e) {
                  log('0205 - WbTextFormFieldShadowWith2Icons - Fehler beim Scrollen: $e');
                }
                /*--------------------------------- *** ---*/
                log('0204 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" ist je nachdem welches Icon angezeigt wird, unterschiedlich!');
                if (suffixIcon == Icons.replay) {
                  if (controller != null) {
                    controller!.clear();
                    log('0172 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" - Text wurde gelöscht!');
                  }
                  //_refreshPage();
                } else if (suffixIcon == Icons.cancel) {
                  if (controller != null) {
                    controller!.clear();
                    log('0178 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" - Text wurde gelöscht!');
                  }
                } else if (suffixIcon == Icons.front_hand_outlined) {
                  if (controller != null) {
                    controller!.text = "Bitte warten ...";
                    log('0183 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" - Text: "Bitte warten ..."');
                  }
                } else if (suffixIcon == Icons.delete_forever) {
                  if (controller != null) {
                    controller!.clear();
                    log('0188 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" - Text wurde gelöscht!');
                  }
                } else if (suffixIcon == Icons.arrow_drop_down) {
                  controller!.clear();
                  log('0193 - WbTextFormFieldShadowWith2Icons - SuffixIcon "onPressed" mit "Icons.arrow_drop_down" - Text wurde gelöscht!');
                  // Hier könnte eine Dropdown-Liste angezeigt werden.
                  focusNode?.requestFocus();

                  // funzt nicht:
                  // log('1593 - WbTextFormFieldShadowWith2Icons - Scrolle unter die AppBar');
                  // // Scrollen, um das Feld unter die AppBar zu bringen
                  // final renderBox =
                  //     context.findRenderObject() as RenderBox;
                  // final position =
                  //     renderBox.localToGlobal(Offset.zero);
                  // final offset = position.dy - kToolbarHeight - 8;
                  // final scrollController = ScrollController();
                  // scrollController.animateTo(
                  //   scrollController.offset + offset,
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                  //

                  // log('1537 - ContactScreen - K024 - Firma: Land - Tap auf das Textfeld');
                  // Scrollable.ensureVisible(
                  //   context,
                  //   alignment:
                  //       0, // Positioniere das Widget etwas unterhalb der AppBar
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                } else if (suffixIcon == Icons.visibility_outlined) {
                  // Das Passwort ist sichtbar!
                  visibilityPassword = false;
                  // Weil "suffixIcon" final ist, muss der Sichtbarkeitsstatus anders behandelt werden. Entweder mit einer Statusverwaltungslösung, um das Symbol zu aktualisieren, oder einen "Callback" übergeben, um das Symbol vom übergeordneten Widget aus zu aktualisieren. In diesem Fall wird der Sichtbarkeitsstatus in der Klasse "P01LoginScreen" aktualisiert.
                  /*--- visibilityPassword ---*/
                  // suffixIcon: GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       visibilityPassword = !visibilityPassword;
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Icon(
                  //       size: 40,
                  //       visibilityPassword
                  //           ? Icons.visibility_outlined
                  //           : Icons.visibility_off_outlined,
                  //     ),
                  //   ),
                  // ),
                }
                //controller!.clear();
              },
            ),

            // // void _handleIconButtonPress(IconData icon) {
            //   if (icon == Icons.delete_forever) {
            //     controller.clear();
            //   } else if (icon == Icons.front_hand_outlined) {
            //     controller.text = "Bitte warten ...";
            //   } else if (icon == Icons.phone_forwarded) {
            //     _showCallDialog();
            //   }
            // // }

            // suffixIcon: Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Icon(
            //     size: suffixIconSize32 ?? 32, //28
            //     suffixIcon ?? Icons.delete_forever, //Icons.email_rounded,
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
          // onTap: onTap,
          //onPressed: context,

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

//icons.front_hand_outlined, //Icons.email_rounded,
