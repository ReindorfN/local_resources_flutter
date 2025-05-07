//Imports
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCImplementation extends StatefulWidget {
  const NFCImplementation({super.key});

  @override
  State<NFCImplementation> createState() => _NFCImplementationState();
}

class _NFCImplementationState extends State<NFCImplementation> {
  //some variable definitions
  String _nfcStatus = 'Ready to scan';
  bool _isAvailable = false;
  bool _isReading = false;
  bool _isWriting = false;
  final TextEditingController _writeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkNFCAvailability();
  }

  @override
  void dispose() {
    _writeController.dispose();
    super.dispose();
  }

  //Function to check if mobile device running application supports nfc
  Future<void> _checkNFCAvailability() async {
    try {
      NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
      setState(() {
        _isAvailable = availability == NFCAvailability.available;
        _nfcStatus = _isAvailable ? 'Ready to scan' : 'NFC is not available';
      });
    } catch (e) {
      setState(() {
        _isAvailable = false;
        _nfcStatus = 'Error checking NFC availability: $e';
      });
    }
  }

  //function to start a session and detect nearby nfc tags
  Future<void> _startNFCSession(bool isWrite) async {
    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NFC is not available on this device')),
      );
      return;
    }

    setState(() {
      _isReading = !isWrite;
      _isWriting = isWrite;
      _nfcStatus = isWrite ? 'Ready to write' : 'Ready to read';
    });

    try {
      // Poll for NFC tag
      var tag = await FlutterNfcKit.poll();

      if (isWrite) {
        await _writeToTag(tag);
      } else {
        await _readFromTag(tag);
      }
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error: $e';
        _isReading = false;
        _isWriting = false;
      });
    }
  }

  // Function to read information from an nfc tag
  Future<void> _readFromTag(NFCTag tag) async {
    try {
      // Get tag information
      String data = tag.id;
      if (tag.standard == "ISO 14443-4 (Type B)") {
        data += "\nType: ${tag.type}\nProtocol Info: ${tag.protocolInfo}";
      } else if (tag.standard == "ISO 14443-4 (Type A)") {
        data += "\nType: ${tag.type}\nATQA: ${tag.atqa}\nSAK: ${tag.sak}";
      } else if (tag.standard == "ISO 14443-3 (Type A)") {
        data += "\nType: ${tag.type}\nATQA: ${tag.atqa}\nSAK: ${tag.sak}";
      }

      setState(() {
        _nfcStatus = 'Read: $data';
      });
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error reading tag: $e';
      });
    } finally {
      await FlutterNfcKit.finish();
      setState(() {
        _isReading = false;
      });
    }
  }

  //function to write information to an nfc tag
  Future<void> _writeToTag(NFCTag tag) async {
    if (_writeController.text.isEmpty) {
      setState(() {
        _nfcStatus = 'Please enter text to write';
      });
      return;
    }

    try {
      // For now, we'll just show the tag information since writing requires specific tag types
      String info =
          'Tag detected:\nID: ${tag.id}\nStandard: ${tag.standard}\nType: ${tag.type}';
      setState(() {
        _nfcStatus =
            '$info\n\nNote: Writing to this tag type is not supported in this demo';
      });
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error interacting with tag: $e';
      });
    } finally {
      await FlutterNfcKit.finish();
      setState(() {
        _isWriting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Implementation'),
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
                      _isAvailable ? Icons.nfc : Icons.error_outline,
                      size: 48,
                      color: _isAvailable ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _nfcStatus,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Write Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Write to NFC Tag',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _writeController,
                      decoration: const InputDecoration(
                        labelText: 'Enter text to write',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _isWriting ? null : () => _startNFCSession(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isWriting ? 'Writing...' : 'Write to Tag'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Read Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Read from NFC Tag',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _isReading ? null : () => _startNFCSession(false),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isReading ? 'Reading...' : 'Read from Tag'),
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
