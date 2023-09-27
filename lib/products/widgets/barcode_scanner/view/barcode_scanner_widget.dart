import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obase_barcode/products/widgets/barcode_scanner/cubit/barcode_scanner_cubit.dart';

import 'barcode_scanner_view.dart';

typedef OnBarcodeScanned = Future<void> Function(int barcode);
typedef OnBarcodeSubmitted = Future<void> Function(int barcode);

class BarcodeScannerWidget extends StatelessWidget {
  final OnBarcodeScanned onScanned;
  final OnBarcodeSubmitted onSubmitted;

  const BarcodeScannerWidget({
    super.key,
    required this.onScanned,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeScannerCubit(
        onScanned: onScanned,
        onSubmitted: onSubmitted,
      ),
      child: const BarcodeScannerView(),
    );
  }
}
