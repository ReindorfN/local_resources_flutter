import 'package:flutter/material.dart';
import '../tutorials/biometric-auth.dart';
import '../tutorials/motionSensors-demo.dart';
import '../tutorials/nfc-demo.dart';
import '../tutorials/qr_scanner_demo.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Resources Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResourceCard(
              context,
              title: 'Biometric Authentication',
              description:
                  'Implement secure authentication using fingerprint or face recognition',
              icon: Icons.fingerprint,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BiometricAuth(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'Motion Sensors',
              description: 'Access device accelerometer and gyroscope data',
              icon: Icons.screen_rotation,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MotionSensorsDemo(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'NFC',
              description: 'Read and write NFC tags',
              icon: Icons.nfc,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NFCImplementation(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              title: 'QR Code Scanner',
              description: 'Scan QR codes using the device camera',
              icon: Icons.qr_code_scanner,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerDemo(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
