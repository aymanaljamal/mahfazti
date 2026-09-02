import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Category>> getCategories() async {
    final models =
        await _remoteDataSource.getCategories();

    return models
        .map((model) => model.toEntity())
        .toList();
  }
}