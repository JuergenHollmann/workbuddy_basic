import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/features/home/screens/home_screen.dart';
import 'package:workbuddy/firebase_options.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_date_provider.dart';
import 'package:workbuddy/shared/providers/current_day_long_provider.dart';
import 'package:workbuddy/shared/providers/current_day_short_provider.dart';
import 'package:workbuddy/shared/providers/current_time_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/auth_repository.dart';
// import 'package:workbuddy/shared/repositories/database_helper.dart';
import 'package:workbuddy/shared/repositories/database_repository.dart';
import 'package:workbuddy/shared/repositories/database_setup.dart';
// import 'package:workbuddy/shared/repositories/database_setup.dart';
import 'package:workbuddy/shared/repositories/firebase_auth_repository.dart';
import 'package:workbuddy/shared/repositories/mock_database.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';
import 'package:workbuddy/wb_terms_of_service.dart'; // Import der Nutzungsbedingungen-Seite

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;

  log('0028 - MainApp - DatabaseHelper() wird gestartet');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await DatabaseHelper().database; // Initialisiere die Datenbank
  /*--------------------------------- Repositories ---*/
  final DatabaseRepository databaseRepository = MockDatabase();
  final AuthRepository authRepository = FirebaseAuthRepository();

  DatabaseSetup();
  log('0074 - MainApp - DatabaseSetup wird gestartet');

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
    log("0071 - MainApp - wird gestartet");

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
      routes: {
        '/terms': (context) =>
            const WbTermsOfService(), // Route für die Nutzungsbedingungen-Seite
      },
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  // Singleton-Muster
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.WorkBuddy.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE KontaktDaten (
        TKD_000 INTEGER PRIMARY KEY AUTOINCREMENT,
        TKD_001 TEXT,
        TKD_002 TEXT,
        TKD_003 TEXT,
        TKD_004 TEXT,
        TKD_005 TEXT,
        TKD_006 TEXT,
        TKD_007 TEXT,
        TKD_008 TEXT,
        TKD_009 TEXT,
        TKD_010 TEXT,
        TKD_011 TEXT,
        TKD_012 TEXT,
        TKD_013 TEXT,
        TKD_014 TEXT,
        TKD_015 TEXT,
        TKD_016 TEXT,
        TKD_017 TEXT,
        TKD_018 TEXT,
        TKD_019 TEXT,
        TKD_020 TEXT,
        TKD_021 TEXT,
        TKD_022 TEXT,
        TKD_023 TEXT,
        TKD_024 TEXT,
        TKD_025 TEXT,
        TKD_026 TEXT,
        TKD_027 TEXT,
        TKD_028 TEXT,
        TKD_029 TEXT,
        TKD_030 TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE BenutzerDaten (
        TBD_000 INTEGER PRIMARY KEY AUTOINCREMENT,
        TBD_001 TEXT,
        TBD_002 TEXT,
        TBD_003 TEXT,
        TBD_004 TEXT,
        TBD_005 TEXT,
        TBD_006 TEXT,
        TBD_007 TEXT,
        TBD_008 TEXT,
        TBD_009 TEXT,
        TBD_010 TEXT,
        TBD_011 TEXT,
        TBD_012 TEXT,
        TBD_013 TEXT,
        TBD_014 TEXT,
        TBD_015 TEXT,
        TBD_016 TEXT,
        TBD_017 TEXT,
        TBD_018 TEXT,
        TBD_019 TEXT,
        TBD_020 TEXT,
        TBD_021 TEXT,
        TBD_022 TEXT,
        TBD_023 TEXT,
        TBD_024 TEXT,
        TBD_025 TEXT,
        TBD_026 TEXT,
        TBD_027 TEXT,
        TBD_028 TEXT,
        TBD_029 TEXT,
        TBD_030 TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE EinstellungenKontakte (
        TEK_000 INTEGER PRIMARY KEY AUTOINCREMENT,
        TEK_001 TEXT,
        TEK_002 TEXT,
        TEK_003 TEXT,
        TEK_004 TEXT,
        TEK_005 TEXT,
        TEK_006 TEXT,
        TEK_007 TEXT,
        TEK_008 TEXT,
        TEK_009 TEXT,
        TEK_010 TEXT,
        TEK_011 TEXT,
        TEK_012 TEXT,
        TEK_013 TEXT,
        TEK_014 TEXT,
        TEK_015 TEXT,
        TEK_016 TEXT,
        TEK_017 TEXT,
        TEK_018 TEXT,
        TEK_019 TEXT,
        TEK_020 TEXT,
        TEK_021 TEXT,
        TEK_022 TEXT,
        TEK_023 TEXT,
        TEK_024 TEXT,
        TEK_025 TEXT,
        TEK_026 TEXT,
        TEK_027 TEXT,
        TEK_028 TEXT,
        TEK_029 TEXT,
        TEK_030 TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE EinstellungenBenutzer (
        TEB_000 INTEGER PRIMARY KEY AUTOINCREMENT,
        TEB_001 TEXT,
        TEB_002 TEXT,
        TEB_003 TEXT,
        TEB_004 TEXT,
        TEB_005 TEXT,
        TEB_006 TEXT,
        TEB_007 TEXT,
        TEB_008 TEXT,
        TEB_009 TEXT,
        TEB_010 TEXT,
        TEB_011 TEXT,
        TEB_012 TEXT,
        TEB_013 TEXT,
        TEB_014 TEXT,
        TEB_015 TEXT,
        TEB_016 TEXT,
        TEB_017 TEXT,
        TEB_018 TEXT,
        TEB_019 TEXT,
        TEB_020 TEXT,
        TEB_021 TEXT,
        TEB_022 TEXT,
        TEB_023 TEXT,
        TEB_024 TEXT,
        TEB_025 TEXT,
        TEB_026 TEXT,
        TEB_027 TEXT,
        TEB_028 TEXT,
        TEB_029 TEXT,
        TEB_030 TEXT
      )
    ''');

    // Tabelle "EinkaufVerkauf"
    await db.execute('''
      CREATE TABLE IF NOT EXISTS EinkaufVerkauf (
        TEV_000 INTEGER PRIMARY KEY AUTOINCREMENT,
        TEV_001 TEXT,
        TEV_002 TEXT,
        TEV_003 TEXT,
        TEV_004 TEXT,
        TEV_005 TEXT,
        TEV_006 TEXT,
        TEV_007 TEXT,
        TEV_008 TEXT,
        TEV_009 TEXT,
        TEV_010 TEXT,
        TEV_011 TEXT,
        TEV_012 TEXT,
        TEV_013 TEXT,
        TEV_014 TEXT,
        TEV_015 TEXT,
        TEV_016 TEXT,
        TEV_017 TEXT,
        TEV_018 TEXT,
        TEV_019 TEXT,
        TEV_020 TEXT,
        TEV_021 TEXT,
        TEV_022 TEXT,
        TEV_023 TEXT,
        TEV_024 TEXT,
        TEV_025 TEXT,
        TEV_026 TEXT,
        TEV_027 TEXT,
        TEV_028 TEXT,
        TEV_029 TEXT,
        TEV_030 TEXT
      )
    ''');
  }
}

/*--------------------------------- TODO's ---
* Firebase:
  √ für iOS muss im ios/Podfile     ---> platform :ios, '13.0'  eingestellt werden √ 
  √ für macOS muss im macos/Podfile ---> platform :osx, '10.15' eingestellt werden √ 
  /*--------------------------------- *** ---
  - SnackBar - Kontakt wird überprüft 0535 - ContactListFromDevice todo
  - 0402 - SettingsMenu - Sprache "Deutsch" auswählen.
  - Snackbar einblenden funzt hier nicht! 2101 - ContactScreen
  - Fehlermeldung beheben: wegen disposed() called on null - 0466 - ContactScreen
  - CurrentUserProvider>().currentUser; // funzt nicht 0616 - P01LoginScreen
  - Klicke unten auf den E-Mail-Button - dann das E-Mail-Menü starten - CM-0121
  - dispose(); // löscht die Controller aus dem Speicher - hängt sich auf - 1652 - ContactScreen
  - Automatisch das Alter berechnen mit "age_calculator" 0785 - ContactScreen
  - Zeitstempel formatieren - 01441 - ContactScreen
  - Geburtstag ist ein Datum und kein String - wie kann ich das mit einem Controller verarbeiten? - 0146 - ContactScreen
  - Die Farbe mit "focusNode" in Textformfield ändern - todo 0267 - P01LoginScreen
  - "WbTextFormFieldSHADOWContour" - lib/config/wb_textformfield_shadow_contour.dart als Widget erstellen
  - Mit Provider im Feld "Wer hat eingekauft?" den angemeldeten User automatisch eintragen.
  - Überprüfen, ob im Device eine Speicherkarte vorhanden ist oder nicht.
  - Foto von der Quittung oder Rechnung erstellen.
  - Foto-Datei umbenennen nach folgendem Muster: JJJJ-MM-DD - Einkauf/Verkauf - Wo - Was - Gesamt-Bruttopreis.
  - Datensatz des Einkaufs/Verkaufs speichern nachf folgendem Muster:
    Einkauf/Verkauf, Wo, Was, Anzahl, Einheiten, Steuersatz, Einzel-Bruttopreis, Gesamt-Bruttopreis, ... etc.
  - Foto entweder intern oder extern auf Speicherkarte speichern.
  - Im ExpenseWidget bleiben die Einträge noch der Berechnung nicht im Textfeld mit dem Wert stehen.

- Datenschutz und Rechtliches:  
  √ Zustimmung zu Datenschutz + Textvorlage einpflegen √
  √ Zustimmung zu Nutzungsbedingungen + Textvorlage einpflegen √
  - Impressum + Textvorlage einpflegen.

  - Allgemein überall "TextEditingController.dispose" einbauen.
  - Nützliche Funktion für den User vorschlagen - E-Mail DIREKT an den Entwickler senden - "Support-E-Mail" eintragen - CM-0121
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
  - "ButtonTasksAndToDos"      umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "ButtonContacts"     umbauen und mit Text erweitern - MainSelectionScreen - 0043
  - "wbImageAssetImage"   hat keine Auswirkung!          - MainSelectionScreen - 0124
  
  - Es sollen alle Kontakte angezeigt werden - ContactListP051 - 0010 */
  - "WbInfoContainer" auf ein BottomSheet legen?
  - Die grüne Neon-Linie "neon_green_line" wieder einbauen - wurde vorübergehend ausgeblendet - 0047 - NavigationBarGreenNeon
  √ Buttons auf GridView umbauen - MainSelectionScreen - 0048 √
  √ Mit "$formatWeekday" gibt es eine Fehlermeldung - main - CurrentDateProvider - 0071 √
  √ WbHomePage: WbInfoContainer als "Footer" programmieren √
  √ Icons sollen beim Aussuchen sichtbar sein (Einstellungen in VSCode) √
  √ ContactScreen: Logo und Bild oben sind noch zu groß für SamsungA05 √
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
  - kann gelöscht werden: lib/features/authentication/schema/server_user_response.dart
  - kann gelöscht werden: "WBTextfieldNotice"
  - kann gelöscht werden: "WbDividerWithSmallTextCenter"
  - kann gelöscht werden: "WbDropdownButtonFormfield" 
  - kann gelöscht werden: "WbDropDownMenuWithAnyIcon2"
  - kann gelöscht werden: "SplashScreen"
  √ wurde gelöscht: "WbButtonUniversal" √
  √ wurde gelöscht: "WBRedButton" √
  √ wurde gelöscht: "ContactMenuX" √
  √ wurde gelöscht: "ContactScreenX" √
  √ wurde gelöscht: "WbButtonUniShadow" √

  - Hier besser eine Map erstellen - ExpenseWidget - 0033
  - ContactScreen: leadingIconsInMenu hat hier keine Auswikung // todo 0233 + 0406

- Updates:
  - Aufgaben anlegen, bearbeiten, delegieren ...  - Update AM-0019
  - Kontakt direkt anrufen                        - Update CM-0090
  - WhatsApp direkt versenden                     - Update CM-0150
  - mehr Funktionen - E-Mail an den Entwickler    - Update CM-0249
  - mehr Funktionen - E-Mail an den Entwickler    - Update CM-0132
  - mehr Funktionen - E-Mail an den Entwickler    - Update AM-0249
  - mehr Funktionen - E-Mail an den Entwickler    - Update SM-0263
  √ Alle Kontakte suchen und finden               - Update CM-0098 √
  - Mit Google-Account einloggen                  - Update LS-0495
  - Mit Apple-Account einloggen                   - Update LS-0573
  - Mit Facebook-Account einloggen                - Update LS-0601
  - Mit WorkBuddy-Account einloggen               - Update LS-0555
  - Alle Ausgaben als Liste zeigen                - Update AM-0115
  - Alle Einnahmen als Liste zeigen               - Update AM-0146
  - Alle Ausgaben suchen und finden               - Update AM-0180
  - Alle Einnahmen suchen und finden              - Update AM-02129

  √ Datums-Picker (Geburtstage, etc.) installiert: time_picker_spinner_pop_up: ^2.0.0 √
    x - flutter_rounded_date_picker: ^3.0.4 (nicht installiert, ist aber umfangreicher)
    x - flutter_holo_date_picker: ^2.0.0    (nur für Datumseinstellungen - nicht installiert)
    x - progressive_time_picker: ^1.0.1     (nur Zeitspanne, aber gut aussehend - nicht installiert)
  √ Alter anhand vom Geburtstag automatisch berechnen und im Feld eintragen - 0491 - ContactScreen √ 
  - Checklisten-App in WorkBuddy einbauen - ToDo-Liste (Aufgaben)
  - Im Validator "Die Paßwörter sind NICHT gleich!" funzt so nicht! 0050 - Validator
  - App-Icon neu erstellen (Android-Bug? - in Android nur schwarz)
- Splash-Screen neu erstellen (Android-Bug? - in Android beschnitten) - wird nicht besser - selber programmmieren

- WbInfoContainer:
  √ Der "WbInfoContainer" soll außerhalb der Scrollview am Bottom fixiert sein - 0927 √
  √ Den "WbInfoContainer" als "bottomSheet" deklarieren √
    - Im "WbInfoContainer" sollen unten die Änderungen und der Kunde angezeigt werden, wenn keine Änderungen, dann "zuletzt geändert am" anzeigen.

- Drawer:
  - Überprüfe ob der AudioPlayer in den Settings(Jingles) "an" oder "aus" ist.
  - Im Drawer eine Liste anlegen (wie ein Inhaltsverzeichnis - nach Themen geordnet), die eine direkte Navigation auf alle möglichen Seiten durch anklicken erstellt. Hinweis: WbButtonUniversal2 

- Firebase Services:
  - Mit Analytics werden Nutzungs- und Verhaltensdaten für meine App erfasst   → firebase_analytics
  - Authentication zur Identifizierung meiner User                             → firebase_auth
  - Cloud Firestore-Datenbank zur Speicherung von Daten in der Cloud           → cloud_firestore
  - Firebase Cloud Messaging-Client für Push-Nachrichten an meine User         → firebase_messaging
  - Mit Cloud Storage - Bilder und Videos hochladen und teilen                 → firebase_storage
  - Crashlytics - Fehlermeldungen und Abstürze der App auswerten               → firebase_crashlytics

- GitHub:  
  In die ".gitignore" vom Projektverzeichnis eintragen:
  # Um die Firebase API-Keys bei GitHub NICHT zu veröffentlichen:
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
  √ ContactScreen: Button "Firma speichern" auf dynamische Größe ändern √
  √ ContactScreen: DropDown Lieferant / Kunde / etc. anstatt "CompanyRadioButton1" = deaktiviert - 0193 √
  √ ContactScreen: Name der Firma unter dem Logo automatisch eintragen √
  √ ContactScreen: Name des Kunden unter dem Bild automatisch eintragen √
  √ ContactScreen: lässt sich nicht mehr starten - gelöst, Seite komplett neu aufgebaut √
  - WbButtonUniversal: Warum hat "width" keine Auswirkung?
  - WbHomePage: Drawer fertig programmieren
  - P01LoginScreen: 0513 - andere Schriftgrößen: iOS = 24 | Pixel8 = 27
  - P01LoginScreen: Info-Leiste auf dem Startbildschirm unten einbauen
  - P01LoginScreen: Login mit SQFlite-DB verbinden
  - P01LoginScreen: Passwort gleich von Anfang an ausblenden (mit State?)
  - ContactScreen: Telefonanruf starten - 0513 - company_screen - Anruf starten
  - autofillHints: autofillHints, // wie funzt das?
  - PRODUCT_BUNDLE_IDENTIFIER = com.example.widgetsIntroductionLiveCoding umbenennen

  *---------------------------------- Was habe ich dazugelernt? ---* 
  - Da in der App möglichst alles groß und kontrastreich dargestellt werden soll, habe ich viel über Styles und "overflows", etc. gelernt.
  - Nutzung von KeyboardType: Phone, Text, Datetime, ...
  - Text-Validierung mit "TextEditingController".
  - Text an andere Felder übergeben mit "TextEditingController" und der Funktion "onChange".
  - Den GestureDetector nicht "doppelt" benutzen, sondern die Funktion in den Button-Widget-Vorlagen richtig übergeben und nur einmal nutzen.
  - Für die Arbeit im Team nicht nur Buttons (ohne Funktion) als Platzhalter anlegen, sondern dann einen Hinweis ("showDialog" oder "snackBar") anzeigen.

--------------------------------- 6.2.4 - 6.3.3 - Projekt 21: Provider ---
  1) Provider
  √ Implementiere Provider in deiner App.
  √ Entferne alle Klassenattribute und Parameter aus allen Widgets, die Repositories entgegennehmen und speichern.
  √ Nutze stattdessen Provider, um deine Repositories zu holen und zu verwenden.
  √ Hinweis: Folge der Anleitung aus der Vorlesung und nutze den Code der Batch App als Hilfe!
  Wie sieht dein Code aus, um Repositories zur Verfügung zu stellen und zu verwenden?


  --------------------------------- 6.1.1 - 6.2.1 - Projekt 20: Firebase Auth ---
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
  */
