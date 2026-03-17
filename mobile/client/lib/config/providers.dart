import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';

// Auth
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

// Orders
import '../features/orders/data/datasources/orders_local_datasource.dart';
import '../features/orders/data/datasources/orders_remote_datasource.dart';
import '../features/orders/data/repositories/orders_repository_impl.dart';
import '../features/orders/domain/repositories/orders_repository.dart';

// Products
import '../features/products/data/datasources/products_remote_datasource.dart';
import '../features/products/data/repositories/products_repository_impl.dart';
import '../features/products/domain/repositories/products_repository.dart';

// Pharmacies
import '../features/pharmacies/data/datasources/pharmacies_remote_datasource.dart';
import '../features/pharmacies/data/repositories/pharmacies_repository_impl.dart';
import '../features/pharmacies/domain/repositories/pharmacies_repository.dart';
import '../features/pharmacies/domain/usecases/get_pharmacies_usecase.dart';
import '../features/pharmacies/domain/usecases/get_nearby_pharmacies_usecase.dart';
import '../features/pharmacies/domain/usecases/get_on_duty_pharmacies_usecase.dart';
import '../features/pharmacies/domain/usecases/get_pharmacy_details_usecase.dart';
import '../features/pharmacies/domain/usecases/get_featured_pharmacies_usecase.dart';
import '../features/pharmacies/presentation/providers/pharmacies_notifier.dart';
import '../features/pharmacies/presentation/providers/pharmacies_state.dart';

// Profile
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';

// Services
import '../core/services/notification_service.dart';
import '../features/auth/domain/usecases/update_password_usecase.dart';

// ──────────────────────────────────────────────────────────
// Core Providers
// ──────────────────────────────────────────────────────────

/// SharedPreferences — overridden in main.dart with the actual instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// API Client singleton
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// ──────────────────────────────────────────────────────────
// Auth
// ──────────────────────────────────────────────────────────

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient: apiClient);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: prefs);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

// ──────────────────────────────────────────────────────────
// Orders
// ──────────────────────────────────────────────────────────

final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrdersRemoteDataSource(apiClient);
});

final ordersLocalDataSourceProvider = Provider<OrdersLocalDataSource>((ref) {
  return OrdersLocalDataSourceImpl();
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl(
    remoteDataSource: ref.watch(ordersRemoteDataSourceProvider),
    localDataSource: ref.watch(ordersLocalDataSourceProvider),
  );
});

// ──────────────────────────────────────────────────────────
// Products
// ──────────────────────────────────────────────────────────

final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductsRemoteDataSource(apiClient);
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(
    remoteDataSource: ref.watch(productsRemoteDataSourceProvider),
  );
});

// ──────────────────────────────────────────────────────────
// Pharmacies
// ──────────────────────────────────────────────────────────

final pharmaciesRemoteDataSourceProvider = Provider<PharmaciesRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PharmaciesRemoteDataSource(apiClient);
});

final pharmaciesRepositoryProvider = Provider<PharmaciesRepository>((ref) {
  return PharmaciesRepositoryImpl(
    remoteDataSource: ref.watch(pharmaciesRemoteDataSourceProvider),
  );
});

final pharmaciesProvider =
    StateNotifierProvider<PharmaciesNotifier, PharmaciesState>((ref) {
  final repository = ref.watch(pharmaciesRepositoryProvider);
  return PharmaciesNotifier(
    getPharmaciesUseCase: GetPharmaciesUseCase(repository),
    getNearbyPharmaciesUseCase: GetNearbyPharmaciesUseCase(repository),
    getOnDutyPharmaciesUseCase: GetOnDutyPharmaciesUseCase(repository),
    getPharmacyDetailsUseCase: GetPharmacyDetailsUseCase(repository),
    getFeaturedPharmaciesUseCase: GetFeaturedPharmaciesUseCase(repository),
  );
});

// ──────────────────────────────────────────────────────────
// Profile
// ──────────────────────────────────────────────────────────

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSource(apiClient);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

// ──────────────────────────────────────────────────────────
// Notification Service
// ──────────────────────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// ──────────────────────────────────────────────────────────
// Update Password Use Case
// ──────────────────────────────────────────────────────────

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UpdatePasswordUseCase(apiClient);
});
