class UserModel {
  final String userId;
  final String email;
  final String? phoneNumber;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "email": email,
      "phone_number": phoneNumber,
      "role": role,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
