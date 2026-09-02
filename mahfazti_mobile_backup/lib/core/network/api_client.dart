import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/error_handler.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  // =========================================================
  // DEPENDENCIES
  // =========================================================

  final Dio _dio;
  final SecureStorage _secureStorage;

  // =========================================================
  // CONSTRUCTOR
  // =========================================================

  ApiClient({
    Dio? dio,
    SecureStorage? secureStorage,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ),
        _secureStorage = secureStorage ?? SecureStorage() {
    _setupInterceptors();
  }

  // =========================================================
  // INTERCEPTORS
  // =========================================================

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // -----------------------------------------------------
        // REQUEST
        // -----------------------------------------------------

        onRequest: (options, handler) async {
          final token = await _secureStorage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        // -----------------------------------------------------
        // RESPONSE
        // -----------------------------------------------------

        onResponse: (response, handler) {
          handler.next(response);
        },

        // -----------------------------------------------------
        // ERROR
        // -----------------------------------------------------

        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  // =========================================================
  // GET
  // =========================================================

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  // =========================================================
  // POST
  // =========================================================

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  // =========================================================
  // PUT
  // =========================================================

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioException(e);
    }
  }

  // =========================================================
  // TOKEN MANAGEMENT
  // =========================================================

  Future<void> saveToken(String token) async {
    await _secureStorage.saveAccessToken(token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.getAccessToken();
  }

  Future<void> deleteToken() async {
    await _secureStorage.deleteAccessToken();
  }

  Future<bool> hasToken() async {
    return await _secureStorage.hasAccessToken();
  }

  // =========================================================
  // CLEAR AUTH DATA
  // =========================================================

  Future<void> clearAuthData() async {
    await _secureStorage.deleteAccessToken();
  }
}
