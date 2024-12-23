/*
Das kann später evtl. gelöscht werden: lib/shared/data/user.dart
 */

import 'dart:developer';

class User {
  String userName;
  String userPassword;

  User({
    required this.userName,
    required this.userPassword,
  });

  @override
  String toString() {
    return "($userName $userPassword)";
    // return "($userName, ********)"; // geht das auch mit Sternchen?
  }

  // /*--------------------------------------- checkLogin ---*/
  /* Überprüfen ob der Benutzername UND das Passwort korrekt ist */
  bool checkLogin(String inputUserName, String inputUserPassword) {
    String checkUserName = "Jürgenx";
    String checkUserPassword = "Pass";
    bool result = false;
    if (checkUserName == inputUserName &&
        checkUserPassword == inputUserPassword) {
      result = true;
    } else {
      result = false;
    }
        log('0034 - User - Benutzername UND Passwort sind korrekt --> $result');
    return result;
  }

  // /*--------------------------------------- checkUserName ---*/
  /* Überprüfen ob der Benutzername korrekt ist */
  bool checkUserName(String inputUserName) {
    String checkUserName = "Jürgenx";
    bool result = false;
    if (checkUserName == inputUserName) {
      result = true;
    } else {
      // so könnte man das hier auch machen } else if (checkUserName != inputUserName) {
      result = false;
    }
    return result;
  }

  // /*--------------------------------------- checkPassword ---*/
/* Überprüfen ob das Passwort korrekt ist */
  bool checkPassword(String inputPassword) {
    String checkPassword = "Pass";
    bool result = false;
    if (checkPassword == inputPassword) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  /*--------------------------------------- getUser ---*/
  /* Einen User aufrufen */
  void getUser(String userName) {
    // print("Benutzername: $userName Passwort: $userPassword");
  }

  /*--------------------------------------- createUser ---*/
  /* Einen User neu hinzufügen */
  void createUser(String userName, String userPassword) {
    // User newUser = User (userName: userName, userPassword: userPassword);
    // newUser.toString();
  }

  /*--------------------------------------- updateUser ---*/
  /* Die Daten eines Users ändern */
  void updateUser(String userName, String userPassword) {
    // code
  }

  /*--------------------------------------- deleteUser ---*/
  /* Einen User löschen */
  void deleteUser(String userName, String userPassword) {
    // code
  }

  // /*--------------------------------------- addUser ---*/
  // /* Einen User hinzufügen */
  // static void createUser(EmailUserModel EmailUserModel) {}
  // // code
  /*--------------------------------------- getAllUsers ---*/
  /* Alle vorhandenen User zurückgeben */
  void getAllUsers(String userName) {
    // code
  }
  /*--------------------------------------- *** ---*/
}
