import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:workbuddy/shared/models/current_user_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  String _currentUser = 'Benutzer der WorkBuddy-App';

  String get currentUser => _currentUser;

  CurrentUserProvider() {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = prefs.getString('currentUser') ?? '';
    notifyListeners();
    log('0021 - CurrentUserProvider - Benutzername geladen: ---> $currentUser <--- funzt');
  }

  Future<void> setCurrentUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', user);
    _currentUser = user;
    notifyListeners();
  }
}

// class CurrentUserProvider extends ChangeNotifier {
//   final CurrentUserModel _currentUser = CurrentUserModel(
//     // currentUserName: 'Josef der Platzhalter mit dem langen Namen zum Testen',
//     currentUserName: 'Jürgen',
//   );

//   CurrentUserModel get currentUser => _currentUser;

//   void update({
//     required String newCurrentUserName,
//   }) {
//     _currentUser.currentUserName = newCurrentUserName;
//   }

//   Future<void> loadCurrentUser(
//       TextEditingController currentUserController) async {
//     final prefs = await SharedPreferences.getInstance();
//     final currentUser = prefs.getString('currentUser') ?? '';
//     currentUserController.text = currentUser;
//     log('0149 - CurrentUserProvider - Benutzername geladen: ---> ${currentUserController.text.characters} <--- funzt');
//     log('0150 - CurrentUserProvider - Benutzername geladen: ---> $currentUser <--- funzt');
//     log('0151 - CurrentUserProvider - Benutzername geladen: ---> ${currentUserController.text} <--- funzt');
//     log('0152 - CurrentUserProvider - Benutzername geladen: ---> $currentUserController <--- liefert nur die Instanz');
//     notifyListeners();
//   }
// }




// log('0069 - CurrentUserProvider - Der aktuelle Benutzer ist --> $currentUserName <---');



  // final TextEditingController currentUserController = TextEditingController();
  // late String currentUser;
  // CurrentUserProvider() {
  //   currentUser = currentUserController.text;
  //   log('0061 - MainApp - CurrentUserProvider ---> $currentUser <---');
  //   currentUserController.addListener(() {
  //     currentUser = currentUserController.text;
  //     notifyListeners(); // gibt nichts zurück?
  //   });
   // log('0069 - MainApp - CurrentUserProvider - Der aktuelle Benutzer ist --> ${currentUserController.text.characters} <---');
  // }

