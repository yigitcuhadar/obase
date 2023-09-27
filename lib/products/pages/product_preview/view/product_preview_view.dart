import 'package:barcode/barcode.dart' as bcd;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';
import '../../../../core/constants/app_contants.dart';
import '../../product_add_edit/view/product_add_edit_page.dart';

class ProductPreviewView extends StatelessWidget {
  final Product product;

  const ProductPreviewView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppConstants.itemSeperator,
              _ProductPhoto(photoUrl: product.photoUrl),
              AppConstants.itemSeperator,
              _ProductName(name: product.name),
              AppConstants.itemSeperator,
              _ProductDescription(description: product.description),
              AppConstants.itemSeperator,
              _ProductStockQuantity(stockQuantity: product.stockQuantity),
              AppConstants.itemSeperator,
              _BarcodeList(barcodes: product.barcodes),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(product.name),
      centerTitle: true,
      actions: [
        PopupMenuButton<int>(
          onSelected: (value) async {
            if (value == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProductAddEditPage(defaultProduct: product)),
              );
            }
          },
          itemBuilder: (context) {
            return [
              {'label': 'Edit', 'value': 0},
            ].map((choice) {
              return PopupMenuItem<int>(
                value: choice['value'] as int,
                child: Text(choice['label'] as String),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

class _ProductPhoto extends StatelessWidget {
  const _ProductPhoto({
    required this.photoUrl,
  });

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: CachedNetworkImage(
        imageUrl: photoUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

class _ProductName extends StatelessWidget {
  const _ProductName({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.product_preview_title_name.locale,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(name),
      ],
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription({
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.product_preview_title_description.locale,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(description),
      ],
    );
  }
}

class _ProductStockQuantity extends StatelessWidget {
  const _ProductStockQuantity({
    required this.stockQuantity,
  });

  final int stockQuantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.product_preview_title_stock_quantity.locale,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text('$stockQuantity'),
      ],
    );
  }
}

class _BarcodeList extends StatelessWidget {
  const _BarcodeList({
    required this.barcodes,
  });

  final List<int> barcodes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.product_preview_title_barcodes.locale,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        AppConstants.halfItemSeperator,
        ...barcodes.map((e) => _buildBarcode('$e')).toList(),
      ],
    );
  }

  Widget _buildBarcode(String data) {
    bcd.Barcode bc = bcd.Barcode.ean13(drawEndChar: true);
    final svg = bc.toSvg(data, width: 200, height: 80);
    return SvgPicture.string(svg);
  }
}
