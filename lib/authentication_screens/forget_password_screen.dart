import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _resetPassword() async {
    //reset password function
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address';
        _successMessage = null;
      });
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        _successMessage = 'Password reset email sent! Please check your inbox.';
        _errorMessage = null;
      });

      // Clear the email field
      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'too-many-requests':
            _errorMessage = 'Too many requests. Please try again later.';
            _successMessage = null;
            break;
          case 'invalid-email':
            _errorMessage = 'Please enter a valid email address.';
            _successMessage = null;
            break;
          default:
            // For all other errors, show generic error
            _errorMessage = 'An error occurred. Please try again.';
            _successMessage = null;
        }
      });
    } catch (e) {
      //for interenal errors
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 68),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header name for the app
              Text(
                'Recover\nPassword',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF57DE45),
                  height: 1.2,
                ),
              ),

              SizedBox(height: 40),

              // Subtitle
              Text(
                'Provide the email and we will send a link\nto reset your password',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              SizedBox(height: 30),

              // Email input field
              FractionallySizedBox(
                widthFactor: 0.95,
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    hintStyle: TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Color(0xFFD8EFD5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
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

              // Reset Password Button to send the recovery email
              Center(
                child: SizedBox(
                  width: 250,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: _loading ? null : _resetPassword,
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      side: BorderSide(color: Color(0xFF57DE45), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFF57DE45),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Reset Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 60),

              // go back to login button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
