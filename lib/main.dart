import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/firebase_options.dart';
import 'package:eco_connect/authentication_screens/login_screen.dart';
import 'package:eco_connect/authentication_screens/register_screen.dart';
import 'package:eco_connect/authentication_screens/forget_password_screen.dart';
import 'package:eco_connect/CRUD_related_screens/home_screen.dart';
import 'package:eco_connect/CRUD_related_screens/create_post_screen.dart';
import 'package:eco_connect/CRUD_related_screens/profile_screen.dart';
import 'package:eco_connect/screens/settingsScreen.dart';
import 'package:eco_connect/screens/donation_qr_code_screen.dart';
import 'package:eco_connect/screens/search_screen.dart';
import 'package:eco_connect/screens/supportus_scren.dart';
import 'package:eco_connect/screens/update_profile_screen.dart';
import 'package:eco_connect/authentication_screens/change_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Configure Firestore
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      // Force long polling for more reliable connection
      webExperimentalForceLongPolling: true,
      webExperimentalAutoDetectLongPolling: true,
      // Add timeout settings
      webExperimentalLongPollingOptions: {
        'timeoutSeconds': 30,
      },
    );
    
    print('Firebase initialized successfully'); // Debug log
  } catch (e) {
    print('Error initializing Firebase: $e'); // Debug log
    rethrow;
  }
  
  runApp(EcoConnect());
}

class EcoConnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forget': (context) => ForgetPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/create': (context) => CreatePostScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/qr': (context) => DonationQRCodeScreen(),
        '/profile_details': (context) => ProfileDetailsScreen(),
        '/search': (context) => SearchScreen(),
        '/support': (context) => SupportUsScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
      },
    );
  }
}
