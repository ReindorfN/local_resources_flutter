import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.nfc,
        'color': Colors.deepPurple,
        'title': 'NFC (Near Field Communication)',
        'subtitle': 'Main highlight 🚀',
        'onTap': () {}, // To be implemented
      },
      {
        'icon': Icons.fingerprint,
        'color': Colors.green,
        'title': 'Biometric Authentication',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.bluetooth,
        'color': Colors.blue,
        'title': 'Bluetooth Low Energy (BLE) device scanning',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.location_on,
        'color': Colors.red,
        'title': 'Geofencing',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.sensors,
        'color': Colors.orange,
        'title': 'Motion Sensors (Accelerometer/Gyroscope)',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.qr_code_scanner,
        'color': Colors.teal,
        'title': 'QR Code Scanner',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.notifications_active,
        'color': Colors.amber,
        'title': 'Local Notifications',
        'subtitle': '',
        'onTap': () {},
      },
      {
        'icon': Icons.wifi_tethering,
        'color': Colors.pink,
        'title': 'Nearby Sharing',
        'subtitle': '',
        'onTap': () {},
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Implementing Modern\nMobile Resources',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: features.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: feature['onTap'] as void Function(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.95),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: feature['color'] as Color,
                                child: Icon(
                                  feature['icon'] as IconData,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      feature['title'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    if ((feature['subtitle'] as String)
                                        .isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          feature['subtitle'] as String,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[700],
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.black45),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
