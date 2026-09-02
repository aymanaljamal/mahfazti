import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(
      ApiConstants.categories,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => CategoryModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}