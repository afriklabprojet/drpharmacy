import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../models/pharmacy_model.dart';

class PharmaciesRemoteDataSource {
  final ApiClient apiClient;

  PharmaciesRemoteDataSource(this.apiClient);

  Future<List<PharmacyModel>> getPharmacies({int page = 1, int perPage = 20}) async {
    final response = await apiClient.get(
      '/customer/pharmacies',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => PharmacyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<PharmacyModel>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    double? radius,
  }) async {
    final response = await apiClient.get(
      '/customer/pharmacies/nearby',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        if (radius != null) 'radius': radius,
      },
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => PharmacyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<PharmacyModel>> getOnDutyPharmacies() async {
    final response = await apiClient.get('/customer/pharmacies/on-duty');
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => PharmacyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PharmacyModel> getPharmacyDetails(int pharmacyId) async {
    final response = await apiClient.get('/customer/pharmacies/$pharmacyId');
    return PharmacyModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<PharmacyModel>> getFeaturedPharmacies() async {
    final response = await apiClient.get('/customer/pharmacies/featured');
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((json) => PharmacyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
