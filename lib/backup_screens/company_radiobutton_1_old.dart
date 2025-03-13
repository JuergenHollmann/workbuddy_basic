// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:workbuddy/config/wb_sizes.dart';

// class CompanyRadioButton1 extends StatelessWidget {
//   const CompanyRadioButton1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     log("0011 - CompanyRadioButton1 - wird benutzt");

//     return Column(
//       children: [
//         Container(
//           width: 398,
//           height: 60,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey, width: 5),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Expanded(
//               child: Row(
//                 children: [
//                   Radio(
//                     value: "Lieferant",
//                     groupValue: "Lieferant",
//                     onChanged: (value) {
//                       log("Lieferant wurde angeklickt");
//                     },
//                   ),
//                   const Text(
//                     "Lieferant",
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   wbSizedBoxWidth16,
//                   Radio(
//                     value: "Kunde",
//                     groupValue: "",
//                     onChanged: (value) {
//                       log("Kunde wurde angeklickt");
//                     },
//                   ),
//                   const Text(
//                     "Kunde",
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
