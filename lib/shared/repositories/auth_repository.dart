/* 
Momentan existieren 3 "class User" Modelle für userName und UserPasswort:
- lib/features/authentication/schema/user.dart;   <-- diese kann später gelöscht werden (Beispiel von Sobhi) --
- shared/data/user.dart';                         <-- diese kann später gelöscht werden --
- shared/data/user_data.dart';                    <-- diese wird benutzt --
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:workbuddy/shared/data/user_data.dart';

abstract class AuthRepository {
  /*--------------------------------------- signInWithUserNameAndPassword ---*/
  Future signInWithUserNameAndPassword(
      {required String userName, required String password}) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: userName, password: password);
    FirebaseAuth.instance.signOut();
  }
  /*--------------------------------------- signInWithEmailAndPasswort ---*/
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseAuth.instance.signOut();
  }
  /*--------------------------------------- authStateChanges ---*/
  Stream<User?> get onAuthStateChanges => FirebaseAuth.instance.authStateChanges();
  /*--------------------------------------- Login ---*/
  /* Den User einloggen */
  Future<bool> login(String userName, String password);
  /*--------------------------------------- getUser ---*/
  /* Einen User aufrufen. Falls kein User eingeloggt ist, wird "null" zurückgegeben. */
  Future<String> getUser();
  /*--------------------------------------- createUser ---*/
  /* Einen User neu hinzufügen */
  Future<String?> createUser(String userName, String password);
  /*--------------------------------------- deleteUser ---*/
  /* Einen User löschen */
  Future<String> deleteUser();
  /*--------------------------------------- editUser ---*/
  /* Die Daten eines Users bearbeiten */
  Future<void> editUser(UserData user);
  /*--------------------------------------- getCurrentUser ---*/
  /* Aktuell eingeloggten User zurückgeben. Falls keiner eingeloggt ist, wird "null" zurückgegeben. */
  UserData get currentUser;
  /*--------------------------------------- Logout ---*/
  Future<void> logout();
  /*--------------------------------------- getAllUsers ---*/
  /* Alle vorhandenen User zurückgeben */
  Future<List<UserData>> getAllUsers();
  /*--------------------------------------- signInWithGoogle ---*/
  Future<UserData> signInWithGoogle();
  /*--------------------------------------- signInWithFacebook ---*/
  Future<UserData> signInWithFacebook();
  /*--------------------------------------- signInWithApple ---*/
  // Future<UserData> signInWithApple(); // deaktiviert weil Apple Sign-In nicht implementiert ist und Account 99 USD p.a. kostet
  /*--------------------------------------- *** ---*/
}
