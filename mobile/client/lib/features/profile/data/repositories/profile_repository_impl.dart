import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/app_logger.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/update_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProfileRepository.getProfile failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UpdateProfileEntity updateProfile) async {
    try {
      final data = <String, dynamic>{};
      if (updateProfile.name != null) data['name'] = updateProfile.name;
      if (updateProfile.email != null) data['email'] = updateProfile.email;
      if (updateProfile.phone != null) data['phone'] = updateProfile.phone;
      if (updateProfile.address != null) data['address'] = updateProfile.address;

      final model = await remoteDataSource.updateProfile(data);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProfileRepository.updateProfile failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(Uint8List imageBytes) async {
    try {
      final url = await remoteDataSource.uploadAvatar(imageBytes);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProfileRepository.uploadAvatar failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar() async {
    try {
      await remoteDataSource.deleteAvatar();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProfileRepository.deleteAvatar failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
