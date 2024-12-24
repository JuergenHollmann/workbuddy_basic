import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_button_universal_2.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/email/email_screen_p043.dart';
import 'package:workbuddy/shared/widgets/wb_buttons_uni_with_image_button.dart';
import 'package:workbuddy/shared/widgets/wb_dialog_alert_update_coming_soon.dart';
import 'package:workbuddy/shared/widgets/wb_divider_with_text_in_center.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

class CommunicationMenu extends StatelessWidget {
  const CommunicationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    log("0016 - CommunicationMenu - wird benutzt");

    DateTime dateTime = DateTime.now();
    String dateTimeText = '${dateTime.day}.${dateTime.month}.${dateTime.year} • ${dateTime.hour}:${dateTime.minute} Uhr';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      /*--------------------------------- *** ---*/
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
      /*--------------------------------- *** ---*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/workbuddy_glow_schriftzug.png"),
            ),
            // --------------------------------------- Kommunikation-Menü ---
            const WbDividerWithTextInCenter(
              wbColor: wbColorLogoBlue,
              wbText: "Kommunikation",
              wbTextColor: wbColorLogoBlue,
              wbFontSize12: 28,
              wbHeight3: 3,
            ),
            /*--------------------------------- Listview mit AuswahlButtons ---*/
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  /*--------------------------------- WbButtonsUniWithImageButton - Telefonanruf ---*/
                  WbButtonsUniWithImageButton(
                    wbColor: wbColorButtonDarkRed,
                    wbIcon: Icons.phone_forwarded,
                    wbIconSize40: 40,
                    wbText: "Kontakt anrufen",
                    wbFontSize24: 22,
                    wbWidth276: 276,
                    wbHeight90: 90,
                    wbHeightAssetImage90: 90,
                    wbImageAssetImage: const AssetImage(
                      "assets/iconbuttons/icon_button_kontakte.png",
                    ),
                    wbImageButtonRadius12: 12,
                    wbOnTapTextButton: () {
                      log("0069 - CommunicationMenu - großer roter Button angeklickt"); // nur das Smartphone starten
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "Kontakt anrufen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0090",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- *** ---*/
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ContactScreen(),
                      //   ),
                      // );
                    },
                    wbOnTapImageButton: () {
                      log("0069 - CommunicationMenu - Icon Kontakt anrufen angeklickt"); // erst Kontakt auswählen, dann anrufen:
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "Kontakt anrufen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0090",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- *** ---*/
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ContactScreen(),
                      //   ),
                      // );
                    },
                  ),
                  /*--------------------------------- *** ---*/
                  wbSizedBoxHeight8,
                  /*--------------------------------- *** ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- WhatsApp ---*/
                  WbButtonsUniWithImageButton(
                    wbColor: wbColorButtonGreen,
                    wbIcon: Icons.phonelink_ring_outlined,
                    wbIconSize40: 40,
                    wbText: "WhatsApp versenden",
                    wbFontSize24: 22,
                    wbWidth276: 276,
                    wbHeight90: 90,
                    wbHeightAssetImage90: 90,
                    wbImageAssetImage: const AssetImage(
                      "assets/icon_button_whatsapp.png",
                    ),
                    wbImageButtonRadius12: 12,
                    wbOnTapTextButton: () {
                      log("0031 - CommunicationMenu - großer grüner WhatsApp Button angeklickt");
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "WhatsApp versenden?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0136",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- *** ---*/
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ContactScreen(),
                      //   ),
                      // );
                    },
                    wbOnTapImageButton: () {
                      log("0150 - CommunicationMenu - großer grüner WhatsApp Button angeklickt");
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "WhatsApp versenden?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0150",
                          actionsText: "OK 👍",
                        ),
                      );
                      /*--------------------------------- *** ---*/
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ContactScreen(),
                      //   ),
                      // );
                    },
                  ),
                  /*--------------------------------- *** ---*/
                  wbSizedBoxHeight8,
                  /*--------------------------------- Divider ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- E-Mail senden ---*/
                  WbButtonsUniWithImageButton(
                    wbColor: wbColorButtonBlue,
                    wbIcon: Icons.forward_to_inbox_outlined,
                    wbIconSize40: 40,
                    wbText: "E-Mail versenden",
                    wbFontSize24: 22,
                    wbWidth276: 276,
                    wbHeight90: 90,
                    wbHeightAssetImage90: 90,
                    wbImageAssetImage: const AssetImage(
                      "assets/iconbuttons/icon_button_email.png",
                    ),
                    wbImageButtonRadius12: 12,
                    wbOnTapTextButton: () {
                      log("0190 - CommunicationMenu - zeige EMailScreenP043");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => const EMailScreenP043(),
                          // direkten Weg finden:
                          builder: (context) => const EMailScreenP043(
                            emailUserModel: '',
                          ), // EmailUserSelection(), // funzt noch nicht
                        ),
                      );
                    },
                    wbOnTapImageButton: () {
                      log("0199 - CommunicationMenu - zeige EMailScreenP043");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EMailScreenP043(
                            emailUserModel: 'aa@aa.de',
                          ),
                        ),
                      );
                    },
                  ),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- Divider ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- WbButtonUniversal2 - Neue Funktionen? ---*/
                  WbButtonUniversal2(
                    wbColor: const Color.fromARGB(255, 255, 102, 219),
                    wbIcon: Icons.forward_to_inbox_outlined,
                    wbIconSize40: 40,
                    wbText:
                        "Möchtest Du\nMEHR Funktionen?\nSchreibe einfach eine\nE-Mail an den Entwickler.",
                    wbFontSize24: 14,
                    wbWidth155: 398,
                    wbHeight60: 110,
                    wbOnTap: () {
                      log("0249 - CommunicationMenu - großer rosa Entwickler Button angeklickt");
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WbDialogAlertUpdateComingSoon(
                          headlineText: "Mehr Funktionen?",
                          contentText:
                              "Diese Funktion kommt bald in einem KOSTENLOSEN Update!\n\nHinweis: CM-0249",
                          actionsText: "OK 👍",
                        ),
                      );
                    },
                  ),
                  /*--------------------------------- *** ---*/
                  const SizedBox(height: 8),
                  /*--------------------------------- Divider ---*/
                  const Divider(
                      thickness: 3, height: 32, color: wbColorLogoBlue),
                  /*--------------------------------- *** ---*/
                ],
              ),
            ),
          ],
        ),
      ),
      /*--------------------------------- WbInfoContainer ---*/
      bottomSheet: WbInfoContainer(
        infoText: '$dateTimeText • Angemeldet ist JH-01',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- WbInfoContainer ENDE ---*/
    );
  }
}
