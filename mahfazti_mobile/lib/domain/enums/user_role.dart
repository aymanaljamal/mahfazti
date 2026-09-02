enum UserRole {
  user,
  admin,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.user:
        return 'USER';
      case UserRole.admin:
        return 'ADMIN';
    }
  }

  static UserRole fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'USER':
        return UserRole.user;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }
}