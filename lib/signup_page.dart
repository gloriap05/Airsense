import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signin_page.dart'; // Links straight to your updated login file

void main() async {
  // 1. Ensures native engine bindings are stable before initializing services
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initializes connection to your Firebase Backend instance
  await Firebase.initializeApp();
  
  runApp(const AirSenseApp());
}

class AirSenseApp extends StatelessWidget {
  const AirSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirSense',
      debugShowCheckedModeBanner: false, // Cleans up the debug banner in the corner
      
      // 3. Centralized UI Branding Theme Configurator
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.indigo, // Sets the global branding identity color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
        ),
      ),
      
      // 4. Sets the initial landing view container
      home: const SignInPage(), 
    );
  }
}
