class Child {
  final int? id;
  final String username;
  final String password;
  final String name;
  final DateTime? dateOfBirth;
  final int? motherId;
  final DateTime? createdAt;

  Child({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    this.dateOfBirth,
    this.motherId,
    this.createdAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      username: json['username'],
      password: json['password'] ?? '',
      name: json['name'],
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.tryParse(json['dateOfBirth'])
              : null,
      motherId: json['motherId'],
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
      if (dateOfBirth != null)
        'dateOfBirth':
            dateOfBirth!.toIso8601String().split('T')[0], // YYYY-MM-DD format
    };
  }
}
