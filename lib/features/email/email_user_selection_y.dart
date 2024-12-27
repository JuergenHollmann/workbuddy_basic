// Custom Suggestions

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/features/authentication/screens/p01_login_screen.dart';
import 'package:workbuddy/features/email/email_user_model.dart';

import 'mock_email_users_data.dart';

class EmailUserSelectionX extends StatefulWidget {
  const EmailUserSelectionX({
    super.key,
    required this.emailUserModel,
  });

  final String emailUserModel;

  @override
  State<EmailUserSelectionX> createState() => _EmailUserSelectionXState();
}

class _EmailUserSelectionXState extends State<EmailUserSelectionX> {
  final List<EmailUserModel> emailUser = [];
  /*--------------------------------- neu ---*/
  List<String> allUsers = ['Peter', 'Paul', 'Mary', 'John', 'Jane'];
  List<String> filteredUsers = [];
  int foundUsersCount = 0;
  String currentEMail = '';
  /*--------------------------------- neu ---*/
  @override
  void initState() {
    super.initState();
    /*--------------------------------- *** ---*/
    // durch alle Elemente in der Liste iterieren:
    for (var element in emailUsersData) {
      emailUser.add(EmailUserModel.fromJson(element));
      // nur zur Kontrolle: zeigt bei JEDEM Durchgang die Anzahl aus "emailUser.length" an:
      // int searchFieldCounter = emailUser.length;
      // log("0028_custom Counter: $searchFieldCounter");

      // String searchFieldItems = "$firstName $lastName $email";
      // log("0056 $searchFieldItems");
    }
    /*--------------------------------- *** ---*/
    // die Gesamt-Anzahl der User in der Liste zeigen (NACH Iterierung NUR EINE Zahl zeigen):
    int searchFieldCounter = emailUser.length;
    log("0038 - EmailUserSelectionX - custom Counter: $searchFieldCounter");
    /*--------------------------------- *** ---*/
    // die gefundene Anzahl der User in der Liste zeigen:
    int? searchFieldFoundCounter = emailUsersData.length;
    log("0245 - EmailUserSelectionX - Counter: $searchFieldFoundCounter");

    /*--------------------------------- neu ---*/
    List<String> allUsers = emailUser.map((e) => e.email).toList();
    log("0056 - EmailUserSelectionX ---> $allUsers");
    filteredUsers = allUsers;
    foundUsersCount = filteredUsers.length;
    /*--------------------------------- neu ---*/
  }

  /*--------------------------------- neu ---*/
  void filterUsers(String query) {
    String query = searchFieldController.text;
    setState(() {
      filteredUsers = allUsers
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
      foundUsersCount = filteredUsers.length;
      log('0069 - EmailUserSelectionX ---> foundUsersCount: $foundUsersCount - erwartet: "0"');
      log('0072 - EmailUserSelectionX - query: $query');
    });
    /*--------------------------------- neu ---*/
  }

  void onSuggestionTap(String user) {
    // Hier können Sie den Inhalt des angetippten Vorschlags verarbeiten
    log('0079 - EmailUserSelectionX ---> Angetippter Benutzer: $user');
    // Weitere Verarbeitung, z.B. den Benutzer auswählen oder eine Aktion ausführen
  }

  final TextEditingController searchFieldController = TextEditingController();
  void clearSearchField() {
    searchFieldController.clear();
  }
  /*--------------------------------- searchFieldItems generieren ---*/
  /* Welche Felder sollen in die Suche miteinbezogen  werden (Daten aus "emailUsersData")?
  1) Vorname = firstName 
  2) Nachname = lastName
  3) E-Mail-Adresse = email */

  // void searchFieldItems(String searchFieldItems) {
  //   String searchFieldItems = "$firstName $lastName $email";
  //   log("0056 $searchFieldItems");
  // }
  /*--------------------------------- *** ---*/
  @override
  Widget build(BuildContext context) {
    /*--------------------------------- E-Mail-Adresse ---*/

    try {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: SearchField<EmailUserModel>(
              /*--------------------------------- onSearchTextChanged ---*/
              // onSearchTextChanged: (value) => filterUsers(value),//O
              // onSearchTextChanged: (value) {
              //   filterUsers(value);
              //   return null;
              // },
              /*--------------------------------- onSuggestionTap ---*/
              // onSuggestionTap: (value) => onSuggestionTap(value.item?.email ?? ''), // passiert nichts

              // onSuggestionTap: (value) => onSuggestionTap(value.item?.email ?? ''), // passiert nichts
              // onSuggestionTap: (value) => filterUsers(value
              //     .searchKey), // findet 0072 - aber friert ein ohne Fehlermeldung
              // onSuggestionTap: (value) =>
              //     filterUsers(value.item?.email?.runes.string ?? ''), // findet 0072 - aber friert ein ohne Fehlermeldung
              onSuggestionTap: (value) => filterUsers(
                  userName), // findet 0072 - aber friert ein ohne Fehlermeldung
              /*--------------------------------- xxx ---*/
              // maxLength: 10, // maximale Anzahl der Ziffern für die Suche
              dynamicHeight:
                  false, // zeigt die Auswahl-Liste in der Länge der Items
              // maxSuggestionBoxHeight: 200,
              controller: searchFieldController,
              maxSuggestionsInViewPort: 4,
              itemHeight: 110,
              /*--------------------------------- SearchInputDecoration - Suchfeld ---*/
              searchInputDecoration: SearchInputDecoration(
                cursorHeight: 30,
                cursorWidth: 3,
                filled: true,
                fillColor: wbColorBackgroundBlue,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.search_outlined,
                    size: 48,
                  ),
                ),
                /*--- Nach anklicken des suffixIcon wird der Eintrag im "SearchField" gelöscht ---*/
                suffixIcon: GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 40,
                    ),
                  ),
                  onTap: () {
                    log("0173 - EmailUserSelectionX - searchFieldController.clear");
                    setState(() {
                      /*--------------------------------- *** ---*/
                      // diesen Text kann man auf 3 Arten löschen:
                      /*--------------------------------- *** ---*/
                      searchFieldController.clear(); // funzt!
                      // clearSearchField(); // funzt auch!
                      // searchFieldController.text = ""; // funzt auch!
                      /*--------------------------------- *** ---*/
                    });
                  },
                ),
                /*--------------------------------- *** ---*/
                searchStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    overflow: TextOverflow.visible),
              ),
              hint: 'Suche nach E-Mails',
              /*--------------------------------- SuggestionDecoration - Suchliste ---*/
              suggestionsDecoration: SuggestionDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.black, width: 2, //Colors.grey.withOpacity(0.5),
                ),
              ),
              /*--------------------------------- *** ---*/
              suggestionItemDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.yellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4],
                  //tileMode: TileMode.repeated,
                ),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              marginColor: Colors.black, //Colors.grey.shade300,
              /*--------------------------------- *** ---*/
              suggestions: emailUser
                  .map(
                    (emailUserModel) => SearchFieldListItem<EmailUserModel>(
                      // Wie kann ich hier nach mehreren Kriterien suchen oder filtern? - EmailUserSelectionX - 0158
                      /* Diese Daten werden in das "SearchFieldListItem" beim Anklicken übergeben */
                      emailUserModel.email,
                      /*--------------------------------- *** ---*/

                      child: UserTile(
                        user: emailUserModel,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          /*--------------------------------- filteredUsers ---*/
          filteredUsers.isNotEmpty
              ? const Text('Keine Benutzer gefunden')
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredUsers[index]),
                      );
                    },
                  ),
                ),
          /*--------------------------------- filteredUsers xxx ---*/

          Text('Erste E_Mail: ${emailUser.first.email}'),
          Text('Vorname: ${emailUser.nonNulls.first.firstName}'),
          Text('xxx: ${widget.emailUserModel.characters}'),
          // Text('List of instances: $emailUser,'),
          Text('Anzahl ${widget.emailUserModel.length}'),
          Text('E-Mail-Adresse: ${widget.emailUserModel}'),
          Text('Gefundene E-Mails: $foundUsersCount\n$filteredUsers'),
          // Text('filteredUsers: ${filteredUsers.first}'),
          Text('Gefundene: $foundUsersCount'),
        ],
      );
    } catch (e) {
      log('Fehlermeldung: $e');
      return const Text('So ne Grütze!');
    }
  }
}
/*--------------------------------- *** ---*/

// /*--------------------------------- ListView.builder ---*/
// child: ListView.builder(
//   itemCount: filteredUsers.length,
//   itemBuilder: (context, index) {
//     return ListTile(
//       title: Text(filteredUsers[index]),
//     );
//   },
// ),
// /*--------------------------------- ListView.builder xxx ---*/

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Email User Selection'),
//     ),
//     body: Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             onChanged: (value) => filterUsers(value),
//             decoration: InputDecoration(
//               labelText: 'Search',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Gefundene Benutzer: $foundUsersCount'),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredUsers.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(filteredUsers[index]),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

class UserTile extends StatelessWidget {
  final EmailUserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    /*--------------------------------- ListTile ---*/
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: 4),
      isThreeLine: true,
      autofocus: true,
      dense: false,
      selectedColor: Colors.redAccent,
      tileColor: wbColorBackgroundBlue, // Hintergrundfarbe
      contentPadding: const EdgeInsets.all(0),
      // minTileHeight: 10,
      // minLeadingWidth: 50,
      leading: CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(user.avatar),
      ),
      /*--------------------------------- Name ---*/
      title: Text(
        "${user.firstName} ${user.lastName}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      /*--------------------------------- Status 1 + 2 + Kategorie + Alter + Job ---*/
      subtitle: Text(
        "${user.status2}-${user.status1} (${user.age})\n💼 ${user.role}", // \n${user.email}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      /*--------------------------------- ListTile ---*/
      trailing: Text(
        "[${user.category}]  ",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      /*--------------------------------- ListTile - ENDE ---*/
    );
  }
}
