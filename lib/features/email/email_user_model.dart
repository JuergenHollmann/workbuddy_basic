class EmailUserModel {
  EmailUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.team,
    required this.status1,
    required this.status2,
    required this.category,
    required this.age,
    required this.avatar,
    required this.email,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String team;
  final String status1;
  final String status2;
  final String category;
  final String age;
  final String avatar;
  final String email;

  factory EmailUserModel.fromJson(Map<String, dynamic> json) {
    return EmailUserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      team: json['team'],
      status1: json['status1'],
      status2: json['status2'],
      category: json['category'],
      age: json['age'] ?? '18',
      avatar: json['avatar'],
      email: json['email'],
    );
  }
}
