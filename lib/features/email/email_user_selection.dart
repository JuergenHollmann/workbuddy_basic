// Custom Suggestions

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:workbuddy/config/wb_colors.dart';
import 'package:workbuddy/config/wb_sizes.dart';
import 'package:workbuddy/features/email/email_user_model.dart';

import 'mock_email_users_data.dart';

class EmailUserSelection extends StatefulWidget {
  const EmailUserSelection({
    super.key,
    required this.emailUserModel,
  });

  final String emailUserModel;

  @override
  State<EmailUserSelection> createState() => _EmailUserSelectionState();
}

class _EmailUserSelectionState extends State<EmailUserSelection> {
  final List<EmailUserModel> emailUser = [];
  /*--------------------------------- neu ---*/
  List<String> allUsers = [];
  List<String> filteredUsers = [];
  int foundUsersCount = 0;
  String selectedEMail = '';
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
    log("0038 - EmailUserSelection - custom Counter: $searchFieldCounter");
    /*--------------------------------- *** ---*/
    // die gefundene Anzahl der User in der Liste zeigen:
    int? searchFieldFoundCounter = emailUsersData.length;
    log("0245 - EmailUserSelection - Counter: $searchFieldFoundCounter");

    /*--------------------------------- neu ---*/
    List<String> allUsers = emailUser.map((e) => e.email).toList();
    log("0056 - EmailUserSelection ---> $allUsers");
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
      log('0069 - EmailUserSelection ---> foundUsersCount: $foundUsersCount - erwartet: "0"');
      log('0072 - EmailUserSelection - query: $query');
    });
    /*--------------------------------- neu ---*/
  }

  /*--------------------------------- onSuggestionTap ---*/
  void onSuggestionTap(String user) {
    /* Hier wird der Inhalt des in der Liste angetippten Items verarbeitet */
    setState(() {
      selectedEMail = user;
    });
    log('0079 - EmailUserSelection ---> Angetippter Benutzer: $user');
    log('0081 - EmailUserSelection ---> foundUsersCount: $foundUsersCount - erwartet: "21"');
  }

  /*--------------------------------- searchFieldController ---*/
  final TextEditingController searchFieldController = TextEditingController();
  void clearSearchField() {
    searchFieldController.clear();
  }

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
              /*--------------------------------- onSuggestionTap ---*/
              onSuggestionTap: (SearchFieldListItem<EmailUserModel> value) {
                onSuggestionTap(value.searchKey);
              },
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
                    log("0173 - EmailUserSelection - searchFieldController.clear");
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
                      // Wie kann ich hier nach mehreren Kriterien suchen oder filtern? - EmailUserSelection - 0158
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
          /*--------------------------------- filteredUsers xxx ---*/
          // Text('Erste E_Mail: ${emailUser.first.email}'), // funzt
          // Text('Vorname: ${emailUser.nonNulls.first.firstName}'), // funzt
          // Text('xxx: ${widget.emailUserModel.characters}'), // funzt
          // Text('List of instances: $emailUser,'), // funzt
          // Text('Anzahl ${widget.emailUserModel.length}'), // falsch: 8 ???
          // Text('E-Mail-Adresse: ${widget.emailUserModel}'), // komischer Wert
          // Text('Anzahl aller gefundenen E-Mails: $foundUsersCount\n$filteredUsers'), // funzt
          // Text('filteredUsers: ${filteredUsers.first}'), // funzt
          // Text('Anzahl aller Gefundenen E-Mails: $foundUsersCount'), // funzt
          /*--------------------------------- Abstand ---*/
          wbSizedBoxHeight8,
          /*--------------------------------- E-Mail versenden an ---*/
          Text('E-Mail versenden an:'),
          Text(
            selectedEMail,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } catch (e) {
      log('Fehlermeldung: $e');
      return const Text('So ne Grütze!');
    }
  }
}

/*--------------------------------- *** ---*/
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
