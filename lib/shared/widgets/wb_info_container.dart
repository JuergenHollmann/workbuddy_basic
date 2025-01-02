import 'package:flutter/material.dart';

class WbInfoContainer extends StatelessWidget {
  const WbInfoContainer({
    super.key,
    required this.infoText,
    required this.wbColors,
  });

  final String infoText;
  final Color wbColors;

  /*--------------------------------- WbInfoContainer ---*/
  /* Der Aufruf muss so starten: "bottomSheet: WbInfoContainer(..." */

  @override
  Widget build(BuildContext context) {
    return

        // BottomSheet(
        //   onClosing: (){},
        //   builder: (BuildContext context) {},
        //   child:

        Container(
      /* das sorgt für die automatische Anpassung der Höhe, wenn mehr Text hineingeschrieben wird */
      height: double.tryParse('.'),
      /* das sogt für die maximale Breite */
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),
        color: wbColors, // Colors.yellow,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Text(
          maxLines: null,
          /*--------------------------------- infoText ---*/
          infoText,
          /*--------------------------------- *** ---*/
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

void bottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Bottom Sheet Title', style: TextStyle(fontSize: 24.0)),
            SizedBox(height: 10.0),
            Text('This is the content of the bottom sheet.'),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}
/* 
infoText-Beispiele:
  E-Mail 1 (von $searchFieldCounter043) senden an $emailUserModelEMail
  Heute ist ${context.watch<CurrentDayLongProvider>().currentDayLong}
  Heute ist ${context.watch<CurrentDayShortProvider>().currentDayShort}
  Datum ${context.watch<CurrentDateProvider>().currentDate}
  \nAngemeldet zur Bearbeitung: ${context.watch<CurrentUserProvider>().currentUser}
  \n${context.watch<CurrentAppVersionProvider>().currentAppVersion}
*/

/* \nAngemeldet zur Bearbeitung: JH-01\nLetzte Änderung: Am 18.12.2024 um 22:51 Uhr' */
/* WorkBuddy • Free-BASIC-Version 0.003 */
/* WorkBuddy • save time and money • V0.003 */

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

