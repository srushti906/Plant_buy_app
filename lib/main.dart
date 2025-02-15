import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file exists and has the correct Firebase configuration
import 'sign_up_page.dart';
import 'sign_in_page.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this matches your Firebase setup
  );
  runApp(GreenSquareApp());
}

class GreenSquareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GREEN SQUARE',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/sign-in', // Start with the sign-in page
      routes: {
        '/home': (context) => HomePage(),
        '/sign-up': (context) => SignUpPage(),
        '/sign-in': (context) => SignInPage(),
        // Add other routes here as needed
      },
    );
  }
}
