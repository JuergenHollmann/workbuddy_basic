import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDayShortProvider extends ChangeNotifier {
  DateTime date = DateTime.now();
  late String currentDayShort;
  CurrentDayShortProvider() {
    currentDayShort =
        DateFormat('EE', 'de_DE').format(date).replaceAll('.', '');
    log('0063 - main - CurrentDayLongProvider ---> Heute ist $currentDayShort');
  }
}
