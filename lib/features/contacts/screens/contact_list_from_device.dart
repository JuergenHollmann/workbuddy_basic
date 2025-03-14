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
                          leading: (contact.photo != null &&
                                  contact.photo!.isNotEmpty)
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                        offset: Offset(8, 8),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.photo!),
                                    radius: 30,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person, size: 30),
                                ),
                          title: Text(contact.displayName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: wbColorLogoBlue,
                              )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (contact.phones.isNotEmpty)
                                Text('Telefon: ${contact.phones.first.number}'),
                              if (contact.emails.isNotEmpty)
                                Text('E-Mail: ${contact.emails.first.address}'),
                              if (contact.addresses.isNotEmpty)
                                Text(
                                    'Adresse: ${contact.addresses.first.address}'),
                              if (contact.organizations.isNotEmpty)
                                Text(
                                    'Firma: ${contact.organizations.first.company}'),

                              // if (contact.birthday != null)
                              //   Text(
                              //       'Geburtstag: ${contact.birthday!.day}.${contact.birthday!.month}.${contact.birthday!.year}'),

                              if (contact.notes.isNotEmpty)
                                Text('Notiz: ${contact.notes.first}'),
                              if (contact.websites.isNotEmpty)
                                Text('Webseite: ${contact.websites.first.url}'),

                              // if (contact.socialMedias.isNotEmpty)
                              //   Text(
                              //       'Social Media: ${contact.socialMedias.first.username}'),

                              if (contact.events.isNotEmpty)
                                Text('Event: ${contact.events.first.label}'),
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
