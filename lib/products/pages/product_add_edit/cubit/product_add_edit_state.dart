part of 'product_add_edit_cubit.dart';

class ProductAddEditState extends Equatable {
  final int? id;
  final ProductNameForm name;
  final ProductPhotoUrlForm photoUrl;
  final ProductDescriptionForm description;
  final StockQuantityForm stockQuantity;
  final List<int> barcodes;
  final bool isValid;
  final FormzSubmissionStatus productStatus;
  final FormzSubmissionStatus scannerStatus;
  final int scannedBarcode;
  final String scannerMessage;

  bool get isAddScreen => id == null;
  bool get isEditScreen => id != null;

  Product get toProduct => Product(
        id ?? -1,
        name.value,
        description.value,
        photoUrl.value,
        barcodes,
        stockQuantity.intValue,
      );

  const ProductAddEditState({
    this.id,
    this.name = const ProductNameForm.pure(),
    this.description = const ProductDescriptionForm.pure(),
    this.photoUrl = const ProductPhotoUrlForm.pure(),
    this.stockQuantity = const StockQuantityForm.pure(),
    this.barcodes = const [],
    this.isValid = false,
    this.productStatus = FormzSubmissionStatus.initial,
    this.scannerStatus = FormzSubmissionStatus.initial,
    this.scannedBarcode = -1,
    this.scannerMessage = '',
  });

  ProductAddEditState.fromProduct({
    required Product product,
  })  : id = product.id,
        name = ProductNameForm.dirty(product.name),
        description = ProductDescriptionForm.dirty(product.description),
        photoUrl = ProductPhotoUrlForm.dirty(product.photoUrl),
        stockQuantity = StockQuantityForm.dirty(product.stockQuantity.toString()),
        barcodes = product.barcodes,
        isValid = true,
        productStatus = FormzSubmissionStatus.initial,
        scannerStatus = FormzSubmissionStatus.initial,
        scannedBarcode = -1,
        scannerMessage = '';
  @override
  List<Object?> get props => [
        id,
        name,
        description,
        photoUrl,
        stockQuantity,
        barcodes,
        isValid,
        productStatus,
        scannerStatus,
        scannedBarcode,
        scannerMessage
      ];

  ProductAddEditState copyWith({
    int? id,
    ProductNameForm? name,
    ProductDescriptionForm? description,
    ProductPhotoUrlForm? photoUrl,
    StockQuantityForm? stockQuantity,
    List<int>? barcodes,
    bool? isValid,
    FormzSubmissionStatus? productStatus,
    FormzSubmissionStatus? scannerStatus,
    int? scannedBarcode,
    String? scannerMessage,
  }) {
    return ProductAddEditState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      barcodes: barcodes ?? this.barcodes,
      isValid: isValid ?? this.isValid,
      productStatus: productStatus ?? this.productStatus,
      scannerStatus: scannerStatus ?? this.scannerStatus,
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,
      scannerMessage: scannerMessage ?? this.scannerMessage,
    );
  }
}
