import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_textformfield_shadow_with_2_icons.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';
import 'package:workbuddy/shared/repositories/database_helper.dart';
import 'package:workbuddy/shared/widgets/wb_navigationbar.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListState createState() => _ContactListState();
}

/*--------------------------------- Controller ---*/
final TextEditingController _searchController = TextEditingController();

/*--------------------------------- State ---*/
class _ContactListState extends State<ContactList> {
  List<Map<String, dynamic>> data = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await DatabaseHelper.instance.database;
    fetchData();
    log('0112 - ContactList - initDatabase() - Datenbank initialisiert und mit "fetchData" Daten abgerufen');
  }

  Future<void> fetchData() async {
    // var db = await DatabaseHelper().database;

    /*--- Zeige den Kontakt mit der KontaktID: 1683296820166' ---*/
    // var query = await db.rawQuery(
    //     "SELECT * FROM Tabelle01 WHERE Tabelle01_030 = 'KontaktID: 1683296820166'");

    /*--- Zeige alle Kunden aus Schwäbisch Gmünd ---*/
    // var query = await db.rawQuery(
    // "SELECT * FROM Tabelle01 WHERE Tabelle01_007 = 'Schwäbisch Gmünd'");

    /*--- Zeige alle Kunden mit allen Daten ---*/
    var query = await db.rawQuery(
        // "SELECT * FROM Tabelle01 ORDER BY Tabelle01_003 ASC, Tabelle01_002 ASC"); // alte Tabelle "Tabelle01"
        "SELECT * FROM Tabelle01 ORDER BY Tabelle01_003 ASC, Tabelle01_002 ASC");
    log('0128 - ContactList - Abfrage '); //Ergebnis: $query');

    setState(() {
      data = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: wbColorButtonBlue,
        appBar: AppBar(
          title: const Text('WorkBuddy-Kontaktliste',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              )),
          backgroundColor: wbColorBackgroundBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            children: [
              /*--------------------------------- Suchfeld ---*/
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: WbTextFormFieldShadowWith2Icons(
                  controller: _searchController,
                  labelText: 'Suche Kontakte',
                  hintText: 'Suche Vorname, Nachname, Firma oder Ort',
                  contentPadding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  prefixIcon: Icons.search,
                  suffixIcon: Icons.delete_forever,
                  fillColor: Colors.yellow,
                  // inputTextAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  labelBackgroundColor: Colors.yellow,
                  onChanged: (value) async {
                    var query = await db.rawQuery('''
                      SELECT * FROM Tabelle01 WHERE
                      Tabelle01_003 LIKE '%$value%' OR
                      Tabelle01_004 LIKE '%$value%' OR
                      Tabelle01_009 LIKE '%$value%' OR
                      Tabelle01_015 LIKE '%$value%' ''');
                    setState(() {
                      data = query;
                    });
                    log('0093 - ContactList - Suchfeld - value: $value');
                  },
                ),
              ),
              /*--------------------------------- Anzahl der Kontakte ---*/
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  data.length == 1
                      ? '${data.length} Kontakt gefunden'
                      : '${data.length} Kontakte gefunden',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              /*--------------------------------- Divider ---*/
              Divider(color: Colors.white, thickness: 2),
              /*--------------------------------- Liste der Kontakte ---*/
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final contact = data[index];
                    /*--------------------------------- Cards ---*/
                    return GestureDetector(
                      onTap: () {
                        log('0118 - ContactList - Kontakt $contact angeklickt');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactScreen(
                              contact: contact,
                              isNewContact: false,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Stack(
                          children: [
                            Container(
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
                              child: Card(
                                color: wbColorLightYellowGreen,
                                elevation: 10,
                                margin: EdgeInsets.all(2),
                                child: ListTile(
                                  // leading: const Icon(Icons.person),
                                  /*--------------------------------- Überschrift ---*/
                                  title: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 4,
                                        right: 72,
                                      ),
                                      /*--------------------------------- Name oder Firmenname? ---*/
                                      child: contact['Tabelle01_015'] !=
                                              '' // 014 = Firmenname mit ternärem Operator abfragen!
                                          ? Text(
                                              '--------------------\n${contact['Tabelle01_015']}\n${contact['Tabelle01_003']} ${contact['Tabelle01_004']}\n--------------------',
                                              style: const TextStyle(
                                                height: 1.2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              '--------------------\n${contact['Tabelle01_003']} ${contact['Tabelle01_004']}\n--------------------',
                                              style: const TextStyle(
                                                height: 1.2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.black,
                                              ),
                                            )),
                                  /*--------------------------------- Untertitel ---*/
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*--------------------------------- Straße + Nr. ---*/
                                      if (contact['Tabelle01_006'] != '')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            '${contact['Tabelle01_006']}',
                                            style: const TextStyle(
                                              height: 0.8,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      /*--------------------------------- PLZ + Ort ---*/
                                      if (contact['Tabelle01_008'] != '')
                                        if (contact['Tabelle01_009'] != '')
                                          Text(
                                            '${contact['Tabelle01_008']} ${contact['Tabelle01_009']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black45,
                                            ),
                                          ),
                                      /*--------------------------------- Telefon 1 ---*/
                                      if (contact['Tabelle01_011'] != null &&
                                          contact['Tabelle01_011'].isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.phone, size: 24),
                                              const SizedBox(width: 8),
                                              Text(
                                                contact['Tabelle01_011'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              //Text(data[index]['Tabelle01_011']),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /*--------------------------------- KontaktID ---*/
                            if (contact['Tabelle01_001'] != null &&
                                contact['Tabelle01_001'].isNotEmpty)
                              Positioned(
                                top: 14,
                                left: 20,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  contact['Tabelle01_001'],
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            /*--------------------------------- Privat oder Firma? ---*/
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                width: 80,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                        spreadRadius: 0),
                                  ],
                                  color: contact['Tabelle01_015'] != null &&
                                          contact['Tabelle01_015'].isNotEmpty
                                      ? Colors.green
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  contact['Tabelle01_015'] != null &&
                                          contact['Tabelle01_015'].isNotEmpty
                                      ? 'Firma'
                                      : 'Privat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                /*--------------------------------- *** ---*/
                              ),
                            ),
                            /*--------------------------------- Bild ---*/
                            Positioned(
                              top: 52,
                              right: 14,
                              child: Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                        spreadRadius: 0),
                                  ],
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: wbColorButtonBlue,
                                  backgroundImage: AssetImage(
                                    "assets/company_logos/enpower_expert_logo_4_x_4.png",
                                  ),
                                  /*--------------------------------- *** ---*/
                                  // Alternativ-Bild aus dem Internet:
                                  // NetworkImage('https://picsum.photos/200'),
                                  /*--------------------------------- *** ---*/
                                  radius: 40,
                                ),
                              ),
                            ),
                            /*--------------------------------- *** ---*/
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              /*--------------------------------- Divider ---*/
              Divider(color: Colors.white, thickness: 2),
              /*--------------------------------- *** ---*/
            ],
          ),
        ),
        /*--------------------------------- NavigationBar ---*/
        bottomNavigationBar: WbNavigationbar(
          wbIcon1: AssetImage(
            'assets/iconbuttons/icon_button_home_rund_3d_neon.png',
          ),
          wbTextButton1: 'Startseite',
        ),
        /*--------------------------------- NavigationBar - ENDE ---*/
      ),
    );
  }
}
