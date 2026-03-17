import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _prescriptionUpdates = true;
  bool _deliveryAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Gérez vos préférences de notifications',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            title: const Text('Mises à jour des commandes'),
            subtitle: const Text('Recevez des notifications sur vos commandes'),
            value: _orderUpdates,
            onChanged: (v) => setState(() => _orderUpdates = v),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Promotions'),
            subtitle: const Text('Offres et réductions'),
            value: _promotions,
            onChanged: (v) => setState(() => _promotions = v),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Ordonnances'),
            subtitle: const Text('Statut de vos ordonnances'),
            value: _prescriptionUpdates,
            onChanged: (v) => setState(() => _prescriptionUpdates = v),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Alertes livraison'),
            subtitle: const Text('Suivi de livraison en temps réel'),
            value: _deliveryAlerts,
            onChanged: (v) => setState(() => _deliveryAlerts = v),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
