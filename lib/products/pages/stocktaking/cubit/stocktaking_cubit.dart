import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ob_product/ob_product.dart';
import 'package:collection/collection.dart';

import '../../../cubit/products_cubit.dart';

part 'stocktaking_state.dart';

class StocktakingCubit extends HydratedCubit<StocktakingState> {
  final ProductsCubit productsCubit;
  StocktakingCubit({
    required this.productsCubit,
  }) : super(const StocktakingState());

  @override
  StocktakingState? fromJson(Map<String, dynamic> json) {
    return StocktakingState(
      entries: (json['entries'] as List<dynamic>).map((e) => StocktakingEntry.fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(StocktakingState state) {
    return {
      'entries': state.entries.map((e) => e.toJson()).toList(),
    };
  }

  Product get scannedProduct => _getProduct(state.scannedProductId);

  Product getProductFromEntry(StocktakingEntry entry) {
    return _getProduct(entry.productId).copyWith(stockQuantity: entry.stockQuantity);
  }

  Product _getProduct(int productId) => productsCubit.state.products.firstWhere((e) => e.id == productId);

  Future<void> onBarcodeScanned(int value) async {
    final Barcode? barcode = await productsCubit.getBarcode(value);
    final StocktakingEntry? alreadyAddedEntry = barcode != null ? state.getAlreadyAddedEntry(barcode.productId) : null;
    emit(state.copyWith(
      scannedBarcode: value,
      scannedProductId: barcode?.productId ?? -1,
      stockQuantityForm: alreadyAddedEntry != null
          ? StockQuantityForm.dirty('${alreadyAddedEntry.stockQuantity}')
          : const StockQuantityForm.pure(),
      isStockQuantityValid: alreadyAddedEntry != null,
    ));
  }

  void onStockQuantityChanged(String value) {
    final stockQuantityForm = StockQuantityForm.dirty(value);
    emit(state.copyWith(
      stockQuantityForm: stockQuantityForm,
      isStockQuantityValid: Formz.validate([stockQuantityForm]),
    ));
  }

  void onEntryAdded() {
    List<StocktakingEntry> entries = List<StocktakingEntry>.from(state.entries);
    final StocktakingEntry? alreadyAddedEntry = state.alreadyAddedEntry;
    if (alreadyAddedEntry != null) {
      entries.remove(alreadyAddedEntry);
    }
    entries.add(state.entry);
    emit(state.copyWith(entries: entries));
  }

  void onEntryDeleted(int productId) {
    List<StocktakingEntry> entries = List<StocktakingEntry>.from(state.entries);
    entries.remove(entries.firstWhere((e) => e.productId == productId));
    emit(state.copyWith(entries: entries));
  }

  void onResetted() {
    emit(const StocktakingState());
  }

  Future<void> onSubmitted() async {
    try {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
      List<Product> products =
          state.entries.map((e) => _getProduct(e.productId).copyWith(stockQuantity: e.stockQuantity)).toList();
      await productsCubit.updateAll(products);
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
      onResetted();
    } catch (e) {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.failure));
    }
  }
}
