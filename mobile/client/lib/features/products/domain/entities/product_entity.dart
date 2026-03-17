import 'package:equatable/equatable.dart';
import 'pharmacy_entity.dart';
import 'category_entity.dart';

/// Entité Produit (couche Domain)
class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int stockQuantity;
  final String? manufacturer;
  final bool requiresPrescription;
  final PharmacyEntity pharmacy;
  final CategoryEntity? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.stockQuantity,
    this.manufacturer,
    required this.requiresPrescription,
    required this.pharmacy,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAvailable => stockQuantity > 0;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [id, name, price, stockQuantity, pharmacy.id];
}
