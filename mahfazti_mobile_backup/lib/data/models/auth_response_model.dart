import '../../domain/enums/user_role.dart';

class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final String? profileImageUrl;

  const AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
      userId: (json['userId'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: UserRoleExtension.fromValue(
        json['role'] as String,
      ),
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role.value,
      'profileImageUrl': profileImageUrl,
    };
  }
}
