import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formz/formz.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/products/pages/product_add_edit/view/product_add_edit_page.dart';

import '../../../../core/constants/app_contants.dart';
import '../../../widgets/barcode_scanner.dart';
import '../cubit/stocktaking_cubit.dart';

class StocktakingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StocktakingAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Stocktaking'),
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
    if (state.entries.isNotEmpty && state.scannedBarcode == -1) {
      Future.delayed(
        Duration.zero,
        () => showDialog(context: context, builder: (context) => _buildOngoingDialog(context)),
      );
    }
    return MultiBlocListener(
        listeners: [
          BlocListener<StocktakingCubit, StocktakingState>(
            listenWhen: (p, c) =>
                p.submissionStatus != c.submissionStatus && (c.submissionStatus.isFailure || c.submissionStatus.isSuccess),
            listener: (context, state) {
              String message = state.submissionStatus.isSuccess ? 'Stocktaking successfully completed!' : 'Stocktaking failed!';
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
            },
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
              child: BarcodeScanner(
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
              ),
            ),
            const _ProductList(),
            const _ResetButton(),
          ],
        ));
  }

  Widget _buildOngoingDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Ongoing Stocktaking'),
      content: const Text('There is a stocktaking in progress. Do you want to continue?'),
      actions: [
        TextButton(
            onPressed: () {
              context.read<StocktakingCubit>().onResetted();
              Navigator.of(context).maybePop();
            },
            child: const Text('No')),
        TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Yes')),
      ],
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
                builder: (context) => _buildDialog(context),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete Stocktaking'),
      content: const Text(
          'Do you want to complete stocktaking? This transaction cannot be undone, stock quantities will be recorded.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('No')),
        TextButton(
          onPressed: () => context.read<StocktakingCubit>().onSubmitted().then(
                (value) => Navigator.of(context).maybePop(),
              ),
          child: const Text('Yes'),
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
      return _buildUnkown(context, state);
    } else {
      return _buildKnown(context, state);
    }
  }

  AlertDialog _buildKnown(BuildContext context, StocktakingState state) {
    final Product product = context.read<StocktakingCubit>().scannedProduct;
    return AlertDialog(
      title: state.isEntryAlreadyAdded ? Text('Override Stock\n${product.name}') : Text('Add Stock\n${product.name}'),
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
              ? const Text('The product has already been added. You will overwrite the stock quantity.')
              : const Text('Enter the stock quantity for the product.'),
          BlocBuilder<StocktakingCubit, StocktakingState>(
            buildWhen: (p, c) => p.stockQuantityForm != c.stockQuantityForm,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  autofocus: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Stock Quantity',
                    errorText: state.stockQuantityForm.displayError != null ? 'invalid stock quantity' : null,
                  ),
                  initialValue: state.stockQuantityForm.value,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => context.read<StocktakingCubit>().onStockQuantityChanged(value),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Cancel')),
        BlocBuilder<StocktakingCubit, StocktakingState>(
          builder: (context, state) {
            return TextButton(
              onPressed: state.isStockQuantityValid
                  ? () {
                      context.read<StocktakingCubit>().onEntryAdded();
                      Navigator.maybePop(context);
                    }
                  : null,
              child: const Text('Ok'),
            );
          },
        ),
      ],
    );
  }

  AlertDialog _buildUnkown(BuildContext context, StocktakingState state) {
    return AlertDialog(
      title: const Text('Unknown Product Scanned'),
      content: const Text('The scanned barcode does not belong to any product. Would you like to add a new product?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('No')),
        TextButton(
          onPressed: () async {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => ProductAddEditPage(
                      defaultBarcodes: [state.scannedBarcode],
                    ),
                  ),
                )
                .then((value) => Navigator.of(context).maybePop());
          },
          child: const Text('Yes'),
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
                builder: (context) => AlertDialog(
                  title: const Text('Do you want to reset stocktaking?'),
                  content: const Text('This transaction cannot be undone, stocktaking will be reseted.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('No')),
                    TextButton(
                      onPressed: () {
                        context.read<StocktakingCubit>().onResetted();
                        Navigator.of(context).maybePop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Reset Stocktaking',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
