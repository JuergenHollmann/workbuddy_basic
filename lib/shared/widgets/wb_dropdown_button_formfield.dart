// import 'package:flutter/material.dart';

// class WbDropdownButtonFormfield {
//   late String _selectedValue;
//   List<String> listOfValue = [
//     'Lieferant',
//     'Kunde',
//     'Interesse',
//     'Kontakt',
//   ];

//   @override
//   Widget build(BuildContext context) {
//         log("0039 - WbDropdownButtonFormfield - aktiviert");

//     return DropdownButtonFormField(
//       value: _selectedValue,
//       hint: Text(
//         'Bitte auswählen',
//       ),
//       isExpanded: true,
//       onChanged: (value) {
//         setState(() {
//           _selectedValue = value;
//         });
//       },
//       onSaved: (value) {
//         setState(() {
//           _selectedValue = value;
//         });
//       },
//       // validator: (String value) {
//       //   if (value.isEmpty) {
//       //     return "can't empty";
//       //   } else {
//       //     return null;
//       //   }
//       // },
//       items: listOfValue.map((String val) {
//         return DropdownMenuItem(
//           value: val,
//           child: Text(
//             val,
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
