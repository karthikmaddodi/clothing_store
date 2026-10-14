import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.isFavorite = false,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    bool? isFavorite,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        subtitle,
        description,
        price,
        imageUrl,
        category,
        rating,
        isFavorite,
      ];
}
