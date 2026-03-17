import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class UploadAvatarUseCase {
  final dynamic repository;
  UploadAvatarUseCase(this.repository);

  Future<Either<Failure, String>> call(Uint8List imageBytes) async {
    return await repository.uploadAvatar(imageBytes);
  }
}
