import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/config/wb_text_form_field.dart';
import 'package:workbuddy/features/email/email_user_selection.dart';
import 'package:workbuddy/shared/providers/current_app_version_provider.dart';
import 'package:workbuddy/shared/providers/current_date_provider.dart';
import 'package:workbuddy/shared/providers/current_day_long_provider.dart';
import 'package:workbuddy/shared/providers/current_time_provider.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/wb_info_container.dart';

import 'mock_email_users_data.dart';

/*--------------------------------- *** ---*/
class EMailScreenP043 extends StatefulWidget implements EmailUserSelection {
  @override
  final String emailUserModel;
  const EMailScreenP043({
    super.key,
    required this.emailUserModel,
  });
/*--------------------------------- *** ---*/
  @override
  State<EMailScreenP043> createState() => _EMailScreenP043State();
}

/*--------------------------------- *** ---*/
class _EMailScreenP043State extends State<EMailScreenP043> {
  /*--------------------------------- *** ---*/
  final TextEditingController searchController = TextEditingController();
  var suggestions = <String>[];
  int counter = 0;
  var selected = '';

  // String emailUserModelEMail = "KlausMueller@test.de";
  String selectedEMail = 'jemanden';
  late String emailUserModelEMail;

  @override
  void initState() {
    super.initState();
    emailUserModelEMail = selectedEMail;
  }
  /*--------------------------------- filteredUsers ---*/
  // filteredUsers.isNotEmpty
  //     ? const Text('Keine Benutzer gefunden')
  //     : Expanded(
  //         child: ListView.builder(
  //           itemCount: filteredUsers.length,
  //           itemBuilder: (context, index) {
  //             log('0218 - EmailUserSelection - filteredUsers: ---> $filteredUsers');
  //             return ListTile(
  //               title: Text(filteredUsers[index]),
  //             );
  //           },
  //         ),
  //       ),

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
            fontSize: 20,
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
                  /*------------------------------------------------------------------------------------------- *** ---*/
                  EmailUserSelection(emailUserModel: widget.emailUserModel),

                  //               setState(() {

                  // });
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
      bottomSheet: WbInfoContainer(
        infoText:
            'Am ${context.watch<CurrentDayLongProvider>().currentDayLong}, ${context.watch<CurrentDateProvider>().currentDate} ab ${context.watch<CurrentTimeProvider>().currentTime} eine Mail versenden.\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
        wbColors: Colors.yellow,
      ),
      /*--------------------------------- *** ---*/
      /// emailUserModelEMail wurde ersetzt mit selectedEMail

      // if (selectedEMail.isEmpty) {
      //   return const WbInfoContainer(
      //     infoText:
      //         'Keine E-Mail-Adresse ausgewählt.\nBitte wählen Sie eine E-Mail-Adresse aus der Liste aus.',
      //     wbColors: Colors.red,
      //   );
      // } else {
      //   return WbInfoContainer(
      //     infoText:
      //         'Am ${context.watch<CurrentDayLongProvider>().currentDayLong}, ${context.watch<CurrentDateProvider>().currentDate} um ${context.watch<CurrentTimeProvider>().currentTime} eine Mail an\n$selectedEMail versenden.\nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}\n${context.watch<CurrentAppVersionProvider>().currentAppVersion}',
      //     wbColors: Colors.yellow,
      //   );
      // }

      /*--------------------------------- *** ---*/
    );
  }
}
