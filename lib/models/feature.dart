import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feature {
  final String id;
  final String title;
  final String iconName;
  final Color color;
  final String subtitle;
  final String description;
  final String codeSnippet;
  final String videoUrl;
  final bool isAvailable;
  final String demoRoute;

  Feature({
    required this.id,
    required this.title,
    required this.iconName,
    required this.color,
    required this.subtitle,
    required this.description,
    required this.codeSnippet,
    required this.videoUrl,
    required this.isAvailable,
    required this.demoRoute,
  });

  factory Feature.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Feature(
      id: doc.id,
      title: data['title'] ?? '',
      iconName: data['iconName'] ?? '',
      color: _getColorFromString(data['color'] ?? 'deepPurple'),
      subtitle: data['subtitle'] ?? '',
      description: data['description'] ?? '',
      codeSnippet: data['codeSnippet'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      demoRoute: data['demoRoute'] ?? '',
    );
  }

  static Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.deepPurple;
    }
  }

  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'nfc':
        return Icons.nfc;
      case 'fingerprint':
        return Icons.fingerprint;
      case 'bluetooth':
        return Icons.bluetooth;
      case 'location':
        return Icons.location_on;
      case 'sensors':
        return Icons.sensors;
      case 'qr_code':
        return Icons.qr_code_scanner;
      case 'notifications':
        return Icons.notifications_active;
      case 'wifi':
        return Icons.wifi_tethering;
      case 'authentication':
        return Icons.safety_check;
      case 'motion':
        return Icons.screen_rotation;
      default:
        return Icons.error;
    }
  }
}
