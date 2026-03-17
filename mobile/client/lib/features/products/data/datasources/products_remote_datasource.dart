import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  final ApiClient apiClient;

  ProductsRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> getProducts({int page = 1, int perPage = 20}) async {
    final response = await apiClient.get(
      '/customer/products',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductDetails(int productId) async {
    final response = await apiClient.get('/customer/products/$productId');
    return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<ProductModel>> searchProducts(String query, {int page = 1}) async {
    final response = await apiClient.get(
      '/customer/products/search',
      queryParameters: {'q': query, 'page': page},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId, {int page = 1}) async {
    final response = await apiClient.get(
      '/customer/products',
      queryParameters: {'category_id': categoryId, 'page': page},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
