//Imports
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:convert';

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

//Fnction to check if mobile device running application supports nfc
  Future<void> _checkNFCAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
      _nfcStatus = isAvailable ? 'Ready to scan' : 'NFC is not available';
    });
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
      // Start NFC session
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          if (isWrite) {
            await _writeToTag(tag);
          } else {
            await _readFromTag(tag);
          }
        },
      );
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error: $e';
        _isReading = false;
        _isWriting = false;
      });
    }
  }

// Functon to read information from an nfc tag
  Future<void> _readFromTag(NfcTag tag) async {
    try {
      // Get NDEF records
      Ndef? ndef = Ndef.from(tag);
      if (ndef == null) {
        setState(() {
          _nfcStatus = 'Tag is not NDEF formatted';
        });
        return;
      }

      if (!ndef.isWritable) {
        setState(() {
          _nfcStatus = 'Tag is not writable';
        });
        return;
      }

      // Read NDEF message
      NdefMessage? message = await ndef.read();
      if (message == null) {
        setState(() {
          _nfcStatus = 'No data found on tag';
        });
        return;
      }

      // Process NDEF records
      String data = '';
      for (var record in message.records) {
        if (record.typeNameFormat == 1 && // 1 represents NFC Well Known type
            record.type.length == 1 &&
            record.type.first == 0x54) {
          // 'T' record type
          data += utf8.decode(record.payload);
        }
      }

      setState(() {
        _nfcStatus = 'Read: $data';
      });
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error reading tag: $e';
      });
    } finally {
      await NfcManager.instance.stopSession();
      setState(() {
        _isReading = false;
      });
    }
  }

  //function to write information to an nfc tag
  Future<void> _writeToTag(NfcTag tag) async {
    if (_writeController.text.isEmpty) {
      setState(() {
        _nfcStatus = 'Please enter text to write';
      });
      return;
    }

    try {
      Ndef? ndef = Ndef.from(tag);
      if (ndef == null) {
        setState(() {
          _nfcStatus = 'Tag is not NDEF formatted';
        });
        return;
      }

      if (!ndef.isWritable) {
        setState(() {
          _nfcStatus = 'Tag is not writable';
        });
        return;
      }

      // Create NDEF message
      NdefMessage message = NdefMessage([
        NdefRecord.createText(_writeController.text),
      ]);

      // Write to tag
      await ndef.write(message);
      setState(() {
        _nfcStatus = 'Successfully wrote: ${_writeController.text}';
      });
    } catch (e) {
      setState(() {
        _nfcStatus = 'Error writing to tag: $e';
      });
    } finally {
      await NfcManager.instance.stopSession();
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
