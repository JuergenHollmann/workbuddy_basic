import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/main.dart';
import 'package:workbuddy/shared/widgets/button_accounting.dart';
import 'package:workbuddy/shared/widgets/button_communication.dart';
import 'package:workbuddy/shared/widgets/button_companies.dart';
import 'package:workbuddy/shared/widgets/button_customer.dart';
import 'package:workbuddy/shared/widgets/wb_navigationbar.dart';
//import 'current_user_provider.dart';

class MainSelectionScreen extends StatefulWidget {
  const MainSelectionScreen({super.key});

  @override
  State<MainSelectionScreen> createState() => _MainSelectionScreenState();
}

class _MainSelectionScreenState extends State<MainSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUserProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.blue,
      /*--------------------------------- AppBar ---*/
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(height: 60,
              child: Image(
              image: AssetImage("assets/button_close.png")),
            ),
            wbSizedBoxWidth8,
            Text(
              '$currentUser ist angemeldet',
              // '${context.watch<CurrentUserProvider>().currentUser} ist angemeldet', // funzt auch
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ), // Schriftfarbe
            ),
            
          ],
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
              child: GridView.count(
                crossAxisCount: 2, // Anzahl der Spalten
                crossAxisSpacing: 1, // Platz zwischen den Spalten
                mainAxisSpacing: 20, // Platz zwischen den Reihen
                childAspectRatio: 1.2, // Verhältnis Höhe zu Breite
                // /*--------------------------------- GridView children ---*/
                children: [
                  ButtonAccounting(),
                  ButtonCommunication(),
                  ButtonCustomer(),
                  ButtonCompanies(),
                ],
                /*--------------------------------- Alternative zur GridView ---*/
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ButtonAccounting(),
                //     ButtonCommunication(),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ButtonCustomer(),
                //     ButtonCompanies(),
                //   ],
                // ),
                /*--------------------------------- *** ---*/
              ),
            ),
          ),
        ],
      ),
      /*--------------------------------- NavigationBar ---*/
      bottomNavigationBar: WbNavigationbar(
        wbImageAssetImage: AssetImage(
            "assets/button_settings.png"), // hat keine Auswirkung! - 0124 - MainSelectionScreen
      ),
      /*--------------------------------- *** ---*/
    );
  }
}
