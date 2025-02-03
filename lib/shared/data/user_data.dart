class UserData {
  String userName;
  String email;
  String password;

  UserData({
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return "($userName, $email, ********)";
  }
}
