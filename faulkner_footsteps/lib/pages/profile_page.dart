import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user and credentials
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        // Reauthenticate user
        final credential = EmailAuthProvider.credential(
          email: email,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(_newPasswordController.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password successfully updated'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to change password. Please check your current password.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 52, 52),
        title: Text(
          'Profile',
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 243, 228),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color.fromARGB(255, 250, 235, 215),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.ultra(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 72, 52, 52),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'Not signed in',
                      style: GoogleFonts.rakkas(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 107, 79, 79),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: const Color.fromARGB(255, 250, 235, 215),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: GoogleFonts.ultra(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 72, 52, 52),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          labelStyle: GoogleFonts.rakkas(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 79, 79),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: GoogleFonts.rakkas(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 79, 79),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: GoogleFonts.rakkas(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 79, 79),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 72, 52, 52),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Update Password',
                                  style: GoogleFonts.rakkas(
                                    textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 243, 228),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
