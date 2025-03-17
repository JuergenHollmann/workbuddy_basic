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
          backgroundColor: wbColorButtonBlue),
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
                                        'Telefon: ${contact.phones.first.number}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    // 'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}'),

                                    // /*--------------------------------- E-Mail ---*/
                                    // if (contact.emails.isNotEmpty)
                                    //   Text('E-Mail: ${contact.emails.first.address}'),

                                    // /*--------------------------------- Geburtstag ---*/
                                    // if (contact.events.isNotEmpty)
                                    //   Text(
                                    //       'Geburtstag: ${contact.events.first.day.toString().padLeft(2, '0')}.${contact.events.first.month.toString().padLeft(2, '0')}.${contact.events.first.year}'),

                                    // /*--- Adresse - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.addresses.isNotEmpty)
                                    //   Text(
                                    //       'Adresse: ${contact.addresses.first.address}'),

                                    // /*--- Firma - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.organizations.isNotEmpty)
                                    //   Text(
                                    //       'Firma: ${contact.organizations.first.company}'),

                                    // /*--- Notiz - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.notes.isNotEmpty)
                                    //   Text('Notiz: ${contact.notes.first}'),

                                    // /*--- Webseite - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.websites.isNotEmpty)
                                    //   Text('Webseite: ${contact.websites.first.url}'),

                                    /*--- Social Media - funzt nicht richtig ---*/
                                    // if (contact.socialMedias.isNotEmpty)
                                    //   Text(
                                    //       'Social Media: ${contact.socialMedias.first.username}'),

                                    // /*--- Gruppen - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.groups.isNotEmpty)
                                    //   Text('Gruppen: ${contact.groups.first.name}'),

                                    // /*--- Accounts - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.accounts.isNotEmpty)
                                    //   Text(
                                    //       'Accounts: ${contact.accounts.first.name}'),

                                    // /*--- ContactID - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                                    // if (contact.id.isNotEmpty)
                                    //   Text(
                                    //       'ContactID: ${contact.id.isNotEmpty ? contact.id : 'Keine ContactID'}'),

                                    // Text('---------------------------------------'),
                                    /*--------------------------------- Auflistungen - Name ---*/
                                    // // Text('Name: ${contact.name}'),
                                    // Text('Vorname: ${contact.name.first}'),
                                    // Text('Nachname: ${contact.name.last}'),
                                    // Text('Präfix: ${contact.name.prefix}'),
                                    // Text('Suffix: ${contact.name.suffix}'),
                                    // Text('Mittlerer Name: ${contact.name.middle}'),
                                    // Text('Spitzname: ${contact.name.nickname}'),
                                    // Text(
                                    //     'Vornamens-Zeichen: ${contact.name.firstPhonetic}'),
                                    // Text(
                                    //     'Nachnamens-Zeichen: ${contact.name.lastPhonetic}'),
                                    // Text(
                                    //     'Mittleres Namezeichen: ${contact.name.middlePhonetic}'),

                                    /*--------------------------------- Auflistungen - Accounts ---*/
                                    // // Text('Accounts: ${contact.accounts}'),
                                    // Text(
                                    //     'Accounts first.rawId: ${contact.accounts.first.rawId}'),
                                    // Text(
                                    //     'Accounts first.name: ${contact.accounts.first.name}'),
                                    // Text(
                                    //     'Accounts first.type: ${contact.accounts.first.type}'),
                                    // Text(
                                    //     'Accounts first.mimetypes: ${contact.accounts.first.mimetypes}'),
                                    // // ---> es gibt auch noch "contact.accounts.single" und "contact.accounts.last"

                                    /*--------------------------------- Auflistungen - Adressen ---*/
                                    // Text('Adressen: ${contact.addresses}'),
                                    // Text(
                                    //     'Erste Adresse komplett: ${contact.addresses.first.address}'),
                                    // Text(
                                    //     'Erste Adresse Straße: ${contact.addresses.first.street}'),
                                    // Text(
                                    //     'Erste Adresse Stadt: ${contact.addresses.first.city}'),
                                    // Text(
                                    //     'Erste Adresse PLZ: ${contact.addresses.first.postalCode}'),
                                    // Text(
                                    //     'Erste Adresse Land: ${contact.addresses.first.country}'),
                                    // Text(
                                    //     'Erste Adresse CustomLabel: ${contact.addresses.first.customLabel}'),
                                    // Text(
                                    //     'Erste Adresse ISO-Land: ${contact.addresses.first.isoCountry}'),
                                    // Text(
                                    //     'Erste Adresse Label: ${contact.addresses.first.label}'),
                                    // Text(
                                    //     'Erste Adresse Neighborhood: ${contact.addresses.first.neighborhood}'),
                                    // Text(
                                    //     'Erste Adresse pobox: ${contact.addresses.first.pobox}'),
                                    // Text(
                                    //     'Erste Adresse Bundesland: ${contact.addresses.first.state}'),
                                    // Text(
                                    //     'Erste Adresse subAdminArea: ${contact.addresses.first.subAdminArea}'),
                                    // Text(
                                    //     'Erste Adresse subLocality: ${contact.addresses.first.subLocality}'),
                                    // Text(
                                    //     'Erste Adresse V-CARD: ${contact.addresses.first.toVCard()}'),
                                    // // ---> es gibt auch noch "contact.addresses.single" und "contact.addresses.last"

                                    /*--------------------------------- Auflistungen - E-Mails ---*/
                                    // Text('E-Mails: ${contact.emails}'),

                                    // if (contact.emails.isNotEmpty) ...[
                                    //   Text(
                                    //       'Erste E-Mail address: ${contact.emails.first.address}'),
                                    //   Text(
                                    //       'Erste E-Mail label: ${contact.emails.first.label}'),
                                    //   Text(
                                    //       'Erste E-Mail customLabel: ${contact.emails.first.customLabel}'),
                                    //                                       Text(
                                    //       'Erste E-Mail isPrimary: ${contact.emails.first.isPrimary}'),

                                    //   Text(
                                    //       'Erste E-Mail toVCard: ${contact.emails.first.toVCard()}'),
                                    // ],
                                    // // ---> es gibt auch noch "contact.emails.single" und "contact.emails.last"

                                    /*--------------------------------- Auflistungen - Events - Geburtstag ---*/
                                    // Text('Geburtstag: ${contact.events}'),
                                    // if (contact.events.isNotEmpty) ...[
                                    //   Text(
                                    //       'Geburtstag: ${contact.events.first.customLabel}'),
                                    //   Text(
                                    //       'Geburtstag first.day: ${contact.events.first.day}'),
                                    //   Text(
                                    //       'Geburtstag first.label: ${contact.events.first.label}'),
                                    //   Text(
                                    //       'Geburtstag first.month: ${contact.events.first.month}'),
                                    //   Text(
                                    //       'Geburtstag first.year: ${contact.events.first.year}'),
                                    //   Text(
                                    //       'Geburtstag first.toVCard: ${contact.events.first.toVCard()}'),
                                    // ],
                                    // // ---> es gibt auch noch "contact.events.single" und "contact.events.last"

                                    // /*--------------------------------- Auflistungen - Firmen ---*/
                                    // Text('Firmen: ${contact.organizations}'),
                                    // if (contact.organizations.isNotEmpty) ...[
                                    //   Text('Firmen: ${contact.organizations}'),
                                    //   Text(
                                    //       'Firmen first.company: ${contact.organizations.first.company}'),
                                    //   Text(
                                    //       'Firmen first.department: ${contact.organizations.first.department}'),
                                    //   Text(
                                    //       'Firmen first.jobDescription: ${contact.organizations.first.jobDescription}'),
                                    //   Text(
                                    //       'Firmen first.title: ${contact.organizations.first.title}'),
                                    //   Text(
                                    //       'Firmen first.jobDescription: ${contact.organizations.first.jobDescription}'),
                                    //   Text(
                                    //       'Firmen first.officeLocation: ${contact.organizations.first.officeLocation}'),
                                    //   Text(
                                    //       'Firmen first.symbol: ${contact.organizations.first.symbol}'),
                                    //   Text(
                                    //       'Firmen first.phoneticName: ${contact.organizations.first.phoneticName}'),
                                    //   Text(
                                    //       'Firmen first.toVCard: ${contact.organizations.first.toVCard()}'),
                                    // ],
                                    // // ---> es gibt auch noch "contact.organizations.single" und "contact.organizations.last"

                                    /*--------------------------------- Auflistungen - Gruppen ---*/
                                    // Text('Gruppen: ${contact.groups}'),
                                    // if (contact.groups.isNotEmpty) ...[
                                    //   Text('Gruppen first.id: ${contact.groups.first.id}'),
                                    //   Text('Gruppen first.name: ${contact.groups.first.name}'),
                                    //   Text(
                                    //       'Gruppen first.toString: ${contact.groups.first.toString()}'),
                                    //   Text('Gruppen single.id: ${contact.groups.single.id}'),
                                    //   Text('Gruppen single.name: ${contact.groups.single.name}'),
                                    //   Text(
                                    //       'Gruppen single.toString: ${contact.groups.single.toString()}'),
                                    //   Text('Gruppen last.id: ${contact.groups.last.id}'),
                                    //   Text('Gruppen last.name: ${contact.groups.last.name}'),
                                    //   Text(
                                    //       'Gruppen last.toString: ${contact.groups.last.toString()}'),
                                    // ]

                                    /*--------------------------------- Auflistungen - Notizen ---*/
                                    // Text('Notizen: ${contact.notes}'),
                                    // if (contact.notes.isNotEmpty) ...[
                                    //   Text('Notizen: ${contact.notes}'),
                                    //   Text(
                                    //       'Notizen first: ${contact.notes.first.note}'),

                                    //   Text(
                                    //       'Notizen first: ${contact.notes.first.toVCard()}'),
                                    // ]
                                    // // ---> es gibt auch noch "contact.notes.single" und "contact.notes.last"

                                    /*--------------------------------- Auflistungen - Telefonnummern ---*/
                                    // Text('Telefonnummern: ${contact.phones}'),
                                    // if (contact.phones.isNotEmpty) ...[
                                    // Text(
                                    //     '1. Telefonnummer customLabel: ${contact.phones.first.customLabel}'),
                                    // Text(
                                    //     '1. Telefonnummer isPrimary: ${contact.phones.first.isPrimary}'),
                                    // Text(
                                    //     '1. Telefonnummer label: ${contact.phones.first.label}'),
                                    // Text(
                                    //     '1. Telefonnummer normalizedNumber: ${contact.phones.first.normalizedNumber}'),
                                    // Text(
                                    //     '1. Telefonnummer number: ${contact.phones.first.number}'),
                                    // Text(
                                    //     '1. Telefonnummer toVCard: ${contact.phones.first.toVCard()}'),
                                    // Text(
                                    //     '2. Telefonnummer customLabel: ${contact.phones.last.customLabel}'),
                                    // Text(
                                    //     '2. Telefonnummer isPrimary: ${contact.phones.last.isPrimary}'),
                                    // Text(
                                    //     '2. Telefonnummer label: ${contact.phones.last.label}'),
                                    // Text(
                                    //     '2. Telefonnummer normalizedNumber: ${contact.phones.last.normalizedNumber}'),
                                    // Text(
                                    //     '2. Telefonnummer number: ${contact.phones.last.number}'),
                                    // Text(
                                    //     '2. Telefonnummer toVCard: ${contact.phones.last.toVCard()}'),
                                    // ]
                                    // // ---> es gibt auch noch "contact.phones.last"

                                    /*--------------------------------- Auflistungen - Soziale Medien ---*/
                                    // Text('Soziale Medien: ${contact.socialMedias}'),
                                    // if (contact.socialMedias.isNotEmpty) ...[
                                    //   Text(
                                    //       'Soziale Medien first.customLabel: ${contact.socialMedias.first.customLabel}'),
                                    //   Text(
                                    //       'Soziale Medien first.label: ${contact.socialMedias.first.label}'),
                                    //   Text(
                                    //       'Soziale Medien first.userName: ${contact.socialMedias.first.userName}'),
                                    //   Text(
                                    //       'Soziale Medien first,toVCard: ${contact.socialMedias.first.toVCard()}'),
                                    // ]
                                    // // ---> es gibt auch noch "contact.socialMedias.single" und "contact.socialMedias.last"

                                    /*--------------------------------- Auflistungen - Webseiten ---*/
                                    // Text('Webseiten: ${contact.websites}'),
                                    // if (contact.websites.isNotEmpty) ...[
                                    // Text(
                                    //     'Webseiten first.customLabel: ${contact.websites.first.customLabel}'),
                                    // Text(
                                    //     'Webseiten first.label: ${contact.websites.first.label}'),
                                    // Text(
                                    //     'Webseite: ${contact.websites.first.url}'),
                                    // Text(
                                    //     'Webseiten first.toString: ${contact.websites.first.toString()}'),
                                    // Text(
                                    //     'Webseiten first.toVCard: ${contact.websites.first.toVCard()}'),
                                    // ]
                                    // // ---> es gibt auch noch "contact.websites.single" und "contact.websites.last"
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

                                                  //       // country: contact.addresses.isNotEmpty ? contact.addresses.first.country : '',
                                                  //       // customLabel: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.customLabel
                                                  //       //     : '',
                                                  //       // isoCountry: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.isoCountry
                                                  //       //     : '',
                                                  //       // label: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.label
                                                  //       //     : '',
                                                  //       // neighborhood: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.neighborhood
                                                  //       //     : '',
                                                  //       // pobox: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.pobox
                                                  //       //     : '',
                                                  //       // state: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.state
                                                  //       //     : '',
                                                  //       // subAdminArea: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.subAdminArea
                                                  //       //     : '',
                                                  //       // subLocality: contact.addresses.isNotEmpty
                                                  //       //     ? contact.addresses.first.subLocality
                                                  //       //     : '',
                                                  //       // toVCard: contact.addresses.isNotEmpty   ? contact.addresses.first.toVCard()    : '',
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

// extension on Contact {
//   toMap() {}
// }

/*--- Mögliche Datenabfragen des Packages "FlutterContacts" ---*/
// contact.phones
// contact.emails
// contact.addresses
// contact.organizations
// contact.birthday
// contact.notes
// contact.websites
// contact.socialMedias
// contact.events
// contact.groups
// contact.accounts
// contact.customProperties
