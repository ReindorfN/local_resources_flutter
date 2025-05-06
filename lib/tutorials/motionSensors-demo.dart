import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class MotionSensorsDemo extends StatefulWidget {
  const MotionSensorsDemo({super.key});

  @override
  State<MotionSensorsDemo> createState() => _MotionSensorsDemoState();
}

class _MotionSensorsDemoState extends State<MotionSensorsDemo> {
  // Accelerometer data
  double _accelerometerX = 0;
  double _accelerometerY = 0;
  double _accelerometerZ = 0;

  // Gyroscope data
  double _gyroscopeX = 0;
  double _gyroscopeY = 0;
  double _gyroscopeZ = 0;

  // Stream subscriptions
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _startSensors();
  }

  @override
  void dispose() {
    _stopSensors();
    super.dispose();
  }

  void _startSensors() {
    // Start accelerometer
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
      });
    });

    // Start gyroscope
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeX = event.x;
        _gyroscopeY = event.y;
        _gyroscopeZ = event.z;
      });
    });
  }

  void _stopSensors() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }

  //Building card to display both gyroscope and accelerometer data
  Widget _buildSensorCard(String title, List<Map<String, dynamic>> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...data
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['label'] as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            item['value'].toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motion Sensors'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accelerometer Card
            _buildSensorCard(
              'Accelerometer',
              [
                {
                  'icon': Icons.arrow_right_alt,
                  'color': Colors.red,
                  'label': 'X-axis',
                  'value': _accelerometerX,
                },
                {
                  'icon': Icons.arrow_upward,
                  'color': Colors.green,
                  'label': 'Y-axis',
                  'value': _accelerometerY,
                },
                {
                  'icon': Icons.arrow_forward,
                  'color': Colors.blue,
                  'label': 'Z-axis',
                  'value': _accelerometerZ,
                },
              ],
            ),
            const SizedBox(height: 24),

            // Gyroscope Card
            _buildSensorCard(
              'Gyroscope',
              [
                {
                  'icon': Icons.rotate_right,
                  'color': Colors.red,
                  'label': 'X-axis (roll)',
                  'value': _gyroscopeX,
                },
                {
                  'icon': Icons.rotate_left,
                  'color': Colors.green,
                  'label': 'Y-axis (pitch)',
                  'value': _gyroscopeY,
                },
                {
                  'icon': Icons.sync,
                  'color': Colors.blue,
                  'label': 'Z-axis (yaw)',
                  'value': _gyroscopeZ,
                },
              ],
            ),
            const SizedBox(height: 24),

            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Test',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Hold your device in different orientations\n'
                      '2. Move it in different directions\n'
                      '3. Rotate it around different axes\n'
                      '4. Watch how the values change in real-time',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
