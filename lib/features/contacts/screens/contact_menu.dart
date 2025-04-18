import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/contacts/screens/contact_list.dart';
import 'package:workbuddy/features/contacts/screens/contact_list_from_device.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/repositories/database_helper.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class ContactMenu extends StatefulWidget {
  const ContactMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactMenuState createState() => _ContactMenuState();
}

class _ContactMenuState extends State<ContactMenu> {
  bool isNewContact = false;

  @override
  Widget build(BuildContext context) {
    developer.log("0020 - ContactMenu - wird benutzt");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      appBar: AppBar(
        title: const Text(
          'Was möchtest Du tun?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black, // Schriftfarbe
          ),
        ),
        backgroundColor: wbColorBackgroundBlue, // Hintergrundfarbe
        foregroundColor: Colors.black, // Icon-/Button-/Chevron-Farbe
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
              ),
              /*--------------------------------- Kontakte-Menü ---*/
              const WbDividerWithTextInCenter(
                wbColor: wbColorLogoBlue,
                wbText: "Kontakte",
                wbTextColor: wbColorLogoBlue,
                wbFontSize12: 28,
                wbHeight3: 3,
              ),
              /*--------------------------------- Listview mit AuswahlButtons ---*/
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    /*--------------------------------- In allen Kontakten SUCHEN und FINDEN ---*/
                    WbButtonUniversal2(
                      wbColor: wbColorButtonGreen,
                      wbIcon: Icons.person_search_outlined,
                      wbIconSize40: 40,
                      wbText: 'In allen Kontakten\nSUCHEN und FINDEN',
                      wbFontSize24: 20,
                      wbWidth155: double.infinity, // maximale Breite
                      wbHeight60: 80,
                      wbOnTap: () {
                        developer.log(
                            '0092 - ContactMenu - "In allen Kontakten SUCHEN und FINDEN" - angeklickt');
                        /*--------------------------------- Navigator.push ---*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactList(), // ContactScreen
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    const Divider(
                      thickness: 3,
                      height: 32,
                      color: wbColorLogoBlue,
                    ),

                    /*--------------------------------- Kontakte aus dem Smartphone holen ---*/
                    WbButtonUniversal2(
                      wbColor: wbColorOrangeDarker,
                      wbIcon: Icons.person_search_outlined,
                      wbIconSize40: 40,
                      wbText: 'Kontakte aus dem\nSmartphone holen',
                      wbFontSize24: 20,
                      wbWidth155: double.infinity, // maximale Breite
                      wbHeight60: 80,
                      wbOnTap: () {
                        developer.log(
                            '0146 - ContactMenu - "Kontakte aus dem Smartphone holen" - angeklickt');

                        /*--------------------------------- Navigator.push ---*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactListFromDevice(), // ContactScreen
                          ),
                        );

                        /*--------------------------------- *** ---*/
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),
                    /*--------------------------------- Kontakt NEU anlegen ---*/
                    WbButtonUniversal2(
                      wbColor: wbColorAppBarBlue,
                      wbIcon: Icons.person_add_alt_1_outlined,
                      wbIconSize40: 40,
                      wbText: 'Einen Kontakt \nNEU anlegen',
                      wbFontSize24: 20,
                      wbWidth155: 398,
                      wbHeight60: 80,
                      wbOnTap: () {
                        /*--------------------------------- Navigator.push ---*/
                        developer.log(
                            "0144 - ContactMenu - Einen Kontakt NEU anlegen - angeklickt");

                        /*--------------------------------- Verwende "generateContactID" aus DatabaseHelper ---*/
                        String newContactID =
                            DatabaseHelper.instance.generateContactID();
                        setState(() {
                          isNewContact = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactScreen(
                              contact: {'Tabelle01_001': newContactID},
                              isNewContact: isNewContact,
                            ),
                          ),
                          /*--------------------------------- *** ---*/
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- *** ---*/
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),

                    /*--------------------------------- Mehr Funktionen? ---*/
                    WbButtonUniversal2(
                      wbColor: const Color.fromARGB(255, 255, 102, 219),
                      wbIcon: Icons.forward_to_inbox_outlined,
                      wbIconSize40: 40,
                      wbText:
                          "Möchtest Du noch\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
                      wbFontSize24: 15,
                      wbWidth155: 300, // hat keine Auswirkung
                      wbHeight60: 110,
                      wbOnTap: () {
                        developer.log(
                            "0121 - ContactMenu - Mehr Info? - Update-Hinweis wird angezeigt");
                        showDialog(
                          context: context,
                          builder: (context) => WbDialogAlertUpdateComingSoon(
                            headlineText:
                                'Hey ${context.watch<CurrentUserProvider>().currentUser},\nmöchtest Du noch mehr Funktionen in dieser App?',
                            contentText:
                                'Diese App wird ständig weiterentwickelt.\n\nWenn Du eine nützliche Funktion vorschlagen möchtest, kannst Du gerne eine E-Mail DIREKT an den Entwickler senden.\n\nSchreibe dazu einfach an JOTHAsoft@gmail.com oder klicke unten auf den E-Mail-Button.\n\nHinweis: CM-0121',
                            actionsText: "OK 👍",
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,

                    /*--------------------------------- Divider ---*/
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),

                    /*--------------------------------- Abstand ---*/
                    SizedBox(height: 40),
                    /*--------------------------------- ENDE ---*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      /*--------------------------------- WbInfoContainer ---*/
      bottomSheet: WbInfoContainer(
        infoText:
            'Angemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- *** ---*/
    );
  }
}
