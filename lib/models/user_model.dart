class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;

  AppUser({required this.id, required this.name, required this.email, required this.role});

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role,
  };

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
    );
  }
}
