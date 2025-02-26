import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:workbuddy/config/wb_colors.dart';

class WbTextFormFieldOnlyDATE extends StatelessWidget {
  WbTextFormFieldOnlyDATE({
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
    this.width,
  });

  final String labelText;
  final double labelFontSize20;
  final String hintText;
  final double? hintTextFontSize16;
  final double inputTextFontSize22;
  final IconData? prefixIcon;
  final double? prefixIconSize28;
  final FontWeight inputFontWeightW900;
  final Color inputFontColor;
  final Color fillColor;
  final TextInputType? textInputTypeOnKeyboard;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String inputInWbTextFormField)? onChanged;
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  final double? width;

  @override
  Widget build(BuildContext context) {
    log("0043 - WbTextFormFieldOnlyDATE - aktiviert");

    /*--- TextEditingController ---*/
    // final dateController = TextEditingController();

    return SizedBox(
      width: width,
      child: TextFormField(
                
        // controller: dateController,
        controller: controller,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        keyboardType: textInputTypeOnKeyboard,
        textAlignVertical: TextAlignVertical.center,
        maxLines: null,
        //validator: Validator.isValidEmail,
        style: TextStyle(
          height: 1.1,
          fontSize: inputTextFontSize22,
          fontWeight: inputFontWeightW900,
          color: inputFontColor,
        ),
        textAlign: TextAlign.left,
                  
        textInputAction: textInputAction,

        /*--- InputDecoration ---*/
        decoration: InputDecoration(
          
          floatingLabelAlignment: FloatingLabelAlignment.start,
          filled: true,
          fillColor: fillColor, //wbColorBackgroundBlue
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 8),

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
            backgroundColor: wbColorLightYellowGreen,
          ),

          /*--- prefixIcon ---*/
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
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

          /*--- border ---*/
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        /*--- onChanged ---*/
        //controller: controller,
        onChanged: onChanged,

        /*--- inputFormatters ---*/
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'\d+|\.+')),
          DateInputFormatter(),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            log('Bitte ein Datum eingeben');
            return 'Bitte ein Datum eingeben';
          }
          if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(value)) {
            log('Ungültiges Datum: $value');
            return 'Ungültiges Datum';
          }
          try {
            DateFormat('dd.MM.yyyy').parseStrict(value);
          } catch (e) {
            log('Ungültiges Datum: $e');
            return 'Ungültiges Datum';
          }
          return null;
        },
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length == 2 || text.length == 5) {
      return TextEditingValue(
        text: '$text.',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
    return newValue;
  }
}
