import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

class GetProfileUseCase {
  final dynamic repository;
  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getProfile();
  }
}
