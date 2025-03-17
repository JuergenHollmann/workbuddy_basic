import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';

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
  int currentMax = 20; // Initiale Anzahl der geladenen Kontakte
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
    // Berechtigungen anfordern
    if (await FlutterContacts.requestPermission()) {
      log('0033 - ContactListFromDevice - Zugriff auf Kontakte erlaubt');

      // Die ersten zwanzig Kontakte ohne zusätzliche Details laden
      allContacts = await FlutterContacts.getContacts(
        withProperties: false,
        withThumbnail: true,
        withPhoto: true,
        withGroups: false,
        withAccounts: false,
        sorted: true,
        deduplicateProperties: false,
      ).then((contacts) => contacts.take(20).toList());

      setState(() {
        filteredContacts = allContacts;
        displayedContacts = filteredContacts.take(currentMax).toList();
      });

      // Die restlichen Kontakte mit allen Details laden
      loadAllContacts();
    } else {
      // Berechtigung verweigert
      log('0042 - ContactListFromDevice - Zugriff auf Kontakte verweigert');
    }
  }

  Future<void> loadAllContacts() async {
    // Alle Kontakte mit allen Details laden
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

  void loadMoreContacts() {
    setState(() {
      currentMax = currentMax + 20; // Lade weitere 20 Kontakte
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
    final Database db = await openDatabase('JOTHAsoft.FiveStars.db', version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS KundenDaten (
          TKD_Feld_001 TEXT,
          TKD_Feld_002 TEXT,
          TKD_Feld_003 TEXT,
          TKD_Feld_004 TEXT,
          TKD_Feld_005 TEXT,
          TKD_Feld_006 TEXT,
          TKD_Feld_007 TEXT,
          TKD_Feld_008 TEXT,
          TKD_Feld_009 TEXT,
          TKD_Feld_010 TEXT,
          TKD_Feld_011 TEXT,
          TKD_Feld_012 TEXT,
          TKD_Feld_013 TEXT,
          TKD_Feld_014 TEXT,
          TKD_Feld_015 TEXT,
          TKD_Feld_016 TEXT,
          TKD_Feld_017 TEXT,
          TKD_Feld_018 TEXT,
          TKD_Feld_019 TEXT,
          TKD_Feld_020 TEXT,
          TKD_Feld_021 TEXT,
          TKD_Feld_022 TEXT,
          TKD_Feld_023 TEXT,
          TKD_Feld_024 TEXT,
          TKD_Feld_025 TEXT,
          TKD_Feld_026 TEXT,
          TKD_Feld_027 TEXT,
          TKD_Feld_028 TEXT,
          TKD_Feld_029 TEXT,
          TKD_Feld_030 TEXT PRIMARY KEY
        )
      ''');
    });
    final List<Map<String, dynamic>> result = await db.query(
      'KundenDaten',
      where: 'TKD_Feld_002 = ? AND TKD_Feld_003 = ?',
      whereArgs: [
        contact.name.first.isNotEmpty ? contact.name.first : '',
        contact.name.last.isNotEmpty ? contact.name.last : '',
      ],
    );
    return result.isNotEmpty;
  }

  // ? '${contact.events.first.year}-${contact.events.first.month.toString().padLeft(2, '0')}-${contact.events.first.day.toString().padLeft(2, '0')}'

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
                                onTap: () {
                                  log('0203 - ContactListFromDevice - Kontakt "${contact.displayName}" angeklickt');
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

                                        bool exists =
                                            await isContactInDatabase(contact);
                                        if (exists) {
                                          log('0588 - ContactListFromDevice - Ergebnis der Abfrage: "Der Kontakt ist bereits in der Datenbank vorhanden."');

                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);

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

                                          // Sound abspielen
                                          player.play(AssetSource(
                                              "sound/sound03enterprise.wav"));
                                        } else {
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

                                          /*--- Öffne den ContactScreen wie mit dem Button "Einen Kontakt NEU anlegen" und übergebe die Kontaktdaten an den ContactScreen ---*/
                                          Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactScreen(
                                                contact: {
                                                  /*---------------------------------- Kontakt-Status ---*/
                                                  'TKD_Feld_019':
                                                      contact.groups.isNotEmpty
                                                          ? contact
                                                              .groups.first.name
                                                          : '',
                                                  /*---------------------------------- Anrede ---*/
                                                  'TKD_Feld_001': contact.name
                                                          .prefix.isNotEmpty
                                                      ? contact.name.prefix
                                                      : '',
                                                  /*---------------------------------- Vorname ---*/
                                                  'TKD_Feld_002': contact
                                                          .name.first.isNotEmpty
                                                      ? contact.name.first
                                                      : '',
                                                  /*---------------------------------- Nachname ---*/
                                                  'TKD_Feld_003': contact
                                                          .name.last.isNotEmpty
                                                      ? contact.name.last
                                                      : '',
                                                  /*---------------------------------- Geburtstag ---*/
                                                  'TKD_Feld_004': contact
                                                          .events.isNotEmpty
                                                      ? '${contact.events.first.day.toString().padLeft(2, '0')}.${contact.events.first.month.toString().padLeft(2, '0')}.${contact.events.first.year}'
                                                      : '',

                                                  /*---------------------------------- Adresse 1 komplett ---*/
                                                  'TKD_Feld_018': // stimmt noch nicht
                                                      contact.addresses
                                                              .isNotEmpty
                                                          ? contact.addresses
                                                              .first.address
                                                          : '',

                                                  /*---------------------------------- Adresse 2 komplett ---*/
                                                  'TKD_Feld_027': // stimmt noch nicht
                                                      contact.addresses
                                                              .isNotEmpty
                                                          ? contact.addresses
                                                              .last.address
                                                          : '',

                                                  /*---------------------------------- Straße ---*/
                                                  'TKD_Feld_005': contact
                                                          .addresses.isNotEmpty
                                                      ? contact.addresses.first
                                                          .street
                                                      : '',
                                                  /*---------------------------------- PLZ ---*/
                                                  'TKD_Feld_006': contact
                                                          .addresses.isNotEmpty
                                                      ? contact.addresses.first
                                                          .postalCode
                                                      : '',

                                                  /*---------------------------------- Stadt ---*/
                                                  'TKD_Feld_007': contact
                                                          .addresses.isNotEmpty
                                                      ? contact
                                                          .addresses.first.city
                                                      : '',

                                                  /*---------------------------------- Webseite ---*/
                                                  'TKD_Feld_012': contact
                                                          .websites.isNotEmpty
                                                      ? contact
                                                          .websites.first.url
                                                      : '',

                                                  /*---------------------------------- Telefon ---*/
                                                  'TKD_Feld_008':
                                                      contact.phones.isNotEmpty
                                                          ? contact.phones.first
                                                              .number
                                                          : '',
                                                  /*---------------------------------- E-Mail ---*/
                                                  'TKD_Feld_009':
                                                      contact.emails.isNotEmpty
                                                          ? contact.emails.first
                                                              .address
                                                          : '',

                                                  /*---------------------------------- Firma ---*/
                                                  'TKD_Feld_014': contact
                                                          .organizations
                                                          .isNotEmpty
                                                      ? contact.organizations
                                                          .first.company
                                                      : '',

                                                  /*---------------------------------- Notiz ---*/
                                                  'TKD_Feld_016':
                                                      contact.notes.isNotEmpty
                                                          ? contact.notes.first
                                                          : '',

                                                  //       /*---------------------------------- Kategorien ---*/
                                                  //       // group: contact.groups.isNotEmpty
                                                  //       //     ? contact.groups.first.name
                                                  //       //     : '',

                                                  /*---------------------------------- ContactID ---*/
                                                  'TKD_Feld_030':
                                                      contact.id.isNotEmpty
                                                          ? contact.id
                                                          : '',
                                                },
                                              ),
                                            ),
                                          );

                                          //       /*--------------------------------- Kontakt-Status ---*/

                                          //       /*--------------------------------- Einträge in die ContactScreen - ENDE ---*/
                                          //     ),
                                          //   ),
                                          // );
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
                        SizedBox(
                            height:
                                16), // Abstand von 8 Pixeln zwischen den Cards
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
