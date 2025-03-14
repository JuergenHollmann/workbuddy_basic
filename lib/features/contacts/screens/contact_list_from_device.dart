import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_dialog_2buttons.dart';

class ContactListFromDevice extends StatefulWidget {
  const ContactListFromDevice({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListFromDeviceState createState() => _ContactListFromDeviceState();
}

class _ContactListFromDeviceState extends State<ContactListFromDevice> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<Group> _groups = [];
  String _selectedGroup = 'Alle Kontakte';
  bool _permissionDenied = false;
  bool _isLoading = true;
  double _progress = 0.0;
  bool _isGroupSelected = false;
  bool withGroups = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchGroups();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _fetchGroups() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _permissionDenied = true);
      return;
    }

    final groups = await FlutterContacts.getGroups();
    groups.sort((a, b) => a.name.compareTo(b.name)); // Sortieren nach Namen
    setState(() {
      _groups = groups;
    });
  }

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _permissionDenied = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    final contacts = <Contact>[];
    await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
      withGroups: true,

      // group: _selectedGroup == 'Alle Kontakte' ? null : _selectedGroup,
      // onProgress: (current, total) {
      //   setState(() {
      //     _progress = current / total;
      //   });
      // },
    ).then((fetchedContacts) {
      for (var contact in fetchedContacts) {
        contacts.add(contact);
        log('0075 - ContactListFromDevice - Kontakt: $contact');
      }
    });

    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
      _isLoading = false;
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.displayName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Smartphone Kontaktliste'),
        ),
        body: const Center(child: Text('Berechtigung verweigert')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: wbColorBackgroundBlue,
        title: Text(
          'Anzahl der Kontakte: ${_contacts.length}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButton<String>(
              value: _selectedGroup,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGroup = newValue!;
                  _isGroupSelected = true;
                  _fetchContacts();
                });
              },
              items: ['Alle Kontakte', ..._groups.map((group) => group.name)]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          if (_isGroupSelected)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Suche Kontakte',
                  labelStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _progress,
                          color: wbColorBackgroundBlue,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(textAlign: TextAlign.center,
                            'Bitte zuerst eine Gruppe\noder "Alle Kontakte auswählen"\naus deinen Kontakten anklicken.\nFortschritt: ${(_progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return ListTile(
                        leading: (contact.photo != null &&
                                contact.photo!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 40,
                              )
                            : const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 50),
                              ),
                        title: Text(contact.displayName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                          ],
                        ),
                        onTap: () {
                          log('0140 - ContactListFromDevice - Kontakt ausgewählt: $contact');

                          /*--------------------------------- AlertDialog - START ---*/
                          /* Abfrage ob die App geschlossen werden soll */
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => WBDialog2Buttons(
                              headLineText:
                                  'Diesen Kontakt aus deinem internen Adressbuch in "WorkBuddy" übernehmen?',
                              descriptionText:
                                  'Kontakt: ${contact.displayName.isNotEmpty ? contact.displayName : 'Kein Name'}\n'
                                  'Firma: ${contact.organizations.isNotEmpty ? contact.organizations : 'Keine Firma'}\n'
                                  'Adresse: ${contact.addresses.isNotEmpty ? contact.addresses.first.address : 'Keine Adresse'}\n'
                                  'Geburtstag: ${contact.events.isNotEmpty && contact.events.first.year != null ? '${contact.events.first.day}.${contact.events.first.month}.${contact.events.first.year}' : 'Kein Geburtstag'}\n'
                                  'Notiz: ${contact.notes.isNotEmpty ? contact.notes : 'Keine Notizen'}\n'
                                  'Webseite: ${contact.websites.isNotEmpty ? contact.websites.first.url : 'Keine Webseite'}\n'
                                  'Social Media: ${contact.socialMedias.isNotEmpty ? contact.socialMedias.first.toString() : 'Kein Social Media'}\n'
                                  'Jobtitel: ${contact.events.isNotEmpty ? contact.events : 'Kein Job'}\n'
                                  'Vorname: ${contact.name.first.isNotEmpty ? contact.name.first : 'Kein Vorname'}\n'
                                  'Zweiter Vorname: ${contact.name.middle.isNotEmpty ? contact.name.middle : 'Kein zweiter Vorname'}\n'
                                  'Spitzname: ${contact.name.nickname.isNotEmpty ? contact.name.nickname : 'Kein Spitzname'}\n'
                                  'Photo: ${contact.photo != null ? 'Photo vorhanden' : 'Kein Photo'}\n'
                                  'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}\n'
                                  'E-Mail: ${contact.emails.isNotEmpty ? contact.emails.first.address : 'Keine E-Mail-Adresse'}',

                              /*--------------------------------- Button 2 "Ja • Übernehmen" ---*/
                              wbText2: "Ja • Übernehmen",
                              wbColor2: wbColorButtonGreen,
                              wbWidth2W155: double.infinity, // maximale Breite
                              wbOnTap2: () {
                                Navigator.of(context).pop();
                                log('0158 - ContactListFromDevice - Button 2 "Ja • Übernehmen" wurde angeklickt');

                                /*--------------------------------- Snackbar ---*/
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: wbColorOrangeDarker,
                                  content: const Text(
                                    'Die Daten werden in "WorkBuddy" übernommen ... 😉',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ));
                              },
                              /*--------------------------------- Button 1 "Nein • Abbrechen" ---*/
                              wbText1: "Nein • Abbrechen",
                              wbColor1: wbColorButtonDarkRed,
                              wbWidth1W155: double.infinity, // maximale Breite
                              wbOnTap1: () {
                                Navigator.of(context).pop();
                                log('0181 - ContactListFromDevice - Button 1 "Nein • Abbrechen" wurde angeklickt');

                                /*--------------------------------- Snackbar ---*/
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: wbColorButtonDarkRed,
                                  content: const Text(
                                    'Die Daten werden NICHT in "WorkBuddy" übernommen ... 😉',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ));
                              },
                            ),
                          );
                          /*--------------------------------- AlertDialog ENDE ---*/
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}




/*--------------------------------- ContactListFromDevice - START ---*/
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:workbuddy/config/wb_colors.dart';
// import 'package:workbuddy/config/wb_dialog_2buttons.dart';

// class ContactListFromDevice extends StatefulWidget {
//   const ContactListFromDevice({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ContactListFromDeviceState createState() => _ContactListFromDeviceState();
// }

// class _ContactListFromDeviceState extends State<ContactListFromDevice> {
//   List<Contact> _contacts = [];
//   List<Contact> _filteredContacts = [];
//   List<Group> _groups = [];
//   String _selectedGroup = 'Alle Kontakte';
//   bool _permissionDenied = false;
//   bool _isLoading = true;
//   double _progress = 0.0;

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchGroups();
//     _searchController.addListener(_filterContacts);
//   }

//   Future<void> _fetchGroups() async {
//     if (!await FlutterContacts.requestPermission()) {
//       setState(() => _permissionDenied = true);
//       return;
//     }

//     final groups = await FlutterContacts.getGroups();
//     setState(() {
//       _groups = groups;
//     });
//   }

//   Future<void> _fetchContacts() async {
//     if (!await FlutterContacts.requestPermission()) {
//       setState(() => _permissionDenied = true);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _progress = 0.0;
//     });

//     final contacts = <Contact>[];
//     await FlutterContacts.getContacts(
//       withProperties: true,
//       withPhoto: true,
//       //group: _selectedGroup == 'Alle Kontakte' ? null : _selectedGroup,
//       // onProgress: (current, total) {
//       //   setState(() {
//       //     _progress = current / total;
//       //   });
//       // },
//     ).then((fetchedContacts) {
//       for (var contact in fetchedContacts) {
//         contacts.add(contact);
//       }
//     });

//     setState(() {
//       _contacts = contacts;
//       _filteredContacts = contacts;
//       _isLoading = false;
//     });
//   }

//   void _filterContacts() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredContacts = _contacts.where((contact) {
//         return contact.displayName.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_permissionDenied) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Smartphone Kontaktliste'),
//         ),
//         body: const Center(child: Text('Berechtigung verweigert')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: wbColorBackgroundBlue,
//         title: Text(
//           'Anzahl der Kontakte: ${_contacts.length}',
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//             child: DropdownButton<String>(
//               value: _selectedGroup,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedGroup = newValue!;
//                   _fetchContacts();
//                 });
//               },
//               items: ['Alle Kontakte', ..._groups.map((group) => group.name)]
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//             child: TextField(
//               controller: _searchController,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               decoration: const InputDecoration(
//                 labelText: 'Suche Kontakte',
//                 labelStyle:
//                     TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           value: _progress,
//                           color: wbColorBackgroundBlue,
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'Bitte warten ... ${(_progress * 100).toStringAsFixed(0)}%',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: _filteredContacts.length,
//                     itemBuilder: (context, index) {
//                       final contact = _filteredContacts[index];
//                       return ListTile(
//                         leading: (contact.photo != null &&
//                                 contact.photo!.isNotEmpty)
//                             ? CircleAvatar(
//                                 backgroundImage: MemoryImage(contact.photo!),
//                                 radius: 40,
//                               )
//                             : const CircleAvatar(
//                                 radius: 30,
//                                 child: Icon(Icons.person, size: 50),
//                               ),
//                         title: Text(contact.displayName,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (contact.phones.isNotEmpty)
//                               Text('Telefon: ${contact.phones.first.number}'),
//                             if (contact.emails.isNotEmpty)
//                               Text('E-Mail: ${contact.emails.first.address}'),
//                             if (contact.addresses.isNotEmpty)
//                               Text(
//                                   'Adresse: ${contact.addresses.first.address}'),
//                           ],
//                         ),
//                         onTap: () {
//                           log('0140 - ContactListFromDevice - Kontakt ausgewählt: $contact');

//                           /*--------------------------------- AlertDialog - START ---*/
//                           /* Abfrage ob die App geschlossen werden soll */
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) => WBDialog2Buttons(
//                               headLineText:
//                                   'Diesen Kontakt aus deinem internen Adressbuch in "WorkBuddy" übernehmen?',
//                               descriptionText:
//                                   'Kontakt: ${contact.displayName.isNotEmpty ? contact.displayName : 'Kein Name'}\n'
//                                   'Firma: ${contact.organizations.isNotEmpty ? contact.organizations : 'Keine Firma'}\n'
//                                   'Adresse: ${contact.addresses.isNotEmpty ? contact.addresses.first.address : 'Keine Adresse'}\n'
//                                   'Geburtstag: ${contact.events.isNotEmpty && contact.events.first.year != null ? '${contact.events.first.day}.${contact.events.first.month}.${contact.events.first.year}' : 'Kein Geburtstag'}\n'
//                                   'Notiz: ${contact.notes.isNotEmpty ? contact.notes : 'Keine Notizen'}\n'
//                                   'Webseite: ${contact.websites.isNotEmpty ? contact.websites.first.url : 'Keine Webseite'}\n'
//                                   'Social Media: ${contact.socialMedias.isNotEmpty ? contact.socialMedias.first.toString() : 'Kein Social Media'}\n'
//                                   'Jobtitel: ${contact.events.isNotEmpty ? contact.events : 'Kein Job'}\n'
//                                   'Vorname: ${contact.name.first.isNotEmpty ? contact.name.first : 'Kein Vorname'}\n'
//                                   'Zweiter Vorname: ${contact.name.middle.isNotEmpty ? contact.name.middle : 'Kein zweiter Vorname'}\n'
//                                   'Spitzname: ${contact.name.nickname.isNotEmpty ? contact.name.nickname : 'Kein Spitzname'}\n'
//                                   'Photo: ${contact.photo != null ? 'Photo vorhanden' : 'Kein Photo'}\n'
//                                   'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}\n'
//                                   'E-Mail: ${contact.emails.isNotEmpty ? contact.emails.first.address : 'Keine E-Mail-Adresse'}',

//                               /*--------------------------------- Button 2 "Ja • Übernehmen" ---*/
//                               wbText2: "Ja • Übernehmen",
//                               wbColor2: wbColorButtonGreen,
//                               wbWidth2W155: double.infinity, // maximale Breite
//                               wbOnTap2: () {
//                                 Navigator.of(context).pop();
//                                 log('0158 - ContactListFromDevice - Button 2 "Ja • Übernehmen" wurde angeklickt');

//                                 /*--------------------------------- Snackbar ---*/
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   backgroundColor: wbColorOrangeDarker,
//                                   content: const Text(
//                                     'Die Daten werden in "WorkBuddy" übernommen ... 😉',
//                                     style: TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ));
//                               },
//                               /*--------------------------------- Button 1 "Nein • Abbrechen" ---*/
//                               wbText1: "Nein • Abbrechen",
//                               wbColor1: wbColorButtonDarkRed,
//                               wbWidth1W155: double.infinity, // maximale Breite
//                               wbOnTap1: () {
//                                 Navigator.of(context).pop();
//                                 log('0181 - ContactListFromDevice - Button 1 "Nein • Abbrechen" wurde angeklickt');

//                                 /*--------------------------------- Snackbar ---*/
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   backgroundColor: wbColorButtonDarkRed,
//                                   content: const Text(
//                                     'Die Daten werden NICHT in "WorkBuddy" übernommen ... 😉',
//                                     style: TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ));
//                               },
//                             ),
//                           );
//                           /*--------------------------------- AlertDialog ENDE ---*/
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

// /*--------------------------------- *** ---*/





// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_contacts/flutter_contacts.dart';
// // import 'package:workbuddy/config/wb_colors.dart';
// // import 'package:workbuddy/config/wb_dialog_2buttons.dart';

// // class ContactListFromDevice extends StatefulWidget {
// //   const ContactListFromDevice({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _ContactListFromDeviceState createState() => _ContactListFromDeviceState();
// // }

// // class _ContactListFromDeviceState extends State<ContactListFromDevice> {
// //   List<Contact> _contacts = [];
// //   List<Contact> _filteredContacts = [];
// //   bool _permissionDenied = false;
// //   bool _isLoading = true;
// //   final double _progress = 0.0;

// //   final TextEditingController _searchController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchContacts();
// //     _searchController.addListener(_filterContacts);
// //   }

// //   Future<void> _fetchContacts() async {
// //     if (!await FlutterContacts.requestPermission()) {
// //       setState(() => _permissionDenied = true);
// //       return;
// //     }

// //     // final contacts = <Contact>[];
// //     // final fetchedContacts = await FlutterContacts.getContacts(
// //     //   withProperties: true,
// //     //   withPhoto: true,
// //     // );

// //     // for (var contact in fetchedContacts) {
// //     //   contacts.add(contact);
// //     // }

// // final contacts = <Contact>[];
// //     final fetchedContacts = await FlutterContacts.getContacts(
// //       withProperties: true,
// //       withPhoto: true,
// //     );

// //     for (final contact in fetchedContacts) {
// //       contacts.add(contact);
// //       if (contacts.length % 100 == 0) {
// //         setState(() {
// //           _contacts = List.from(contacts);
// //           _filteredContacts = List.from(contacts);
// //         });
// //       }
// //     }

// //     setState(() {
// //       _contacts = contacts;
// //       _filteredContacts = contacts;
// //       _isLoading = false;
// //     });
// //   }

// //   void _filterContacts() {
// //     final query = _searchController.text.toLowerCase();
// //     setState(() {
// //       _filteredContacts = _contacts.where((contact) {
// //         return contact.displayName.toLowerCase().contains(query);
// //       }).toList();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_permissionDenied) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Smartphone Kontaktliste'),
// //         ),
// //         body: const Center(child: Text('Berechtigung verweigert')),
// //       );
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: wbColorBackgroundBlue,
// //         title: Text(
// //           'Anzahl der Kontakte: ${_contacts.length}',
// //           style: const TextStyle(
// //             fontSize: 22,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //       body: _isLoading
// //           ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CircularProgressIndicator(
// //                     value: _progress,
// //                     color: wbColorBackgroundBlue,
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Text(
// //                     'Bitte warten ... ${(_progress * 100).toStringAsFixed(0)}%',
// //                     style: const TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           : Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     style: const TextStyle(
// //                         fontSize: 24, fontWeight: FontWeight.bold),
// //                     decoration: const InputDecoration(
// //                       labelText: 'Suche Kontakte',
// //                       labelStyle:
// //                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: _filteredContacts.length,
// //                     itemBuilder: (context, index) {
// //                       final contact = _filteredContacts[index];
// //                       return ListTile(
// //                         leading: (contact.photo != null &&
// //                                 contact.photo!.isNotEmpty)
// //                             ? CircleAvatar(
// //                                 backgroundImage: MemoryImage(contact.photo!),
// //                                 radius: 40,
// //                               )
// //                             : const CircleAvatar(
// //                                 radius: 30,
// //                                 child: Icon(Icons.person, size: 50),
// //                               ),
// //                         title: Text(contact.displayName,
// //                             style: const TextStyle(
// //                                 fontSize: 18, fontWeight: FontWeight.bold)),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             if (contact.phones.isNotEmpty)
// //                               Text('Telefon: ${contact.phones.first.number}'),
// //                             if (contact.emails.isNotEmpty)
// //                               Text('E-Mail: ${contact.emails.first.address}'),
// //                             if (contact.addresses.isNotEmpty)
// //                               Text(
// //                                   'Adresse: ${contact.addresses.first.address}'),
// //                           ],
// //                         ),
// //                         onTap: () {
// //                           log('0140 - ContactListFromDevice - Kontakt ausgewählt: $contact');

// //                           /*--------------------------------- AlertDialog - START ---*/
// //                           /* Abfrage ob die App geschlossen werden soll */
// //                           showDialog(
// //                             context: context,
// //                             builder: (BuildContext context) => WBDialog2Buttons(
// //                               headLineText:
// //                                   'Diesen Kontakt aus deinem internen Adressbuch in "WorkBuddy" übernehmen?',
// //                               descriptionText:
// //                                   'Kontakt: ${contact.displayName.isNotEmpty ? contact.displayName : 'Kein Name'}\n'
// //                                   'Firma: ${contact.organizations.isNotEmpty ? contact.organizations : 'Keine Firma'}\n'
// //                                   'Adresse: ${contact.addresses.isNotEmpty ? contact.addresses.first.address : 'Keine Adresse'}\n'
// //                                   'Geburtstag: ${contact.events.isNotEmpty && contact.events.first.year != null ? '${contact.events.first.day}.${contact.events.first.month}.${contact.events.first.year}' : 'Kein Geburtstag'}\n'
// //                                   'Notiz: ${contact.notes.isNotEmpty ? contact.notes : 'Keine Notizen'}\n'
// //                                   'Webseite: ${contact.websites.isNotEmpty ? contact.websites.first.url : 'Keine Webseite'}\n'
// //                                   'Social Media: ${contact.socialMedias.isNotEmpty ? contact.socialMedias.first.toString() : 'Kein Social Media'}\n'
// //                                   'Jobtitel: ${contact.events.isNotEmpty ? contact.events : 'Kein Job'}\n'
// //                                   'Vorname: ${contact.name.first.isNotEmpty ? contact.name.first : 'Kein Vorname'}\n'
// //                                   'Zweiter Vorname: ${contact.name.middle.isNotEmpty ? contact.name.middle : 'Kein zweiter Vorname'}\n'
// //                                   'Spitzname: ${contact.name.nickname.isNotEmpty ? contact.name.nickname : 'Kein Spitzname'}\n'
// //                                   'Photo: ${contact.photo != null ? 'Photo vorhanden' : 'Kein Photo'}\n'
// //                                   'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}\n'
// //                                   'E-Mail: ${contact.emails.isNotEmpty ? contact.emails.first.address : 'Keine E-Mail-Adresse'}',

// //                               /*--------------------------------- Button 2 "Ja • Übernehmen" ---*/
// //                               wbText2: "Ja • Übernehmen",
// //                               wbColor2: wbColorButtonGreen,
// //                               wbWidth2W155: double.infinity, // maximale Breite
// //                               wbOnTap2: () {
// //                                 Navigator.of(context).pop();
// //                                 log('0158 - ContactListFromDevice - Button 2 "Ja • Übernehmen" wurde angeklickt');

// //                                 /*--------------------------------- Snackbar ---*/
// //                                 ScaffoldMessenger.of(context)
// //                                     .showSnackBar(SnackBar(
// //                                   backgroundColor: wbColorOrangeDarker,
// //                                   content: const Text(
// //                                     'Die Daten werden in "WorkBuddy" übernommen ... 😉',
// //                                     style: TextStyle(
// //                                       fontSize: 28,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                 ));
// //                               },
// //                               /*--------------------------------- Button 1 "Nein • Abbrechen" ---*/
// //                               wbText1: "Nein • Abbrechen",
// //                               wbColor1: wbColorButtonDarkRed,
// //                               wbWidth1W155: double.infinity, // maximale Breite
// //                               wbOnTap1: () {
// //                                 Navigator.of(context).pop();
// //                                 log('0181 - ContactListFromDevice - Button 1 "Nein • Abbrechen" wurde angeklickt');

// //                                 /*--------------------------------- Snackbar ---*/
// //                                 ScaffoldMessenger.of(context)
// //                                     .showSnackBar(SnackBar(
// //                                   backgroundColor: wbColorButtonDarkRed,
// //                                   content: const Text(
// //                                     'Die Daten werden NICHT in "WorkBuddy" übernommen ... 😉',
// //                                     style: TextStyle(
// //                                       fontSize: 28,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                 ));
// //                               },
// //                             ),
// //                           );
// //                           /*--------------------------------- AlertDialog ENDE ---*/
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// // }








// // // import 'dart:developer';

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_contacts/flutter_contacts.dart';
// // // import 'package:workbuddy/config/wb_colors.dart';
// // // import 'package:workbuddy/config/wb_dialog_2buttons.dart';

// // // class ContactListFromDevice extends StatefulWidget {
// // //   const ContactListFromDevice({super.key});

// // //   @override
// // //   // ignore: library_private_types_in_public_api
// // //   _ContactListFromDeviceState createState() => _ContactListFromDeviceState();
// // // }

// // // class _ContactListFromDeviceState extends State<ContactListFromDevice> {
// // //   List<Contact> _contacts = [];
// // //   List<Contact> _filteredContacts = [];
// // //   bool _permissionDenied = false;
// // //   bool _isLoading = true;
// // //   double _progress = 0.0;

// // //   final TextEditingController _searchController = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchContacts();
// // //     _searchController.addListener(_filterContacts);
// // //   }

// // //   Future<void> _fetchContacts() async {
// // //     if (!await FlutterContacts.requestPermission()) {
// // //       setState(() => _permissionDenied = true);
// // //       return;
// // //     }

// // //     // final contacts = await FlutterContacts.getContacts(
// // //     //   withProperties: true,
// // //     //   withPhoto: true,
// // //     // );



// // //     // // onProgress callback to update progress
// // //     // final contacts = await FlutterContacts.getContacts(
// // //     //   withProperties: true,
// // //     //   withPhoto: true,
// // //     //   onProgress: (current, total) {
// // //     //     setState(() {
// // //     //       _progress = current / total;
// // //     //     });
// // //     //   },
// // //     // );

// // //     final contacts = <Contact>[];
// // //     await FlutterContacts.getContacts(
// // //       withProperties: true,
// // //       withPhoto: true,
// // //       onProgress: (current, total) {
// // //         setState(() {
// // //           _progress = current / total;
// // //         });
// // //       },
// // //     ).forEach((contact) {
// // //       contacts.add(contact);
// // //     });

// // //     setState(() {
// // //       _contacts = contacts;
// // //       _filteredContacts = contacts;
// // //       _isLoading = false;
// // //     });
// // //   }

// // //   void _filterContacts() {
// // //     final query = _searchController.text.toLowerCase();
// // //     setState(() {
// // //       _filteredContacts = _contacts.where((contact) {
// // //         return contact.displayName.toLowerCase().contains(query);
// // //       }).toList();
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     if (_permissionDenied) {
// // //       return Scaffold(
// // //         appBar: AppBar(
// // //           title: const Text('Smartphone Kontaktliste'),
// // //         ),
// // //         body: Center(child: Text('Berechtigung verweigert')),
// // //       );
// // //     }

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: wbColorBackgroundBlue,
// // //         title: Text(
// // //           'Anzahl der Kontakte: ${_contacts.length}',
// // //           style: TextStyle(
// // //             fontSize: 22,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //       ),
// // //       body: _isLoading
// // //           ? Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   CircularProgressIndicator(
// // //                     value: _progress,
// // //                     color: wbColorBackgroundBlue,
// // //                   ),
// // //                   const SizedBox(height: 20),
// // //                   Text(
// // //                     'Bitte warten ... ${(_progress * 100).toStringAsFixed(0)}%',
// // //                     style: const TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             )
// // //           : Column(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// // //                   child: TextField(
// // //                     controller: _searchController,
// // //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //                     decoration: InputDecoration(
// // //                       labelText: 'Suche Kontakte',
// // //                       labelStyle:
// // //                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //                       border: OutlineInputBorder(),
// // //                     ),
// // //                   ),
// // //                 ),

// // // // displayName: Der vollständige Name des Kontakts.
// // // // givenName: Der Vorname des Kontakts.
// // // // middleName: Der zweite Vorname des Kontakts.
// // // // familyName: Der Nachname des Kontakts.
// // // // prefix: Der Präfix des Namens (z.B. "Dr.").
// // // // suffix: Der Suffix des Namens (z.B. "Jr.").
// // // // organization: Der Name der Firma oder Organisation, mit der der Kontakt verbunden ist.
// // // // jobTitle: Der Jobtitel des Kontakts.
// // // // phones: Eine Liste von Telefonnummern des Kontakts.
// // // // emails: Eine Liste von E-Mail-Adressen des Kontakts.
// // // // addresses: Eine Liste von Adressen des Kontakts.
// // // // birthday: Das Geburtsdatum des Kontakts.
// // // // photo: Ein Bild des Kontakts.
// // // // note: Notizen zum Kontakt.
// // // // websites: Eine Liste von Websites des Kontakts.
// // // // socialMedias: Eine Liste von Social-Media-Profilen des Kontakts.

// // //                 Expanded(
// // //                   child: ListView.builder(
// // //                     itemCount: _filteredContacts.length,
// // //                     itemBuilder: (context, index) {
// // //                       final contact = _filteredContacts[index];
// // //                       return ListTile(
// // //                         leading: (contact.photo != null &&
// // //                                 contact.photo!.isNotEmpty)
// // //                             ? CircleAvatar(
// // //                                 backgroundImage: MemoryImage(contact.photo!),
// // //                                 radius: 40,
// // //                               )
// // //                             : const CircleAvatar(
// // //                                 radius: 30,
// // //                                 child: Icon(Icons.person, size: 50),
// // //                               ),
// // //                         title: Text(contact.displayName,
// // //                             style: TextStyle(
// // //                                 fontSize: 18, fontWeight: FontWeight.bold)),
// // //                         subtitle: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             // if (contact.organization.isNotEmpty)
// // //                             //   Text('Firma: ${contact.organization}'),
// // //                             // if (contact.birthday != null)
// // //                             //   Text('Geburtstag: ${contact.birthday!.day}.${contact.birthday!.month}.${contact.birthday!.year}'),
// // //                             if (contact.phones.isNotEmpty)
// // //                               Text('Telefon: ${contact.phones.first.number}'),
// // //                             if (contact.emails.isNotEmpty)
// // //                               Text('E-Mail: ${contact.emails.first.address}'),
// // //                             if (contact.addresses.isNotEmpty)
// // //                               Text(
// // //                                   'Adresse: ${contact.addresses.first.address}'),
// // //                           ],
// // //                         ),
// // //                         onTap: () {
// // //                           log('0140 - ContactListFromDevice - Kontakt ausgewählt: $contact');

// // //                           /*--------------------------------- AlertDialog - START ---*/
// // //                           /* Abfrage ob die App geschlossen werden soll */
// // //                           showDialog(
// // //                             context: context,
// // //                             builder: (BuildContext context) => WBDialog2Buttons(
// // //                               headLineText:
// // //                                   'Diesen Kontakt aus deinem internen Adressbuch in "WorkBuddy" übernehmen?',
// // //                               descriptionText:
// // //                                   'Kontakt: ${contact.displayName.isNotEmpty ? contact.displayName : 'Kein Name'}\n'
// // //                                   'Firma: ${contact.organizations.isNotEmpty ? contact.organizations : 'Keine Firma'}\n'
// // //                                   'Adresse: ${contact.addresses.isNotEmpty ? contact.addresses.first.address : 'Keine Adresse'}\n'
// // //                                   'Geburtstag: ${contact.events.isNotEmpty && contact.events.first.year != null ? '${contact.events.first.day}.${contact.events.first.month}.${contact.events.first.year}' : 'Kein Geburtstag'}\n'
// // //                                   'Notiz: ${contact.notes.isNotEmpty ? contact.notes : 'Keine Notizen'}\n'
// // //                                   'Webseite: ${contact.websites.isNotEmpty ? contact.websites.first.url : 'Keine Webseite'}\n'
// // //                                   'Social Media: ${contact.socialMedias.isNotEmpty ? contact.socialMedias.first.toString() : 'Kein Social Media'}\n'
// // //                                   '---> Jobtitel: ${contact.events.isNotEmpty ? contact.events : 'Kein Job'}\n'
// // //                                   // 'Prefix: ${contact.prefix.isNotEmpty ? contact.prefix : 'Kein Prefix'}\n'
// // //                                   // 'Suffix: ${contact.suffix.isNotEmpty ? contact.suffix : 'Kein Suffix'}\n'
// // //                                   'Vorname: ${contact.name.first.isNotEmpty ? contact.name.first : 'Kein Vorname'}\n'
// // //                                   'Zweiter Vorname: ${contact.name.middle.isNotEmpty ? contact.name.middle : 'Kein zweiter Vorname'}\n'
// // //                                   'Spitzname: ${contact.name.nickname.isNotEmpty ? contact.name.nickname : 'Kein Spitzname'}\n'
// // //                                   'Photo: ${contact.photo != null ? 'Photo vorhanden' : 'Kein Photo'}\n'
// // //                                   'Telefon: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'Keine Telefonnummer'}\n'
// // //                                   'E-Mail: ${contact.emails.isNotEmpty ? contact.emails.first.address : 'Keine E-Mail-Adresse'}',

// // //                               //events=[Event(year=1998, month=6, day=15, label=EventLabel.birthday,

// // //                               /*--------------------------------- Button 2 "Ja • Übernehmen" ---*/
// // //                               wbText2: "Ja • Übernehmen",
// // //                               wbColor2: wbColorButtonGreen,
// // //                               wbWidth2W155: double.infinity, // maximale Breite
// // //                               wbOnTap2: () {
// // //                                 Navigator.of(context).pop();
// // //                                 log('0158 - ContactListFromDevice - Button 2 "Ja • Übernehmen" wurde angeklickt');

// // //                                 /*--------------------------------- Snackbar ---*/
// // //                                 ScaffoldMessenger.of(context)
// // //                                     .showSnackBar(SnackBar(
// // //                                   backgroundColor: wbColorOrangeDarker,
// // //                                   content: Text(
// // //                                     'Die Daten werden in "WorkBuddy" übernommen ... 😉',
// // //                                     style: TextStyle(
// // //                                       fontSize: 28,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       color: Colors.white,
// // //                                     ),
// // //                                   ),
// // //                                 ));
// // //                               },
// // //                               /*--------------------------------- Button 1 "Nein • Abbrechen" ---*/
// // //                               wbText1: "Nein • Abbrechen",
// // //                               wbColor1: wbColorButtonDarkRed,
// // //                               wbWidth1W155: double.infinity, // maximale Breite
// // //                               wbOnTap1: () {
// // //                                 Navigator.of(context).pop();
// // //                                 log('0181 - ContactListFromDevice - Button 1 "Nein • Abbrechen" wurde angeklickt');

// // //                                 /*--------------------------------- Snackbar ---*/
// // //                                 ScaffoldMessenger.of(context)
// // //                                     .showSnackBar(SnackBar(
// // //                                   backgroundColor: wbColorButtonDarkRed,
// // //                                   content: Text(
// // //                                     'Die Daten werden NICHT in "WorkBuddy" übernommen ... 😉',
// // //                                     style: TextStyle(
// // //                                       fontSize: 28,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       color: Colors.white,
// // //                                     ),
// // //                                   ),
// // //                                 ));
// // //                               },
// // //                             ),
// // //                           );
// // //                           /*--------------------------------- AlertDialog ENDE ---*/
// // //                         },
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _searchController.dispose();
// // //     super.dispose();
// // //   }
// // // }
