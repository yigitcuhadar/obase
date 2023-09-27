import 'package:equatable/equatable.dart';

class BarcodeEntity extends Equatable {
  final int id;
  final int productId;

  const BarcodeEntity(
    this.id,
    this.productId,
  );

  BarcodeEntity.fromJson(Map<String, dynamic> json)
      : this(
          json['id'] as int,
          json['productId'] as int,
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
      };

  BarcodeEntity copyWith({
    int? id,
    int? productId,
  }) {
    return BarcodeEntity(
      id ?? this.id,
      productId ?? this.productId,
    );
  }

  @override
  List<Object?> get props => [id, productId];
}
