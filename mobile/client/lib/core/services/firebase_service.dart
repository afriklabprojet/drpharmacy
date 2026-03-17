import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'app_logger.dart';

/// Background message handler — doit être top-level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.debug('[Firebase] Background message: ${message.messageId}');
}

/// Service pour l'initialisation et la gestion de Firebase
class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      AppLogger.info('Firebase initialized successfully');
    } catch (e) {
      AppLogger.error('Firebase initialization failed', error: e);
    }
  }

  /// Configure Firebase Messaging (notifications push)
  static Future<void> configureMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.info('FCM permission granted');

        // Get token
        final token = await messaging.getToken();
        if (kDebugMode) {
          AppLogger.debug('FCM Token: $token');
        }
      }
    } catch (e) {
      AppLogger.error('FCM configuration failed', error: e);
    }
  }
}
