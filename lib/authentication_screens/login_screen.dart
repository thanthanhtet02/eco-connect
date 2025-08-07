import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_connect/services/auth_serivces.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles the login process for email and password validation
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
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
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Checking if email is verified or not
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text("Email Not Verified",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              content: Text(
                  "Please verify your email before logging in. Check your inbox for the verification link.",
                  style: TextStyle(color: Colors.black87)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.grey[600])),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try { // Resend verification email
                      final tempUser = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      await tempUser.user!.sendEmailVerification();
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _successMessage =
                            'Verification email sent! Please check your inbox.';
                        _errorMessage = null;
                      });
                    } on FirebaseAuthException catch (e) {    //  error handling for FirebaseAuthException for email verification
                      setState(() {
                        if (e.code == 'too-many-requests') {
                          _errorMessage =
                              'Too many requests. Please wait 1-2 minutes before requesting another email.';
                        } else {
                          _errorMessage =
                              'Failed to send verification email. Please try again.';
                        }
                        _successMessage = null;
                      });
                    } catch (e) { 
                      setState(() {
                        _errorMessage =
                            'Failed to send verification email. Please try again.';
                        _successMessage = null;
                      });
                    }
                  },
                  child: Text("Resend Email",
                      style: TextStyle(color: Color(0xFF57DE45))),
                ),
              ],
            ),
          );
        }
        setState(() {
          _loading = false;
        });
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _loading = false;
            });
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    } on FirebaseAuthException catch (e) { // error handling for FirebaseAuthException email and password validation
      setState(() {
        if (e.code == 'wrong-password' ||
            e.code == 'user-not-found' ||
            e.code == 'invalid-credential') {
          _errorMessage = 'Email or password is incorrect.';
        } else if (e.code == 'too-many-requests') {
          _errorMessage =
              'Too many attempts.\nPlease wait a few minutes before trying again.';
        } else {
          _errorMessage =
              'Login failed. Please check your credentials and try again.';
        }
        _successMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _successMessage = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle() async {// error handling for Google sign-in
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final userCredential = await AuthServices.signInWithGoogle(context);
      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _loading = false;
            });
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loginWithFacebook() async {// error handling for Facebook sign-in
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final userCredential = await AuthServices.signInWithFacebook(context);
      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _loading = false;
            });
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
// UI for the login screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Center(
                child: Transform.scale(
                  scale: 2.5,
                  child: Image.asset(
                    'images/logo.png',
                    height: 150,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Log In to continue to the future',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'With ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Eco',
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: 'Connect',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      style: TextStyle(fontSize: 16),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Username or email',
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
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      style: TextStyle(fontSize: 16),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
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
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _successMessage!,
                    style: TextStyle(color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.45,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF57DE45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Log In',
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
                    child: Text(
                      'or continue with',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: _loading ? null : _loginWithGoogle,
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
                      onTap: _loading ? null : _loginWithFacebook,
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
                  Text(
                    "Do not have an account? ",
                    style: TextStyle(fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFF57DE45), fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
