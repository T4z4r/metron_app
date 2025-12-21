class User {
  int? id;
  String name;
  String role;

  User({this.id, required this.name, required this.role});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], role: json['role']);
}
