import 'package:eco_connect/services/auth_serivces.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await userCredential.user?.sendEmailVerification(); //handle email verification
      if (mounted) {
        setState(() {
          _successMessage =
              "A verification link has been sent to your email. Please verify before logging in.";
          _errorMessage = null;
        });
        showDialog(  // Show dialog to inform user about email verification
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Verify your email",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            content: Text(
                "A verification link has been sent to your email. Please verify before logging in.",
                style: TextStyle(color: Colors.black87)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text("OK", style: TextStyle(color: Color(0xFF57DE45))),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {//  error handling for registration
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = "This email is already in use.";
            break;
          case 'invalid-email':
            _errorMessage = "The email address is not valid.";
            break;
          default:
            _errorMessage = e.message ?? "Registration failed.";
        }
        _successMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Registration failed. Please try again.";
        _successMessage = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String? _validateEmail(String? value) { //  error handling for email validation
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _registerWithGoogle() async {  //  error handling for Google sign-in
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final userCredential = await AuthServices.signInWithGoogle(context);
      if (userCredential != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _registerWithFacebook() async {   //  error handling for Facebook sign-in
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final userCredential = await AuthServices.signInWithFacebook(context);
      if (userCredential != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Transform.scale(
                    scale: 3.2,
                    child: Image.asset(
                      'images/logo.png',
                      height: 120,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Eco',
                        style: TextStyle(color: Color(0xFF57DE45)),
                      ),
                      TextSpan(
                        text: 'Connect',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 55),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter email',
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
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _confirmFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter password',
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
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmController,
                        focusNode: _confirmFocusNode,
                        obscureText: true,
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Re-enter password',
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
                    ],
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                SizedBox(height: 30),
                FractionallySizedBox(
                  widthFactor: 0.45,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF57DE45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('or continue with',
                          style: TextStyle(fontSize: 15)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 25),

                // Social login icons - Google and Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: _loading ? null : _registerWithGoogle,
                        child: Transform.scale(
                          scale: 1.1,
                          child: Image.asset('images/google.png',
                              height: 80, width: 80),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: _loading ? null : _registerWithFacebook,
                        child: Transform.scale(
                          scale: 1.1,
                          child: Image.asset('images/facebook.png',
                              height: 75, width: 75),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        "Log In",
                        style:
                            TextStyle(color: Color(0xFF57DE45), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
