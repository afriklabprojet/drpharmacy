import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/providers.dart';
import '../../data/datasources/address_remote_datasource.dart';
import 'addresses_notifier.dart';

final addressesProvider =
    StateNotifierProvider<AddressesNotifier, AddressesState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AddressesNotifier(
    remoteDataSource: AddressRemoteDataSource(apiClient),
  );
});

/// Provider pour les données de formulaire d'adresse (labels, téléphone par défaut)
final addressFormDataProvider = FutureProvider<AddressFormData>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final datasource = AddressRemoteDataSource(apiClient);
  return await datasource.getLabels();
});
