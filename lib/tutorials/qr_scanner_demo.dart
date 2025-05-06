import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerDemo extends StatefulWidget {
  const QRScannerDemo({super.key});

  @override
  State<QRScannerDemo> createState() => _QRScannerDemoState();
}

class _QRScannerDemoState extends State<QRScannerDemo> {
  final MobileScannerController _controller = MobileScannerController();
  String? _lastScannedCode;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue != _lastScannedCode) {
        setState(() {
          _lastScannedCode = barcode.rawValue;
        });
        // Show the scanned code in a dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('QR Code Detected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Content: ${barcode.rawValue}'),
                const SizedBox(height: 8),
                Text('Format: ${barcode.format}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          // Flash toggle button
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                _controller.toggleTorch();
              });
            },
          ),
          // Camera switch button
          IconButton(
            icon: Icon(_isFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: () {
              setState(() {
                _isFrontCamera = !_isFrontCamera;
                _controller.switchCamera();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                // Scanner overlay
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(50),
                ),
              ],
            ),
          ),
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Position the QR code within the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The scanner will automatically detect QR codes',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
