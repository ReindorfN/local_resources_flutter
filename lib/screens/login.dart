import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      final email = data['email']?.trim() ?? '';
      final password = data['password']?.trim() ?? '';

      try {
        // 1. Sign in with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // 2. Optionally, pull user info from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        // 3. Navigate to main page
        Navigator.of(context).pushReplacementNamed('/main');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
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
              // Color.fromARGB(20, 154, 8, 159)
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
                        "Welcome Back",
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
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          // TODO: Forgot password logic
                        },
                        child: const Text('Forgot Password?'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/signup'),
                        child: const Text('Don\'t have an account? Sign up'),
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
