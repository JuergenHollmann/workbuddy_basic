import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_keys.dart';

class SharedPreferencesRepository {
  /* Unsere SharedPreferences-Instanz */
  late final SharedPreferences instance;

  /* Damit können wir überprüfen, ob die await "SharedPreferences.getInstance();"" bereits ausgeführt wurde */
  bool _init = false;

  /* Die "SharedPreferences" initialisieren */
  Future<void> init() async {
    /* Wenn bereits einmal initialisiert wurde, soll nichts ausgeführt werden */
    if (_init) {
      return;
    }

    /* Die Instanz setzen */
    instance = await SharedPreferences.getInstance();

    /* _init auf true setzen */
    _init = true;
  }

  /* Wenn wir noch nicht initialisiert haben, wird ein Fehler ausgegeben */
  void checkInit() {
    if (!_init) {
      throw Exception(
          "[SharedPreferencesRepository]: Bitte die init() Methode vorher ausführen");
    }
  }

  /*--------------------------------- Controller ---*/
  // final TextEditingController _currentUserController = TextEditingController();

/*--------------------------------- currentUser ---*/
  // Future<void> _saveCurrentUser(String currentUser) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('currentUser', currentUser);
  //   log('0044- SharedPreferencesRepository - Benutzername gespeichert: $currentUser');
  // }

  // Future<void> _loadCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final currentUser = prefs.getString('currentUser') ?? '';
  //   setState(() {
  //     currentUserController.text = currentUser;
  //     log('0059 - P01LoginScreen - Benutzername geladen: ---> ${currentUserController.text.characters} <---');
  //   });
  // }

  // Future<void> _loadCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final currentUser = prefs.getString('currentUser') ?? '';
  //   // setState(() {
  //     _currentUserController.text = currentUser;
  //     log('0052- SharedPreferencesRepository - Benutzername geladen: ${currentUser.characters}');
  //   // });
  // }

  // void _onLogin() {
  //   final currentUser = _currentUserController.text;
  //   if (currentUser.isNotEmpty) {
  //     _saveCurrentUser(currentUser);
  //     // Weitere Aktionen nach erfolgreichem Login
  //     log('0061 - SharedPreferencesRepository - Benutzername gespeichert: $currentUser');
  //   } else {
  //     log('0063 - SharedPreferencesRepository - Benutzername darf NICHT leer sein');
  //   }
  // }

/*--------------------------------- DarkMode oder LightMode ---*/
  /* Die "DarkMode-Variable" setzen */
  void setThemeMode(bool isDarkMode) async {
    /* Überprüfen, ob wir bereits initialisiert haben */
    checkInit();

    /* WICHTIG: Hier wird die Variable gespeichert */
    bool success = await instance.setBool(darkModeKey, isDarkMode);

    /* Wenn das Speichern erfolgreich war, erhalten wir eine Variable zurück (true, false) */
    if (success) {
      log("0044 - SharedPreferencesRepository - Variable erfolgreich gespeichert");
    } else {
      log("0046 - SharedPreferencesRepository - Variable konnte NICHT gespeichert werden");
    }
  }

  /* Die "DarkMode-Variable" abrufen */
  bool getThemeMode() {
    /* Überprüfen, ob wir bereits initialisiert haben */
    checkInit();

    /* WICHTIG: Hier rufen wir die Variable ab */
    /* Nullable Boolean, da es sein kann, dass der Key nicht existiert */
    bool? isDarkMode = instance.getBool(darkModeKey);

    /* Wenn es "null" ist, haben wir die Variable vorher nicht gespeichert */
    if (isDarkMode == null) {
      log('Der "SharedPreferences-Key" existiert nicht');
      return false;
    }

    /* Die Variable, die wir aus dem lokalen Speicher abgerufen haben, geben wir hier zurück */
    return isDarkMode;
  }
}
