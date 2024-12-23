import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/features/email/email_user_selection.dart';
import 'package:workbuddy/main.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

import 'mock_email_users_data.dart';

/*--------------------------------- *** ---*/
class EMailScreenP043 extends StatefulWidget {
  const EMailScreenP043({super.key, required String emailUserModel});
/*--------------------------------- *** ---*/
  @override
  State<EMailScreenP043> createState() => _EMailScreenP043State();
}

/*--------------------------------- *** ---*/
class _EMailScreenP043State extends State<EMailScreenP043> {
/*--------------------------------- *** ---*/
  @override
  void initState() {
    super.initState();
  }

  /*--------------------------------- *** ---*/
  final TextEditingController searchController = TextEditingController();
  var suggestions = <String>[];
  int counter = 0;
  var selected = '';

  String emailUserModelEMail = "KlausMueller@test.de";

  /*--------------------------------- *** ---*/
  // die Gesamt-Anzahl aller User in der Liste zeigen:
  int searchFieldCounter043 = emailUsersData.length;
  /*--------------------------------- *** ---*/
  // Die GEFUNDENE Anzahl aller User mit der gesuchten Zeichenfolge in der Liste zeigen - EMailScreenP043 - 0030

  /*--------------------------------- Scaffold ---*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 242),
      /*--------------------------------- AppBar ---*/
      appBar: AppBar(
        title: const Text(
          'E-Mail versenden',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black, // Schriftfarbe
          ),
        ),
        backgroundColor: wbColorBackgroundBlue, // Hintergrundfarbe
        foregroundColor: Colors.black, // Icon-/Button-/Chevron-Farbe
      ),
      /*--------------------------------- ListView ---*/
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                semanticChildCount: 3,
                children: [
                  /*--------------------------------- Info-Überschrift ---*/
                  Center(
                    child: Text(
                      "Auswahl aus $searchFieldCounter043 E-Mail-Adressen:",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  /*--------------------------------- *** ---*/
                  const EmailUserSelection(),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- E-Mail Betreff ---*/
                  const WbTextFormField(
                    labelText: "Betreff",
                    labelFontSize20: 20,
                    hintText: "Betreff der E-Mail eintragen",
                    inputTextFontSize22: 20,
                    prefixIcon: Icons.psychology_alt_outlined,
                    prefixIconSize28: 48, //28,
                    inputFontWeightW900: FontWeight.bold,
                    inputFontColor: wbColorAppBarBlue,
                    fillColor: wbColorBackgroundBlue,
                  ),
                  /*--------------------------------- Abstand ---*/
                  wbSizedBoxHeight16,
                  /*--------------------------------- E-Mail Text-Nachricht ---*/
                  const WbTextFormField(
                    labelText: "E-Mail Text-Nachricht",
                    labelFontSize20: 20,
                    hintText: "Nachricht der E-Mail verfassen",
                    inputTextFontSize22: 20,
                    prefixIcon: Icons.email_outlined,
                    prefixIconSize28: 48,
                    inputFontWeightW900: FontWeight.bold,
                    inputFontColor: Colors.black,
                    fillColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    /*--------------------------------- WbInfoContainer ---*/
    // bottomSheet: Consumer<CurrentUserProvider>(
    //   builder: (context, data, child) {
    //     return WbInfoContainer(
    //       infoText:
    //           'E-Mail 1 (von $searchFieldCounter043) senden an $emailUserModelEMail\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\nWorkBuddy • Free-BASIC-Version 0.003',
    //       wbColors: Colors.yellow,
    //     );
    //   },
    // ),

      bottomSheet: 
      // Consumer<CurrentUserProvider>(
      //   builder: (context, data, child) {
          WbInfoContainer(
            infoText:
                'E-Mail 1 (von $searchFieldCounter043) senden an $emailUserModelEMail\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\nWorkBuddy • Free-BASIC-Version ${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
            wbColors: Colors.yellow,
          ),
      //   },
      // ),
      /*--------------------------------- *** ---*/
    );
  }
}
/* WorkBuddy • save time and money • Version 0.003 */