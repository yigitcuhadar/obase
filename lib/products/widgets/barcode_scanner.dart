import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ob_product/ob_product.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef OnScanned = Future<void> Function(int barcode);

enum _ScannerStatus { closed, waiting }

enum _ScannerType { manual, camera, laser }

class BarcodeScanner extends StatefulWidget {
  final OnScanned onScanned;
  const BarcodeScanner({
    super.key,
    required this.onScanned,
  });

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  _ScannerType _type = _ScannerType.camera;
  _ScannerStatus _status = _ScannerStatus.closed;
  bool _isScanFree = true;

  static final Color _iconColor = Colors.grey.shade300;

  void _changeType(_ScannerType value) {
    setState(() {
      _type = value;
    });
  }

  void _changeStatus(_ScannerStatus value) {
    setState(() {
      _status = value;
    });
  }

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
      if (_isScanFree) {
        if (data.code != null) {
          int? barcode = int.tryParse(data.code!);
          if (barcode != null) {
            setState(() {
              _isScanFree = false;
              _status = _ScannerStatus.waiting;
            });
            await widget.onScanned(barcode);
            setState(() {
              _isScanFree = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Stack(
        children: [
          if (_status != _ScannerStatus.closed) _buildOpened(),
          if (_status != _ScannerStatus.closed) _buildTypeChanger(),
          if (_status == _ScannerStatus.closed) _buildClosed(),
        ],
      ),
    );
  }

  Widget _buildClosed() {
    return Center(
      child: TextButton(
        onPressed: () => _changeStatus(_ScannerStatus.waiting),
        child: const Text('Click to open barcode scanner!'),
      ),
    );
  }

  Widget _buildOpened() {
    switch (_type) {
      case _ScannerType.manual:
        return _buildManual();
      case _ScannerType.camera:
        return _buildCamera();
      case _ScannerType.laser:
        return _buildLaser();
    }
  }

  Widget _buildManual() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 80),
      child: Center(
        child: Container(
          color: Colors.white,
          width: 200,
          height: 100,
          child: TextFormField(
            autofocus: true,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
              BarcodeFormatter(),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Barcode',
            ),
            keyboardType: TextInputType.number,
            onChanged: null,
          ),
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
            onPressed: () => _changeStatus(_ScannerStatus.closed),
            color: _iconColor,
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
                color: _iconColor,
              ),
              IconButton(
                onPressed: () => _controller?.toggleFlash(),
                icon: const Icon(Icons.flashlight_on),
                color: _iconColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLaser() => const SizedBox();

  Widget _buildTypeChanger() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _changeType(_ScannerType.laser),
            icon: const Icon(Icons.barcode_reader),
            color: _type == _ScannerType.laser ? Colors.blue : _iconColor,
          ),
          IconButton(
            onPressed: () => _changeType(_ScannerType.camera),
            icon: const Icon(CupertinoIcons.barcode),
            color: _type == _ScannerType.camera ? Colors.blue : _iconColor,
          ),
          IconButton(
            onPressed: () => _changeType(_ScannerType.manual),
            icon: const Icon(Icons.edit),
            color: _type == _ScannerType.manual ? Colors.blue : _iconColor,
          ),
        ],
      ),
    );
  }
}
