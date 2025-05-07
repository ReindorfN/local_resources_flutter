import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart'; // for themeNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool get isDarkMode => themeNotifier.value == ThemeMode.dark;
  String _selectedLanguage = 'English';

  User? get user => FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return doc.data();
  }

  Future<void> _resetPassword() async {
    if (user?.email == null) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Profile Section with Firestore username
        FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserProfile(),
          builder: (context, snapshot) {
            final username = snapshot.data?['username'] ?? 'Username';
            final email = user?.email ?? 'Email';
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      username.isNotEmpty
                          ? username[0].toUpperCase()
                          : (email.isNotEmpty ? email[0].toUpperCase() : '?'),
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _resetPassword,
                          icon: const Icon(Icons.lock_reset),
                          label: const Text('Reset Password'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Theme & Language Section
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.brightness_6,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Theme'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (val) {
                    themeNotifier.value =
                        val ? ThemeMode.dark : ThemeMode.light;
                    setState(() {});
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.language,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('App Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'French', child: Text('French')),
                    DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLanguage = val);
                  },
                ),
              ),
            ],
          ),
        ),

        // About Section
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.primary),
            title: const Text('About'),
            subtitle: const Text(
                """Flutter Local Resources Hub\n\nVersion 1.0.0\n\nThis application is aimed at providing tutorials and demos on implementing modern mobile local resources in Flutter.\n\nDeveloper: Reindorf Narh
                
Next version: \n Future versions of this application will include demo's to allow users test that the implementation works."""),
          ),
        ),

        // Sign Out Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          onPressed: _signOut,
        ),
      ],
    );
  }
}
