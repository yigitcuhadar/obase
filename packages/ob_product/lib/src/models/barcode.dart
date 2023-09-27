import 'package:equatable/equatable.dart';

class Barcode extends Equatable {
  final int id;
  final int productId;

  const Barcode(
    this.id,
    this.productId,
  );

  Barcode.fromJson(Map<String, dynamic> json)
      : this(
          json['id'] as int,
          json['productId'] as int,
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
      };

  Barcode copyWith({
    int? id,
    int? productId,
  }) {
    return Barcode(
      id ?? this.id,
      productId ?? this.productId,
    );
  }

  @override
  List<Object?> get props => [id, productId];
}
