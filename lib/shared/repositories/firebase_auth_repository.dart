/* FirebaseAuthRepository: lib/shared/repositories/firebase_auth_repository.dart

Momentan existieren 3 "class User" Modelle für userName und UserPasswort:
- lib/features/authentication/schema/user.dart;   <-- diese kann später gelöscht werden (Beispiel von Sobhi) --
- shared/data/user.dart';                         <-- diese kann später gelöscht werden --
- shared/data/user_data.dart';                    <-- diese wird benutzt --
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:workbuddy/shared/data/user_data.dart';
import 'package:workbuddy/shared/repositories/auth_repository.dart';


/*--------------------------------------- FirebaseAuthRepository ---*/
// Die Klasse FirebaseAuthRepository implementiert das Interface AuthRepository

class FirebaseAuthRepository implements AuthRepository {
  /*--------------------------------------- FirebaseAuth ---*/
  FirebaseAuth auth = FirebaseAuth.instance;
  /*--------------------------------------- authStateChanges ---*/
  Stream<UserData?> get authStateChanges => auth.authStateChanges().map((user) {
        if (user != null) {
          return UserData(
            userName: user.email ?? '',
            password: '',
          );
        }
        return null;
      });
/*--------------------------------------- getCurrentUser ---*/
  @override
  UserData get currentUser {
    final user = auth.currentUser;
    if (user != null) {
      return UserData(
        userName: user.email ??
            '', // Vorübergehend ist der userName die E-Mail-Adresse
        password: '',
      );
    }
    throw Exception('ACHTUNG: Es gibt aktuell keinen Benutzer!');
  }
/*--------------------------------------- login ---*/
  @override
  Future<bool> login(String userName, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: userName,
        password: password,
      );
    } catch (_) {
      return false;
    }
    return Future.value(true);
  }
/*--------------------------------------- createUser ---*/
  @override
  Future<String?> createUser(String userName, String password) async {
    try {
      final UserCredential credential =
          await auth.createUserWithEmailAndPassword(
        email: userName,
        password: password,
      );
      return credential.user?.uid;
    } catch (e) {
      rethrow;
    }
  }
/*--------------------------------------- deleteUser ---*/
  @override
  Future<String> deleteUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
        return user.uid;
      }
    } catch (e) {
      rethrow;
    }
    return '';
  }
/*--------------------------------------- editUser ---*/
  @override
  Future<void> editUser(UserData userData) async {
    try {
      User? user = auth.currentUser;
      if (user != null && user.email == userData.userName) {
        await user.verifyBeforeUpdateEmail(userData.userName);
        await user.updatePassword(userData.password);
      }
    } catch (e) {
      rethrow;
    }
  }
/*--------------------------------------- getUser ---*/
  @override
  Future<String> getUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        return user.uid;
      }
    } catch (e) {
      rethrow;
    }
    return '';
  }
/*--------------------------------------- logout ---*/
  @override
  Future<void> logout() async {
    await auth.signOut();
  }
/*--------------------------------------- getAllUsers ---*/
    @override
  Future<List<UserData>> getAllUsers() async {
    throw UnimplementedError('Die Methode "Alle Benutzer zeigen" ist noch nicht implementiert!');
  }
/*--------------------------------------- signInWithEmailAndPassword ---*/
  // @override
  // Future<UserData> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   final UserCredential credential =
  //       await auth.signInWithEmailAndPassword(email: email, password: password);
  //   final user = credential.user;
  //   if (user != null) {
  //     return UserData(
  //       userName: user.email ?? '',
  //       password: '',
  //     );
  //   }
  //   throw Exception('Das Login ist fehlgeschlagen!');
  // }
/*--------------------------------------- signInWithFacebook ---*/
  @override
  Future<UserData> signInWithFacebook() async {
    // todo: implement signInWithFacebook
    // final UserCredential credential = await auth.signInWithCredential(facebookAuthCredential);
    // final user = credential.user;
    // if (user != null) {
    //   return UserData(
    //     userName: user.email ?? '',
    //     password: '',
    //   );
    // }
    // throw Exception('Das Login ist fehlgeschlagen!');
    throw UnimplementedError(
        'Das Login mit deinem Facebook-Account ist noch nicht implementiert!');
  }
/*--------------------------------------- signInWithGoogle ---*/
  @override
  Future<UserData> signInWithGoogle() async {
    // todo: implement signInWithGoogle
    // final UserCredential credential = await auth.signInWithCredential(googleAuthCredential);
    // final user = credential.user;
    // if (user != null) {
    //   return UserData(
    //     userName: user.email ?? '',
    //     password: '',
    //   );
    // }
    // throw Exception('Das Login ist fehlgeschlagen!');
    throw UnimplementedError(
        'Das Login mit deinem Google-Account ist noch nicht implementiert!');
  }
  
  @override
  Stream<User?> get onAuthStateChanges => throw UnimplementedError();
  
  @override
  Future signInWithUserNameAndPassword({required String userName, required String password}) {
    throw UnimplementedError();
  }
  
  @override
  Future signInWithEmailAndPassword({required String email, required String password}) {
    throw UnimplementedError();
  }
}
