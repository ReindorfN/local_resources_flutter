import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricAuth extends StatefulWidget {
  const BiometricAuth({super.key});

  @override
  State<BiometricAuth> createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _status = 'Ready to authenticate';
  bool _isAuthenticated = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  //function to check if mobile device supports biometrics
  Future<void> _checkBiometrics() async {
    try {
      // Check if device supports biometrics
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _status = 'Biometric authentication is not available';
        });
        return;
      }

      // Getting available biometrics on mobile device
      _availableBiometrics = await _localAuth.getAvailableBiometrics();

      setState(() {
        _status = 'Biometric authentication is available';
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking biometrics: $e';
      });
    }
  }

  //function to activate and use the authentication methods available on the mobile device
  Future<void> _authenticate() async {
    try {
      setState(() {
        _status = 'Authenticating...';
        _isAuthenticated = false;
      });

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _isAuthenticated = didAuthenticate;
        _status = didAuthenticate
            ? 'Authentication successful!'
            : 'Authentication failed';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${_getErrorText(e.code)}';
        _isAuthenticated = false;
      });
    }
  }

  String _getErrorText(String code) {
    switch (code) {
      case auth_error.notAvailable:
        return 'Biometric authentication is not available';
      case auth_error.notEnrolled:
        return 'No biometrics enrolled on this device';
      case auth_error.lockedOut:
        return 'Too many failed attempts. Try again later';
      case auth_error.passcodeNotSet:
        return 'No passcode set on this device';
      case auth_error.permanentlyLockedOut:
        return 'Biometric authentication is permanently locked';
      default:
        return 'Unknown error: $code';
    }
  }

  //snippet to get the name of the biometrics available on the mobile device
  String _getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong';
      case BiometricType.weak:
        return 'Weak';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isAuthenticated
                          ? Icons.fingerprint
                          : Icons.fingerprint_outlined,
                      size: 48,
                      color: _isAuthenticated ? Colors.green : Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Available Biometrics
            if (_availableBiometrics.isNotEmpty) ...[
              Text(
                'Available Biometrics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _availableBiometrics.map((type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              type == BiometricType.face
                                  ? Icons.face
                                  : Icons.fingerprint,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(_getBiometricTypeName(type)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Authenticate Button
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}
