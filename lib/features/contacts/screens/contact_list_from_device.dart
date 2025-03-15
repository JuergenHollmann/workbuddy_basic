import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:workbuddy/config/wb_colors.dart';
// import 'package:workbuddy/config/wb_colors.dart';
// import 'package:workbuddy/config/wb_dialog_2buttons.dart';

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
  int currentMax = 10;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> loadContacts() async {
    // Berechtigungen anfordern
    if (await FlutterContacts.requestPermission()) {
      log('0033 - ContactListFromDevice - Zugriff auf Kontakte erlaubt');

      // Alle Kontakte laden
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
        filteredContacts = allContacts.take(currentMax).toList();
        filteredContacts.sort((a, b) => a.displayName.compareTo(b.displayName));
      });
    } else {
      // Berechtigung verweigert
      log('0042 - ContactListFromDevice - Zugriff auf Kontakte verweigert');
    }
  }

  void loadMoreContacts() {
    setState(() {
      currentMax = currentMax + 10;
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = allContacts
          .where((contact) => contact.displayName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Kontakte im Gerät',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: wbColorBackgroundBlue),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            // Anzeige der Anzahl der Kontakte
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Gefunden: ${filteredContacts.length} von ${allContacts.length} Kontakten',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Suchfeld
            TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Icon(
                    Icons.search_outlined,
                    size: 40,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.recycling_outlined,
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
                fillColor: Colors.yellow, // Innere Gelb färben
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
                      color: Colors.black, width: 2), // Schwarzer dünner Rand
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Colors.black, width: 2), // Schwarzer dünner Rand
                ),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            // wbSizedBoxHeight8,
            // Liste der gefilterten Kontakte
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
                  itemCount: filteredContacts.length < currentMax
                      ? filteredContacts.length
                      : currentMax,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                            color: Colors.black,
                            width: 1), // Schwarzer dünner Rand
                        borderRadius:
                            BorderRadius.circular(16), // Radius von 16
                      ),
                      child: Card(
                        color: wbColorBackgroundBlue, // Card rosa einfärben
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16), // Radius von 16
                        ),
                        elevation: 10, // 3-D-Effekt
                        shadowColor: Colors.black54, // Schattenfarbe
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white, // Hintergrund weiß
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
                                Text('Telefon: ${contact.phones.first.number}'),
                              // 'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}'),

                              /*--------------------------------- E-Mail ---*/
                              if (contact.emails.isNotEmpty)
                                Text('E-Mail: ${contact.emails.first.address}'),

                              // /*--- Adresse - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                              // if (contact.addresses.isNotEmpty)
                              //   Text(
                              //       'Adresse: ${contact.addresses.first.address}'),

                              // /*--- Firma - hier deaktiviert wegen schnellerem Seitenaufbau ---*/
                              // if (contact.organizations.isNotEmpty)
                              //   Text(
                              //       'Firma: ${contact.organizations.first.company}'),

                              /*--- Geburtstag - funzt nicht richtig ---*/
                              // if (contact.birthday != null)
                              //   Text(
                              //       'Geburtstag: ${contact.birthday!.day}.${contact.birthday!.month}.${contact.birthday!.year}'),

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

                              // /*--- Event - funzt nicht richtig ---*/
                              // if (contact.events.isNotEmpty)
                              //   Text('Event: ${contact.events.first.label}'),

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

                              /*--------------------------------- Auflistungen - Ereignisse - Geburtstag ---*/
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*--- Mögliche Datenabfrage-Möglichkeiten des Packages "FlutterContacts" ---*/
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
