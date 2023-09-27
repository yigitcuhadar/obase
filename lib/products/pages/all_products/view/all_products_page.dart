import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/constants/app_contants.dart';
import 'package:obase_barcode/products/cubit/products_cubit.dart';
import 'package:obase_barcode/products/widgets/delete_product_dialog.dart';

import '../../product_add_edit/view/product_add_edit_page.dart';
import '../../product_preview/view/product_preview_page.dart';

class AllProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AllProductsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Products'),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AllProductsFAB extends StatelessWidget {
  const AllProductsFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProductAddEditPage())),
    );
  }
}

class AllProductBody extends StatelessWidget {
  const AllProductBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        switch (state.status) {
          case ProductsStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProductsStatus.success:
            return const _ProductList();
          case ProductsStatus.failure:
            return const Center(child: Icon(Icons.error));
        }
      },
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (p, c) => p.products != c.products,
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: AppConstants.pagePadding,
                itemCount: state.products.length,
                itemBuilder: (context, item) {
                  Product product = state.products[item];
                  return _buildProductItem(context, product);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Slidable _buildProductItem(BuildContext context, Product product) {
    return Slidable(
      key: Key('${product.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (context) async {
              await showDialog(
                context: context,
                builder: (context) => DeleteProductDialog(productId: product.id),
              );
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(product.name, overflow: TextOverflow.ellipsis, maxLines: 1),
        subtitle: Text(product.description, overflow: TextOverflow.ellipsis, maxLines: 1),
        leading: CachedNetworkImage(
          imageUrl: product.photoUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        trailing: Text('${product.stockQuantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPreviewPage(product: product))),
      ),
    );
  }
}
