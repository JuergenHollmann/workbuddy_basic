import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/config/wb_imagebutton_no_text.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/authentication/screens/p00_registration_screen.dart';
import 'package:workbuddy/features/home/screens/main_selection_screen.dart';
// import 'package:workbuddy/shared/repositories/auth_repository.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_green_button.dart';

class P01LoginScreen extends StatefulWidget {
  const P01LoginScreen({super.key});

  @override
  State<P01LoginScreen> createState() => _P01LoginScreenState();
}

/*--------------------------------- User + Passwort ---*/
// return StreamBuilder(
// stream: context.read<AuthRepository>().authStateChanges(),
// builder: (context, snapshot) {
// return Container ();
// }, );

const String userName = "Jürgen";
const String userPassword = "Pass";
// bool visibilityPassword = false;
// bool loginButtonIsEnabled = false;

class _P01LoginScreenState extends State<P01LoginScreen> {
  /*--------------------------------- AudioPlayer ---*/
  // ACHTUNG: Beim player den sound OHNE "assets/...", sondern gleich mit "sound/..." eintragen (siehe unten):
  late AudioPlayer player = AudioPlayer();

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

  /*--------------------------------- Controller ---*/
  final TextEditingController userNameTEC = TextEditingController();
  final TextEditingController userPasswordTEC = TextEditingController();

  /*--------------------------------- onChanged-Funktion ---*/
  bool visibilityPassword = true;
  String inputUserName = ""; // nur für die "onChanged-Funktion"
  String inputPassword = ""; // nur für die "onChanged-Funktion"

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          /*--------------------------------- Image Logo ---*/
          const SizedBox(
            height: 120,
            width: 120,
            child: Image(
              image: AssetImage("assets/workbuddy_logo_neon_green_512x512.png"),
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
            "Bitte melde Dich an: $inputUserName",
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 0, 0)),
            textAlign: TextAlign.center,
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
          /*--------------------------------- Benutzername - Feld ---*/
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
            child: Container(
              decoration: ShapeDecoration(
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                  )
                ],
                // color: wbColor,
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
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: wbColorButtonGreen,
                ),
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                  /*--------------------------------- labelStyle ---*/
                  labelText: 'Benutzername',
                  labelStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.white,
                  ),
                  /*--------------------------------- prefixIcon ---*/
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      size: 40,
                      Icons.person,
                    ),
                  ),
                  /*--------------------------------- hintText ---*/
                  hintText: "Benutzername eingeben",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black38,
                  ),
                  /*--------------------------------- border ---*/
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                /*--------------------------------- onChanged ---*/
                controller: userNameTEC,
                onChanged: (String userNameTEC) {
                  log("0243 - p01_login_screen - Eingabe: $userNameTEC");
                  inputUserName = userNameTEC;
                  setState(() => inputUserName = userNameTEC);
                  if (userNameTEC == userName) {
                    /*--------------------------------- log ---*/
                    log("0249 - p01_login_screen - Der Benutzername \"$userName\" ist KORREKT 😉");
                    /*--------------------------------- Audio ---*/
                    /* Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist. */ //todo
                    player.play(AssetSource("sound/sound06pling.wav"));
                    /*--------------------------------- Snackbar ---*/
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
                    /*--------------------------------- *** ---*/
                  } else {
                    log("0274 - p01_login_screen - Die Eingabe für den Benutzername ist NICHT korrekt!");
                  }
                },
              ),
            ),
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
          /*--------------------------------- Passwort - Feld ---*/
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
            child: Container(
              decoration: ShapeDecoration(
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                  )
                ],
                // color: wbColor,
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
                  fontSize: 28,
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.white,
                  ),
                  /*--------------------------------- prefixIcon ---*/
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      size: 40,
                      Icons.lock,
                    ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        size: 40,
                        visibilityPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          wbSizedBoxHeight8,
          /*--------------------------------- Text ---*/
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
          WBGreenButton(
            onTap: () {
              /*--------------------------------- checkUserAndPassword ---*/
              log("0440 - P01LoginScreen - überprüfe Benutzer UND Passwort");
              if (userName == "Jürgen" && userPassword == "Pass") {
                log("0489 - P01LoginScreen - nach erfolgreicher Prüfung wechsle zur MainSelectionScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainSelectionScreen(),
                  ),
                );
              } else {
                /*--------------------------------- Snackbar ---*/
                log("Das Passwort oder der Benutzername sind nicht korrekt ... 😉");
                player.play(AssetSource("sound/sound03enterprise.wav"));
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
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight16,
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
                  wbColor: const Color.fromARGB(255, 209, 209, 209),
                  wbImage: Image(image: AssetImage("assets/logo_google.png")),
                  wbImagePadding: 8,
                  wbWidth60: 60,
                  wbHeight60: 60,
                  wbBorderRadius16: 16,
                  hasShadow: true,
                  wbOnTap: () {
                    log("0490 - P01LoginScreen - Google angeklickt");
                    /*--------------------------------- showDialog ---*/
                    showDialog(
                      context: context,
                      builder: (context) => const WbDialogAlertUpdateComingSoon(
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
                  wbColor: wbColorButtonBlue,
                  wbImage: Image(image: AssetImage("assets/logo_apple.png")),
                  wbImagePadding: 8,
                  wbWidth60: 60,
                  wbHeight60: 60,
                  wbBorderRadius16: 16,
                  hasShadow: true,
                  wbOnTap: () {
                    log("0508 - P01LoginScreen - Apple angeklickt");
                    /*--------------------------------- showDialog ---*/
                    showDialog(
                      context: context,
                      builder: (context) => const WbDialogAlertUpdateComingSoon(
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
                  wbColor: wbColorDrawerOrangeLight,
                  wbImage: Image(image: AssetImage("assets/logo_facebook.png")),
                  wbImagePadding: 8,
                  wbWidth60: 60,
                  wbHeight60: 60,
                  wbBorderRadius16: 16,
                  hasShadow: true,
                  wbOnTap: () {
                    log("0594 - P01LoginScreen - Facebook angeklickt");
                    /*--------------------------------- showDialog ---*/
                    showDialog(
                      context: context,
                      builder: (context) => const WbDialogAlertUpdateComingSoon(
                        headlineText: "Mit deinem Facebook-Account einloggen?",
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
                  wbColor: wbColorButtonGreen,
                  wbImage: Image(
                      image: AssetImage("assets/workbuddy_glow_logo.png")),
                  wbImagePadding: 8,
                  wbWidth60: 60,
                  wbHeight60: 60,
                  wbBorderRadius16: 16,
                  hasShadow: true,
                  wbOnTap: () {
                    log("0574 - P01LoginScreen - Workbuddy angeklickt");
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
          /*--------------------------------- WbButtonUniversal ---*/
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
            child: WbButtonUniversal2(
              wbColor: wbColorButtonDarkRed,
              wbIcon: Icons.report_outlined,
              wbIconSize40: 40,
              wbText: 'WorkBuddy beenden',
              wbFontSize24: 20,
              wbWidth155: 155, // hat hier keine Auswirkung
              wbHeight60: 60,
              wbOnTap: () {
                /*--------------------------------- AlertDialog ---*/
                // Abfrage ob die App geschlossen werden soll:
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const WBDialog2Buttons(
                          headLineText:
                              "Möchtest Du jetzt wirklich diese tolle WorkBuddy-App beenden?",
                          descriptionText:
                              "Bevor Du diese tolle WorkBuddy-App beendest, denke bitte daran:\n\n Bei aller Aufregung sollten wir aber nicht vergessen, dass Al Bundy im Jahr 1966 vier Touchdowns in einem Spiel gemacht hat und damit den den Polk High School Panthers zur Stadtmeisterschaft verholfen hat!\n\nAußerdem sollte man auf gesunde Ernährung achten, deshalb empfehle ich täglich ein gutes Käsebrot (für Vegetarier und Veganer natürlich auch gerne mit veganer Butter).\n\nWenn du keinen Käse magst, dann kannst du natürlich auch ein Wurstbrot essen, aber dann ist das logischerweise wiederum nicht vegan (aber es gibt ja auch vegane Wurst) und in diesem Falle kannst du eben auch die Wurst weglassen, wenn Du eine vegane Butter auf dem Brot hast. \n\nWarum schreibe ich das alles hier hin?\n\nGanz einfach:\nWeil ich zeigen wollte, dass diese Textzeilen SCROLLBAR sind.",
                        ));
                /*--------------------------------- AlertDialog ---*/
              },
            ),
          ),
          wbSizedBoxHeight24,
          /*--------------------------------- ENDE ---*/
        ],
      ),
    );
  }
}
