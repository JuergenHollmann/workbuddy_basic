import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:workbuddy/config/wb_colors.dart';
// import 'package:workbuddy/config/wb_dialog_2buttons.dart';

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
      allContacts = await FlutterContacts.getContacts(withGroups: true);
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
        title: Text('Kontakte'),
      ),
      body: Column(
        children: [
          // Suchfeld
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Suche Kontakte',
                border: OutlineInputBorder(),
              ),
            ),
          ),
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
                  return ListTile(
                    title: Text(contact.displayName),
                    subtitle: Text(contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : 'Keine Telefonnummer'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
