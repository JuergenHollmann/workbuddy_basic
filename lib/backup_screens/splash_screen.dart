// // funzt noch nicht

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:workbuddy/main.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // damit der SplashScreen etwas länger zu sehen ist soll ein Timer das steuern:
//     Timer(
//         const Duration(seconds: 1),
//         () => Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (BuildContext context) => const MainApp())));

//     var assetsImage = const AssetImage(
//         "assets/splash/workbuddy_glow_logo.png");
//     var image = Image(
//       image: assetsImage,
//       width: 320,
//     );
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("WorkBuddy"),
//           backgroundColor: const Color.fromARGB(255, 255, 0, 0), //const Color(0x00000000),
//         ),
//         body: Container(
//           height: 320,
//           decoration: const BoxDecoration(color: Colors.black),
//           child: Center(
//             child: image,
//           ),
//         ),
//       ),
//     );
//   }
// }
