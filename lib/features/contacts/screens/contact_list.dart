import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_textformfield_shadow_with_2_icons.dart';
import 'package:workbuddy/features/companies/screens/company_screen.dart';
import 'package:workbuddy/shared/widgets/wb_navigationbar.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton-Muster
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabaseFromAssets();
    return _database!;
  }

  Future<Database> _openDatabaseFromAssets() async {
    log('0046 - CompanyScreen - Öffnet die Datenbank');
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
    bool dbExists = await databaseExists(dbPath);
    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath);
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Map<String, dynamic>> data = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await DatabaseHelper().database;
    fetchData();
  }

  Future<void> fetchData() async {
    var db = await DatabaseHelper().database;

    /*--- Zeige den Kontakt mit der KundenID: 1683296820166' ---*/
    // var query = await db.rawQuery(
    //     "SELECT * FROM KundenDaten WHERE TKD_Feld_030 = 'KundenID: 1683296820166'");

    /*--- Zeige alle Kunden aus Schwäbisch Gmünd ---*/
    // var query = await db.rawQuery(
    // "SELECT * FROM KundenDaten WHERE TKD_Feld_007 = 'Schwäbisch Gmünd'");

    /*--- Zeige alle Kunden mit allen Daten ---*/
    var query = await db.rawQuery(
        "SELECT * FROM KundenDaten ORDER BY TKD_Feld_003 ASC, TKD_Feld_003 ASC");
    log('0062 - ContactList - Abfrage '); //Ergebnis: $query');

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
          title: const Text('Kontaktliste',
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
                    labelText: 'Vor- oder Nachname',
                    hintText: 'Suche Vor- oder Nachname',
                    prefixIcon: Icons.search,
                    suffixIcon: Icons.clear,
                    fillColor: Colors.yellow,
                    labelBackgroundColor: Colors.yellow,
                    onChanged: (value) async {
                      var query = await db.rawQuery(
                          "SELECT * FROM KundenDaten WHERE TKD_Feld_002 LIKE '%$value%' OR TKD_Feld_003 LIKE '%$value%'");
                      setState(() {
                        data = query;
                      });
                      log('0093 - ContactList - Suchfeld - value: $value');
                    }),
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
                            builder: (context) => CompanyScreen(
                                contact:
                                    contact), // später umbenennen in ContactScreen?
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
                                      padding: const EdgeInsets.only(top: 16,
                                        bottom: 4,
                                        right: 72,
                                      ),
                                      /*--------------------------------- Name oder Firmenname? ---*/
                                      child: contact['TKD_Feld_014'] !=
                                              '' // 014 = Firmenname mit ternärem Operator abfragen!
                                          ? Text(
                                              '--------------------\n${contact['TKD_Feld_014']}\n${contact['TKD_Feld_002']} ${contact['TKD_Feld_003']}\n--------------------',
                                              style: const TextStyle(
                                                height: 1.2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              '--------------------\n${contact['TKD_Feld_002']} ${contact['TKD_Feld_003']}\n--------------------',
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
                                      if (contact['TKD_Feld_005'] != '')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            '${contact['TKD_Feld_005']}',
                                            style: const TextStyle(
                                              height: 0.8,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      /*--------------------------------- PLZ + Ort ---*/
                                      if (contact['TKD_Feld_006'] != '')
                                        if (contact['TKD_Feld_007'] != '')
                                          Text(
                                            '${contact['TKD_Feld_006']} ${contact['TKD_Feld_007']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black45,
                                            ),
                                          ),
                                      /*--------------------------------- Telefon ---*/
                                      if (contact['TKD_Feld_008'] != '')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.phone, size: 24),
                                              const SizedBox(width: 8),
                                              Text(
                                                contact['TKD_Feld_008'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              //Text(data[index]['TKD_Feld_001']),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /*--------------------------------- Privat oder Firma? ---*/
                            Positioned(
                              top: 14,
                              left: 20,
                              child: Text(
                                textAlign: TextAlign.center,
                                contact['TKD_Feld_030'] ,
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
                                  color: contact['TKD_Feld_001'] == 'Herr'
                                      ? Colors.green
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  contact['TKD_Feld_001'] == 'Herr'
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
          wbImageAssetImage: AssetImage(
              "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon_viel_breiter.png"), // hat keine Auswirkung! - 0124 - MainSelectionScreen
        ),
      ),
    );
  }
}
