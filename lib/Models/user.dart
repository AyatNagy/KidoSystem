class User {
  final int? id;
  final String username;
  final String password;
  final String name;
  final String email;
  final String? phone;
  final DateTime? createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    this.phone,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'] ?? '',
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
