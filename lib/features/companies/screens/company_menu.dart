import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/companies/screens/company_screen.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class CompanyMenu extends StatelessWidget {
  const CompanyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    log("0020 - CompanyMenu - wird benutzt");

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
              /*--------------------------------- Firmen-Menü ---*/
              const WbDividerWithTextInCenter(
                wbColor: wbColorLogoBlue,
                wbText: "Firmen",
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
                      wbText: 'Eine Firma \nNEU anlegen',
                      wbFontSize24: 22,
                      wbWidth155: 398,
                      wbHeight60: 80,
                      wbOnTap: () {
                        /*--------------------------------- Navigator.push ---*/
                        log("0090 - CompanyMenu - Eine Firma NEU anlegen - angeklickt");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompanyScreen(),
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
                      wbText: 'In allen Firmen\nsuchen und finden',
                      wbFontSize24: 20,
                      wbWidth155: 398,
                      wbHeight60: 80,
                      wbOnTap: () {
                        log("0092 - CompanyMenu - Eine Firma suchen - Update-Hinweis - CM092 - angeklickt");
                        showDialog(
                          context: context,
                          builder: (context) =>
                               WbDialogAlertUpdateComingSoon(
                            headlineText: 'Hey ${context.watch<CurrentUserProvider>().currentUser},\nDu willst jetzt eine Firma aus deinen Kontakten heraussuchen?',
                            contentText:
                                'Diese Funktion kommt bald in einem kostenlosen Update!\n\nHinweis: CM-0092',
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
                          "Möchtest Du noch\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
                      wbFontSize24: 15,
                      wbWidth155: 300, // hat keine Auswirkung
                      wbHeight60: 110,
                      wbOnTap: () {
                        log("0121 - CompanyMenu - Mehr Info? - Update-Hinweis wird angezeigt");
                        showDialog(
                          context: context,
                          builder: (context) =>
                               WbDialogAlertUpdateComingSoon(
                            headlineText:
                                'Hey ${context.watch<CurrentUserProvider>().currentUser},\nmöchtest Du noch mehr Funktionen in dieser App?',
                            contentText:
                                'Diese App wird ständig weiterentwickelt.\n\nWenn Du eine nützliche Funktion vorschlagen möchtest, kannst Du gerne eine E-Mail DIREKT an den Entwickler senden.\n\nSchreibe dazu einfach an XXXXXXXXXXXX oder klicke unten auf den E-Mail-Button.\n\nHinweis: CM-0121',
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