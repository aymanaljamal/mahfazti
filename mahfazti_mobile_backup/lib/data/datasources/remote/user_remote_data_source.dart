import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/update_user_request_model.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(
      ApiConstants.currentUser,
    );

    return UserModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<UserModel> updateCurrentUser(
    UpdateUserRequestModel request,
  ) async {
    final response = await _apiClient.put(
      ApiConstants.currentUser,
      data: request.toJson(),
    );

    return UserModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
