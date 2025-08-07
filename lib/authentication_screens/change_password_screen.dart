import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _changePassword() async {
    // Change password function validation
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Re-authenticate the user with current password for security
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(_newPasswordController.text.trim());

      setState(() {
        _successMessage = 'Password changed successfully!';
        _errorMessage = null;
      });

      // Clear the form
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Navigate back after a short delay
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      setState(() {
        switch (e.code) {
          case 'wrong-password':
            if (e.message != null &&
                e.message!.contains('auth credential is incorrect')) {
              _errorMessage = 'Current password is incorrect';
            }
            _successMessage = null;
            break;

          case 'requires-recent-login':
            _errorMessage =
                'Please log out and log in again before changing password';
            _successMessage = null;
            break;

          case 'too-many-requests':
            _errorMessage =
                'Too many attempts. Please wait a few minutes before trying again.';
            _successMessage = null;
            break;

          default:
            if (e.message != null &&
                e.message!.contains('auth credential is incorrect')) {
              _errorMessage = 'Current password is incorrect';
            } else {
              _errorMessage =
                  e.message ?? 'An error occurred. Please try again.';
            }
            _successMessage = null;
        }
      });
    } catch (e) {
      //internal errors
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _successMessage = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

// Validation functions for password fields
  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a new password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

//widget build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: 28, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // Instruction text
                Text(
                  'Enter your current password and choose a new password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 30),

                // Current Password Field
                Text(
                  'Current Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Color(0xFFD8EFD5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  validator: _validateCurrentPassword,
                ),

                SizedBox(height: 20),

                // New Password Field
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Color(0xFFD8EFD5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  validator: _validateNewPassword,
                ),

                SizedBox(height: 20),

                // Confirm New Password Field
                Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm your new password',
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Color(0xFFD8EFD5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),

                SizedBox(height: 20),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                // Success message
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                SizedBox(height: 40),

                // Change Password Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF57DE45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Change Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Password requirements
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• At least 6 characters long\n• Should be different from your current password\n• Use a combination of letters and numbers for better security',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
