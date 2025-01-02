import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDayLongProvider extends ChangeNotifier {
  DateTime date = DateTime.now();
  late String currentDayLong;
  CurrentDayLongProvider() {
    currentDayLong = DateFormat('EEEE', 'de_DE').format(date);
    log('0063 - main - CurrentDayLongProvider ---> Heute ist $currentDayLong');
  }
}
