import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/shared/providers/current_user_provider.dart';
import 'package:workbuddy/shared/widgets/button_accounting.dart';
import 'package:workbuddy/shared/widgets/button_communication.dart';
import 'package:workbuddy/shared/widgets/button_contacts.dart';
import 'package:workbuddy/shared/widgets/button_tasks_and_todos.dart';
import 'package:workbuddy/shared/widgets/wb_navigationbar.dart';

class MainSelectionScreen extends StatefulWidget {
  const MainSelectionScreen({super.key});

  @override
  State<MainSelectionScreen> createState() => _MainSelectionScreenState();
}

class _MainSelectionScreenState extends State<MainSelectionScreen> {
  @override
  void initState() {
    // Eine Methode einmalig ausführen
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      /*--------------------------------- AppBar ---*/
      appBar: AppBar(
        title: Text(
          //'Was möchtest Du tun?',
          '${context.watch<CurrentUserProvider>().currentUser} ist angemeldet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        /* das sogt für den Abstand zum "Chevron" am Anfang */
        // leadingWidth: 24,
        foregroundColor: Colors.white,
        backgroundColor: wbColorAppBarBlue, // dunkles Blau
        shadowColor: Colors.black87, // Schatten
        elevation: 20, // graue Zone für den Schatten unter der AppBar
      ),
      /*--------------------------------- Logo ---*/
      body: Column(
        children: [
          const Image(
              image: AssetImage(
            "assets/workbuddy_patch_and_slogan.png",
          )),
          /*--------------------------------- GridView ---*/
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
          //     child: GridView.count(
          //       crossAxisCount: 2, // Anzahl der Spalten
          //       crossAxisSpacing: 1, // Platz zwischen den Spalten
          //       mainAxisSpacing: 1, // Platz zwischen den Reihen
          //       childAspectRatio: 1.1, // Verhältnis Höhe zu Breite
          //       // /*--------------------------------- GridView children ---*/
          //       children: [
          //         ButtonContacts(),
          //         ButtonContacts(),
          //         ButtonContacts(),
          //         ButtonContacts(),
          //         // ButtonAccounting(),
          //         // ButtonContacts(),
          //         // ButtonTasksAndToDos(),
          //         // ButtonCommunication(),
          //       ],
          //     ),
          //   ),
          // ),
          /*--------------------------------- Alternative zur GridView ---*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonAccounting(),
              ButtonContacts(),
              // ButtonContacts(),
              //ButtonCommunication(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ButtonTasksAndToDos(),
              ButtonCommunication(),
              ButtonTasksAndToDos(),
            ],
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- Wer ist angemeldet? ---*/
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<CurrentUserProvider>(
                builder: (context, value, child) => Text(
                  '${value.currentUser} ist angemeldet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight32,
          /*--------------------------------- *** ---*/
        ],
      ),
      /*--------------------------------- NavigationBar ---*/
      bottomNavigationBar: WbNavigationbar(
        wbImageAssetImage: AssetImage(
            "assets/iconbuttons/icon_button_einstellungen_rund_3d_neon_viel_breiter.png"), // hat keine Auswirkung! - 0124 - MainSelectionScreen
      ),
      /*--------------------------------- *** ---*/
    );
  }
}
