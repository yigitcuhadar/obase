import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ob_product/ob_product.dart';

import '../../../cubit/products_cubit.dart';

part 'product_add_edit_state.dart';

class ProductAddEditCubit extends Cubit<ProductAddEditState> {
  final ProductsCubit productsCubit;
  final Product? defaultProduct;
  final List<int>? defaultBarcodes;
  ProductAddEditCubit({
    required this.productsCubit,
    this.defaultProduct,
    this.defaultBarcodes,
  }) : super(
          defaultProduct == null
              ? ProductAddEditState(barcodes: defaultBarcodes ?? [])
              : ProductAddEditState.fromProduct(
                  product: defaultProduct,
                ),
        );

  bool get isChanged =>
      defaultProduct != null && state.toProduct.copyWith(barcodes: []) != defaultProduct!.copyWith(barcodes: []);

  void onNameChanged(String value) {
    final name = ProductNameForm.dirty(value);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name, state.description, state.photoUrl, state.stockQuantity]),
      ),
    );
  }

  void onDescriptionChanged(String value) {
    final description = ProductDescriptionForm.dirty(value);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate([state.name, description, state.photoUrl, state.stockQuantity]),
      ),
    );
  }

  void onPhotoUrlChanged(String value) {
    final photoUrl = ProductPhotoUrlForm.dirty(value);
    emit(
      state.copyWith(
        photoUrl: photoUrl,
        isValid: Formz.validate([state.name, state.description, photoUrl, state.stockQuantity]),
      ),
    );
  }

  void onStockQuantityChanged(String value) {
    final StockQuantityForm stockQuantity;
    final int? parse = int.tryParse(value);
    if (parse != null) {
      stockQuantity = StockQuantityForm.dirty(value);
    } else {
      stockQuantity = const StockQuantityForm.dirty('');
    }
    emit(
      state.copyWith(
        stockQuantity: stockQuantity,
        isValid: Formz.validate([state.name, state.description, state.photoUrl, stockQuantity]),
      ),
    );
  }

  void onBarcodeScanned(int value) {
    if (value != state.scannedBarcode) {
      emit(state.copyWith(
        scannedBarcode: value,
        scannerStatus: ProductAddEditScannerStatus.initial,
      ));
    }
  }

  void onBarcodeAdded() async {
    final int scannedBarcode = state.scannedBarcode;
    if (state.barcodes.contains(scannedBarcode)) {
      emit(state.copyWith(
        scannedBarcode: -1,
        scannerStatus: ProductAddEditScannerStatus.alreadyInProduct,
      ));
      return;
    }
    try {
      Barcode? barcode = await productsCubit.getBarcode(scannedBarcode);
      if (barcode != null) {
        emit(state.copyWith(
          scannedBarcode: -1,
          scannerStatus: ProductAddEditScannerStatus.alreadyInUse,
        ));
        return;
      }
      if (state.isEditScreen) {
        await productsCubit.addBarcode(scannedBarcode, state.id!);
      }
    } catch (_) {
      emit(state.copyWith(
        scannedBarcode: -1,
        scannerStatus: ProductAddEditScannerStatus.failure,
      ));
      return;
    }
    List<int> barcodes = List<int>.from(state.barcodes);
    barcodes.add(scannedBarcode);
    emit(state.copyWith(
      barcodes: barcodes,
      scannedBarcode: -1,
      scannerStatus: ProductAddEditScannerStatus.success,
    ));
  }

  Future<void> onBarcodeDeleted(int value) async {
    if (state.isEditScreen) await productsCubit.deleteBarcode(value, state.id!);
    List<int> barcodes = List<int>.from(state.barcodes);
    barcodes.remove(value);
    emit(state.copyWith(barcodes: barcodes));
  }

  Future<void> onSubmitted() async {
    final Product product = state.toProduct;
    if (state.isValid) {
      if (state.isEditScreen) {
        emit(state.copyWith(productStatus: FormzSubmissionStatus.inProgress));
        try {
          await productsCubit.updateProduct(product);
          emit(state.copyWith(productStatus: FormzSubmissionStatus.success));
        } catch (_) {
          emit(state.copyWith(productStatus: FormzSubmissionStatus.failure));
          rethrow;
        }
      } else {
        try {
          int id = await productsCubit.addProduct(product.copyWith(barcodes: []));
          for (int barcode in state.barcodes) {
            await productsCubit.addBarcode(barcode, id);
          }
          emit(state.copyWith(productStatus: FormzSubmissionStatus.success));
        } catch (_) {
          emit(state.copyWith(productStatus: FormzSubmissionStatus.failure));
          rethrow;
        }
      }
    }
  }
}
