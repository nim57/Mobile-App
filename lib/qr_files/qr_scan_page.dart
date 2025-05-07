// qr_scan_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'veryfy_screen.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );
  final String _validQrText = "ECHO_5730@";
  double _zoomLevel = 0.0;
  bool _torchEnabled = false;

  Future<void> _showShopIdDialog() async {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Shop ID'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Shop ID',
              border: OutlineInputBorder(),
              hintText: 'Enter shop ID',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextScreen(shopId: result),
        ),
      );
    }

    if (mounted) cameraController.start();
  }

  Future<void> _showInvalidQRDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid QR Code'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) cameraController.start();
  }

  void _handleBarcode(Barcode barcode) async {
    try {
      final qrText = barcode.rawValue;
      print('Scanned QR Text: $qrText');
      print('Condition Text: $_validQrText');

      if (qrText == null) throw Exception('Empty QR code');
      
      if (qrText == _validQrText) {
        if (mounted) {
          cameraController.stop();
          await _showShopIdDialog();
        }
      } else {
        throw Exception('QR code does not match required text');
      }
    } catch (e) {
      if (mounted) {
        cameraController.stop();
        await _showInvalidQRDialog('Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() => _torchEnabled = !_torchEnabled);
              cameraController.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                _handleBarcode(barcode);
                break; // Process only first barcode
              }
            },
          ),
          Positioned(
            right: 20,
            top: 100,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () {
                    setState(() => _zoomLevel = (_zoomLevel + 0.1).clamp(0.0, 1.0));
                    cameraController.setZoomScale(_zoomLevel);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () {
                    setState(() => _zoomLevel = (_zoomLevel - 0.1).clamp(0.0, 1.0));
                    cameraController.setZoomScale(_zoomLevel);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

