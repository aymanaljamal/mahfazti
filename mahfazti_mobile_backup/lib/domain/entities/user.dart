import '../enums/user_role.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final UserRole role;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.profileImageUrl,
    required this.role,
  });

  String get fullName => '$firstName $lastName';
}
