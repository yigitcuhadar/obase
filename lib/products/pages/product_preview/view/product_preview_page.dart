import 'package:flutter/material.dart';
import 'package:ob_product/ob_product.dart';

import 'product_preview_view.dart';

class ProductPreviewPage extends StatelessWidget {
  final Product product;
  const ProductPreviewPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductPreviewView(product: product);
  }
}
