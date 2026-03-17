import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../entities/update_profile_entity.dart';

class UpdateProfileUseCase {
  final dynamic repository;
  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UpdateProfileEntity updateProfile) async {
    return await repository.updateProfile(updateProfile);
  }
}
