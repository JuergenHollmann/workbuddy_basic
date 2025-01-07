import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/features/home/screens/home_screen.dart';
import 'package:workbuddy/firebase_options.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_date_provider.dart';
import 'package:workbuddy/shared/providers/current_day_long_provider.dart';
import 'package:workbuddy/shared/providers/current_day_short_provider.dart';
import 'package:workbuddy/shared/providers/current_time_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/auth_repository.dart';
import 'package:workbuddy/shared/repositories/database_repository.dart';
import 'package:workbuddy/shared/repositories/firebase_auth_repository.dart';
import 'package:workbuddy/shared/repositories/mock_database.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*--------------------------------- Repositories ---*/
  final DatabaseRepository databaseRepository = MockDatabase();
  final AuthRepository authRepository = FirebaseAuthRepository();

  /*--- Alle Providers sind vorläufig im Ordner "lib/shared/providers" oder werden später dahin kopiert ---*/
  runApp(MultiProvider(
    providers: [
      Provider<DatabaseRepository>(create: (_) => databaseRepository),
      Provider<AuthRepository>(create: (_) => authRepository),
      ChangeNotifierProvider(create: (context) => CurrentAppVersionProvider()),
      ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
      ChangeNotifierProvider(create: (context) => CurrentDayLongProvider()),
      ChangeNotifierProvider(create: (context) => CurrentDayShortProvider()),
      ChangeNotifierProvider(create: (context) => CurrentDateProvider()),
      ChangeNotifierProvider(create: (context) => CurrentTimeProvider()),
    ],
    child: MainApp(
      databaseRepository: databaseRepository,
      authRepository: authRepository,
    ),
  ));
}

/*--------------------------------- MainApp ---*/
class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  /*--------------------------------- *** ---*/
  final String appTitle = 'WorkBuddy • save time and money!';
  /*--------------------------------- *** ---*/

  @override
  Widget build(BuildContext context) {
    log("0015 - MainApp - wird gestartet");

    /*--- Datum formatieren auf DE = Deutschland ---*/
    initializeDateFormatting('de', null);

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: <Locale>[
      //   Locale('de', 'DE'),
      // ],
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: WbHomePage(
        title: appTitle,
        preferencesRepository: SharedPreferencesRepository(),
      ),
    );
  }
}
/*--------------------------------- Projekt 21: Provider ---
  1) Provider
  √ Implementiere Provider in deiner App.
  √ Entferne alle Klassenattribute und Parameter aus allen Widgets, die Repositories entgegennehmen und speichern.
  Nutze stattdessen Provider, um deine Repositories zu holen und zu verwenden.
  Hinweis: Folge der Anleitung aus der Vorlesung und nutze den Code der Batch App als Hilfe!
  Wie sieht dein Code aus, um Repositories zur Verfügung zu stellen und zu verwenden?

  /*--------------------------------- Projekt 20: Firebase Auth ---
  1) AuthRepository
  √ Implementiere ein AuthRepository in deiner App.
  Dieses soll Methoden bieten, um an einen Benutzer zu kommen
  und Benutzer zu registrieren und anzumelden.
  Implementiere außerdem ein MockAuthRepository, das das AuthRepository implementiert
  und den Login etc. ermöglicht.
  Hinweis: Nutze die Anleitung im Classroom und den Code der Beispiel-App!
  Hinweis: Wenn du bereits ein Repository für Login und Registrierung nutzt,
  musst du nur den Code dafür kopieren.
  Erzeuge dann an der Wurzel deiner App eine Instanz dieser Klasse
  und reiche sie durch den Widget Tree an alle Widgets (Screens) weiter,
  die sie benötigen (z.B. zum Login oder Logout).
  Nutze die Funktionen deines AuthRepository nun in deinen Screens.
  Wie sieht dein AuthRepository und dein MockAuthRepository aus? Kopiere den Code.
  Deine Antwort:

  2) Binde nun Firebase Auth ein.
  Baue dies in ein FirebaseAuthRepository ein, das AuthRepository implementiert.
  In diesem sollst du FirebaseAuth verwenden.
  Ermögliche es, dass der Benutzer sich einloggt.
  Reagiere außerdem im FirebaseAuthRepository auf den Stream authStateChanges
  und gib die Benutzerdaten weiter.
  Reagiere in der UI mit einem StreamBuilder, sodass du deine Nutzer je nach Login-Status
  auf den LoginScreen bzw. deinen Hauptscreen leiten kannst.
  Hinweis: Nutze die Anleitung im Classroom und den Code der Beispiel-App!
  Wie sieht dein Code jetzt aus? Kopiere ihn in das Antwortfeld.

* Firebase:
  √ für iOS muss im ios/Podfile     ---> platform :ios, '13.0'  eingestellt werden √ 
  √ für macOS muss im macos/Podfile ---> platform :osx, '10.15' eingestellt werden √ 

  /*--------------------------------- TODO's ---
  - Zustimmung zu Datenschutz + Textvorlage einpflegen
  - Zustimmung zu Nutzungsbedingungen + Textvorlage einpflegen
  - Impressum + Textvorlage einpflegen

  - Nützliche Funktion vorschlagen - E-Mail DIREKT an den Entwickler senden - "Support-E-Mail" eintragen - CM-0121
  - "WbInfoContainer" im CompanyScreen ist teilweise noch festverdrahtet - 1030
  - "WbInfoContainer" im ContactScreen ist teilweise noch festverdrahtet - 1030

  - In Chrome gibt es keine SharedPreferences, deshalb muss ich das auf "null" setzen? oder woanders (SQL) speichern?
  - Die Variable für den "DarkMode" setzen - WbHomePage - 0173
  - Wie kann ich hier nach mehreren Kriterien suchen oder filtern? - EmailUserSelection - 0158
  - Die GEFUNDENE Anzahl aller User mit der gesuchten Zeichenfolge in der Liste zeigen - EMailScreenP043 - 0030
  - Anzeigen auf dem "WbInfoContainer", welcher Benutzer gerade angemeldet ist.
  - WbImageButtonNoText: Abfrage ob mit oder ohne Schatten - 0038
  - In allen Buttons eine Soundfunktion (Click) einfügen
  - "ButtonAccounting"    umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "ButtonCommunication" umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "ButtonCustomer"      umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "ButtonCompanies"     umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "wbImageAssetImage"   hat keine Auswirkung!          - MainSelectionScreen - 0124
  
  - Es sollen alle Kontakte angezeigt werden - ContactListP051 - 0010 */
  - "WbInfoContainer" auf ein BottomSheet legen?
  - Die grüne Neon-Linie "neon_green_line" wieder einbauen - wurde vorübergehend ausgeblendet - 0047 - NavigationBarGreenNeon
  √ Buttons auf GridView umbauen - MainSelectionScreen - 0048 √
  √ Mit "$formatWeekday" gibt es eine Fehlermeldung - main - CurrentDateProvider - 0071 √
  √ WbHomePage: WbInfoContainer als "Footer" programmieren √
  √ Icons sollen beim Aussuchen sichtbar sein (Einstellungen in VSCode) √
  √ CompanyScreen: Logo und Bild oben sind noch zu groß für SamsungA05 √
  √ GestureDetector in allen Button-Widgets fixen √
  √ WBGreenButton - Beispiel: Login-Button √
  √ WbButtonsUniWithImageButton √
  √ WbDialogAlertUpdateComingSoon √
  √ WbButtonUniversal2 - Beispiel: WorkBuddy beenden √
  √ "Spacer(flex: 1)" waren das Problem, warum ich nicht mehr die Seite öffnen konnte! √
  
- kann gelöscht werden: lib/config/wb_dropdownmenu.dart 
- kann später evtl. gelöscht werden: lib/shared/data/user.dart
- kann später evtl. gelöscht werden: lib/features/authentication/repositories/mock_user_database.dart
- kann später evtl. gelöscht werden: lib/features/authentication/repositories/mock_user_repository.dart
- kann später evtl. gelöscht werden: lib/features/authentication/schema/server_user_response.dart
- kann später evtl. gelöscht werden: lib/features/authentication/schema/user.dart
- kann später evtl. gelöscht werden: lib/features/authentication/repositories/user_repository.dart
- kann später evtl. gelöscht werden: lib/features/authentication/logic/user_service.dart
- kann später evtl. gelöscht werden: lib/features/authentication/screens/user_screen.dart
- kann später evtl. gelöscht werden: "backup_screens" mit allen Unterordnern

   √ wurde gelöscht: "EMailScreen"
   √ wurde gelöscht: "EMailScreenP043x"
  - kann gelöscht werden: "WBTextfieldNotice"
  - kann gelöscht werden: "WbDividerWithSmallTextCenter"
  - kann gelöscht werden: "WbDropdownButtonFormfield" 
  - kann gelöscht werden: "WbDropDownMenuWithIcon2"
  - kann gelöscht werden: "SplashScreen"
  √ wurde gelöscht: "WbButtonUniversal" √
  √ wurde gelöscht: "WBRedButton" √
  √ wurde gelöscht: "ContactMenuX" √
  √ wurde gelöscht: "ContactScreenX" √
  √ wurde gelöscht: "WbButtonUniShadow" √

  - Hier besser eine Map erstellen - ExpenseWidget - 0033
  - CompanyScreen: leadingIconsInMenu hat hier keine Auswikung // todo 0233 + 0406

* Updates:
  - Kontakt direkt anrufen                        - Update CM-0090
  - WhatsApp direkt versenden                     - Update CM-0150
  - mehr Funktionen - E-Mail an den Entwickler    - Update CM-0249
  - mehr Funktionen - E-Mail an den Entwickler    - Update CM-0132
  - mehr Funktionen - E-Mail an den Entwickler    - Update AM-0249
  - mehr Funktionen - E-Mail an den Entwickler    - Update SM-0263
  - Alle Kontakte zeigen                          - Update CM-0098
  - Mit Google-Account einloggen                  - Update LS-0495
  - Mit Apple-Account einloggen                   - Update LS-0573
  - Mit Facebook-Account einloggen                - Update LS-0601
  - Mit WorkBuddy-Account einloggen               - Update LS-0555
  - Alle Ausgaben als Liste zeigen                - Update AM-0115
  - Alle Einnahmen als Liste zeigen               - Update AM-0146
  - Alle Ausgaben suchen und finden               - Update AM-0180
  - Alle Einnahmen suchen und finden              - Update AM-0212


  √ Datums-Picker (Geburtstage, etc.) installiert: time_picker_spinner_pop_up: ^2.0.0 √
    x - flutter_rounded_date_picker: ^3.0.4 (nicht installiert, ist aber umfangreicher)
    x - flutter_holo_date_picker: ^2.0.0    (nur für Datumseinstellungen - nicht installiert)
    x - progressive_time_picker: ^1.0.1     (nur Zeitspanne, aber gut aussehend - nicht installiert)
  √ Alter anhand vom Geburtstag automatisch berechnen und im Feld eintragen - 0491 - CompanyScreen √ 
  - Checklisten-App in WorkBuddy einbauen - ToDo-Liste (Aufgaben)
  - Im Validator "Die Paßwörter sind NICHT gleich!" funzt so nicht! 0050 - Validator
  - App-Icon neu erstellen (Android-Bug? - in Android nur schwarz)
- Splash-Screen neu erstellen (Android-Bug? - in Android beschnitten) - wird nicht besser - selber programmmieren

* WbInfoContainer:
  √ Der "WbInfoContainer" soll außerhalb der Scrollview am Bottom fixiert sein - 0927 √
  √ Den "WbInfoContainer" als "bottomSheet" deklarieren √
    - Im "WbInfoContainer" sollen unten die Änderungen und der Kunde angezeigt werden, wenn keine Änderungen, dann "zuletzt geändert am" anzeigen.

* Drawer:
  - Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist.
  - Im Drawer eine Liste anlegen (wie ein Inhaltsverzeichnis - nach Themen geordnet), die eine direkte Navigation auf alle möglichen Seiten durch anklicken erstellt. Hinweis: WbButtonUniversal2 

* Firebase Services:
  - Mit Analytics werden Nutzungs- und Verhaltensdaten für meine App erfasst   → firebase_analytics
  - Authentication zur Identifizierung meiner User                             → firebase_auth
  - Cloud Firestore-Datenbank zur Speicherung von Daten in der Cloud           → cloud_firestore
  - Firebase Cloud Messaging-Client für Push-Nachrichten an meine User         → firebase_messaging
  - Mit Cloud Storage - Bilder und Videos hochladen und teilen                 → firebase_storage
  - Crashlytics - Fehlermeldungen und Abstürze der App auswerten               → firebase_crashlytics

* GitHub:  
  In die ".gitignore" vom Projektverzeichnis eintragen:
  # Um die Firebase API-Keys bei GitHub geheim zu halten:
  /lib/firebase_options.dart
  /android/app/google-services.json
  /macos/Runner/GoogleService-Info.plist
  /ios/Runner/GoogleService-Info.plist
  Falls bereits ein commit mit den Api Keys unternommen wurde, muss man GitHub mitteilen, dass diese Files nicht mehr beobachtet werden sollen. Dies erreicht man, wenn man im Projekt das Terminal öffnet und folgende Befehle eingibt:
  git rm --cached lib/firebase_options.dart
  git rm --cached android/app/google-services.json
  git rm --cached macos/Runner/GoogleService-Info.plist
  git rm --cached ios/Runner/GoogleService-Info.plist

  - ANDERE Schriftgrößen automatisch einstellen? Beispiel: iOS = 20 | Pixel8 = 27 | SamsungA05 = 21 (0513)
  √ CompanyScreen: Button "Firma speichern" auf dynamische Größe ändern √
  √ CompanyScreen: DropDown Lieferant / Kunde / etc. anstatt "CompanyRadioButton1" = deaktiviert - 0193 √
  √ CompanyScreen: Name der Firma unter dem Logo automatisch eintragen √
  √ CompanyScreen: Name des Kunden unter dem Bild automatisch eintragen √
  √ ContactScreen: lässt sich nicht mehr starten - gelöst, Seite komplett neu aufgebaut √
  - WbButtonUniversal: Warum hat "width" keine Auswirkung?
  - WbHomePage: Drawer fertig programmieren
  - P01LoginScreen: 0513 - andere Schriftgrößen: iOS = 24 | Pixel8 = 27
  - P01LoginScreen: Info-Leiste auf dem Startbildschirm unten einbauen
  - P01LoginScreen: Login mit SQFlite-DB verbinden
  - P01LoginScreen: Passwort gleich von Anfang an ausblenden (mit State?)
  - CompanyScreen: Telefonanruf starten - 0513 - company_screen - Anruf starten
  - autofillHints: autofillHints, // wie funzt das?
  - PRODUCT_BUNDLE_IDENTIFIER = com.example.widgetsIntroductionLiveCoding umbenennen

  *---------------------------------- Was habe ich dazugelernt? ---* 
  - Da in der App möglichst alles groß und kontrastreich dargestellt werden soll, habe ich viel über Styles und "overflows", etc. gelernt.
  - Nutzung von KeyboardType: Phone, Text, Datetime, ...
  - Text-Validierung mit "TextEditingController".
  - Text an andere Felder übergeben mit "TextEditingController" und der Funktion "onChange".
  - Den GestureDetector nicht "doppelt" benutzen, sondern die Funktion in den Button-Widget-Vorlagen richtig übergeben und nur einmal nutzen.
  - Für die Arbeit im Team nicht nur Buttons (ohne Funktion) als Platzhalter anlegen, sondern dann einen Hinweis ("showDialog" oder "snackBar") anzeigen.
  *--------------------------------- *** ---*/
  */
