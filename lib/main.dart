import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signin_page.dart';

void main() async {
  // 1. Ensures Flutter framework bindings are fully initialized first
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initializes all Firebase services (Auth, Firestore, etc.)
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF007AFF), // Your AirSense primary accent
        useMaterial3: true,
      ),
      // 3. Directly points the entry route to your clean SignInPage
      home: const SignInPage(), 
    );
  }
}
