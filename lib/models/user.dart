class User {
  int? id;
  String name;
  String email;
  String? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String phone;
  String role;
  String isVerified;

  User({
    this.id,
    required this.name,
    this.email = '', // Make email optional with default empty string
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.phone,
    this.role = 'attendant', // Default role
    this.isVerified = '0', // Default not verified
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('Parsing user JSON: $json'); // Debug print
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '', // Make email optional as it's not in Postman
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      phone: json['phone'],
      role: json['role'] ?? 'attendant', // Default role
      isVerified: json['is_verified'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'phone': phone,
        'role': role,
        'is_verified': isVerified,
      };

  // Helper getters
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isUserVerified => isVerified == '1' || isVerified == 'true';

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
