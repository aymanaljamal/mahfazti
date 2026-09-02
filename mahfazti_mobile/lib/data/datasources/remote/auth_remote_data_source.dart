import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth_response_model.dart';
import '../../models/login_request_model.dart';
import '../../models/register_request_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<AuthResponseModel> login(
    LoginRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    return AuthResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<AuthResponseModel> register(
    RegisterRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: request.toJson(),
    );

    return AuthResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}