import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        // Use Firebase Auth Web for  web support
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        // Use signInWithPopup for web
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        //  GoogleSignIn for mobile platform
        GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          print('User cancelled the sign-in');
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          throw Exception('Failed to get Google authentication tokens');
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      print(
          'Google sign-in error: $e'); //error handling for Google cancelled sign-in
      if (context.mounted) {
        String message = 'Google sign-in failed. Please try again.';
        if (e is FirebaseAuthException && e.code == 'popup-closed-by-user') {
          message = 'Google sign-in was cancelled.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return null;
    }
  }

  static Future<UserCredential?> signInWithFacebook(
      BuildContext context) async {
    try {
      if (kIsWeb) {
        // Use Firebase Auth Web for Facebook
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.addScope('public_profile');

        // Use signInWithPopup for web
        return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
      } else {
        // flutter_facebook_auth for mobile platform
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
        );

        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;

          // Create Facebook credential
          final credential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          // Sign in with Firebase
          return await FirebaseAuth.instance.signInWithCredential(credential);
        } else {
          print('Facebook login failed: ${result.status} - ${result.message}');
          return null;
        }
      }
    } catch (e) {
      //error handling  for cancelled sign-in Facebook
      print('Facebook sign-in error: $e');
      if (context.mounted) {
        String message = 'Facebook sign-in failed. Please try again.';
        if (e is FirebaseAuthException && e.code == 'popup-closed-by-user') {
          message = 'Facebook sign-in was cancelled.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return null;
    }
  }
}
