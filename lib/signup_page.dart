import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; 
import 'package:air_sense/signup_page.dart'; // Absolute path ensures it links to your real signup file

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'Individual'; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errMsg = 'Invalid email or password.';
        if (e.code == 'user-not-found') errMsg = 'No user found with this email.';
        if (e.code == 'wrong-password') errMsg = 'Incorrect password.';
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errMsg), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- RESPONSIVE LOGO FRAME ---
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65, 
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.fitWidth, 
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.blur_on, size: 80, color: Colors.indigo);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    "Welcome to AirSense", 
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: themeColor), 
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select your portal type to log in",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  // --- PORTAL ROLE SELECTION ---
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'Individual'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'Individual' ? themeColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Individual",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: _selectedRole == 'Individual' ? Colors.white : Colors.black54
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'Government'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'Government' ? themeColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Government",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: _selectedRole == 'Government' ? Colors.white : Colors.black54
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: _selectedRole == 'Government' ? 'Official Gov Email' : 'Email Address', 
                      border: const OutlineInputBorder()
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 20),

                  // Standard Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 30),
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16), 
                      backgroundColor: themeColor
                    ),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : Text("Sign In as $_selectedRole", style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
