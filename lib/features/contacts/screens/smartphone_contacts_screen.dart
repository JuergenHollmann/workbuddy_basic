// import 'dart:developer';

// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SmartphoneContactsScreen extends StatefulWidget {
//   const SmartphoneContactsScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _SmartphoneContactsScreenState createState() =>
//       _SmartphoneContactsScreenState();
// }

// class _SmartphoneContactsScreenState extends State<SmartphoneContactsScreen> {
//   List<Contact> _contacts = [];
//   List<Contact> _filteredContacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchContacts();
//   }

//   Future<void> _fetchContacts() async {
//     if (await Permission.contacts.request().isGranted) {
//       Iterable<Contact> contacts = await ContactsService.getContacts();
//       setState(() {
//         _contacts = contacts.toList();
//         _filteredContacts = _contacts;
//       });
//     } else {
//       /*--- Die Berechtigung wurde NICHT erteilt ---*/
//       setState(() {
//         log('0036 - SmartphoneContactsScreen - Die Berechtigung wurde NICHT erteilt');
//         _contacts = [];
//         _filteredContacts = [];
//       });
//       // _showPermissionDeniedDialog(); // Der Dialog wird vorübergehend nicht angezeigt, dafür wird die Funktion ohne Berechtigung vorübergehend angezeigt.
//             Iterable<Contact> contacts = await ContactsService.getContacts();
//       setState(() {
//         _contacts = contacts.toList();
//         _filteredContacts = _contacts;
//       });
//     }
//   }

//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Berechtigung erforderlich'),
//           content: const Text(
//               'Diese App benötigt Zugriff auf Deine Kontakte, um sie anzuzeigen. Bitte erteile die Berechtigung in den Einstellungen.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _filterContacts(String query) {
//     List<Contact> filteredContacts = _contacts.where((contact) {
//       return contact.displayName!.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//     setState(() {
//       _filteredContacts = filteredContacts;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Smartphone Kontakte'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Suche',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: _filterContacts,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('Anzahl der Kontakte: ${_filteredContacts.length}'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredContacts.length,
//               itemBuilder: (context, index) {
//                 Contact contact = _filteredContacts[index];
//                 return ListTile(
//                   title: Text(contact.displayName ?? ''),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
