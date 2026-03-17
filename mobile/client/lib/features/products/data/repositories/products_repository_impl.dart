import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/app_logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int perPage = 20}) async {
    try {
      final models = await remoteDataSource.getProducts(page: page, perPage: perPage);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProductsRepository.getProducts failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(int productId) async {
    try {
      final model = await remoteDataSource.getProductDetails(productId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProductsRepository.getProductDetails failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query, {int page = 1}) async {
    try {
      final models = await remoteDataSource.searchProducts(query, page: page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProductsRepository.searchProducts failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(int categoryId, {int page = 1}) async {
    try {
      final models = await remoteDataSource.getProductsByCategory(categoryId, page: page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('ProductsRepository.getProductsByCategory failed', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
