/* WbTextFormFieldSHADOWContour - lib/config/wb_textformfield_shadow_contour.dart */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WbTextFormFieldSHADOWContour extends StatelessWidget {
  const WbTextFormFieldSHADOWContour({
    super.key,
    required this.labelText,
    required this.labelFontSize20,
    required this.hintText,
    this.hintTextFontSize16,
    required this.inputTextFontSize22,
    this.inputTextAlign,
    required this.inputFontWeightW900,
    required this.inputFontColor,
    // this.prefixIcon,
    // this.prefixIconSize28,
    required this.fillColor,
    this.labelBackgroundColor,
    this.textInputTypeOnKeyboard,
    this.textInputAction, // default: Enter | TextInputAction.done
    this.controller,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
    // this.suffixIcon,
    // this.suffixIconSize48,
    // this.autofillHints,
  });

  final String labelText;
  final double labelFontSize20;
  final String hintText;
  final double? hintTextFontSize16;
  final double inputTextFontSize22;
  final TextAlign? inputTextAlign;
  // final IconData? prefixIcon;
  // final double? prefixIconSize28;
  final FontWeight inputFontWeightW900;
  final Color inputFontColor;
  final Color fillColor;
  final Color? labelBackgroundColor;
  final TextInputType? textInputTypeOnKeyboard;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String inputInWbTextFormField)? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  // final IconData? suffixIcon;
  // final double? suffixIconSize48;
  // final List<String>? autofillHints;


            // /*--------------------------------- Benutzername - Feld ---*/
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
            //   child: Container(
            //     decoration: ShapeDecoration(
            //       shadows: const [
            //         BoxShadow(
            //           color: Colors.black,
            //           blurRadius: 8,
            //           offset: Offset(4, 4),
            //           spreadRadius: 0,
            //         )
            //       ],
            //       // color: wbColor,
            //       shape: RoundedRectangleBorder(
            //         side: const BorderSide(
            //           width: 2,
            //           color: Colors.white,
            //         ),
            //         borderRadius: BorderRadius.circular(
            //           16,
            //         ),
            //       ),
            //     ),
            //     child: TextFormField(
            //       style: const TextStyle(
            //         fontSize: 28,
            //         fontWeight: FontWeight.w900,
            //         color: wbColorButtonGreen,
            //       ),
            //       textAlign: TextAlign.left,
            //       textInputAction: TextInputAction.next,
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Colors.white,
            //         contentPadding: const EdgeInsets.all(16),
            //         /*--------------------------------- labelStyle ---*/
            //         labelText: 'Benutzername',
            //         labelStyle: const TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           backgroundColor: Colors.white,
            //         ),
            //         /*--------------------------------- prefixIcon ---*/
            //         prefixIcon: const Padding(
            //           padding: EdgeInsets.all(16),
            //           child: Icon(
            //             size: 40,
            //             Icons.person,
            //           ),
            //         ),
            //         /*--------------------------------- hintText ---*/
            //         hintText:
            //             '${context.watch<CurrentUserProvider>().currentUser} war angemeldet',
            //         hintStyle: const TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w900,
            //           color: Colors.black38,
            //         ),
            //         /*--------------------------------- border ---*/
            //         border: const OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(16)),
            //         ),
            //       ),
            //       /*--------------------------------- onChanged ---*/
            //       controller: userNameTEC,
            //       onChanged: (String userNameTEC) {
            //         log("0243 - p01_login_screen - Eingabe: $userNameTEC");
            //         inputUserName = userNameTEC;
            //         setState(() => inputUserName = userNameTEC);
            //         if (userNameTEC == userName) {
            //           /*--------------------------------- log ---*/
            //           log("0249 - p01_login_screen - Der Benutzername \"$userName\" ist KORREKT 😉");
            //           /*--------------------------------- Audio ---*/
            //           /* Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist. */ //todo
            //           player.play(AssetSource("sound/sound06pling.wav"));
            //           /*--------------------------------- Snackbar ---*/
            //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //             backgroundColor: wbColorButtonGreen,
            //             duration: Duration(milliseconds: 400),
            //             content: Text(
            //               "Hinweis:\nDer Benutzername \"$userName\" ist KORREKT 😉",
            //               style: TextStyle(
            //                 fontSize: 28,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ));
            //           /*--------------------------------- *** ---*/
            //         } else {
            //           log("0274 - p01_login_screen - Die Eingabe für den Benutzername ist NICHT korrekt!");
            //         }
            //       },
            //     ),
            //   ),
            // ),
            // /*--------------------------------- Abstand ---*/
            // wbSizedBoxHeight8,
            // /*--------------------------------- Text in Consumer<CurrentUserProvider> ---*/
            // Consumer<CurrentUserProvider>(
            //   builder: (context, value, child) {
            //     return Text(
            //       'Zuvor angemeldeter Benutzer: ${value.currentUser}',
            //       textAlign: TextAlign.center,
            //     );
            //   },
            // ),
            // /*--------------------------------- Abstand ---*/








  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      // expands: true,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      keyboardType: textInputTypeOnKeyboard,
      textAlignVertical: TextAlignVertical.center, // vertikale Textausrichtung
      /* horizontale Textausrichtung - wenn nichts expilzit angegeben wird, ist default = "TextAlign.right" */
      textAlign: inputTextAlign ?? TextAlign.right,
      textInputAction: textInputAction,
      expands: true,
      maxLines: null,
      focusNode: focusNode,
      //validator: Validator.isValidEmail,
      style: TextStyle(
        fontSize: inputTextFontSize22,
        fontWeight: inputFontWeightW900,
        color: inputFontColor,
        height: 1, // Höhe des Textfeldes
      ),

      //obscureText: visibilityPassword, // Passwort sichtbar?
      /*--------------------------------- InputDecoration ---*/
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        filled: true,
        fillColor: fillColor, //wbColorBackgroundBlue
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        constraints: BoxConstraints.tightFor(height: 46),

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

        // /*--- prefixIcon ---*/
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(8),
        //   child: Icon(
        //     size: prefixIconSize28, //28
        //     prefixIcon, //Icons.email_rounded,
        //   ),
        // ),

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
    );
  }
}
