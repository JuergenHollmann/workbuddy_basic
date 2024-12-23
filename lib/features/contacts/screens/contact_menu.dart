import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/contacts/screens/contact_screen.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';

class ContactMenu extends StatelessWidget {
  const ContactMenu({super.key});

  @override
  Widget build(BuildContext context) {
    log("0017 - ContactMenu - wird benutzt");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      appBar: AppBar(
        title: const Text(
          'Was möchtest Du tun?',
          style: TextStyle(
            fontSize: 24,
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
              // --------------------------------------- Listview mit AuswahlButtons ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    /*--------------------------------- Kontakt NEU anlegen ---*/
                    WbButtonUniversal2(
                      wbColor: wbColorButtonGreen,
                      wbIcon: Icons.person_add_alt_1_outlined,
                      wbIconSize40: 40,
                      wbText: 'Einen Kontakt \nNEU anlegen',
                      wbFontSize24: 22,
                      wbWidth155: 398,
                      wbHeight60: 80,
                      wbOnTap: () {
                        /*--------------------------------- Navigator.push ---*/
                        log("0090 - contact_menu - Einen Kontakt NEU anlegen - angeklickt");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactScreen(),
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    /*--------------------------------- *** ---*/
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),
                    /*--------------------------------- *** ---*/
                    WbButtonUniversal2(
                      wbColor: wbColorAppBarBlue,
                      wbIcon: Icons.person_search_outlined,
                      wbIconSize40: 40,
                      wbText: 'In allen Kontakten\nsuchen und finden',
                      wbFontSize24: 20,
                      wbWidth155: 398,
                      wbHeight60: 80,
                      wbOnTap: () {
                        log("0085 - contact_menu - Einen Kontakt suchen - Update-Hinweis - CM108 - angeklickt");
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: 'Update-Hinweis - CM108',
                            contentText:
                                'Diese Funktion kommt bald in einem kostenlosen Update!',
                            actionsText: "OK 👍",
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),
                    /*--------------------------------- Mehr Funktionen? ---*/
                    WbButtonUniversal2(
                      wbColor: const Color.fromARGB(255, 255, 102, 219),
                      wbIcon: Icons.forward_to_inbox_outlined,
                      wbIconSize40: 40,
                      wbText:
                          "Möchtest Du\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
                      wbFontSize24: 15,
                      wbWidth155: 300, // hat keine Auswirkung
                      wbHeight60: 110,
                      wbOnTap: () {
                        log("0109 - contact_menu - Mehr Info? - Update-Hinweis - CM109 - angeklickt");
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: 'Update-Hinweis - CM0109',
                            contentText:
                                'Diese Funktion kommt bald in einem kostenlosen Update!',
                            actionsText: "OK 👍",
                          ),
                        );
                      },
                    ),
                    /*--------------------------------- Abstand ---*/
                    wbSizedBoxHeight8,
                    const Divider(
                        thickness: 3, height: 32, color: wbColorLogoBlue),
                    /*--------------------------------- ENDE ---*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
