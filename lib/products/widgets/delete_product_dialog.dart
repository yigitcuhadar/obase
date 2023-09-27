import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';
import 'package:obase_barcode/products/cubit/products_cubit.dart';

class DeleteProductDialog extends StatelessWidget {
  final int productId;
  const DeleteProductDialog({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_delete_product_title.locale),
      content: Text(LocaleKeys.dialog_delete_product_content.locale),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(LocaleKeys.dialog_delete_product_no.locale)),
        TextButton(
          onPressed: () async {
            await context.read<ProductsCubit>().deleteProduct(productId);
            if (context.mounted) Navigator.of(context).maybePop();
          },
          child: Text(LocaleKeys.dialog_delete_product_yes.locale),
        ),
      ],
    );
  }
}
