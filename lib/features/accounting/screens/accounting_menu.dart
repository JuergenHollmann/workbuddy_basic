import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/accounting/screens/accounting_screen.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class AccountingMenu extends StatelessWidget {
  const AccountingMenu({super.key});
  @override
  Widget build(BuildContext context) {
    log("0016 - AccountingMenu - wird angezeigt");

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
      //    body: SingleChildScrollView(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
            ),
            /*--------------------------------- Divider Buchhaltung ---*/
            const WbDividerWithTextInCenter(
              wbColor: wbColorLogoBlue,
              wbText: "Buchhaltung",
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 28,
              wbHeight3: 3,
            ),
            /*--------------------------------- Listview mit AuswahlButtons ---*/
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
                children: [
                  /*--------------------------------- Ausgabe buchen ---*/
                  Semantics(
                    label:
                        'Eine Ausgabe buchen', // für Screenreader (liest Texte vor), funktioniert nur mit "TalkBack" für Android oder "VoiceOver" für iOS
                    child: WbButtonUniversal2(
                        wbColor: wbColorButtonDarkRed,
                        wbIcon: Icons.payments_outlined,
                        wbIconSize40: 40,
                        wbText: "Ausgabe buchen",
                        wbFontSize24: 22,
                        wbWidth155: 398, // hat hier keine Auswirkung
                        wbHeight60: 80,
                        wbOnTap: () {
                          log("0064 - AccountingMenu - Eine Ausgabe buchen - angeklickt");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountingScreen(
                                    startGroupValue: "Ausgabe"),
                              ));
                        }),
                  ),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- Einnahme buchen ---*/
                  WbButtonUniversal2(
                      wbColor: wbColorButtonGreen,
                      wbIcon: Icons.add_card_outlined,
                      wbIconSize40: 40,
                      wbText: "Einnahme buchen",
                      wbFontSize24: 22,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 80,
                      wbOnTap: () {
                        log("0084 - AccountingMenu - Eine Einnahme buchen - angeklickt");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountingScreen(
                                  startGroupValue: "Einnahme"),
                            ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight8,
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- Ausgaben zeigen ---*/
                  WbButtonUniversal2(
                      wbColor: wbColorButtonDarkRed,
                      wbIcon: Icons.receipt_long_outlined,
                      wbIconSize40: 40,
                      wbText: "Alle Ausgaben\nals Liste zeigen",
                      wbFontSize24: 22,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 80,
                      wbOnTap: () {
                        log('0106 - AccountingMenu - "Alle Ausgaben als Liste zeigen" - angeklickt');
                        /*--------------------------------- showDialog ---*/
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: "Alle Ausgaben als Liste zeigen?",
                            contentText:
                                "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate AM-0115",
                            actionsText: "OK 👍",
                          ),
                        );
                        /*--------------------------------- showDialog ENDE ---*/
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AccountingScreen(
                        //           startGroupValue: "Einnahme"),
                        //     ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- Einnahmen zeigen ---*/
                  WbButtonUniversal2(
                      wbColor: wbColorButtonGreen,
                      wbIcon: Icons.receipt_long_outlined,
                      wbIconSize40: 40,
                      wbText: "Alle Einnahmen\nals Liste zeigen",
                      wbFontSize24: 22,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 80,
                      wbOnTap: () {
                        log('0106 - AccountingMenu - "Alle Einnahmen als Liste zeigen" - angeklickt');
                        /*--------------------------------- showDialog ---*/
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: "Alle Einnahmen als Liste zeigen?",
                            contentText:
                                "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate AM-0146",
                            actionsText: "OK 👍",
                          ),
                        );
                        /*--------------------------------- showDialog ENDE ---*/
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AccountingScreen(
                        //           startGroupValue: "Einnahme"),
                        //     ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight8,
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- Ausgaben finden ---*/
                  WbButtonUniversal2(
                      wbColor: wbColorOrangeDarker,
                      wbIcon: Icons.manage_search_outlined,
                      wbIconSize40: 40,
                      wbText: "Alle Ausgaben\nsuchen und finden",
                      wbFontSize24: 22,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 80,
                      wbOnTap: () {
                        log('0172 - AccountingMenu - "Alle Ausgaben suchen und finden" - angeklickt');
                        /*--------------------------------- showDialog ---*/
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: "Alle Ausgaben suchen und finden?",
                            contentText:
                                "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate AM-0180",
                            actionsText: "OK 👍",
                          ),
                        );
                        /*--------------------------------- showDialog ENDE ---*/
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AccountingScreen(
                        //           startGroupValue: "Einnahme"),
                        //     ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- Einnahmen finden ---*/
                  WbButtonUniversal2(
                      wbColor: wbColorOrangeDarker,
                      wbIcon: Icons.manage_search_outlined,
                      wbIconSize40: 40,
                      wbText: "Alle Einnahmen\nsuchen und finden",
                      wbFontSize24: 22,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 80,
                      wbOnTap: () {
                        log('0204 - AccountingMenu - "Alle Einnahmen suchen und finden" - angeklickt');
                        /*--------------------------------- showDialog ---*/
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const WbDialogAlertUpdateComingSoon(
                            headlineText: "Alle Einnahmen suchen und finden?",
                            contentText:
                                "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate AM-0212",
                            actionsText: "OK 👍",
                          ),
                        );
                        /*--------------------------------- showDialog ENDE ---*/
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AccountingScreen(
                        //           startGroupValue: "Einnahme"),
                        //     ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight8,
                  /*--------------------------------- Dvider ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- Mehr Funktionen ---*/
                  WbButtonUniversal2(
                      wbColor: const Color.fromARGB(255, 255, 102, 219),
                      wbIcon: Icons.forward_to_inbox_outlined,
                      wbIconSize40: 40,
                      wbText:
                          "Möchtest Du\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
                      wbFontSize24: 15,
                      wbWidth155: 398, // hat hier keine Auswirkung
                      wbHeight60: 110,
                      wbOnTap: () {
                        log("0249 - CommunicationMenu - großer rosa Entwickler Button angeklickt");
                        showDialog(
                            context: context,
                            builder: (context) =>
                                const WbDialogAlertUpdateComingSoon(
                                  headlineText: "Mehr Funktionen?",
                                  contentText:
                                      "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nUpdate AM-0249",
                                  actionsText: "OK 👍",
                                ));
                      }),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight8,
                  /*--------------------------------- Divider ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight24,
                  /*--------------------------------- *** ---*/
                ],
              ),
            ),
          ],
        ),
      ),

      /*--------------------------------- WbInfoContainer ---*/
      bottomSheet: Consumer2<CurrentUserProvider, CurrentAppVersionProvider>(
        builder:
            (context, currentUserProvider, currentAppVersionProvider, child) =>
                WbInfoContainer(
          infoText:
              'Angemeldet zur Bearbeitung: ${currentUserProvider.currentUser}\n${currentAppVersionProvider.currentAppVersion}',
          // 'Angemeldet zur Bearbeitung: ${currentUserProvider.currentUser.currentUserName}\n${currentAppVersionProvider.currentAppVersion}',
          wbColors: Colors.yellow,
        ),
      ),
      /*--------------------------------- WbInfoContainer ENDE ---*/

      // /*--------------------------------- WbInfoContainer ---*/
      // bottomSheet: Consumer<CurrentUserProvider>(
      //   builder: (context, value, child) => WbInfoContainer(
      //     infoText:
      //     'Angemeldet zur Bearbeitung: ${value.currentUser.currentUserName}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
      //         // 'Angemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
      //     wbColors: Colors.yellow,
      //   ),
      // )
      // /*--------------------------------- WbInfoContainer ENDE ---*/
    );
  }
}
