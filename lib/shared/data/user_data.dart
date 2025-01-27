class UserData {
  String userName; // Vorübergehend ist der userName die E-Mail-Adresse
  String password;

  UserData({
    required this.userName, // Vorübergehend ist der userName die E-Mail-Adresse
    required this.password,
  });

  @override
  String toString() {
    return "($userName, ********)";
  }
}
