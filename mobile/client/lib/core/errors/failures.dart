import 'package:equatable/equatable.dart';

/// Classe de base pour les échecs (Failures) — couche Domain
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Échec serveur
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Échec réseau
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Erreur de connexion réseau'});
}

/// Échec de cache
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Erreur de cache'});
}

/// Échec de validation
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    required super.message,
    this.errors = const {},
  });

  @override
  List<Object?> get props => [message, errors];
}

/// Échec d'authentification (non autorisé)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Session expirée. Veuillez vous reconnecter.'});
}

/// Échec inconnu
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Erreur inattendue'});
}
