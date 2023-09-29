import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String photoUrl;
  final int stockQuantity;

  const ProductEntity(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.stockQuantity,
  );

  ProductEntity.fromJson(Map<String, dynamic> json)
      : this(
          json['id'] as int,
          json['name'] as String,
          json['description'] as String,
          json['photoUrl'] as String,
          json['stockQuantity'] as int,
        );

  ProductEntity.fromProduct(Product product)
      : this(
          product.id,
          product.name,
          product.description,
          product.photoUrl,
          product.stockQuantity,
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'photoUrl': photoUrl,
        'stockQuantity': stockQuantity,
      };

  ProductEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? photoUrl,
    int? stockQuantity,
  }) {
    return ProductEntity(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      photoUrl ?? this.photoUrl,
      stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  List<Object?> get props => [id, name, description, photoUrl, stockQuantity];
}
