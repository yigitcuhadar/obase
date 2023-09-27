import 'dart:math';

import 'package:barcode/barcode.dart' as brc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/extensions/form_extension.dart';
import 'package:obase_barcode/core/extensions/other_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';
import 'package:obase_barcode/products/widgets/delete_product_dialog.dart';

import '../../../../core/constants/app_contants.dart';
import '../../../widgets/barcode_scanner/view/barcode_scanner_widget.dart';
import '../cubit/product_add_edit_cubit.dart';

class ProductAddEditView extends StatelessWidget {
  const ProductAddEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductAddEditCubit, ProductAddEditState>(
      listenWhen: (p, c) => p.productStatus != c.productStatus,
      listener: (context, state) {
        if (state.productStatus.isFailure || state.productStatus.isSuccess) {
          String message;
          if (state.productStatus.isFailure) {
            message = state.isAddScreen
                ? LocaleKeys.add_edit_product_message_failure_add.locale
                : LocaleKeys.add_edit_product_message_failure_edit.locale;
          } else {
            message = state.isAddScreen
                ? LocaleKeys.add_edit_product_message_success_add.locale
                : LocaleKeys.add_edit_product_message_success_edit.locale;
          }
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: const _AppBar(),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: const SingleChildScrollView(
                padding: AppConstants.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NameField(),
                    AppConstants.itemSeperator,
                    _DescriptionField(),
                    AppConstants.itemSeperator,
                    _PhotoUrlField(),
                    AppConstants.itemSeperator,
                    _StockQuantityField(),
                    AppConstants.itemSeperator,
                    _BarcodeList(),
                    AppConstants.itemSeperator,
                    _BarcodeScanner(),
                    AppConstants.itemSeperator,
                    _SubmitButton(),
                    _DeleteButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (context.read<ProductAddEditCubit>().isChanged && !context.read<ProductAddEditCubit>().state.productStatus.isSuccess) {
      bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => _buildDialog(context),
      );
      return result ?? false;
    }
    return true;
  }

  AlertDialog _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_unsaved_changes_title.locale),
      content: Text(LocaleKeys.dialog_unsaved_changes_content.locale),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(LocaleKeys.dialog_unsaved_changes_no.locale),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(LocaleKeys.dialog_unsaved_changes_yes.locale),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      builder: (context, state) {
        return AppBar(
          title: state.isAddScreen
              ? Text(LocaleKeys.add_edit_product_title_add.locale)
              : Text(LocaleKeys.add_edit_product_title_edit.locale),
          centerTitle: true,
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.name != c.name,
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            icon: const Icon(Icons.abc),
            labelText: LocaleKeys.form_product_name_label.locale,
            errorText: state.name.errorText,
            errorMaxLines: 2,
          ),
          initialValue: state.name.value,
          textInputAction: TextInputAction.next,
          onChanged: (value) => context.read<ProductAddEditCubit>().onNameChanged(value),
        );
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.description != c.description,
      builder: (context, state) {
        return TextFormField(
          maxLines: null,
          decoration: InputDecoration(
            icon: const Icon(Icons.abc),
            labelText: LocaleKeys.form_product_description_label.locale,
            errorText: state.description.errorText,
            errorMaxLines: 2,
          ),
          initialValue: state.description.value,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
          onChanged: (value) => context.read<ProductAddEditCubit>().onDescriptionChanged(value),
        );
      },
    );
  }
}

class _PhotoUrlField extends StatelessWidget {
  const _PhotoUrlField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.photoUrl != c.photoUrl,
      builder: (context, state) {
        return TextFormField(
          maxLines: null,
          decoration: InputDecoration(
            icon: const Icon(Icons.link),
            labelText: LocaleKeys.form_product_photo_url_label.locale,
            errorText: state.photoUrl.errorText,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          initialValue: state.photoUrl.value,
          onChanged: (value) => context.read<ProductAddEditCubit>().onPhotoUrlChanged(value),
        );
      },
    );
  }
}

class _StockQuantityField extends StatelessWidget {
  const _StockQuantityField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.stockQuantity != c.stockQuantity,
      builder: (context, state) {
        return TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            icon: const Icon(Icons.numbers),
            labelText: LocaleKeys.form_stock_quantity_label.locale,
            errorText: state.stockQuantity.errorText,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          initialValue: state.stockQuantity.value,
          onChanged: (value) => context.read<ProductAddEditCubit>().onStockQuantityChanged(value),
        );
      },
    );
  }
}

class _BarcodeList extends StatelessWidget {
  const _BarcodeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.barcodes != c.barcodes,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.add_edit_product_title_barcodes.locale,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            AppConstants.halfItemSeperator,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.barcodes.map((e) => _buildBarcode(context, e)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBarcode(BuildContext context, int barcode) {
    brc.Barcode bc = brc.Barcode.ean13(drawEndChar: true);
    final svg = bc.toSvg('$barcode', height: 100);
    return Column(
      children: [
        SvgPicture.string(svg),
        IconButton(
          onPressed: () => context.read<ProductAddEditCubit>().onBarcodeDeleted(barcode),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }
}

class _BarcodeScanner extends StatelessWidget {
  const _BarcodeScanner();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.scannerStatus != c.scannerStatus,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(border: Border.all(color: state.scannerStatus.toColor)),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  BarcodeScannerWidget(
                    onScanned: (value) async => context.read<ProductAddEditCubit>().onBarcodeScanned(value),
                    onSubmitted: (value) async {
                      context.read<ProductAddEditCubit>().onBarcodeScanned(value);
                      context.read<ProductAddEditCubit>().onBarcodeAdded();
                    },
                  ),
                  const _AddBarcodeButton(),
                ],
              ),
              const _ScannerMessagePanel(),
            ],
          ),
        );
      },
    );
  }
}

class _AddBarcodeButton extends StatelessWidget {
  const _AddBarcodeButton();

  Color get _randomColor {
    final int random = Random().nextInt(Colors.primaries.length);
    return Colors.primaries[random];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.scannedBarcode != c.scannedBarcode,
      builder: (context, state) {
        if (state.scannedBarcode != -1) {
          return ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(_randomColor.withAlpha(128))),
            onPressed: () => context.read<ProductAddEditCubit>().onBarcodeAdded(),
            child: Text('Add ${state.scannedBarcode}'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _ScannerMessagePanel extends StatelessWidget {
  const _ScannerMessagePanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.scannerStatus != c.scannerStatus,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
          child: Text(
            state.scannerStatus.toMessage,
            style: TextStyle(color: state.scannerStatus.toColor, fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      buildWhen: (p, c) => p.isValid != c.isValid,
      builder: (context, state) {
        final String buttonTitle = state.isAddScreen ? 'Add' : 'Update';
        return ElevatedButton(
          onPressed: state.isValid
              ? () async {
                  await context.read<ProductAddEditCubit>().onSubmitted();
                  if (context.mounted) Navigator.of(context).maybePop();
                }
              : null,
          child: Text(buttonTitle),
        );
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductAddEditCubit, ProductAddEditState>(
      builder: (context, state) {
        if (state.isEditScreen) {
          return TextButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => DeleteProductDialog(productId: state.id!),
              );
              if (context.mounted) Navigator.of(context).maybePop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Container();
      },
    );
  }
}
