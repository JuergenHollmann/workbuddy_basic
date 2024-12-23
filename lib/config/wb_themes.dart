import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';

final ThemeData wbLightTheme = ThemeData(
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: normalTextSize),
    headlineMedium: TextStyle(fontSize: bigTextSize),
    bodySmall: TextStyle(fontSize: smallTextSize),
  ),
  scaffoldBackgroundColor: wbColorBackgroundBlue,
);

/* zur Auswahl für die Texte in ThemeData:
    displayLarge
    displayMedium
    displaySmall
    headlineLarge
    headlineMedium
    headlineSmall
    titleLarge
    titleMedium
    titleSmall
    bodyLarge
    bodyMedium
    bodySmall
    labelLarge
    labelMedium
    labelSmall
*/    