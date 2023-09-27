part of 'stocktaking_cubit.dart';

class StocktakingEntry extends Equatable {
  final int productId;
  final int stockQuantity;
  const StocktakingEntry(this.productId, this.stockQuantity);

  StocktakingEntry.fromJson(Map<String, dynamic> json)
      : this(
          json['productId'] as int,
          json['stockQuantity'] as int,
        );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'stockQuantity': stockQuantity,
      };

  @override
  List<Object?> get props => [productId, stockQuantity];
}

final class StocktakingState extends Equatable {
  final List<StocktakingEntry> entries;
  final int scannedBarcode;
  final int scannedProductId;
  final StockQuantityForm stockQuantityForm;
  final bool isStockQuantityValid;
  final FormzSubmissionStatus submissionStatus;

  bool get isScannedBarcodeUnknown => scannedProductId == -1;
  bool get isEntryAlreadyAdded => alreadyAddedEntry != null;
  bool get isReadyForSubmission => entries.isNotEmpty;

  StocktakingEntry? get alreadyAddedEntry => getAlreadyAddedEntry(scannedProductId);
  StocktakingEntry? getAlreadyAddedEntry(int productId) => entries.firstWhereOrNull((e) => e.productId == productId);
  StocktakingEntry get entry => StocktakingEntry(scannedProductId, stockQuantityForm.intValue);

  const StocktakingState({
    this.entries = const [],
    this.scannedBarcode = -1,
    this.scannedProductId = -1,
    this.stockQuantityForm = const StockQuantityForm.pure(),
    this.isStockQuantityValid = false,
    this.submissionStatus = FormzSubmissionStatus.initial,
  });

  StocktakingState copyWith({
    List<StocktakingEntry>? entries,
    int? scannedBarcode,
    int? scannedProductId,
    StockQuantityForm? stockQuantityForm,
    bool? isStockQuantityValid,
    FormzSubmissionStatus? submissionStatus,
  }) {
    return StocktakingState(
      entries: entries ?? this.entries,
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,
      scannedProductId: scannedProductId ?? this.scannedProductId,
      stockQuantityForm: stockQuantityForm ?? this.stockQuantityForm,
      isStockQuantityValid: isStockQuantityValid ?? this.isStockQuantityValid,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        entries,
        scannedBarcode,
        scannedProductId,
        stockQuantityForm,
        isStockQuantityValid,
        submissionStatus,
      ];
}
