import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../../../addresses/domain/entities/address_entity.dart';

class DeliveryFeeState {
  final double? fee;
  final bool isLoading;
  final String? error;

  const DeliveryFeeState({this.fee, this.isLoading = false, this.error});

  DeliveryFeeState copyWith({
    double? fee,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearFee = false,
  }) {
    return DeliveryFeeState(
      fee: clearFee ? null : (fee ?? this.fee),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class DeliveryFeeNotifier extends StateNotifier<DeliveryFeeState> {
  final ApiClient apiClient;

  DeliveryFeeNotifier({required this.apiClient})
      : super(const DeliveryFeeState());

  Future<void> estimateDeliveryFee({required AddressEntity address}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await apiClient.post(
        '/customer/delivery/estimate',
        data: {
          'latitude': address.latitude,
          'longitude': address.longitude,
          'address': address.address,
          if (address.city != null) 'city': address.city,
        },
      );
      final fee = (response.data['data']?['fee'] as num?)?.toDouble() ?? 0.0;
      state = state.copyWith(fee: fee, isLoading: false);
    } catch (e) {
      AppLogger.error('Failed to estimate delivery fee', error: e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const DeliveryFeeState();
  }
}
