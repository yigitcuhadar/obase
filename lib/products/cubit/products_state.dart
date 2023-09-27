part of 'products_cubit.dart';

enum ProductsStatus { loading, success, failure }

final class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.loading,
    this.products = const [],
  });

  final ProductsStatus status;
  final List<Product> products;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, products];
}
