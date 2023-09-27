import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formz/formz.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/extensions/form_extension.dart';
import 'package:obase_barcode/products/widgets/barcode_scanner/view/barcode_scanner_widget.dart';

import '../../../../core/constants/app_contants.dart';
import '../../../../core/lang/locale_keys.g.dart';
import '../../product_add_edit/view/product_add_edit_page.dart';
import '../cubit/stocktaking_cubit.dart';

class StocktakingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StocktakingAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(LocaleKeys.stocktaking_title.locale),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class StocktakingBody extends StatelessWidget {
  const StocktakingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<StocktakingCubit>().state;
    if (state.entries.isNotEmpty && state.copyWith(entries: []) == const StocktakingState()) {
      Future.delayed(
        Duration.zero,
        () => showDialog(context: context, builder: (context) => _buildOngoingDialog(context)),
      );
    }
    return BlocListener<StocktakingCubit, StocktakingState>(
      listenWhen: (p, c) =>
          p.submissionStatus != c.submissionStatus && (c.submissionStatus.isFailure || c.submissionStatus.isSuccess),
      listener: (context, state) {
        String message = state.submissionStatus.isSuccess
            ? LocaleKeys.stocktaking_message_success.locale
            : LocaleKeys.stocktaking_message_failure.locale;
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: const _StocktakingBody(),
    );
  }

  Widget _buildOngoingDialog(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_ongoing_stocktaking_title.locale),
      content: Text(LocaleKeys.dialog_ongoing_stocktaking_content.locale),
      actions: [
        TextButton(
          onPressed: () {
            context.read<StocktakingCubit>().onResetted();
            Navigator.of(context).maybePop();
          },
          child: Text(LocaleKeys.dialog_ongoing_stocktaking_no.locale),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(LocaleKeys.dialog_ongoing_stocktaking_yes.locale),
        ),
      ],
    );
  }
}

class _StocktakingBody extends StatelessWidget {
  const _StocktakingBody();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
            child: BarcodeScannerWidget(
              onScanned: (value) async {
                await context.read<StocktakingCubit>().onBarcodeScanned(value);
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return const _ScannedDialog();
                    },
                  );
                }
              },
              onSubmitted: (value) async {
                await context.read<StocktakingCubit>().onBarcodeScanned(value);
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return const _ScannedDialog();
                    },
                  );
                }
              },
            ),
          ),
          const _ProductList(),
          const _ResetButton(),
        ],
      ),
    );
  }
}

class StocktakingFAB extends StatelessWidget {
  const StocktakingFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StocktakingCubit, StocktakingState>(
      buildWhen: (p, c) => p.isReadyForSubmission != c.isReadyForSubmission || p.submissionStatus != c.submissionStatus,
      builder: (context, state) {
        if (state.isReadyForSubmission) {
          return FloatingActionButton(
            child: state.submissionStatus.isInProgress ? const CircularProgressIndicator() : const Icon(Icons.check),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _builCompletedDialog(context),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  AlertDialog _builCompletedDialog(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_complete_stocktaking_title.locale),
      content: Text(LocaleKeys.dialog_complete_stocktaking_content.locale),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(LocaleKeys.dialog_complete_stocktaking_no.locale),
        ),
        TextButton(
          onPressed: () => context.read<StocktakingCubit>().onSubmitted().then(
                (value) => Navigator.of(context).maybePop(),
              ),
          child: Text(LocaleKeys.dialog_complete_stocktaking_yes.locale),
        ),
      ],
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StocktakingCubit, StocktakingState>(
      buildWhen: (p, c) => p.entries != c.entries,
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            padding: AppConstants.pagePadding,
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final Product product = context.read<StocktakingCubit>().getProductFromEntry(state.entries[index]);
              return Slidable(
                key: Key('${product.id}'),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dragDismissible: false,
                  children: [
                    SlidableAction(
                      onPressed: (context) => context.read<StocktakingCubit>().onEntryDeleted(product.id),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ScannedDialog extends StatelessWidget {
  const _ScannedDialog();
  @override
  Widget build(BuildContext context) {
    final state = context.read<StocktakingCubit>().state;
    if (state.isScannedBarcodeUnknown) {
      return _buildUnkownDialog(context, state);
    } else {
      return _buildKnownDialog(context, state);
    }
  }

  AlertDialog _buildUnkownDialog(BuildContext context, StocktakingState state) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_stocktaking_unknown_title.locale),
      content: Text(LocaleKeys.dialog_stocktaking_unknown_content.locale),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(LocaleKeys.dialog_stocktaking_unknown_no.locale),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ProductAddEditPage(defaultBarcodes: [state.scannedBarcode])))
                .then((value) => Navigator.of(context).maybePop());
          },
          child: Text(LocaleKeys.dialog_stocktaking_unknown_yes.locale),
        ),
      ],
    );
  }

  AlertDialog _buildKnownDialog(BuildContext context, StocktakingState state) {
    final Product product = context.read<StocktakingCubit>().scannedProduct;
    return AlertDialog(
      title: state.isEntryAlreadyAdded
          ? Text(LocaleKeys.dialog_stocktaking_known_title_overwrite.localeWithArgs([product.name]))
          : Text(LocaleKeys.dialog_stocktaking_known_title_add.localeWithArgs([product.name])),
      icon: CachedNetworkImage(
        height: 50,
        width: 50,
        imageUrl: product.photoUrl,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          state.isEntryAlreadyAdded
              ? Text(LocaleKeys.dialog_stocktaking_known_content_overwrite.locale)
              : Text(LocaleKeys.dialog_stocktaking_known_content_add.locale),
          BlocBuilder<StocktakingCubit, StocktakingState>(
            buildWhen: (p, c) => p.stockQuantityForm != c.stockQuantityForm,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  autofocus: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.numbers),
                    labelText: LocaleKeys.form_stock_quantity_label.locale,
                    errorText: state.stockQuantityForm.errorText,
                    errorMaxLines: 2,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  initialValue: state.stockQuantityForm.value,
                  onChanged: (value) => context.read<StocktakingCubit>().onStockQuantityChanged(value),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: state.isEntryAlreadyAdded
              ? Text(LocaleKeys.dialog_stocktaking_known_no_overwrite.locale)
              : Text(LocaleKeys.dialog_stocktaking_known_no_add.locale),
        ),
        BlocBuilder<StocktakingCubit, StocktakingState>(
          builder: (context, state) {
            return TextButton(
              onPressed: state.isStockQuantityValid
                  ? () {
                      context.read<StocktakingCubit>().onEntryAdded();
                      Navigator.maybePop(context);
                    }
                  : null,
              child: state.isEntryAlreadyAdded
                  ? Text(LocaleKeys.dialog_stocktaking_known_yes_overwrite.locale)
                  : Text(LocaleKeys.dialog_stocktaking_known_yes_add.locale),
            );
          },
        ),
      ],
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StocktakingCubit, StocktakingState>(
      buildWhen: (p, c) => p.isReadyForSubmission != c.isReadyForSubmission,
      builder: (context, state) {
        if (state.isReadyForSubmission) {
          return TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildResetDialog(context),
              );
            },
            child: Text(
              LocaleKeys.stocktaking_reset_button.locale,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  AlertDialog _buildResetDialog(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialog_stocktaking_reset_title.locale),
      content: Text(LocaleKeys.dialog_stocktaking_reset_content.locale),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(LocaleKeys.dialog_stocktaking_reset_no.locale),
        ),
        TextButton(
          onPressed: () {
            context.read<StocktakingCubit>().onResetted();
            Navigator.of(context).maybePop();
          },
          child: Text(LocaleKeys.dialog_stocktaking_reset_yes.locale),
        ),
      ],
    );
  }
}
