import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordValidator(String? value) {
    final password = value?.trim() ?? '';
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (password.isEmpty) return 'Password is required';
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be 8+ chars, 1 uppercase, 1 number, 1 special char';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      final email = data['email']?.trim() ?? '';
      final username = data['username']?.trim() ?? '';
      final password = data['password']?.trim() ?? '';
      final confirmPassword = data['confirm_password']?.trim() ?? '';

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      try {
        // 1. Create user in Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // 2. Store additional user info in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 3. Navigate to main page
        Navigator.of(context).pushReplacementNamed('/main');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Signup failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 67, 177, 153),
              Color.fromARGB(255, 144, 216, 62),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Create Account",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 24),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white70,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'confirm_password',
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.white70,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).popAndPushNamed('/login'),
                        child: const Text('Already have an account? Log in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
