import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signin_page.dart'; // Make sure this path correctly points to your sign-in page file

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    // Fetch live user data from Firebase
    final User? user = FirebaseAuth.instance.currentUser;
    final String userEmail = user?.email ?? 'user@gmail.com';
    
    // Split the email prefix to use as a placeholder name (e.g., 'rita' from 'rita@gmail.com')
    final String defaultName = userEmail.split('@')[0];
    final String capitalizedName = defaultName.isNotEmpty 
        ? defaultName[0].toUpperCase() + defaultName.substring(1) 
        : 'AirSense Explorer';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SECTION (Purple background banner + Circular Avatar Stack)
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color(0xFFC5CAE9), // Soft purple/indigo banner accent
                ),
                Positioned(
                  top: 110, // Pushes half of the avatar below the purple banner line
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, size: 70, color: Colors.white), // Using Flutter icon as placeholder
                    ),
                  ),
                ),
              ],
            ),
            
            // Spacer to account for the overlapping floating avatar height
            const SizedBox(height: 65),

            // 2. USER INDENTIFICATION TEXT
            Text(
              capitalizedName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 25),

            // 3. USER INFORMATION CARD DETAILS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildDetailRow("Mail", userEmail),
                  _buildDetailRow("Points", "120 Reward Points"), // Your tracking metric
                  const SizedBox(height: 15),
                  const Divider(color: Colors.black12, thickness: 1),
                ],
              ),
            ),

            // 4. INTERACTIVE SETTINGS LIST OPTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  // Dark Mode Switch Row
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined, color: Colors.black87),
                    title: const Text("Dark mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    trailing: Switch(
                      value: _isDarkMode,
                      activeThumbColor: Colors.indigo,
                      onChanged: (value) {
                        setState(() => _isDarkMode = value);
                      },
                    ),
                  ),
                  _buildDivider(),

                  // Profile Details Clickable Row
                  _buildMenuOption(Icons.person_outline, "Profile details", () {}),
                  _buildDivider(),

                  // Settings Clickable Row
                  _buildMenuOption(Icons.tune, "Settings", () {}),
                  _buildDivider(),

                  // Log Out Row
                  _buildMenuOption(
                    Icons.logout, 
                    "Log out", 
                    () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pushReplacement(
                          MaterialPageRoute(builder: (context) => const SignInPage()),
                        );
                      }
                    },
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper builder for metadata parameters (Mail/Points rows)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder for custom settings tiles
  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap, {Color iconColor = Colors.black87, Color textColor = Colors.black87}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
      onTap: onTap,
    );
  }

  // Helper builder for matching UI divider strips
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.black12, height: 1),
    );
  }
}