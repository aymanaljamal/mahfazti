import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiClient _apiClient;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required ApiClient apiClient,
  })  : _remoteDataSource = remoteDataSource,
        _apiClient = apiClient;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password,
    );

    final response = await _remoteDataSource.login(request);

    await _apiClient.saveToken(
      response.accessToken,
    );

    return User(
      id: response.userId,
      firstName: response.firstName,
      lastName: response.lastName,
      email: response.email,
      profileImageUrl: response.profileImageUrl,
      role: response.role,
    );
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final request = RegisterRequestModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
    );

    final response =
        await _remoteDataSource.register(request);

    await _apiClient.saveToken(
      response.accessToken,
    );

    return User(
      id: response.userId,
      firstName: response.firstName,
      lastName: response.lastName,
      email: response.email,
      profileImageUrl: response.profileImageUrl,
      role: response.role,
    );
  }

  @override
  Future<void> logout() async {
    await _apiClient.deleteToken();
  }

  @override
  Future<bool> hasActiveSession() async {
    return await _apiClient.hasToken();
  }
}