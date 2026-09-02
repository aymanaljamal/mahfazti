import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // =========================================================
  // CONSTANTS
  // =========================================================

  static const String accessTokenKey = 'access_token';

  // =========================================================
  // DEPENDENCY
  // =========================================================

  final FlutterSecureStorage _storage;

  // =========================================================
  // CONSTRUCTOR
  // =========================================================

  SecureStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  // =========================================================
  // ACCESS TOKEN
  // =========================================================

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: accessTokenKey,
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: accessTokenKey,
    );
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(
      key: accessTokenKey,
    );
  }

  // =========================================================
  // AUTH STATUS
  // =========================================================

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }

  // =========================================================
  // CLEAR STORAGE
  // =========================================================

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}