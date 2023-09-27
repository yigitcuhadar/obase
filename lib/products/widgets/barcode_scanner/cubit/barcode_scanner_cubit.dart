import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ob_product/ob_product.dart';

import '../view/barcode_scanner_widget.dart';

part 'barcode_scanner_state.dart';

class BarcodeScannerCubit extends HydratedCubit<BarcodeScannerState> {
  final OnBarcodeScanned onScanned;
  final OnBarcodeSubmitted onSubmitted;
  BarcodeScannerCubit({
    required this.onScanned,
    required this.onSubmitted,
  }) : super(const BarcodeScannerState());

  @override
  BarcodeScannerState? fromJson(Map<String, dynamic> json) {
    return BarcodeScannerState(type: ScannerType.values[json['type'] as int]);
  }

  @override
  Map<String, dynamic>? toJson(BarcodeScannerState state) {
    return {'type': state.type.index};
  }

  void onTypeChanged(ScannerType value) {
    emit(state.copyWith(type: value));
  }

  void onStatusChanged(ScannerStatus value) {
    emit(state.copyWith(status: value));
  }

  void onBarcodeScanned(String value) async {
    int? barcode = int.tryParse(value);
    if (barcode != null) {
      emit(state.copyWith(isScanFree: false));
      await onScanned(barcode);
      emit(state.copyWith(isScanFree: true));
    }
  }

  void onBarcodeFormFieldChanged(String value) {
    value = value.replaceAll(' ', '');
    final BarcodeForm barcodeForm = BarcodeForm.dirty(value);
    emit(state.copyWith(
      barcodeForm: barcodeForm,
      isTypedBarcodeValid: Formz.validate([barcodeForm]),
    ));
  }

  void onBarcodeFormFieldSubmitted() async {
    if (state.isTypedBarcodeValid) {
      emit(state.copyWith(isScanFree: false));
      await onSubmitted(state.barcodeForm.intValue);
      emit(state.copyWith(
        isScanFree: true,
        barcodeForm: const BarcodeForm.pure(),
        isTypedBarcodeValid: false,
      ));
    }
  }
}
