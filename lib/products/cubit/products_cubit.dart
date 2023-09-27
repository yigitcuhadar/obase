import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ob_product/ob_product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _repository;
  ProductsCubit({required ProductRepository repository})
      : _repository = repository,
        super(const ProductsState());

  Future<void> requestProducts() async {
    try {
      emit(state.copyWith(status: ProductsStatus.loading));
      final List<Product> products = await _repository.getAll();
      emit(state.copyWith(status: ProductsStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(status: ProductsStatus.failure));
    }
  }

  Future<Product?> getProduct(int id) async {
    final Product? product = await _repository.getProduct(id);
    return product;
  }

  Future<Product?> getProductByBarcode(int id) async {
    final Barcode? barcode = await getBarcode(id);
    if (barcode != null) {
      final Product? product = await _repository.getProduct(barcode.productId);
      return product;
    }
    return null;
  }

  Future<int> addProduct(Product product) async {
    final int id = await _repository.addProduct(product);
    final Product addedProduct = product.copyWith(id: id);
    List<Product> products = List<Product>.from(state.products);
    products.add(addedProduct);
    emit(state.copyWith(products: products));
    return id;
  }

  Future<void> updateAll(List<Product> newProducts) async {
    await _repository.updateAllProducts(newProducts);
    List<Product> oldProducts = List<Product>.from(state.products);
    for (int i = 0; i < oldProducts.length; i++) {
      for (Product newProduct in newProducts) {
        if (oldProducts[i].id == newProduct.id) {
          oldProducts[i] = newProduct;
          break;
        }
      }
    }
    emit(state.copyWith(products: oldProducts));
  }

  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product);
    List<Product> products = List<Product>.from(state.products);
    products[products.indexWhere((element) => element.id == product.id)] = product;
    emit(state.copyWith(products: products));
  }

  Future<void> deleteProduct(int productId) async {
    await _repository.deleteProduct(productId);
    List<Product> products = List<Product>.from(state.products);
    products.remove(products[products.indexWhere((element) => element.id == productId)]);
    emit(state.copyWith(products: products));
  }

  Future<Barcode?> getBarcode(int id) async {
    final Barcode? barcode = await _repository.getBarcode(id);
    return barcode;
  }

  Future<void> addBarcode(int id, int productId) async {
    await _repository.addBarcode(id, productId);
    List<Product> products = List<Product>.from(state.products);
    int index = products.indexWhere((element) => element.id == productId);
    products[index] = products[index].copyWith(barcodes: List<int>.from(products[index].barcodes)..add(id));
    emit(state.copyWith(products: products));
  }

  Future<void> deleteBarcode(int id, int productId) async {
    await _repository.deleteBarcode(id);
    List<Product> products = List<Product>.from(state.products);
    int index = products.indexWhere((element) => element.id == productId);
    products[index] = products[index].copyWith(barcodes: List<int>.from(products[index].barcodes)..remove(id));
    emit(state.copyWith(products: products));
  }
}
