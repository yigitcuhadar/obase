import 'package:flutter/material.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

import '../../products/pages/product_add_edit/cubit/product_add_edit_cubit.dart';

extension AddEditScannerStatusExtension on ProductAddEditScannerStatus {
  Color get toColor {
    switch (this) {
      case ProductAddEditScannerStatus.initial:
      case ProductAddEditScannerStatus.scanned:
        return Colors.black;
      case ProductAddEditScannerStatus.alreadyInProduct:
      case ProductAddEditScannerStatus.alreadyInUse:
      case ProductAddEditScannerStatus.failure:
        return Colors.red.shade900;
      case ProductAddEditScannerStatus.success:
        return Colors.green.shade900;
    }
  }

  String get toMessage {
    switch (this) {
      case ProductAddEditScannerStatus.initial:
        return LocaleKeys.add_edit_product_barcode_message_initial.locale;
      case ProductAddEditScannerStatus.scanned:
        return LocaleKeys.add_edit_product_barcode_message_scanned.locale;
      case ProductAddEditScannerStatus.alreadyInProduct:
        return LocaleKeys.add_edit_product_barcode_message_alreadyInProduct.locale;
      case ProductAddEditScannerStatus.alreadyInUse:
        return LocaleKeys.add_edit_product_barcode_message_alreadyInUse.locale;
      case ProductAddEditScannerStatus.failure:
        return LocaleKeys.add_edit_product_barcode_message_failure.locale;
      case ProductAddEditScannerStatus.success:
        return LocaleKeys.add_edit_product_barcode_message_success.locale;
    }
  }
}
