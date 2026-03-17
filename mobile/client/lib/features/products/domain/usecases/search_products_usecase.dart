import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

class SearchProductsUseCase {
  final dynamic repository;
  SearchProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({required String query}) async {
    return await repository.searchProducts(query: query);
  }
}
