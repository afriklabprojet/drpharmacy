import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../../domain/entities/pricing_entity.dart';
import '../../data/models/pricing_model.dart';

class PricingState {
  final PricingConfigEntity? config;
  final bool isLoading;
  final String? error;

  const PricingState({this.config, this.isLoading = false, this.error});

  PricingState copyWith({
    PricingConfigEntity? config,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PricingState(
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PricingNotifier extends StateNotifier<PricingState> {
  final ApiClient apiClient;

  PricingNotifier({required this.apiClient}) : super(const PricingState());

  Future<void> loadPricing() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await apiClient.get('/customer/pricing');
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data != null) {
        final model = PricingModel.fromJson(data);
        state = state.copyWith(
          config: model.toEntity(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      AppLogger.error('Failed to load pricing', error: e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
