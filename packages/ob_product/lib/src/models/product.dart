import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String photoUrl;
  final List<int> barcodes;
  final int stockQuantity;

  const Product(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.barcodes,
    this.stockQuantity,
  );

  const Product.empty() : this(-1, '', '', '', const [], -1);

  bool get isEmpty => this == const Product.empty();
  bool get isNotEmpty => !isEmpty;

  Product.fromJson(Map<String, dynamic> json)
      : this(
          json['id'] as int,
          json['name'] as String,
          json['description'] as String,
          json['photoUrl'] as String,
          json['barcodes'] != null ? (json['barcodes'] as String).split('/').map((e) => int.parse(e)).toList() : [],
          json['stockQuantity'] as int,
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'photoUrl': photoUrl,
        'barcodes': barcodes.join('/'),
        'stockQuantity': stockQuantity,
      };

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? photoUrl,
    List<int>? barcodes,
    int? stockQuantity,
  }) {
    return Product(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      photoUrl ?? this.photoUrl,
      barcodes ?? this.barcodes,
      stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  List<Object?> get props => [id, name, description, photoUrl, barcodes, stockQuantity];
}
