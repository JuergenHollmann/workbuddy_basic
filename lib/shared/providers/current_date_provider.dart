import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDateProvider extends ChangeNotifier {
  DateTime date = DateTime.now();
  late String formatDay;
  late String formatMonth;
  late String formatYear;
  late String currentDate;
  CurrentDateProvider() {
    formatDay = NumberFormat("00").format(date.day);
    formatMonth = NumberFormat("00").format(date.month);
    formatYear = NumberFormat("0000").format(date.year);
    currentDate = '$formatDay.$formatMonth.$formatYear';
    log('0071 - main - CurrentDateProvider ---> Heute ist $currentDate');
  }
}
