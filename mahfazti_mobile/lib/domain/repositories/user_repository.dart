import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();

  Future<User> updateCurrentUser({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImageUrl,
  });
}