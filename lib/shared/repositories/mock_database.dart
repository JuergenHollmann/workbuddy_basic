import 'dart:developer';

import 'package:workbuddy/shared/data/user_data.dart'; // <-- diese wird benutzt --

import 'database_repository.dart';

class MockDatabase implements DatabaseRepository {
/*--------------------------------------- _users ---*/
/* Man soll von außen keinen direkten Zugriff haben, deshalb der Unterstrich vor der Variablen. */
  final List<UserData> _users = [
    UserData(email: 'aa@bb.de', userName: "Jürgen", password: "Pass"),
  ];
  /*--------------------------------------- login ---*/
  @override
  /* (1) Die Logindaten eines Users überprüfen */
  Future<bool> login(String email, String userName, String password) async {
    bool isLoginOK = false;
    for (UserData currentUser in _users) {
      if (currentUser.userName == userName &&
              currentUser.password == password ||
          currentUser.email == email && currentUser.password == password) {
        log("0023 - MockDatabase - login OK");
        isLoginOK = true;
        break;
      }
    }
    if (!isLoginOK) {
      log("0026 - MockDatabase - login NICHT OK");
    }
    return isLoginOK;
  }

/*--------------------------------------- createUser ---*/
  @override
  Future<String?> createUser(String userName, String password) {
    // todo: implement createUser und auf "Duplikat" prüfen
    throw UnimplementedError();
  }

/*--------------------------------------- deleteUser ---*/
  @override
  Future<String> deleteUser() {
    // todo: implement deleteUser
    throw UnimplementedError();
  }

/*--------------------------------------- editUser ---*/
  @override
  Future<void> editUser(UserData user) {
    // todo: implement editUser
    throw UnimplementedError();
  }

/*--------------------------------------- getAllUsers ---*/
  @override
  Future<List<UserData>> getAllUsers() {
    // todo: implement getAllUsers
    throw UnimplementedError(
        'Die Methode "getAllUsers" ist noch nicht implementiert.');
  }

/*--------------------------------------- getUser ---*/
  @override
  Future<String> getUser() {
    // todo: implement getUser
    throw UnimplementedError(
        'Die Methode "getUser" ist noch nicht implementiert.');
  }

/*--------------------------------------- Logout ---*/
  @override
  Future<void> logout() {
    _currentUser = null;
    return Future.value();
  }

/*--------------------------------------- getCurrentUser ---*/
// den aktuellen User aufrufen:
  Future<UserData?> getCurrentUser() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => _currentUser,
    );
  }

/*--------------------------------------- _currentUser ---*/
// Der aktuell eingeloggte User. Ist keiner eingeloggt, ist der Wert null.
  UserData? _currentUser;
/*--------------------------------------- duplicateUser ---*/
// Einen User mit "createUser" zur App hinzufügen.
// Jeden User oder eine E-Mail_Adresse darf es nur EINMAL geben.
// Das hier überprüfen und "false" zurückgeben, falls es den User oder die E-Mail_Adresse schon gibt.
  Future<bool> duplicateUser(
      String newEmail, String newUserName, String newPassword) async {
    // Überprüfen, ob es den User oder die E_Mail-Adresse schon gibt.
    for (UserData user in _users) {
      if (newUserName == user.userName || newEmail == user.email) {
        return Future.value(false);
      }
    }
    UserData newUser =
        UserData(email: newEmail, userName: newUserName, password: newPassword);
    _users.add(newUser);
    return Future.delayed(const Duration(seconds: 1), () => true);
  }

  /*--------------------------------------- signInWithEmailAndPassword ---*/
  @override
  Future<UserData> signInWithEmailAndPassword(
      String userName, String password) {
    // todo: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

/*--------------------------------------- signInWithFacebook ---*/
  @override
  Future<UserData> signInWithFacebook() {
    // todo: implement signInWithFacebook
    throw UnimplementedError();
  }

/*--------------------------------------- signInWithGoogle ---*/
  @override
  Future<UserData> signInWithGoogle() {
    // todo: implement signInWithGoogle
    throw UnimplementedError();
  }

  /*--------------------------------------- currentUser ---*/
  @override
  // todo: implement currentUser
  UserData get currentUser => throw UnimplementedError();
/*--------------------------------------- *** ---*/
}
