import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';
import 'package:workbuddy/shared/repositories/database_helper.dart';

/*--- FlutterContacts ---*/
/*--- https://pub.dev/packages/flutter_contacts ---*/

class ContactListFromDevice extends StatefulWidget {
  const ContactListFromDevice({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListFromDeviceState createState() => _ContactListFromDeviceState();
}

class _ContactListFromDeviceState extends State<ContactListFromDevice> {
  List<Contact> filteredContacts = [];
  List<Contact> allContacts = [];
  int currentMax =
      10; // Initiale Anzahl der am Anfang geladenen Kontakte wegen schnellerem Laden des Screens
  final TextEditingController _searchController = TextEditingController();
  List<Contact> displayedContacts = [];
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadInitialContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> loadInitialContacts() async {
    /*--- Berechtigungen anfordern ---*/
    if (await FlutterContacts.requestPermission()) {
      log('0033 - ContactListFromDevice - Zugriff auf Kontakte erlaubt');

      /*--- Die ersten 10 Kontakte mit allen Details laden ---*/
      allContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
        withPhoto: true,
        withGroups: true,
        withAccounts: true,
        sorted: true,
        deduplicateProperties: true,
      ).then((contacts) => contacts.take(10).toList());

      setState(() {
        filteredContacts = allContacts;
        displayedContacts = filteredContacts.take(currentMax).toList();
      });

      /*--- Die restlichen Kontakte mit allen Details laden ---*/
      loadAllContacts();
    } else {
      /*--- Berechtigung verweigert ---*/
      log('0042 - ContactListFromDevice - Zugriff auf Kontakte verweigert');
    }
  }

  Future<void> loadAllContacts() async {
    /*--- Die restlichen Kontakte mit allen Details laden ---*/
    allContacts = await FlutterContacts.getContacts(
      withProperties: true,
      withThumbnail: true,
      withPhoto: true,
      withGroups: true,
      withAccounts: true,
      sorted: true,
      deduplicateProperties: true,
    );

    setState(() {
      filteredContacts = allContacts;
      displayedContacts = filteredContacts.take(currentMax).toList();
      filteredContacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    });
  }

  /*--- Lade weitere Kontakte beim Scrollen ---*/
  void loadMoreContacts() {
    setState(() {
      currentMax = currentMax + 10; // Lade weitere 10 Kontakte
      displayedContacts = filteredContacts.take(currentMax).toList();
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = allContacts
          .where((contact) => contact.displayName.toLowerCase().contains(query))
          .toList();
      displayedContacts = filteredContacts.take(currentMax).toList();
    });
  }

  Future<bool> isContactInDatabase(Contact contact) async {
    final Database db = await openDatabase(
      'JOTHAsoft.FiveStars.db',
      version: 1,
      onCreate: (db, version) async {
        log('Datenbank wird erstellt...');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Tabelle01 (
            Tabelle01_001 TEXT PRIMARY KEY,
            Tabelle01_002 TEXT,
            Tabelle01_003 TEXT,
            Tabelle01_004 TEXT,
            Tabelle01_005 TEXT,
            Tabelle01_006 TEXT,
            Tabelle01_007 TEXT,
            Tabelle01_008 TEXT,
            Tabelle01_009 TEXT,
            Tabelle01_010 TEXT,
            Tabelle01_011 TEXT,
            Tabelle01_012 TEXT,
            Tabelle01_013 TEXT,
            Tabelle01_014 TEXT,
            Tabelle01_015 TEXT,
            Tabelle01_016 TEXT,
            Tabelle01_017 TEXT,
            Tabelle01_018 TEXT,
            Tabelle01_019 TEXT,
            Tabelle01_020 TEXT,
            Tabelle01_021 TEXT,
            Tabelle01_022 TEXT,
            Tabelle01_023 TEXT,
            Tabelle01_024 TEXT,
            Tabelle01_025 TEXT,
            Tabelle01_026 TEXT,
            Tabelle01_027 TEXT,
            Tabelle01_028 TEXT,
            Tabelle01_029 TEXT,
            Tabelle01_030 TEXT,
            Tabelle01_031 TEXT,
            Tabelle01_032 TEXT,
            Tabelle01_033 TEXT,
            Tabelle01_034 TEXT,
            Tabelle01_035 TEXT,
            Tabelle01_036 TEXT,
            Tabelle01_037 TEXT,
            Tabelle01_038 TEXT,
            Tabelle01_039 TEXT,
            Tabelle01_040 TEXT,
            Tabelle01_041 TEXT,
            Tabelle01_042 TEXT,
            Tabelle01_043 TEXT,
            Tabelle01_044 TEXT,
            Tabelle01_045 TEXT,
            Tabelle01_046 TEXT,
            Tabelle01_047 TEXT,
            Tabelle01_048 TEXT,
            Tabelle01_049 TEXT,
            Tabelle01_050 TEXT
          )
        ''');
        log('Tabelle01 wurde erfolgreich erstellt.');
      },
    );

    // Sicherstellen, dass die Tabelle existiert
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Tabelle01 (
        Tabelle01_001 TEXT PRIMARY KEY,
        Tabelle01_002 TEXT,
        Tabelle01_003 TEXT,
        Tabelle01_004 TEXT,
        Tabelle01_005 TEXT,
        Tabelle01_006 TEXT,
        Tabelle01_007 TEXT,
        Tabelle01_008 TEXT,
        Tabelle01_009 TEXT,
        Tabelle01_010 TEXT,
        Tabelle01_011 TEXT,
        Tabelle01_012 TEXT,
        Tabelle01_013 TEXT,
        Tabelle01_014 TEXT,
        Tabelle01_015 TEXT,
        Tabelle01_016 TEXT,
        Tabelle01_017 TEXT,
        Tabelle01_018 TEXT,
        Tabelle01_019 TEXT,
        Tabelle01_020 TEXT,
        Tabelle01_021 TEXT,
        Tabelle01_022 TEXT,
        Tabelle01_023 TEXT,
        Tabelle01_024 TEXT,
        Tabelle01_025 TEXT,
        Tabelle01_026 TEXT,
        Tabelle01_027 TEXT,
        Tabelle01_028 TEXT,
        Tabelle01_029 TEXT,
        Tabelle01_030 TEXT,
        Tabelle01_031 TEXT,
        Tabelle01_032 TEXT,
        Tabelle01_033 TEXT,
        Tabelle01_034 TEXT,
        Tabelle01_035 TEXT,
        Tabelle01_036 TEXT,
        Tabelle01_037 TEXT,
        Tabelle01_038 TEXT,
        Tabelle01_039 TEXT,
        Tabelle01_040 TEXT,
        Tabelle01_041 TEXT,
        Tabelle01_042 TEXT,
        Tabelle01_043 TEXT,
        Tabelle01_044 TEXT,
        Tabelle01_045 TEXT,
        Tabelle01_046 TEXT,
        Tabelle01_047 TEXT,
        Tabelle01_048 TEXT,
        Tabelle01_049 TEXT,
        Tabelle01_050 TEXT
      )
    ''');

    final String? firstName =
        contact.name.first.isNotEmpty ? contact.name.first : null;
    final String? lastName =
        contact.name.last.isNotEmpty ? contact.name.last : null;

    final List<Map<String, dynamic>> result = await db.query(
      'Tabelle01',
      where: '''
        (Tabelle01_003 = ? OR (Tabelle01_003 IS NULL AND ? IS NULL)) AND 
        (Tabelle01_004 = ? OR (Tabelle01_004 IS NULL AND ? IS NULL))
      ''',
      whereArgs: [firstName, firstName, lastName, lastName],
    );

    log('0172 - ContactListFromDevice - Abfrage der Datenbank: ${contact.name.first} ${contact.name.last}');
    log('0173 - ContactListFromDevice - Ergebnis der Abfrage: $result');
    return result.isNotEmpty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      appBar: AppBar(
        title: Text(
          'Kontakte im Gerät',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: wbColorButtonBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Implementiere die Logik zum Speichern der Daten
              log('Daten speichern Button gedrückt');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            /*--- Anzeige der Anzahl der Kontakte ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                'Gefunden: ${filteredContacts.length} von ${allContacts.length} Kontakten',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /*--- Suchfeld ---*/
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
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
                child: TextField(
                  // maxLength: null,
                  // expands:
                  //     false, // bei "true: Das Textfeld wird größer, wenn mehrere Zeilen eingegeben werden.
                  // textAlignVertical: TextAlignVertical.center,
                  // /* horizontale Textausrichtung - wenn nichts expilzit angegeben wird, ist default = "TextAlign.left" */
                  // textAlign: TextAlign.left,

                  controller: _searchController,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),

                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(
                        16, 24, 8, 0), // Label-Abstand

                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Icon(
                        Icons.search_outlined,
                        size: 40,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.delete_forever, // Icons.recycling_outlined,
                        size: 40,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    labelText: 'Suche Kontakte',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    filled: true,
                    fillColor: Colors.yellow, // Innen gelb färben
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ), // Schwarzer dünner Rand
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Schwarzer dünner Rand
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Schwarzer dünner Rand
                    ),
                  ),
                ),
              ),
            ),
            /*--------------------------------- Abstand ---*/
            SizedBox(height: 8),
            /*--------------------------------- Divider ---*/
            Divider(
              color: Colors.black,
              thickness: 2,
            ),

            /*--- Liste der Kontakte ---*/
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    loadMoreContacts();
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: displayedContacts.length,
                  itemBuilder: (context, index) {
                    final contact = displayedContacts[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Container(
                            // width: double.infinity, // maximale Breite

                            /*--- Container für den Schatten um die Card herum ---*/
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

                            /*--- Card für die Anzeige der Kontakte ---*/
                            child: Card(
                              color: wbColorBackgroundRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Eckenradius derCard
                              ),
                              // elevation: 10, // für den 3-D-Effekt
                              shadowColor: Colors.black, // Schattenfarbe

                              /*--- ListTile für die Anzeige der Kontakte ---*/
                              child: ListTile(
                                /*--------------------------------- Container für das Bild---*/
                                leading: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 2,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                                    ),

                                    /*--------------------------------- Bild ---*/
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.white, // Hintergrund weiß
                                      backgroundImage: contact.photo != null &&
                                              contact.photo!.isNotEmpty
                                          ? MemoryImage(contact.photo!)
                                          : null,
                                      radius: 30,
                                      child: contact.photo == null ||
                                              contact.photo!.isEmpty
                                          ? Icon(Icons.person, size: 30)
                                          : null,
                                    ),
                                  ),
                                ),

                                /*--------------------------------- Kontaktinformationen - Name ---*/
                                title: Text(
                                    contact
                                        .displayName, // Überschrift - Name des Kontakts
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: wbColorLogoBlue,
                                    )),

                                /*--------------------------------- Kontaktinformationen - Untertitel ---*/
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*--------------------------------- Telefon ---*/
                                    if (contact.phones.isNotEmpty)
                                      Text(
                                        'Tel: ${contact.phones.first.number}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    // 'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}'),
                                    // weitere Codesnippets unter Text-Codesnippets
                                    /*--------------------------------- Kontaktinformationen - ENDE ---*/
                                  ],
                                ),
                                onTap: () async {
                                  // /*--------------------------------- Sound abspielen ---*/ // funzt hier nicht
                                  // player.play(
                                  //     AssetSource("sound/sound01click.wav"));
                                  log('0203 - ContactListFromDevice - Kontakt "${contact.displayName}" angeklickt');

                                  /*--------------------------------- Dialog - Kontakt übertragen ---*/
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        WBDialog2Buttons(
                                      headLineText:
                                          'Möchtest Du die Daten von ${contact.displayName} in "WorkBuddy" übertragen?',
                                      descriptionText:
                                          'Name: ${contact.displayName}\nGeburtstag: ${contact.events.isNotEmpty ? '${contact.events.first.day.toString().padLeft(2, '0')}.${contact.events.first.month.toString().padLeft(2, '0')}.${contact.events.first.year}' : 'Kein Datum vorhanden!'}\n\nTelefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}\nE-Mail: ${contact.emails.isNotEmpty ? contact.emails.first.address : 'Keine E-Mail-Adresse'}\n\nAdresse: ${contact.addresses.isNotEmpty ? contact.addresses.first.address : 'Keine Adresse'}\n\nFirma: ${contact.organizations.isNotEmpty ? contact.organizations.first.company : 'Keine Firma'}\nNotizen: ${contact.notes.isNotEmpty ? contact.notes.first.note : 'Keine Notiz'}\nWebseite: ${contact.websites.isNotEmpty ? contact.websites.first.url : 'Keine Webseite'}\nGruppen: ${contact.groups.isNotEmpty ? contact.groups.first.name : 'Keine Gruppen'}\n\nContactID: ${contact.id.isNotEmpty ? contact.id : 'Keine ContactID'}',

                                      /*--------------------------------- Button 1 ---*/
                                      wbText1:
                                          'Nein', // es passiert nichts weiter
                                      wbIcon1: Icons.cancel,
                                      wbColor1: wbColorButtonDarkRed,

                                      /*--------------------------------- Button 2 ---*/
                                      wbText2: 'Ja • Übertragen',
                                      wbIcon2: Icons.save,
                                      wbColor2: wbColorButtonGreen,
                                      wbWidth2W155:
                                          double.infinity, // maximale Breite

                                      /*--------------------------------- Button 2 - Aktion ---*/
                                      wbOnTap2: () async {
                                        log('0622 - ContactListFromDevice - Kontakt "${contact.displayName}" soll in "WorkBuddy" übertragen werden');

                                        /*--------------------------------- Dialog - Kontakt bereits vorhanden ---*/
                                        bool exists =
                                            await isContactInDatabase(contact);
                                        if (exists) {
                                          log('0588 - ContactListFromDevice - Ergebnis der Abfrage: "Der Kontakt ist bereits in der Datenbank vorhanden."');

                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);

                                          // Sound abspielen
                                          player.play(AssetSource(
                                              "sound/sound03enterprise.wav"));

                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '🟡 Der Kontakt "${contact.displayName}" ist bereits in der Datenbank vorhanden und wird deshalb NICHT übertragen! ⛔',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                                  wbColorButtonDarkRed,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                            ),
                                          );

                                          // /*--------------------------------- 2 Sekunden Pause einfügen ---*/
                                          //Future.delayed(Duration.zero, () {});

                                          Future.delayed(
                                            Duration(seconds: 2),
                                          );
                                          /*--------------------------------- Dialog - Geburtsdatum überprüfen ---*/
                                          showDialog(
                                              // ignore: use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  WBDialog2Buttons(
                                                      headLineText:
                                                          'Der Kontakt "${contact.displayName}" ist bereits in der Datenbank vorhanden.\n\n🟡  Soll jetzt das Geburtsdatum überprüft werden?',
                                                      descriptionText:
                                                          'Es könnte sein, dass 2 Personen gleichen Namens, aber mit einem unterschiedlichen Geburtsdatum in der Datenbank vorhanden sind.',

                                                      /*--------------------------------- Button 1 'Nein' ---*/
                                                      wbText1: 'Nein',
                                                      wbIcon1: Icons.cancel,
                                                      wbColor1:
                                                          wbColorButtonDarkRed,
                                                      wbOnTap1: () {
                                                        /*--------------------------------- SnackBar - Kontakt wird nicht überprüft ---*/
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                            '🟡 Der Kontakt "${contact.displayName}" wurde nicht weiter überprüft und auch NICHT zusätzlich in WorkBuddy übertragen! ⛔',
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              wbColorButtonDarkRed,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  2000),
                                                        ));

                                                        /*--------------------------------- Sound abspielen ---*/
                                                        player.play(AssetSource(
                                                            "sound/sound06pling.wav"));

                                                        /*--------------------------------- Navigator ausblenden ---*/
                                                        Navigator.pop(context);
                                                      },

                                                      /*--------------------------------- Button 2 'Ja • Überprüfen' ---*/
                                                      wbText2:
                                                          'Ja • Überprüfen',
                                                      wbIcon2: Icons.save,
                                                      wbColor2:
                                                          wbColorButtonGreen,
                                                      wbWidth2W155:
                                                          double.infinity,
                                                      wbOnTap2: () {
                                                        /*--------------------------------- SnackBar - Kontakt wird überprüft 0541 - ContactListFromDevice todo ---*/
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                            '🟡 Diese Funktion kommt in einem Update!\n\nUpdate CLFD-0541 ⛔',
                                                            // '🟡 Der Kontakt "${contact.displayName}" wird jetzt überprüft und auch NICHT zusätzlich in WorkBuddy übertragen! ⛔',
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              wbColorOrangeDarker,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  2000),
                                                        )); // SnackBar

                                                        /*--------------------------------- Sound abspielen ---*/
                                                        player.play(AssetSource(
                                                            "sound/sound06pling.wav"));

                                                        /*--------------------------------- Navigator ausblenden ---*/
                                                        Navigator.pop(context);
                                                      }));

                                          /*--------------------------------- ... wenn der Kontakt noch NICHT vorhanden ist ... ---*/
                                        } else {
                                          /*--------------------------------- SnackBar - Kontakt wird übertragen ---*/
                                          log('0590 - ContactListFromDevice - Der Kontakt wird jetzt in "WorkBuddy" übertragen.');

                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);

                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Der Kontakt "${contact.displayName}" wurde in "WorkBuddy" übertragen. ✅\n\nDu kannst jetzt die Daten bearbeiten und musst am Ende die Daten noch speichern!',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                                  wbColorButtonGreen,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                            ),
                                          );

                                          /*--------------------------------- Verwende "generateContactID" aus DatabaseHelper ---*/
                                          String newContactID = DatabaseHelper
                                              .instance
                                              .generateContactID();

                                          /*--- Öffne den ContactScreen wie mit dem Button "Einen Kontakt NEU anlegen" und übergebe die Kontaktdaten an den ContactScreen ---*/
                                          Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactScreen(
                                                contact: {
                                                  /*---------------------------------- Kontakt-ID ---*/
                                                  'Tabelle01_001': newContactID,
                                                  /*---------------------------------- Anrede ---*/
                                                  'Tabelle01_002': contact.name
                                                          .prefix.isNotEmpty
                                                      ? contact.name.prefix
                                                      : '',
                                                  /*---------------------------------- Vorname ---*/
                                                  'Tabelle01_003': contact
                                                          .name.first.isNotEmpty
                                                      ? contact.name.first
                                                      : '',
                                                  /*---------------------------------- Nachname ---*/
                                                  'Tabelle01_004': contact
                                                          .name.last.isNotEmpty
                                                      ? contact.name.last
                                                      : '',
                                                  /*---------------------------------- Geburtstag ---*/
                                                  'Tabelle01_005': contact
                                                          .events.isNotEmpty
                                                      ? '${contact.events.first.day.toString().padLeft(2, '0')}.${contact.events.first.month.toString().padLeft(2, '0')}.${contact.events.first.year}'
                                                      : '',
                                                  /*---------------------------------- Straße ---*/
                                                  'Tabelle01_006': contact
                                                          .addresses.isNotEmpty
                                                      ? contact.addresses.first
                                                          .street
                                                      : '',
                                                  /*---------------------------------- PLZ ---*/
                                                  'Tabelle01_008': contact
                                                          .addresses.isNotEmpty
                                                      ? contact.addresses.first
                                                          .postalCode
                                                      : '',
                                                  /*---------------------------------- Stadt ---*/
                                                  'Tabelle01_009': contact
                                                          .addresses.isNotEmpty
                                                      ? contact
                                                          .addresses.first.city
                                                      : '',
                                                  /*---------------------------------- Webseite ---*/
                                                  'Tabelle01_014': contact
                                                          .websites.isNotEmpty
                                                      ? contact
                                                          .websites.first.url
                                                      : '',
                                                  /*---------------------------------- Telefon ---*/
                                                  'Tabelle01_011':
                                                      contact.phones.isNotEmpty
                                                          ? contact.phones.first
                                                              .number
                                                          : '',
                                                  /*---------------------------------- E-Mail ---*/
                                                  'Tabelle01_013':
                                                      contact.emails.isNotEmpty
                                                          ? contact.emails.first
                                                              .address
                                                          : '',
                                                  /*---------------------------------- Firma ---*/
                                                  'Tabelle01_015': contact
                                                          .organizations
                                                          .isNotEmpty
                                                      ? contact.organizations
                                                          .first.company
                                                      : '',
                                                  /*---------------------------------- Notiz ---*/
                                                  'Tabelle01_018':
                                                      contact.notes.isNotEmpty
                                                          ? contact.notes.first
                                                          : '',
                                                  /*---------------------------------- Kontakt-Status ---*/
                                                  'Tabelle01_019':
                                                      'Smartphone-Kontakt',
                                                  /*---------------------------------- Phone-Gruppen (Kategorien) ---*/
                                                  'Tabelle01_020':
                                                      contact.groups.isNotEmpty
                                                          ? contact
                                                              .groups.first.name
                                                          : '',
                                                  /*---------------------------------- Adresse 1 komplett (aus Phone) ---*/
                                                  'Tabelle01_025': contact
                                                          .addresses.isNotEmpty
                                                      ? contact.addresses.first
                                                          .address
                                                      : '',
                                                  /*---------------------------------- Adresse 2 komplett (aus Phone) ---*/
                                                  'Tabelle01_026': // stimmt noch nicht
                                                      contact.addresses
                                                              .isNotEmpty
                                                          ? contact.addresses
                                                              .last.address
                                                          : '',
                                                  /*---------------------------------- SmartKontaktID (SK-ID aus Phone) ---*/
                                                  'Tabelle01_027':
                                                      contact.id.isNotEmpty
                                                          ? contact.id
                                                          : '',
                                                },
                                                /*--------------------------------- *** ---*/
                                                isNewContact: true,
                                              ),
                                            ),
                                          );
                                          /*--------------------------------- Einträge in die ContactScreen - ENDE ---*/
                                        }
                                      },
                                      /*--------------------------------- Button 2 - ENDE ---*/
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16), // Abstand zwischen den Cards
                      ],
                    );
                  },
                ),
              ),
            ),
            /*--------------------------------- Abstand ---*/
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
