import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/products/cubit/products_cubit.dart';
import 'package:obase_barcode/products/pages/product_add_edit/cubit/product_add_edit_cubit.dart';

import 'product_add_edit_view.dart';

class ProductAddEditPage extends StatelessWidget {
  final Product? defaultProduct;
  final List<int>? defaultBarcodes;
  const ProductAddEditPage({
    Key? key,
    this.defaultProduct,
    this.defaultBarcodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductAddEditCubit(
        defaultProduct: defaultProduct,
        productsCubit: context.read<ProductsCubit>(),
        defaultBarcodes: defaultBarcodes,
      ),
      child: const ProductAddEditView(),
    );
  }
}
