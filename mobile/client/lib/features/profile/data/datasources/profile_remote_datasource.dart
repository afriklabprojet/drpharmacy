import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<UserModel> getProfile() async {
    final response = await apiClient.get('/customer/profile');
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await apiClient.put('/customer/profile', data: data);
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<String> uploadAvatar(Uint8List imageBytes) async {
    final formData = FormData.fromMap({
      'avatar': MultipartFile.fromBytes(imageBytes, filename: 'avatar.jpg'),
    });
    final response = await apiClient.post('/customer/profile/avatar', data: formData);
    return response.data['data']['avatar_url'] as String? ?? '';
  }

  Future<void> deleteAvatar() async {
    await apiClient.delete('/customer/profile/avatar');
  }
}
