import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address_entity.dart';

/// Repository pour les adresses
abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, AddressEntity>> getAddress(int id);
  Future<Either<Failure, AddressEntity>> createAddress(AddressEntity address);
  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address);
  Future<Either<Failure, void>> deleteAddress(int id);
  Future<Either<Failure, void>> setDefaultAddress(int id);
}
