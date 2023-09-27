import 'dart:async';

import '../models/barcode.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getProduct(int id);
  Future<int> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> updateAllProducts(List<Product> products);
  Future<void> deleteProduct(int id);

  Future<Barcode?> getBarcode(int id);
  Future<void> addBarcode(int id, int productId);
  Future<void> deleteBarcode(int id);
}
