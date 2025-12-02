class UserModel {
  final String name;
  final String email;
  final String role;
  final String status;
  final String dateAdded;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "role": role,
      "status": status,
      "dateAdded": dateAdded,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "",
      status: map["status"] ?? "",
      dateAdded: map["dateAdded"] ?? "",
    );
  }
}

