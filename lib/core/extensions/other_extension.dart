import 'package:flutter/material.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

import '../../products/pages/product_add_edit/cubit/product_add_edit_cubit.dart';

extension AddEditScannerStatusExtension on AddEditScannerStatus {
  Color get toColor {
    switch (this) {
      case AddEditScannerStatus.initial:
      case AddEditScannerStatus.scanned:
        return Colors.black;
      case AddEditScannerStatus.alreadyInProduct:
      case AddEditScannerStatus.alreadyInUse:
      case AddEditScannerStatus.failure:
        return Colors.red.shade900;
      case AddEditScannerStatus.success:
        return Colors.green.shade900;
    }
  }

  String get toMessage {
    switch (this) {
      case AddEditScannerStatus.initial:
        return LocaleKeys.add_edit_product_barcode_message_initial.locale;
      case AddEditScannerStatus.scanned:
        return LocaleKeys.add_edit_product_barcode_message_scanned.locale;
      case AddEditScannerStatus.alreadyInProduct:
        return LocaleKeys.add_edit_product_barcode_message_alreadyInProduct.locale;
      case AddEditScannerStatus.alreadyInUse:
        return LocaleKeys.add_edit_product_barcode_message_alreadyInUse.locale;
      case AddEditScannerStatus.failure:
        return LocaleKeys.add_edit_product_barcode_message_failure.locale;
      case AddEditScannerStatus.success:
        return LocaleKeys.add_edit_product_barcode_message_success.locale;
    }
  }
}
