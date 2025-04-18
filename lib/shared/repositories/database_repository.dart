/* 
Momentan existieren 3 "class User" Modelle für userName und UserPasswort:
- lib/features/authentication/schema/user.dart;   <-- diese kann später gelöscht werden (Beispiel von Sobhi) --
- shared/data/user.dart';                         <-- diese kann später gelöscht werden --
- shared/data/user_data.dart';                    <-- diese wird benutzt --
*/

import 'package:workbuddy/shared/data/user_data.dart';

abstract class DatabaseRepository {
  /*--------------------------------------- Login ---*/
  /* Den User einloggen */
  Future<bool> login(String email, String userName, String password);
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
  /*--------------------------------------- signInWithEmailAndPassword ---*/
  Future<UserData> signInWithEmailAndPassword(String userName, String password);
  /*--------------------------------------- signInWithGoogle ---*/
  Future<UserData> signInWithGoogle();
  /*--------------------------------------- signInWithFacebook ---*/
  Future<UserData> signInWithFacebook();
  /*--------------------------------------- signInWithApple ---*/
  // Future<UserData> signInWithApple(); // deaktiviert weil Apple Sign-In nicht implementiert ist und Account 99 USD p.a. kostet
  /*--------------------------------------- *** ---*/
}
