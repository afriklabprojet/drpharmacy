import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/addresses_notifier.dart';
import '../providers/addresses_provider.dart';
import '../../domain/entities/address_entity.dart';

class AddressesListPage extends ConsumerStatefulWidget {
  final bool selectionMode;

  const AddressesListPage({super.key, this.selectionMode = false});

  @override
  ConsumerState<AddressesListPage> createState() => _AddressesListPageState();
}

class _AddressesListPageState extends ConsumerState<AddressesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressesProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'Choisir une adresse' : 'Mes adresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/addresses/add'),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AddressesState state) {
    if (state.isLoading && state.addresses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erreur'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(addressesProvider.notifier).loadAddresses(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    if (state.addresses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucune adresse enregistrée', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(addressesProvider.notifier).loadAddresses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.addresses.length,
        itemBuilder: (context, index) {
          final address = state.addresses[index];
          return _AddressCard(
            address: address,
            onTap: widget.selectionMode
                ? () => context.pop(address)
                : () => context.push('/addresses/${address.id}/edit', extra: address),
            onDefault: () => ref.read(addressesProvider.notifier).setDefaultAddress(address.id),
            onDelete: () => ref.read(addressesProvider.notifier).deleteAddress(address.id),
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onTap;
  final VoidCallback onDefault;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onTap,
    required this.onDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          address.isDefault ? Icons.location_on : Icons.location_on_outlined,
          color: address.isDefault ? AppColors.primary : Colors.grey,
        ),
        title: Text(address.label),
        subtitle: Text(address.address, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'default') onDefault();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            if (!address.isDefault)
              const PopupMenuItem(value: 'default', child: Text('Définir par défaut')),
            const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
