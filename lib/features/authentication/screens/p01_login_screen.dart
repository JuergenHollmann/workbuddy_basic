// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/config/wb_imagebutton_no_text.dart';
import 'package:workbuddy/config/wb_sizes.dart';
//import 'package:workbuddy/config/wb_textformfield_shadow_with_1_icon.dart';
import 'package:workbuddy/config/wb_textformfield_shadow_with_2_icons.dart';
import 'package:workbuddy/features/authentication/screens/p00_registration_screen.dart';
import 'package:workbuddy/features/home/screens/home_screen.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';

class P01LoginScreen extends StatefulWidget {
  const P01LoginScreen({super.key});

  @override
  State<P01LoginScreen> createState() => _P01LoginScreenState();
}

/*--------------------------------- User + Passwort ---*/
const String userName = "Jürgen";
const String userPassword = "Pass";
const String userEMail = "aa@bb.cc";

bool _visibilityPassword = false;
set visibilityPassword(bool value) {
  _visibilityPassword = value;
}

bool get visibilityPassword => _visibilityPassword;

/*--------------------------------- Button-Farbe beim Anklicken ändern ---*/
bool isButton01Clicked = false; // Login-Button
bool isButton02Clicked = false; // Login-NEU-Button
bool isButton03Clicked = false; // Google-Button
bool isButton04Clicked = false; // Apple-Button
bool isButton05Clicked = false; // Facebook-Button
bool isButton06Clicked = false; // WorkBuddy-Button
bool isButton07Clicked = false; // Beenden-Button

class _P01LoginScreenState extends State<P01LoginScreen> {
  /*--------------------------------- AudioPlayer ---*/
  // ACHTUNG: Beim player den sound OHNE "assets/...", sondern gleich mit "sound/..." eintragen (siehe unten):
  late AudioPlayer player = AudioPlayer();

  /*--------------------------------- Controller ---*/
  final userEmailController = TextEditingController();
  final userNameTEC = TextEditingController();
  final userPasswordTEC = TextEditingController();
  final currentUserController = TextEditingController();

  /*--- Den "CurrentUser" in den "SharedPreferences" speichern ---*/
  Future<void> _saveCurrentUser(String currentUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', currentUser);
    log('0051 - P01LoginScreen - Benutzername gespeichert: ---> $currentUser <---');
    if (currentUser.isEmpty) {
      currentUser = "Gast-User";
      await prefs.setString('currentUser', currentUser);
      log('0055 - P01LoginScreen - Benutzername wurde als ---> $currentUser <--- gespeichert');
    }
  }

  // Future<void> _loadCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final currentUser = prefs.getString('currentUser') ?? '';
  //   setState(() {
  //     currentUserController.text = currentUser;
  //     log('0059 - P01LoginScreen - Benutzername geladen: ---> ${currentUserController.text.characters} <---');
  //     log('0060 - P01LoginScreen - Benutzername geladen: ---> $currentUser <---');
  //   });
  // }
  // loadCurrentUser(currentUserController);

  // void _onLogin() {
  //   final currentUser = currentUserController.text;
  //   if (currentUser.isNotEmpty) {
  //     _saveCurrentUser(currentUser);
  //     log('0068 - P01LoginScreen - Benutzername gespeichert: $currentUser');
  //   } else {
  //     log('0070 - P01LoginScreen - Benutzername darf NICHT leer sein');
  //   }
  // }
  /*--------------------------------- GlobalKey ---*/
  // Brauchen wir, damit wir alle TextFormFields validieren können
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // // Das MockUserRepository ist im UserService definiert.
  // /*--------------------------------- userService ---*/
  // /* Das MockUserRepository ist im UserService definiert.
  //    Hier wird die login-Methode aufgerufen, um eine Antwort von unserem MockUserRepository zu erhalten. */
  // final userService = UserService();

  // /*--------------------------------- successMessage ---*/
  // /* Wenn das Login erfolgreich war, speichern wir die Nachricht in dieser Variable und zeigen sie auf dem Screen an. */
  // String? successMessage;

  // /*--------------------------------- errorMessage ---*/
  // /* Wenn das Login fehlgeschlagen ist, speichern wir die Nachricht in dieser Variable und zeigen sie auf dem Screen an. */
  // String? errorMessage;

  // /*--------------------------------- Loading State ---*/
  // bool isLoading = false;

  // /*--------------------------------- handleLogin ---*/
  // void handleLogin(BuildContext context) async {
  //   /* Hier setzen wir den State zurück. Falls der Nutzer vorher eine falsche Eingabe getätigt hat und z.B. die Fehlermeldung noch angezeigt wird, setzen wir den State zurück und zeigen das Lade-Symbol an. */
  //   setState(() {
  //     errorMessage = null;
  //     successMessage = null;
  //     isLoading = true;
  //   });

  //   /*--------------------------------- Server-Abfrage simmulieren ---*/
  //   /* Simulieren der Server-Abfrage.
  //   Hier erhält man ein "ServerUserResponse", das die folgenden Daten enthält:
  //   --> siehe mock_user_repository.dart

  //       • User?         --> Wenn die Abfrage erfolgreich war, wird ein User mitgegeben
  //       • success       --> Gibt an, ob die Abfrage erfolgreich war
  //       • errorMessage? --> Wenn die Abfrage nicht erfolgreich war, kann eine Fehlermeldung mitgegeben werden.

  //   Wo wird die E-Mail und das Passwort übergeben?
  //   Die Controller für die Textfelder sind im UserService definiert:
  //       --> E-Mail- und Passwort-TextField.
  //       --> Dort werden die TextEditingController vom UserService übergeben.
  //       --> Somit können wir aus der "login"-Methode direkt den Text abrufen. */

  //   ServerUserResponse response = await userService.login();

  //   /*--------------------------------- erfolgreiche Abfrage ---*/
  //   // Wenn die Abfrage erfolgreich war:
  //   if (response.success) {
  //     /* Überprüfen ob der User ein Admin ist:
  //        • Wenn Ja:   "Willkommen Admin" anzeigen
  //        • Wenn Nein: "Willkommen User" anzeigen */
  //     setState(() => successMessage =
  //         "Willkommen ${response.user!.isAdmin ? "Admin" : "User"}");

  //     // Wir zeigen die Erfolgsmeldung 1 Sekunde an und navigieren auf unseren User-Screen:
  //     await Future.delayed(const Duration(seconds: 1));

  //     /* Navigation zum User-Screen:
  //       Hinweis: Auch hier verwenden wir eine separate Funktion, da diese Funktion mit async markiert ist und Flutter es nicht mag, den BuildContext innerhalb einer async-Funktion zu nutzen.
  //     Information: Schaue dir die Funktion "navigateToUserScreen" an, die benötigt nämlich den context. */
  //     navigateToUserScreen(response.user!);
  //   } else {
  //     // Wenn die Abfrage nicht erfolgreich war, wird die Fehlermeldung vom Server in unsere lokale Variable gesetzt, um sie auf dem Screen anzuzeigen:
  //     setState(() => errorMessage = response.errorMessage);
  //   }
  //   setState(() => isLoading = false);
  // }

  // // Navigieren zum User-Screen und den eingeloggten User übergeben:
  // void navigateToUserScreen(User user) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => UserScreen(user: user)));
  // }
  // /*--------------------------------- MockUserRepository ENDE ---*/

  /*--------------------------------- bool-Funktionen ---*/
  bool visibilityPassword = true;

  bool isEmailFieldSelected = false;
  bool isUserNameFieldSelected = false;

  bool showDescriptionText = true;
  bool showEMailField = true;
  bool showUserNameField = true;
  bool showUserPasswordField = false;
  bool showPasswordForgotten = false;

  void toggleFields() {
    setState(() {
      showDescriptionText = !showDescriptionText;
      showEMailField = !showEMailField;
      showUserNameField = !showUserNameField;
      showUserPasswordField = !showUserPasswordField;
      showPasswordForgotten = !showPasswordForgotten;
    });
  }

  /*--------------------------------- onChanged-Funktion ---*/
  String inputUserName = ""; // nur für die "onChanged-Funktion"
  String inputPassword = ""; // nur für die "onChanged-Funktion"

  /* Eine Variable, die den Zustand der Seite repräsentiert zum Zurücksetzen und Aktualisieren der Seite (refreshPage) */
  int _counter = 0;

  /* Methode zum Zurücksetzen und Aktualisieren der Seite */
  void _refreshPage() {
    setState(() {
      _counter = 0; // Setze den Zähler zurück oder führe andere Aktionen durch
      log('0189 - P01LoginScreen - refreshPage()');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 231, 254),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            /*--------------------------------- Image Logo ---*/
            const SizedBox(
              height: 120,
              width: 120,
              child: Image(
                image:
                    AssetImage("assets/workbuddy_logo_neon_green_512x512.png"),
              ),
            ),
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: Colors.blue),
            /*--------------------------------- Text ---*/
            const Text(
              "Herzlich willkommen bei",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 0, 80, 220)),
              textAlign: TextAlign.center,
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Image ---*/
            const Image(
                image: AssetImage("assets/workbuddy_glow_schriftzug.png")),
            /*--------------------------------- Text ---*/
            const Text(
              "\"save time and money!\"",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 0, 80, 220)),
              textAlign: TextAlign.center,
            ),
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: Colors.blue),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Text ---*/
            Text(
              "Bitte melde Dich an $inputUserName",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 255, 0, 0)),
              textAlign: TextAlign.center,
            ),
            /*--------------------------------- wenn showDescriptionText true ist ---*/
            if (showDescriptionText)
              Text(
                  'Entweder mit deiner E-Mail-Adresse\noder mit deinem Benutzernamen',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 0, 80, 220),
                  ),
                  textAlign: TextAlign.center),
            if (showDescriptionText) wbSizedBoxHeight8,
            /*--------------------------------- wenn isEmailFieldSelected true ist ---*/
            if (isEmailFieldSelected)
              Text(
                'Mit deiner E-Mail-Adresse',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.center,
              ),
            /*--------------------------------- wenn isEmailFieldSelected true ist ---*/
            if (isUserNameFieldSelected)
              Text(
                'Mit deinem Benutzernamen',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.center,
              ),
            /*--------------------------------- E-Mail-Adresse ---*/
            if (showEMailField)
              WbTextFormFieldShadowWith2Icons(
                labelText: 'E-Mail-Adresse',
                prefixIcon: Icons.email_rounded,
                prefixIconSize32: 32,
                hintText:
                    '${context.watch<CurrentUserProvider>().currentUser} war angemeldet',
                textInputTypeOnKeyboard: TextInputType.emailAddress,
                controller: userEmailController,
                /*--------------------------------- suffixIcon ---*/
                suffixIcon: Icons.replay, // oder: .front_hand_outlined
                suffixIconSize32: 32,
                /*--- onTap = wenn direkt in das Textfeld geklickt wird ---*/
                onTap: () {
                  toggleFields;
                  setState(() {
                    log('0299 - P01LoginScreen - onTap ==> E-Mail-Adresse - "setState"');
                    showDescriptionText = false;
                    showEMailField = true;
                    showUserNameField = false;
                    showUserPasswordField = true;
                    showPasswordForgotten = true;
                    isEmailFieldSelected = true;
                    isUserNameFieldSelected = false;

                    /* Die Farbe mit "focusNode" in diesem Textformfield ändern - todo 0267 - P01LoginScreen */
                    // fillColor: Colors.yellow ?? Colors.white,
                    // das Passwort wird sichtbar oder unsichtbar gemacht
                    // visibilityPassword = !visibilityPassword;
                    //   visibilityPassword
                    //       ? Icons.visibility_outlined
                    //       : Icons.visibility_off_outlined,
                    // ),
                  });
                },
              ),

            //       /*--------------------------------- onChanged ---*/
            //       controller: userEmailController,
            //       onChanged: (String userEmailController) {
            //         log("0284 - p01_login_screen - Eingabe: $userEmailController");
            //         userEMail = userEmailController;
            //         setState(() => userEMail = userEmailController);
            //         if (userEmailController == userEMail) {
            //           /*--------------------------------- log ---*/
            //           log("0289 - p01_login_screen - Die E-Mail-Adresse \"$userEMail\" ist KORREKT 😉");
            //           /*--------------------------------- Audio ---*/
            //           /* Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist. */ //todo
            //           player.play(AssetSource("sound/sound06pling.wav"));
            //           /*--------------------------------- Snackbar ---*/
            //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //             backgroundColor: wbColorButtonGreen,
            //             duration: Duration(milliseconds: 400),
            //             content: Text(
            //               "Hinweis:\nDie E-Mail-Adresse \"$userEMail\" ist KORREKT 😉",
            //               style: TextStyle(
            //                 fontSize: 28,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ));
            //           /*--------------------------------- *** ---*/
            //         } else {
            //           log("0308 - p01_login_screen - Die Eingabe für die E-Mail-Adresse ist NICHT korrekt!");
            //         }
            //       },
            //     ),
            //   ),
            // ),

            /*--------------------------------- Abstand ---*/
            if (!showPasswordForgotten) wbSizedBoxHeight16,
            /*--------------------------------- Text in Consumer<CurrentUserProvider> ---*/
            // Consumer<CurrentUserProvider>(
            //   builder: (context, value, child) {
            //     return Text(
            //       'Zuvor angemeldete E-Mail-Adresse: ${value.currentUser}',
            //       textAlign: TextAlign.center,
            //     );
            //   },
            // ),
            /*--------------------------------- Benutzername ---*/
            if (showUserNameField)
              WbTextFormFieldShadowWith2Icons(
                labelText: 'Benutzername',
                //textInputAction:TextInputAction.next,
                hintText: 'Benutzername eingeben',
                hintTextFontSize16: 18,
                prefixIcon: Icons.person,
                prefixIconSize32: 32,
                suffixIcon: Icons.replay,
                suffixIconSize32: 32,
                controller: userNameTEC,
                onTap: () {
                  toggleFields;
                  setState(() {
                    log('0455 - P01LoginScreen - onTap ==> Benutzername - "setState" stellt die Variable "isEmailFieldSelected" auf "false"');
                    showDescriptionText = false;
                    showEMailField = false;
                    showUserNameField = true;
                    showUserPasswordField = true;
                    showPasswordForgotten = true;
                    isEmailFieldSelected = false;
                    isUserNameFieldSelected = true;
                    // _visibleEmailField = false;
                    // _visibleUserNameField = true;
                  });
                },
                onChanged: (String userNameTEC) {
                  log("0460 - P01LoginScreen - Eingabe: $userNameTEC");
                  inputUserName = userNameTEC;
                  setState(() => inputUserName = userNameTEC);
                  if (userNameTEC == userName) {
                    log("0464 - P01LoginScreen - Der Benutzername \"$userName\" ist KORREKT 😉");
                    player.play(AssetSource("sound/sound06pling.wav"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: wbColorButtonGreen,
                      duration: Duration(milliseconds: 400),
                      content: Text(
                        "Hinweis:\nDer Benutzername \"$userName\" ist KORREKT 😉",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ));
                  } else {
                    log("0479 - P01LoginScreen - Die Eingabe für den Benutzername ist NICHT korrekt!");
                  }
                },
              ),
            /*--------------------------------- Abstand ---*/
            if (!showPasswordForgotten) wbSizedBoxHeight16,
            if (showPasswordForgotten) wbSizedBoxHeight8,
            /*--------------------------------- Funktionen für den Text ---*/
            if (isEmailFieldSelected) ...[
              Text(
                '... und deinem Passwort  ⬇️',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.center,
              )
            ] else if (isUserNameFieldSelected) ...[
              Text(
                '... und deinem Passwort  ⬇️',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.center,
              )
            ],
            // /*--------------------------------- Passwort - deaktiviert (siehe unten) ---*/
            // WbTextFormFieldShadowWith2Icons(
            //   labelText: 'Passwort',
            //   hintText: 'Passwort',
            //   prefixIcon: Icons.lock,
            //   prefixIconSize32: 32,
            //   suffixIcon: Icons.visibility_off_outlined,
            //   suffixIconSize32: 32,
            // ),
            /*--------------------------------- Abstand ---*/
            if (showPasswordForgotten) wbSizedBoxHeight8,
            /*--------------------------------- Passwort - hier nicht als CustomWidget ---*/
            /* Weil das "suffixIcon" in der "WbTextFormFieldShadowWith2Icons" Klasse ist, kann ich es momentan nicht beim Anklicken austauschen, deshalb benutze ich hier nicht das CustomWidget, sondern schreibe alles einzeln hier rein. */
            if (showUserPasswordField)
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
                child: Container(
                  height: 52,
                  decoration: ShapeDecoration(
                    shadows: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                        spreadRadius: 0,
                      )
                    ],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: wbColorButtonDarkRed,
                    ),
                    textAlign: TextAlign.left,
                    textInputAction: TextInputAction.next,
                    obscureText: visibilityPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      /*--------------------------------- labelStyle ---*/
                      labelText: 'Passwort',
                      labelStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: wbColorAppBarBlue,
                        backgroundColor: Colors.white,
                      ),
                      /*--------------------------------- prefixIcon ---*/
                      prefixIcon: Icon(
                        size: 32,
                        Icons.lock,
                      ),
                      /*--------------------------------- hintText ---*/
                      hintText: "Passwort eingeben",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black38,
                      ),
                      /*--------------------------------- suffixIcon ---*/
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            visibilityPassword = !visibilityPassword;
                          });
                        },
                        child: Icon(
                          size: 32,
                          visibilityPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      /*--------------------------------- border ---*/
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    /*--------------------------------- onChanged ---*/
                    onChanged: (String userPasswordTEC) {
                      log("Eingabe: $userPasswordTEC");
                      inputPassword = userPasswordTEC;
                      setState(() => inputPassword = userPasswordTEC);
                      if (userPasswordTEC == userPassword &&
                          inputUserName == userName) {
                        log("Das Passwort \"$userPassword\" ist KORREKT!");
                        /*--------------------------------- Audio ---*/
                        /* Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist. */ //todo
                        player.play(AssetSource("sound/sound06pling.wav"));
                        /*--------------------------------- Snackbar ---*/
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: wbColorButtonGreen,
                          duration: Duration(milliseconds: 500),
                          content: Text(
                            "Hinweis:\nDas Passwort \"$userPassword\" ist KORREKT 😉",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ));
                        // /*--------------------------------- checkUserAndPassword ---*/
                        // } else if (userName == "Jürgen" && userPassword == "Pass") {
                        //   // userPasswordTEC
                        log("0435 - P01LoginScreen - nach erfolgreicher Prüfung wechsle zur MainSelectionScreen");
                        /* Den Zustand vom MainSelectionScreen aktualisieren */
                        // Navigator.pushReplacement( // nicht mit "Navigator.pushReplacement", sondern mit "Navigator.push" da sonst der "Zurück-Button" nicht mehr funktioniert!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainSelectionScreen(),
                          ),
                        );
                      } else {
                        log("Die Eingabe für das Passwort ist NICHT korrekt!");
                      }
                    },
                    /*--------------------------------- validator ---*/
                    validator: (userPassword) {
                      // Password wurde nicht ausgefüllt:
                      if (userPassword == null) {
                        // return "Bitte Passwort angeben";
                        log("Password wurde nicht ausgefüllt");
                      } else if (userPassword == "Pass") {
                        // } else if (userPassword == userPasswordTEC) {
                        // return "Passwort ist korrekt";
                        log("Password ist korrekt");
                      }
                      // Passwort und Benutzername sind beide korrekt:
                      return null;
                    },
                  ),
                ),
              ),
            /*--------------------------------- Abstand ---*/
            if (showPasswordForgotten) wbSizedBoxHeight8,
            /*--------------------------------- Text ---*/
            if (showPasswordForgotten)
              const Text(
                "Passwort vergessen?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonDarkRed,
                ),
                textAlign: TextAlign.right,
              ),
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: wbColorButtonGreen),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Login-Button ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
              child: WbButtonUniversal2(
                wbColor: isButton01Clicked
                    ? wbColorButtonDarkRed
                    : wbColorButtonGreen,
                wbOnTapDown: (details) {
                  setState(() {
                    isButton01Clicked = true;
                  });
                },
                wbOnTapUp: (details) {
                  setState(() {
                    isButton01Clicked = false;
                  });
                },
                wbOnTapCancel: () {
                  setState(() {
                    isButton01Clicked = false;
                  });
                },
                wbIcon: Icons.input_outlined,
                wbIconSize40: 40,
                wbText: '       Login',
                wbFontSize24: 34,
                wbWidth155: 155, // hat hier keine Auswirkung, weil die Breite des Buttons durch die das "Padding" bestimmt wird
                wbHeight60: 60,

                wbOnTap: () async { // WBGreenButton war hier vorher mit einer Funktion "final VoidCallback onTap" definiert;
                  /* Den Zustand des CurrentUserProvider aktualisieren */
                  context
                      .read<CurrentUserProvider>()
                      .currentUser; // funzt nicht 0616 - P01LoginScreen

                  /* Den eingetragenen Benutzer in den SharedPreferences speichern */
                  currentUserController.text = userNameTEC.text;
                  _saveCurrentUser(currentUserController.text);
                  log('0486 - P01LoginScreen - Speichere den Benutzernamen ---> ${currentUserController.text} <--- in den SharedPreferences');

                  /* Wenn kein Benutzer eingetragern ist, soll ein "Gast-User" in den SharedPreferences gespeichert werden */
                  if (currentUserController.text.isEmpty) {
                    final prefs = await SharedPreferences.getInstance();
                    currentUserController.text = "Gast-User";
                    await prefs.setString(
                        'currentUser', currentUserController.text);
                    log('0489 - P01LoginScreen - KEIN Benutzername eingetragen, deswegen wurde ein ---> ${currentUserController.text} <--- gespeichert.');
                  }

                  /* Den currentUser nach Anklicken auf den "Login-Button" laden */
                  context.read<CurrentUserProvider>().loadCurrentUser();

                  /*--------------------------------- checkUserAndPassword ---*/
                  log("0440 - P01LoginScreen - überprüfe Benutzer UND Passwort");
                  if (userName == "Jürgen" && userPassword == "Pass") {
                    log("0489 - P01LoginScreen - nach erfolgreicher Prüfung wechsle zur MainSelectionScreen");

                    /* Den Zustand vom MainSelectionScreen aktualisieren */
                    /* NICHT mit "Navigator.pushReplacement", da sonst der "Zurück-Button" nicht mehr funktioniert! */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainSelectionScreen(),
                      ),
                    );
                  } else {
                    /*--------------------------------- Snackbar (Toast) ---*/
                    log("Das Passwort oder der Benutzername sind nicht korrekt ... 😉");
                    player.play(AssetSource("sound/sound03enterprise.wav"));
                    /*--------------------------------- Snackbar / Toast ---*/
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: wbColorButtonDarkRed,
                      content: Text(
                        "Hinweis:\nDas Passwort oder der Benutzername sind NICHT korrekt ... 😉",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ));
                    /*--------------------------------- *** ---*/
                  }
                },
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Refresh / Reset = Login "NEU" starten ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
              child: WbButtonUniversal2(
                wbColor: isButton02Clicked
                    ? wbColorButtonDarkRed
                    : wbColorButtonBlue,
                wbOnTapDown: (details) {
                  setState(() {
                    isButton02Clicked = true;
                  });
                },
                wbOnTapUp: (details) {
                  setState(() {
                    isButton02Clicked = false;
                  });
                },
                wbOnTapCancel: () {
                  setState(() {
                    isButton02Clicked = false;
                  });
                },
                wbIcon: Icons.replay,
                wbIconSize40: 40,
                wbText: 'Login "NEU" starten',
                wbFontSize24: 20,
                wbWidth155: 155,
                wbHeight60: 60,
                wbOnTap: () {
                  log('0703 - P01LoginScreen - onPressed: Reset $_counter');
                  /*--------------------------------- Navigator.push ---*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WbHomePage(
                        title: 'WorkBuddy • save time and money!',
                        preferencesRepository: SharedPreferencesRepository(),
                      ),
                    ),
                  );
                  // /*--------------------------------- Navigator.push - ENDE ---*/
                },
              ),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Divider ---*/
            WbDividerWithTextInCenter(
              wbColor: wbColorButtonGreen,
              wbText: "Login mit deinem Account?",
              wbTextColor: wbColorButtonGreen,
              wbFontSize12: 16,
              wbHeight3: 4,
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- Login mit Google ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
              child: Row(children: [
                Expanded(
                  child: WbImageButtonNoText(
                    wbColor: isButton02Clicked
                        ? wbColorButtonDarkRed
                        : Color.fromARGB(255, 209, 209, 209),
                    wbOnTapDown: (details) {
                      setState(() {
                        isButton02Clicked = true;
                      });
                    },
                    wbOnTapUp: (details) {
                      setState(() {
                        isButton02Clicked = false;
                      });
                    },
                    wbOnTapCancel: () {
                      setState(() {
                        isButton02Clicked = false;
                      });
                    },
                    wbImage: Image(image: AssetImage("assets/logo_google.png")),
                    wbImagePadding: 8,
                    wbWidth60: 60,
                    wbHeight60: 60,
                    wbBorderRadius16: 16,
                    hasShadow: true,
                    wbOnTap: () {
                      log("0761 - P01LoginScreen - Google angeklickt");
                      /*--------------------------------- showDialog ---*/
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "Mit deinem Google-Account einloggen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate LS-0495",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- showDialog ENDE ---*/
                    },
                  ),
                ),
                /*--------------------------------- Abstand ---*/
                SizedBox(width: 24),
                /*--------------------------------- Login mit Apple ---*/
                Expanded(
                  child: WbImageButtonNoText(
                    wbColor: isButton03Clicked
                        ? wbColorButtonDarkRed
                        : wbColorButtonBlue,
                    wbOnTapDown: (details) {
                      setState(() {
                        isButton03Clicked = true;
                      });
                    },
                    wbOnTapUp: (details) {
                      setState(() {
                        isButton03Clicked = false;
                      });
                    },
                    wbOnTapCancel: () {
                      setState(() {
                        isButton03Clicked = false;
                      });
                    },
                    wbImage: Image(image: AssetImage("assets/logo_apple.png")),
                    wbImagePadding: 8,
                    wbWidth60: 60,
                    wbHeight60: 60,
                    wbBorderRadius16: 16,
                    hasShadow: true,
                    wbOnTap: () {
                      log("0807 - P01LoginScreen - Apple angeklickt");
                      /*--------------------------------- showDialog ---*/
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "Mit deinem Apple-Account einloggen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate LS-0573",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- showDialog ENDE ---*/
                    },
                  ),
                ),
                /*--------------------------------- Abstand ---*/
                SizedBox(width: 24),
                /*--------------------------------- Login mit Facebook ---*/
                Expanded(
                  child: WbImageButtonNoText(
                    wbColor: isButton04Clicked
                        ? wbColorButtonDarkRed
                        : wbColorDrawerOrangeLight,
                    wbOnTapDown: (details) {
                      setState(() {
                        isButton04Clicked = true;
                      });
                    },
                    wbOnTapUp: (details) {
                      setState(() {
                        isButton04Clicked = false;
                      });
                    },
                    wbOnTapCancel: () {
                      setState(() {
                        isButton04Clicked = false;
                      });
                    },
                    wbImage:
                        Image(image: AssetImage("assets/logo_facebook.png")),
                    wbImagePadding: 8,
                    wbWidth60: 60,
                    wbHeight60: 60,
                    wbBorderRadius16: 16,
                    hasShadow: true,
                    wbOnTap: () {
                      log("0854 - P01LoginScreen - Facebook angeklickt");
                      /*--------------------------------- showDialog ---*/
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText:
                              "Mit deinem Facebook-Account einloggen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate LS-0601",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- showDialog ENDE ---*/
                    },
                  ),
                ),
                /*--------------------------------- Abstand ---*/
                SizedBox(width: 24),
                /*--------------------------------- Login intern mit WorkBuddy ---*/
                Expanded(
                  child: WbImageButtonNoText(
                    wbColor: isButton06Clicked
                        ? wbColorButtonDarkRed
                        : wbColorButtonGreen,
                    wbOnTapDown: (details) {
                      setState(() {
                        isButton06Clicked = true;
                      });
                    },
                    wbOnTapUp: (details) {
                      setState(() {
                        isButton06Clicked = false;
                      });
                    },
                    wbOnTapCancel: () {
                      setState(() {
                        isButton06Clicked = false;
                      });
                    },
                    wbImage: Image(
                        image: AssetImage("assets/workbuddy_glow_logo.png")),
                    wbImagePadding: 8,
                    wbWidth60: 60,
                    wbHeight60: 60,
                    wbBorderRadius16: 16,
                    hasShadow: true,
                    wbOnTap: () {
                      log("0902 - P01LoginScreen - WorkBuddy angeklickt");
                      // /*--- StreamBuilder auslesen ---*/
                      //                     StreamBuilder(
                      //                       stream: context.read<AuthRepository>().authStateChanges(),
                      //                       // stream: context.read<AuthRepository>().login(userName: $userName, userPassword: $userPassword),
                      //                       builder: (context, snapshot) {
                      //                         return Container();
                      //                       },
                      //                     );
                      // /*--- StreamBuilder ENDE ---*/
                      /*--------------------------------- showDialog ---*/
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => const WbDialogAlertUpdateComingSoon(
                      //     headlineText:
                      //         "Mit deinem INTERNEN WorkBuddy-Account einloggen?",
                      //     contentText:
                      //         "HINWEIS: Für deinen INTERNEN WorkBuddy-Account wird keine Internet-Verbindung benötigt.\n\nDeine Daten werden NUR INTERN in einer Datenbank auf deinem Smartphone gespeichert.\n\nEs gibt auch keine weitere automatische Datensicherung!\n\nSpäter können diese Daten aber durch eine Registrierung und Synchronisierung über das Internet gesichert werden. \n\nDiese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate LS-0555",
                      //     actionsText: "OK 👍",
                      //   ),
                      // );
                      /*--------------------------------- showDialog ENDE ---*/
                    },
                  ),
                ),
              ]),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight16,
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: wbColorButtonGreen),
            /*--------------------------------- Text ---*/
            GestureDetector(
              onTap: () {
                log("0532 - P01Loginscreeen - zum P00RegistrationScreen gehen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const P00RegistrationScreen(
                        //startGroupValue: "Ausgabe",
                        ),
                  ),
                );
              },
              child: const Text(
                "Neuer Benutzer? Hier registrieren ... ➡️",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: wbColorButtonGreen),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight8,
            /*--------------------------------- WorkBuddy beenden ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
              child: WbButtonUniversal2(
                  wbColor:
                      isButton07Clicked ? Colors.yellow : wbColorButtonDarkRed,
                  wbOnTapDown: (details) {
                    setState(() {
                      isButton07Clicked = true;
                    });
                  },
                  wbOnTapUp: (details) {
                    setState(() {
                      isButton07Clicked = false;
                    });
                  },
                  wbOnTapCancel: () {
                    setState(() {
                      isButton07Clicked = false;
                    });
                  },
                  wbIcon: Icons.report_outlined,
                  wbIconSize40: 40,
                  wbText: 'WorkBuddy beenden',
                  wbFontSize24: 20,
                  wbWidth155: 155, // hat hier keine Auswirkung
                  wbHeight60: 60,
                  wbOnTap: () {
                    log('0996 - P01LoginScreen - "WorkBuddy beenden" wurde angeklickt');
                    /*--------------------------------- AlertDialog - START ---*/
                    /* Abfrage ob die App geschlossen werden soll */
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => WBDialog2Buttons(
                        headLineText:
                            // 'Hey ${value.currentUser},\nmöchtest Du jetzt die WorkBuddy-App beenden?',
                            'Möchtest Du jetzt die WorkBuddy-App beenden?',
                        descriptionText:
                            'Falls Du Fragen, konstruktive Kritik oder Verbesserungsvorschläge hast, kannst Du den Entwickler gerne direkt anrufen oder eine E-Mail schreiben.\n\nDie Kontaktdaten: \n  • JOTHAsoft • Jürgen Hollmann\n  • Telefon: 0178-9897-193\n  • E-Mail: JOTHAsoft@gmail.com',
                        // 'Wenn die App hier beendet wird, musst Du dich später wieder einloggen.\n\nWenn Du WorkBuddy im Hintergrund einfach weiterlaufen läßt, hast Du schnelleren Zugriff auf deine Daten.',
                        wbText2: "Ja • Beenden",
                        wbOnTap2: () {
                          Navigator.of(context).pop();
                          log('0185 - WbNavigationbar - Button 2 wurde angeklickt');

                          /*--------------------------------- Snackbar ---*/
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: wbColorOrangeDarker,
                            content: Text(
                              "Danke für das Benutzen der WorkBuddy-App ... 😉",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ));

                          /*--------------------------------- *** ---*/
                          log('1025 - P01LoginScreen - App wird beendet ...');
                          /*--- Noch 2 Sekunden warten, bevor die App beendet wird ---*/
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              FlutterExitApp.exitApp(iosForceExit: true);
                            },
                          );
                          /*--------------------------------- *** ---*/
                        },
                      ),
                    );
                    /*--------------------------------- AlertDialog ENDE ---*/

                    // /*--------------------------------- AlertDialog ---*/
                    // /* Abfrage ob die App geschlossen werden soll */
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) =>
                    //         const WBDialog2Buttons(
                    //           headLineText:
                    //               //"Hey ${value.currentUser.currentUserName},\n
                    //               'Möchtest Du jetzt wirklich diese tolle WorkBuddy-App beenden?',
                    //           descriptionText:
                    //               "Bevor Du diese tolle WorkBuddy-App beendest, denke bitte daran:\n\n Bei aller Aufregung sollten wir aber nicht vergessen, dass Al Bundy im Jahr 1966 vier Touchdowns in einem Spiel gemacht hat und damit den den Polk High School Panthers zur Stadtmeisterschaft verholfen hat!\n\nAußerdem sollte man auf gesunde Ernährung achten, deshalb empfehle ich täglich ein gutes Käsebrot (für Vegetarier und Veganer natürlich auch gerne mit veganer Butter).\n\nWenn du keinen Käse magst, dann kannst du natürlich auch ein Wurstbrot essen, aber dann ist das logischerweise wiederum nicht vegan (aber es gibt ja auch vegane Wurst) und in diesem Falle kannst du eben auch die Wurst weglassen, wenn Du eine vegane Butter auf dem Brot hast. \n\nWarum schreibe ich das alles hier hin?\n\nGanz einfach:\nWeil ich zeigen wollte, dass diese Textzeilen SCROLLBAR sind.",
                    //         ));
                    // /*--------------------------------- AlertDialog ---*/
                  }),
            ),
            /*--------------------------------- Abstand ---*/
            wbSizedBoxHeight16,
            /*--------------------------------- Divider ---*/
            const Divider(thickness: 4, color: wbColorButtonGreen),
            /*--------------------------------- ENDE ---*/
          ],
        ),
      ),
    );
  }
}
