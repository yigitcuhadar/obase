import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/extensions/form_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';
import 'package:obase_barcode/products/widgets/barcode_scanner/cubit/barcode_scanner_cubit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeScannerView extends StatelessWidget {
  const BarcodeScannerView({super.key});

  static final Color iconColor = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeScannerCubit, BarcodeScannerState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        return SizedBox(
          height: 225,
          child: Stack(
            children: [
              if (state.status != ScannerStatus.closed) const _OpenedScanner(),
              if (state.status != ScannerStatus.closed) const _TypeChanger(),
              if (state.status == ScannerStatus.closed) _buildClosed(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClosed(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.read<BarcodeScannerCubit>().onStatusChanged(ScannerStatus.opened),
        child: Text(LocaleKeys.widget_barcode_scanner_open_button_title.locale),
      ),
    );
  }
}

class _TypeChanger extends StatelessWidget {
  const _TypeChanger();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeScannerCubit, BarcodeScannerState>(
      buildWhen: (p, c) => p.type != c.type,
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => context.read<BarcodeScannerCubit>().onTypeChanged(ScannerType.laser),
                icon: const Icon(Icons.barcode_reader),
                color: state.type == ScannerType.laser ? Colors.blue : BarcodeScannerView.iconColor,
              ),
              IconButton(
                onPressed: () => context.read<BarcodeScannerCubit>().onTypeChanged(ScannerType.camera),
                icon: const Icon(CupertinoIcons.barcode),
                color: state.type == ScannerType.camera ? Colors.blue : BarcodeScannerView.iconColor,
              ),
              IconButton(
                onPressed: () => context.read<BarcodeScannerCubit>().onTypeChanged(ScannerType.manual),
                icon: const Icon(Icons.edit),
                color: state.type == ScannerType.manual ? Colors.blue : BarcodeScannerView.iconColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OpenedScanner extends StatefulWidget {
  const _OpenedScanner();

  @override
  State<_OpenedScanner> createState() => _OpenedScannerState();
}

class _OpenedScannerState extends State<_OpenedScanner> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((data) async {
      if (context.read<BarcodeScannerCubit>().state.isScanFree) {
        if (data.code != null) {
          context.read<BarcodeScannerCubit>().onBarcodeScanned(data.code!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeScannerCubit, BarcodeScannerState>(
      buildWhen: (p, c) => p.type != c.type,
      builder: (context, state) {
        switch (state.type) {
          case ScannerType.manual:
            return _buildManual();
          case ScannerType.camera:
            return _buildCamera();
          case ScannerType.laser:
            return _buildLaser();
        }
      },
    );
  }

  Widget _buildManual() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 80),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          width: 300,
          height: 100,
          child: const _BarcodeFormField(),
        ),
      ),
    );
  }

  Widget _buildCamera() {
    return Stack(
      children: [
        QRView(
          key: _qrKey,
          onQRViewCreated: (controller) => _onQRViewCreated(context, controller),
          formatsAllowed: const [BarcodeFormat.ean13],
          overlay: QrScannerOverlayShape(
            borderRadius: 10,
            cutOutWidth: 200,
            cutOutHeight: 100,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: CloseButton(
            onPressed: () => context.read<BarcodeScannerCubit>().onStatusChanged(ScannerStatus.closed),
            color: BarcodeScannerView.iconColor,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _controller?.flipCamera(),
                icon: const Icon(Icons.flip_camera_ios),
                color: BarcodeScannerView.iconColor,
              ),
              IconButton(
                onPressed: () => _controller?.toggleFlash(),
                icon: const Icon(Icons.flashlight_on),
                color: BarcodeScannerView.iconColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLaser() => const SizedBox();
}

class _BarcodeFormField extends StatefulWidget {
  const _BarcodeFormField();

  @override
  State<_BarcodeFormField> createState() => _BarcodeFormFieldState();
}

class _BarcodeFormFieldState extends State<_BarcodeFormField> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BarcodeScannerCubit, BarcodeScannerState>(
      listenWhen: (p, c) =>
          p.barcodeForm != c.barcodeForm && p.isTypedBarcodeValid != c.isTypedBarcodeValid && !c.isTypedBarcodeValid,
      listener: (context, state) {
        print('listened');
        _controller.clear();
      },
      buildWhen: (p, c) => p.barcodeForm != c.barcodeForm,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                  BarcodeFormatter(),
                ],
                decoration: InputDecoration(
                  icon: const Icon(CupertinoIcons.barcode),
                  labelText: LocaleKeys.form_barcode_label.locale,
                  errorText: state.barcodeForm.errorText,
                  errorMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value) => context.read<BarcodeScannerCubit>().onBarcodeFormFieldChanged(value),
              ),
            ),
            const _BarcodeSubmitButton(),
          ],
        );
      },
    );
  }
}

class _BarcodeSubmitButton extends StatelessWidget {
  const _BarcodeSubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeScannerCubit, BarcodeScannerState>(
      buildWhen: (p, c) => p.isTypedBarcodeValid != c.isTypedBarcodeValid,
      builder: (context, state) {
        return IconButton(
          onPressed: state.isTypedBarcodeValid ? () => context.read<BarcodeScannerCubit>().onBarcodeFormFieldSubmitted() : null,
          icon: const Icon(Icons.check),
        );
      },
    );
  }
}
