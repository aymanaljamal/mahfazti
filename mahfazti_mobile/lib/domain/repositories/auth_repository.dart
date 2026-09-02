import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<void> logout();

  Future<bool> hasActiveSession();
}