class Validator {
/*--------------------------------- isValidUsername ---*/
  static String? isValidUsername(String? value) {
    // Der Benutzername darf nicht leer sein:
    if (value == null || value.isEmpty) {
      return "Bitte den Benutzer angeben!";
    }
    if (value.length < 3) {
      return "... muss min. 3 Zeichen haben!";
    }
    if (value.length > 15) {
      return "... darf max. 15 Zeichen haben!";
    }
    // wenn null zurückgegeben wird, ist alles OK hier:
    return null;
  }

  /*--------------------------------- isValidEmail ---*/
  static String? isValidEmail(String? value) {
    // Die E-Mail darf nicht leer sein:
    if (value == null || value.isEmpty) {
      return "E-Mail muss angegeben werden! ";
    }
    if (value.length < 5) {
      return "E-Mail benötigt min. 5 Zeichen!";
    }
    if (!value.contains("@")) {
      return "E-Mail muss \" @ \"enthalten!";
    }
    if (!value.contains(".")) {
      return "E-Mail muss \" . \" enthalten!";
    }
    // wenn null zurückgegeben wird, ist alles OK hier:
    return null;
  }

  /*--------------------------------- isValidPassword ---*/
  static String? isValidPassword(String? value) {
    // Das Passwort darf nicht null oder leer sein.
    if (value == null || value.isEmpty) {
      return "Bitte ein Password angeben!";
    }
    if (value.length < 4) {
      return "... muss min. 4 Zeichen haben!";
    }
        if (!value.contains("#")) {
      return "... muss ein \" # \"enthalten!";
    }
    // if (value == value) {
    //   return "Die Paßwörter sind NICHT gleich!"; // funzt so nicht! 0050 - Validator - todo
    // }

    // if (!RegExp(r'^[=]+$').hasMatch(value)) { // [!§%-&/()=?] [a-zA-Z0-9]
    //   return "... muss ein Sonderzeichen enthalten!"; // "... muss \" !§%&/()=? \" enthalten!";
    // }

    if (!value.contains("!") ||
        !value.contains("§") ||
        !value.contains("%") ||
        !value.contains("&") ||
        !value.contains("/") ||
        !value.contains("(") ||
        !value.contains(")") ||
        !value.contains("=") ||
        !value.contains("?") ||
        !value.contains("`") ||
        !value.contains("!") ||
        !value.contains("!") ||
        !value.contains("!") ||
        !value.contains("!") ||
        !value.contains("!") ||
        !value.contains("!") ||
        !value.contains("+") ||
        !value.contains("*") ||
        !value.contains("@") ||
        !value.contains("'") ||
        !value.contains("<") ||
        !value.contains(">") ||
        !value.contains(",") ||
        !value.contains(";") ||
        !value.contains(".") ||
        !value.contains(":") ||
        !value.contains("-") ||
        !value.contains("_")) {
      return "... min. 1 Sonderzeichen enthalten!"; // "... muss \" !§%&/()=? \" enthalten!";
    }
    //       !value.contains("´") ||
    //        !value.contains("#") ||


    return null;
  }
}

// /*--------------------------------- isValidMobileNumber ---*/
//   static String? isValidMobileNumber(String? value) {
//     // Der Benutzername darf nicht leer sein:
//     if (value == null || value.isEmpty) {
//       return "Bitte den Benutzernamen angeben!";
//     }
//     if (value.length < 3) {
//       return "... muss mindestens 3 Zeichen haben!";
//     }
//     if (value.length > 15) {
//       return "... darf max. 15 Zeichen haben!";
//     }
//     // wenn null zurückgegeben wird, ist alles OK hier:
//     return null;
//   }