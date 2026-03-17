import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class DeleteAvatarUseCase {
  final dynamic repository;
  DeleteAvatarUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAvatar();
  }
}
