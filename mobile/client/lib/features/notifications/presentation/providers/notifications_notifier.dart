import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/app_logger.dart';
import '../../data/models/notification_model.dart';
import '../../domain/entities/notification_entity.dart';
import 'notifications_state.dart';

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final ApiClient apiClient;

  NotificationsNotifier({required this.apiClient})
      : super(const NotificationsState());

  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationsStatus.loading);
    try {
      final response = await apiClient.get('/customer/notifications');
      final List<dynamic> data = response.data['data'] ?? [];
      final notifications = data
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>)
                  .toEntity())
          .toList();
      state = state.copyWith(
        status: NotificationsStatus.loaded,
        notifications: notifications,
      );
    } catch (e) {
      AppLogger.error('Failed to load notifications', error: e);
      state = state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await apiClient.post('/customer/notifications/$notificationId/read');
      final updated = state.notifications.map((n) {
        if (n.id == notificationId) {
          return NotificationEntity(
            id: n.id,
            type: n.type,
            title: n.title,
            body: n.body,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      state = state.copyWith(notifications: updated);
    } catch (e) {
      AppLogger.error('Failed to mark notification as read', error: e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await apiClient.post('/customer/notifications/read-all');
      final updated = state.notifications
          .map((n) => NotificationEntity(
                id: n.id,
                type: n.type,
                title: n.title,
                body: n.body,
                data: n.data,
                isRead: true,
                createdAt: n.createdAt,
              ))
          .toList();
      state = state.copyWith(notifications: updated);
    } catch (e) {
      AppLogger.error('Failed to mark all notifications as read', error: e);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await apiClient.delete('/customer/notifications/$notificationId');
      final updated =
          state.notifications.where((n) => n.id != notificationId).toList();
      state = state.copyWith(notifications: updated);
    } catch (e) {
      AppLogger.error('Failed to delete notification', error: e);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
