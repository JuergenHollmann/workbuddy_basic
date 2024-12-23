import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/shared/widgets/button_accounting.dart';
import 'package:workbuddy/shared/widgets/button_communication.dart';
import 'package:workbuddy/shared/widgets/button_companies.dart';
import 'package:workbuddy/shared/widgets/button_customer.dart';
import 'package:workbuddy/shared/widgets/wb_navigationbar.dart';

class MainSelectionScreen extends StatefulWidget {
  const MainSelectionScreen({super.key});

  @override
  State<MainSelectionScreen> createState() => _MainSelectionScreenState();
}

class _MainSelectionScreenState extends State<MainSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // den gesamten Hintergrund einfärben:
      backgroundColor: Colors.blue, // vorher: primeColor
      /*--------------------------------- AppBar ---*/
      appBar: AppBar(
        title: const Text(
          'Was möchtest Du tun?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ), // Schriftfarbe
        ),
        foregroundColor: Colors.white,
        backgroundColor: wbColorAppBarBlue, // dunkles Blau
        shadowColor: Colors.black87, // Schatten
        elevation: 20, // graue Zone für den Schatten unter der AppBar
      ),
      /*--------------------------------- Logo ---*/
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                  image: AssetImage(
                "assets/workbuddy_patch_and_slogan.png",
              )),
              /*--------------------------------- Buttons ---*/
// Hier auf GridView umbauen - MainSelectionScreen - 0043

              // GridView.count(
              //   crossAxisCount: 2, // Number of columns
              //   children: <Widget>[
              //     // Add buttons or any other widgets here
              //     ElevatedButton(
              //       onPressed: () {
              //         // Button pressed action
              //       },
              //       child: Text('Button 1'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         // Button pressed action
              //       },
              //       child: Text('Button 2'),
              //     ),
              //     // Add more buttons as needed
              //   ],
              // ),
/*--------------------------------- GridView ---*/
//               GridView.count(
//                 crossAxisCount: 2, // Number of columns
//                 crossAxisSpacing: 10, // Spacing between columns
//                 mainAxisSpacing: 10, // Spacing between grid items
//                 childAspectRatio:
//                     3, // Width to height ratio of each grid item to adjust item size
//                 // /*--------------------------------- GridView children ---*/
//                 // children: [
//                 //   ButtonAccounting(),
//                 //   ButtonCommunication(),
//                 //   ButtonCustomer(),
//                 //   ButtonCompanies(),
//                 // ],
//                 /*--------------------------------- GridView children ---*/
//                 children: [
// GridItem(text: 'Item 1', bgColor: Colors.red),
// GridItem(text: 'Item 2', bgColor: Colors.green),
// GridItem(text: 'Item 3', bgColor: Colors.blue),
// GridItem(text: 'Item 4', bgColor: Colors.orange),
//                 ],
//                 /*--------------------------------- GridView children ---*/
//                 // children: List.generate // Generate grid items
//                 //     (10, // Number of grid items
//                 //         (index) {
//                 //   return ElevatedButton(
//                 //     onPressed: () {
//                 //       // Button pressed action
//                 //     },
//                 //     child: Text('Button $index'),
//                 //   );
//                 // }),
//                 /*--------------------------------- *** ---*/
//               ),
/*--------------------------------- Buttons ---*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonAccounting(),
                  ButtonCommunication(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonCustomer(),
                  ButtonCompanies(),
                ],
              ),
              /*--------------------------------- *** ---*/
            ],
          ),
        ),
      ),
      /*--------------------------------- NavigationBar ---*/
      bottomNavigationBar: WbNavigationbar(
        wbImageAssetImage: AssetImage("assets/button_settings.png"), // hat keine Auswirkung! - 0124 - MainSelectionScreen
      ),
      /*--------------------------------- *** ---*/
    );
  }
}
