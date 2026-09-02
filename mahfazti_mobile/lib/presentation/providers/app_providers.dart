import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';

import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/datasources/remote/budget_remote_data_source.dart';
import '../../data/datasources/remote/category_remote_data_source.dart';
import '../../data/datasources/remote/expense_remote_data_source.dart';
import '../../data/datasources/remote/income_remote_data_source.dart';
import '../../data/datasources/remote/notification_remote_data_source.dart';
import '../../data/datasources/remote/report_remote_data_source.dart';
import '../../data/datasources/remote/user_remote_data_source.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/income_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/income_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/repositories/user_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// =========================================================
// DATA SOURCES
// =========================================================

final authRemoteDataSourceProvider =
    Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final userRemoteDataSourceProvider =
    Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final incomeRemoteDataSourceProvider =
    Provider<IncomeRemoteDataSource>((ref) {
  return IncomeRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final expenseRemoteDataSourceProvider =
    Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final budgetRemoteDataSourceProvider =
    Provider<BudgetRemoteDataSource>((ref) {
  return BudgetRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

final reportRemoteDataSourceProvider =
    Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
});

// =========================================================
// REPOSITORIES
// =========================================================

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource:
        ref.watch(authRemoteDataSourceProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

final userRepositoryProvider =
    Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource:
        ref.watch(userRemoteDataSourceProvider),
  );
});

final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    remoteDataSource:
        ref.watch(categoryRemoteDataSourceProvider),
  );
});

final incomeRepositoryProvider =
    Provider<IncomeRepository>((ref) {
  return IncomeRepositoryImpl(
    remoteDataSource:
        ref.watch(incomeRemoteDataSourceProvider),
  );
});

final expenseRepositoryProvider =
    Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(
    remoteDataSource:
        ref.watch(expenseRemoteDataSourceProvider),
  );
});

final budgetRepositoryProvider =
    Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(
    remoteDataSource:
        ref.watch(budgetRemoteDataSourceProvider),
  );
});

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource:
        ref.watch(notificationRemoteDataSourceProvider),
  );
});

final reportRepositoryProvider =
    Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(
    remoteDataSource:
        ref.watch(reportRemoteDataSourceProvider),
  );
});