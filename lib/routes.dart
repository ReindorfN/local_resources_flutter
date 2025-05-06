import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'tutorials/nfc-demo.dart';

class AppRoutes {
  static const String home = '/';
  static const String nfcDemo = '/nfc-demo';
  // Add more routes as you implement them

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      nfcDemo: (context) => const NFCImplementation(),
      // Add more route mappings here
    };
  }
}
