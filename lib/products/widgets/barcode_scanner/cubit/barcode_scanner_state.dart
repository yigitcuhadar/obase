part of 'barcode_scanner_cubit.dart';

enum ScannerStatus { closed, opened }

enum ScannerType { manual, camera, laser }

class BarcodeScannerState extends Equatable {
  final ScannerType type;
  final ScannerStatus status;
  final bool isScanFree;
  final BarcodeForm barcodeForm;
  final bool isTypedBarcodeValid;

  const BarcodeScannerState({
    this.type = ScannerType.camera,
    this.status = ScannerStatus.closed,
    this.isScanFree = true,
    this.barcodeForm = const BarcodeForm.pure(),
    this.isTypedBarcodeValid = false,
  });

  BarcodeScannerState copyWith({
    ScannerType? type,
    ScannerStatus? status,
    bool? isScanFree,
    BarcodeForm? barcodeForm,
    bool? isTypedBarcodeValid,
  }) {
    return BarcodeScannerState(
      type: type ?? this.type,
      status: status ?? this.status,
      isScanFree: isScanFree ?? this.isScanFree,
      barcodeForm: barcodeForm ?? this.barcodeForm,
      isTypedBarcodeValid: isTypedBarcodeValid ?? this.isTypedBarcodeValid,
    );
  }

  @override
  List<Object> get props => [type, status, isScanFree, barcodeForm, isTypedBarcodeValid];
}
