import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/providers.dart';
import 'notifications_notifier.dart';
import 'notifications_state.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationsNotifier(apiClient: apiClient);
});

/// Provider qui expose le nombre de notifications non lues
final unreadCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationsProvider);
  return state.unreadCount;
});
