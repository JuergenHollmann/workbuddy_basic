import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/main.dart';
import 'package:workbuddy/shared/repositories/shared_preferences_repository.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

import '../../authentication/screens/p01_login_screen.dart';

class WbHomePage extends StatefulWidget {
  const WbHomePage({
    super.key,
    required this.title,
    required this.preferencesRepository,
  });

  final String title;
  final SharedPreferencesRepository preferencesRepository;

  @override
  State<WbHomePage> createState() => _WbHomePageState();
}

class _WbHomePageState extends State<WbHomePage> {
  /*--------------------------------- SharedPreferences ---*/
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  String currentUser = 'Doch Oiner';

  /* Lokale Variable wegen DarkMode die in der initState() gesetzt wird */
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    /* Aufruf der lokalen "DarkMode-Variable" die auf dem Smartphone gespeichert ist */
    // isDarkMode = widget.preferencesRepository.getThemeMode();

    /*--------------------------------- currentUser in SharedPreferences ---*/
    /* Aufruf von "currentUser" */
    // prefs.getCurrentUser();
    _loadCurrentUser;
  }

  void _loadCurrentUser() async {
    final rememberedCurrentUser = await prefs.getString("currentUser") ?? 0;
    setState(() {
      // currentUser = rememberedCurrentUser as String;
      currentUser = rememberedCurrentUser as String;
    });
  }

  // void _saveCurrentUser() async {
  //   /* Der Datensatz wird wie bei einer Map mit einem Key/Value gespeichert */
  //   await prefs.setString("currentUser", currentUser);
  // }
  /*--------------------------------- currentUser ENDE ---*/

  /*--------------------------------- Drawer Vorbereitung ---*/
  int _selectedDrawerIndex = 0;
  /*--------------------------------- *** ---*/
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetDrawerOptions = <Widget>[
    Text(
      "", //'Index 0: Sprache',
      style: optionStyle,
    ),
    Text(
      "", //'Index 1: Design',
      style: optionStyle,
    ),
    Text(
      "", //'Index 2: Erinnerungen',
      style: optionStyle,
    ),
    Text(
      "", //'Index 3: Sound',
      style: optionStyle,
    ),
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    log("0047 - home_screen $_widgetDrawerOptions[$_selectedDrawerIndex]");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wbColorBackgroundBlue,
      /*--------------------------------- AppBar ---*/
      appBar: AppBar(
        backgroundColor: wbColorAppBarBlue,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white, // Schriftfarbe
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      /*--------------------------------- P01LoginScreen ---*/
      body: Center(
        child: Column(
          children: [
            wbSizedBoxHeight8,
            /*--------------------------------- P01LoginScreen ---*/
            Expanded(child: const P01LoginScreen()),
            /*--------------------------------- WbInfoContainer ---*/
            WbInfoContainer(
              infoText: // Zuvor angemeldeter Benutzer: ${context.watch<CurrentUserProvider>().currentUser}\n
                  'Heute ist ${context.watch<CurrentWeekdayLongProvider>().currentWeekdayLong}, ${context.watch<CurrentDateProvider>().currentDate}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
              wbColors: Colors.yellow,
            ),
            /*--------------------------------- WbInfoContainer ENDE ---*/
          ],
        ),
      ),
      /*--------------------------------- Drawer Aufruf ---*/
      drawer: Drawer(
        // Eine ListView in den Drawer implementieren:
        child: ListView(
          // WICHTIG: JEDES Padding von der ListView ENTFERNEN !!!
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Image(
                image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
              ),
            ),

            /*--- ListTile 0 ---*/
            ListTile(
              title: const Text(
                'Sprache',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: wbColorAppBarBlue,
                ),
              ),
              selected: _selectedDrawerIndex == 0,
              onTap: () {
                // Zuerst den State der App aktualisieren ...
                _onDrawerItemTapped(0);
                // ... dann den Drawer schließen:
                Navigator.pop(context);
              },
            ),

            /*--- ListTile 1 ---*/
            ListTile(
              title: const Text('Designauswahl'),
              selected: _selectedDrawerIndex == 1,
              onTap: () {
                _onDrawerItemTapped(1);
                Navigator.pop(context);
              },
            ),

            /*--- ListTile 2 ---*/
            ListTile(
              title: const Text('Erinnerungen'),
              selected: _selectedDrawerIndex == 2,
              onTap: () {
                _onDrawerItemTapped(2);
                Navigator.pop(context);
              },
            ),

            /*--- ListTile 3 ---*/
            ListTile(
              title: Row(
                children: [
                  Expanded(child: const Text('Sound an/aus')),
                  Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        /* Die Variable setzen */
                        // widget.preferencesRepository.setThemeMode(value); // WbHomePage - 0173
                        setState(() {
                          /* Damit der Schalter korrekt umgelegt wird, rufen wir die "DarkMode-Variable" nochmal ab */
                          // isDarkMode =
                          // widget.preferencesRepository.getThemeMode();
                        });
                      }),
                ],
              ),
              selected: _selectedDrawerIndex == 3,
              onTap: () {
                _onDrawerItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
