import 'package:flutter/foundation.dart';

/// Service de logging centralisé pour l'application
class AppLogger {
  AppLogger._();

  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('🔍 [DEBUG] $message');
      if (error != null) debugPrint('  Error: $error');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ [INFO] $message');
    }
  }

  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('⚠️ [WARN] $message');
      if (error != null) debugPrint('  Error: $error');
    }
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    debugPrint('❌ [ERROR] $message');
    if (error != null) debugPrint('  Error: $error');
    if (stackTrace != null && kDebugMode) {
      debugPrint('  StackTrace: $stackTrace');
    }
  }

  /// Log pour le tracking des événements analytics
  static void event(String eventName, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      debugPrint('📊 [EVENT] $eventName ${params ?? ''}');
    }
  }

  /// Log pour les appels API
  static void api(String method, String path, {int? statusCode, String? body}) {
    if (kDebugMode) {
      debugPrint('🌐 [API] $method $path → ${statusCode ?? '?'}');
    }
  }

  /// Log pour l'authentification
  static void auth(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('🔐 [AUTH] $message');
      if (error != null) debugPrint('  Error: $error');
    }
  }

  /// Log pour la géolocalisation
  static void location(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('📍 [LOCATION] $message');
      if (error != null) debugPrint('  Error: $error');
    }
  }
}
