import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeProvider extends ChangeNotifier {
  DateTime time = DateTime.now();
  late String formatHour;
  late String formatMinute;
  late String currentTime;
  CurrentTimeProvider() {
    formatHour = NumberFormat("00").format(time.hour);
    formatMinute = NumberFormat("00").format(time.minute);
    currentTime = '$formatHour:$formatMinute Uhr';
    log('0067 - main - CurrentTimeProvider ---> Es ist jetzt $currentTime');
  }
}
