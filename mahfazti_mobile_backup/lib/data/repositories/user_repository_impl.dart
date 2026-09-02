import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../models/update_user_request_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<User> getCurrentUser() async {
    final model = await _remoteDataSource.getCurrentUser();

    return model.toEntity();
  }

  @override
  Future<User> updateCurrentUser({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImageUrl,
  }) async {
    final request = UpdateUserRequestModel(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profileImageUrl: profileImageUrl,
    );

    final model = await _remoteDataSource.updateCurrentUser(request);

    return model.toEntity();
  }
}
