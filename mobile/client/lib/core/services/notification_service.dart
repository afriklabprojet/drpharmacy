import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'app_logger.dart';

/// Service de gestion des notifications push (FCM)
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialiser les notifications (permissions + token)
  Future<void> initNotifications() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      AppLogger.info('Notification permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        final token = await _messaging.getToken();
        if (token != null) {
          AppLogger.info('FCM Token obtained (${token.substring(0, 10)}...)');
          // TODO: Send token to backend
        }
      }
    } catch (e) {
      AppLogger.error('Failed to init notifications', error: e);
      if (kDebugMode) rethrow;
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      AppLogger.error('Failed to get FCM token', error: e);
      return null;
    }
  }
}
